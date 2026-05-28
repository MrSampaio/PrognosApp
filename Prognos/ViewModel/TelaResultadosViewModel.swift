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
    @Published var valorInvestido: Float
    @Published var tempoInvestimento: Int
    var dadosDosCards: [CardViewModel]
    
    @Published var nomesLegendas: [String] = []
    @Published var coresLegendas: [Color] = []
    @Published var mostrarValorReal: Bool = true
    @Published var pontosDoGrafico: [PontoEvolucao] = []
    
    private var inflacaoFixadaPorAno: [CenarioInflacao: [Double]] = [:]
    public var dadosPorCenario: [CenarioInflacao: [PontoEvolucao]] = [:]
    
    @Published var cenarioAtual: CenarioInflacao = .historica {
        didSet { atualizarGraficoParaCenarioAtual() }
    }
    
    init(valorInvestido: Float, tempoInvestimento: Int, dadosDosCards: [CardViewModel]) {
        self.valorInvestido = valorInvestido
        self.tempoInvestimento = tempoInvestimento
        self.dadosDosCards = dadosDosCards
        
        configurarLegendasECores()
        gerarLinhaDoTempoDaInflacao()
        gerarTodosOsCenarios()
        atualizarGraficoParaCenarioAtual()
    }
    
    private func gerarLinhaDoTempoDaInflacao() {
        inflacaoFixadaPorAno = [:]
        for cenario in CenarioInflacao.allCases {
            // Garantimos que a trajetória tenha pelo menos o tamanho necessário
            // Se a trajetória for curta, nós a estendemos com o último valor
            var taxa = cenario.trajetoria
            while taxa.count <= tempoInvestimento {
                taxa.append(taxa.last ?? 0.045)
            }
            inflacaoFixadaPorAno[cenario] = taxa
        }
    }
    
    func recalcularSimulacao(novoValor: Float, novoTempo: Int, cardsAtualizados: [CardViewModel]) {
        self.valorInvestido = novoValor
        self.dadosDosCards = cardsAtualizados
        
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
            
            // 🔥 FILTRO BLINDADO DE TEXTO:
            // Transforma " 10,5 % " em "10.5" puro antes de tentar converter para Double!
            let textoNumericoCru = card.caixaTexto.texto
                .replacingOccurrences(of: ",", with: ".") // Troca vírgula por ponto
                .components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted) // Tira %, letras e espaços
                .joined()
            
            let valorInput = (Double(textoNumericoCru) ?? 0.0) / 100.0
            
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
                
                // 🔥 SEGURANÇA TOTAL:
                // Se o cenário não tiver taxa para este ano, usamos a última taxa disponível ou 4.5%
                let trajetoriaDoCenario = inflacaoFixadaPorAno[cenario] ?? [0.045]
                let inflacaoSorteada = ano < trajetoriaDoCenario.count ? trajetoriaDoCenario[ano] : (trajetoriaDoCenario.last ?? 0.045)
                
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
    
    func obterMontanteFinal(noIndice index: Int) -> Double {
            // 1. Segurança: Verifique se o índice existe na lista de cards
            guard index >= 0 && index < dadosDosCards.count else { return Double(valorInvestido) }
            
            // 2. Segurança: Verifique se o gráfico já processou algo para o cenário atual
            let pontosBrutos = dadosPorCenario[cenarioAtual] ?? []
            guard !pontosBrutos.isEmpty else { return Double(valorInvestido) }
            
            let card = dadosDosCards[index]
            let legendaExata = "\(index + 1). \(card.tipo.tituloPrincipal)"
            
            // 3. Pega o último ponto disponível para este investimento (ano final)
            // Se por algum motivo o ano final não foi calculado ainda, pega o último da lista
            let pontoFinal = pontosBrutos.last(where: { $0.nomeInvestimento == legendaExata })
            
            let valorCalculado = mostrarValorReal ? (pontoFinal?.montanteReal ?? 0.0) : (pontoFinal?.montanteNominal ?? 0.0)
            
            // 4. Se o valor for 0 (erro de processamento), retorna o valor investido inicial
            return valorCalculado > 0 ? max(Double(valorInvestido), valorCalculado) : Double(valorInvestido)
        }
    
    func eOMelhorInvestimento(noIndice index: Int) -> Bool {
        var montantes: [Double] = []
        
        for i in 0..<dadosDosCards.count {
            montantes.append(obterMontanteFinal(noIndice: i))
        }
        
        let maximo = montantes.max() ?? 0.0
        if maximo == 0.0 { return false }
        
        return obterMontanteFinal(noIndice: index) == maximo
    }
}
