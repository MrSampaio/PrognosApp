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
            let nomeLegenda = "\(index + 1). \(card.tipo.tituloPrincipal) (\(card.tipo.subtitulo))"
            nomes.append(nomeLegenda)
            
            // 👇 BUSCA A COR RESPECTIVA DAQUELE TIPO ESPECÍFICO
            let corDoInvestimento = obterCorRespectiva(para: card.tipo)
            cores.append(corDoInvestimento)
        }
        
        // nomes.append("Inflação")
        // cores.append(.red)
        
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
            let nomeLegenda = "\(index + 1). \(card.tipo.tituloPrincipal) (\(card.tipo.subtitulo))"
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
                // Em vez de chamar cenario.sortearTaxa() direto e gerar um valor randômico novo a cada milissegundo,
                // nós lemos do nosso cofrinho estável baseado no ano da linha.
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
