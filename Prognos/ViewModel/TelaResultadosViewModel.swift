import Foundation
import Combine
import SwiftUI

// MARK: - Model para o Gráfico
struct PontoEvolucao: Identifiable, Equatable {
    var id: String { "\(nomeInvestimento)-\(ano)" }
    
    let nomeInvestimento: String
    let ano: Int
    let montanteNominal: Double
    let montanteReal: Double
}

class TelaResultadosViewModel: ObservableObject {
    var valorInvestido: Float
    var tempoInvestimento: Int
    var dadosDosCards: [CardViewModel]
    
    @Published var nomesLegendas: [String] = []
    @Published var coresLegendas: [Color] = []
    @Published var mostrarValorReal: Bool = true
    @Published var pontosDoGrafico: [PontoEvolucao] = []
    
    private var inflacaoFixadaPorAno: [CenarioInflacao: [Double]] = [:]
    public var dadosPorCenario: [CenarioInflacao: [PontoEvolucao]] = [:]
    
    @Published var cenarioAtual: CenarioInflacao = .randomica {
        didSet { atualizarGraficoParaCenarioAtual() }
    }
    
    init(valorInvestido: Float, tempoInvestimento: Int, dadosDosCards: [CardViewModel]) {
        self.valorInvestido = valorInvestido
        self.tempoInvestimento = tempoInvestimento
        self.dadosDosCards = dadosDosCards
        
        configurarLegendasECores()
        
        // 🔥 1. Sorteia e fixa a inflação para toda a linha do tempo logo na inicialização
        gerarLinhaDoTempoDaInflacao()
        
        gerarTodosOsCenarios()
        atualizarGraficoParaCenarioAtual()
    }
    
    // 🔥 2. NOVA FUNÇÃO: Sorteia as taxas uma única vez e guarda no cofrinho
    private func gerarLinhaDoTempoDaInflacao() {
        inflacaoFixadaPorAno = [:]
        
        for cenario in CenarioInflacao.allCases {
            var taxasDoPeriodo: [Double] = []
            // Sorteia uma taxa para o ano 0, ano 1, ano 2... até o limite de tempo
            for _ in 0...tempoInvestimento {
                taxasDoPeriodo.append(cenario.sortearTaxa())
            }
            // Guarda o array estável desse cenário
            inflacaoFixadaPorAno[cenario] = taxasDoPeriodo
        }
    }
    
    func recalcularSimulacao(novoValor: Float, novoTempo: Int, cardsAtualizados: [CardViewModel]) {
        self.valorInvestido = novoValor
        self.dadosDosCards = cardsAtualizados
        
        // 🔥 3. Se o usuário alterou a quantidade de anos, a linha do tempo cresceu/encolheu.
        // Só nesse caso re-sorteamos as inflações para o novo período.
        if novoTempo != self.tempoInvestimento {
            self.tempoInvestimento = novoTempo
            gerarLinhaDoTempoDaInflacao()
        }
        
        configurarLegendasECores()
        gerarTodosOsCenarios()
        atualizarGraficoParaCenarioAtual()
    }
    
    private func configurarLegendasECores() {
        var nomes: [String] = []
        var cores: [Color] = []
        
        for (index, card) in dadosDosCards.enumerated() {
            let nomeLegenda = "\(index + 1). \(card.tipo.tituloPrincipal)"
            nomes.append(nomeLegenda)
            
            // 👇 BUSCA A COR RESPECTIVA DAQUELE TIPO ESPECÍFICO
            let corDoInvestimento = obterCorRespectiva(para: card.tipo)
            cores.append(corDoInvestimento)
        }
        
        self.nomesLegendas = nomes
        self.coresLegendas = cores
    }

    private func obterCorRespectiva(para tipo: TipoDeInvestimento) -> Color {
        switch tipo {
        case .tesouroPrefixado:   return .tesouroPrefixado
        case .tesouroSelic:       return .tesouroSelic
        case .tesouroIpca:        return .tesouroHibrido
        
        case .cdbPrefixado:       return .cdbLcPrefixado
        case .cdbCdi:             return .cdbLcPosFixado
        case .cdbIpca:            return .cdbLcHibrido
        
        case .lciPrefixado:       return .lciLcaPrefixada
        case .lciCdi:             return .lciLcaPosfixada
        case .lciIpca:            return .lciLcaHibrido
        
        case .debComumPrefixada:  return .debenturePrefixado
        case .debComumCdi:        return .debenturePosfixado
        case .debComumIpca:       return .debentureHibrido
        
        case .isentoPrefixado:    return .criCraPrefixado
        case .isentoCdi:          return .criCraPosfixado
        case .isentoIpca:         return .criCraHibrido
        
        case .fundoRendaFixa:     return .fundoRendaFixa
        }
    }
    
    // MARK: - Navegação dos Cenários
    func proximoCenario() {
        let todos = CenarioInflacao.allCases
        if let indexAtual = todos.firstIndex(of: cenarioAtual) {
            let proximoIndex = (indexAtual + 1) % todos.count
            cenarioAtual = todos[proximoIndex]
        }
    }
    
    func cenarioAnterior() {
        let todos = CenarioInflacao.allCases
        if let indexAtual = todos.firstIndex(of: cenarioAtual) {
            let indexAnterior = (indexAtual - 1 + todos.count) % todos.count
            cenarioAtual = todos[indexAnterior]
        }
    }
    
    private func atualizarGraficoParaCenarioAtual() {
        self.pontosDoGrafico = dadosPorCenario[cenarioAtual] ?? []
    }
    
    private func gerarTodosOsCenarios() {
        for cenario in CenarioInflacao.allCases {
            dadosPorCenario[cenario] = calcularMatematica(para: cenario)
        }
    }
    
    private func calcularMatematica(para cenario: CenarioInflacao) -> [PontoEvolucao] {
        var novosDados: [PontoEvolucao] = []
        let valorInicialDouble = Double(valorInvestido)
        let cdiBase = 0.104
        
        for (index, card) in dadosDosCards.enumerated() {
            let nomeLegenda = "\(index + 1). \(card.tipo.tituloPrincipal)"
            let valorInput = (Double(card.caixaTexto.texto.replacingOccurrences(of: ",", with: ".")) ?? 0) / 100.0
            
            var taxaFixa: Double = 0.0
            var percentualCDI: Double = 0.0
            var taxaAdm: Double = 0.0
            
            if card.tipo.pedeTaxaPrefixada { taxaFixa = valorInput }
            if card.tipo.pedePercentualCDI { percentualCDI = valorInput }
            if card.tipo.pedeTaxasDeFundo { taxaAdm = valorInput }
            
            let investimento = card.tipo.criarInvestimento(
                taxaFixa: taxaFixa,
                percentualCDI: percentualCDI,
                taxaAdministracao: taxaAdm
            )
            
            for ano in 0...tempoInvestimento {
                let meses = ano * 12
                
                // 🔥 4. AQUI ESTÁ A MUDANÇA MATEMÁTICA:
                let inflacaoSorteada = inflacaoFixadaPorAno[cenario]?[ano] ?? 0.045
                
                let montanteNominal = investimento.calcular(
                    valor: valorInicialDouble,
                    meses: meses,
                    inflacao: inflacaoSorteada,
                    indicador: cdiBase
                )
                
                let fatorDescontoInflacao = pow(1.0 + inflacaoSorteada, Double(ano))
                let montanteReal = montanteNominal / fatorDescontoInflacao
                
                novosDados.append(PontoEvolucao(
                    nomeInvestimento: nomeLegenda,
                    ano: ano,
                    montanteNominal: montanteNominal,
                    montanteReal: montanteReal
                ))
            }
        }
        
        return novosDados
    }
}

// MARK: - Extensão de Lógica Reativa
extension TelaResultadosViewModel {
    
    // Função inteligente: acha o lucro exato cruzando o ID do card com a posição dele no gráfico
        func obterMontanteFinal(para card: CardViewModel) -> Double {
            // 1. Descobre a posição (index) exata deste card na nossa lista
            guard let index = dadosDosCards.firstIndex(where: { $0.id == card.id }) else { return 0.0 }
            
            // 2. Recria o nome exato que o gráfico usou (ex: "1. CDB")
            let nomeLegendaEsperado = "\(index + 1). \(card.tipo.tituloPrincipal)"
            let anoFinal = tempoInvestimento
            
            // 3. Puxa do cenário que está passando na tela agora
            let pontos = dadosPorCenario[cenarioAtual] ?? []
            let pontoExato = pontos.first(where: { $0.nomeInvestimento == nomeLegendaEsperado && $0.ano == anoFinal })
            
            // 👇 4. A MÁGICA: Retorna o valor Real ou Nominal dependendo do Toggle da tela!
            if mostrarValorReal {
                return pontoExato?.montanteReal ?? 0.0
            } else {
                return pontoExato?.montanteNominal ?? 0.0
            }
        }
    
    // Compara todos os cards para ver quem leva a medalha de ouro (o ícone verde)
    func eOMelhorInvestimento(_ card: CardViewModel) -> Bool {
        let montantes = dadosDosCards.map { obterMontanteFinal(para: $0) }
        let maximo = montantes.max() ?? 0.0
        
        // Evita dar troféu se tudo estiver zerado
        if maximo == 0.0 { return false }
        
        return obterMontanteFinal(para: card) == maximo
    }
}
