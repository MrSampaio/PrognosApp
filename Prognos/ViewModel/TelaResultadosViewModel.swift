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
    
    // 👇 REVERTIDO: Voltaram a ser @Published para que a View possa atualizar e ler
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
            var taxa = cenario.trajetoria
            // Garante que o array tenha o tamanho necessário
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
    
    func configurarLegendasECores() {
        self.nomesLegendas = dadosDosCards.enumerated().map { index, card in
            "\(index + 1). \(card.tipo.tituloPrincipal)"
        }
        self.coresLegendas = dadosDosCards.map { Color($0.tipo.cores) }
    }

    private func obterCorRespectiva(para tipo: TipoDeInvestimento) -> Color {
        // Mantenha sua lógica atual aqui
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
            cenarioAtual = todos[(indexAtual + 1) % todos.count]
        }
    }
    
    func cenarioAnterior() {
        let todos = CenarioInflacao.allCases
        if let indexAtual = todos.firstIndex(of: cenarioAtual) {
            cenarioAtual = todos[(indexAtual - 1 + todos.count) % todos.count]
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
                
                let textoNumericoCru = card.caixaTexto.texto
                    .replacingOccurrences(of: ",", with: ".")
                    .components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted)
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
                
                // Loop seguro pelos anos
                for ano in 0...tempoInvestimento {
                    let meses = ano * 12
                    let trajetoria = inflacaoFixadaPorAno[cenario] ?? [0.045]
                    let inflacaoSorteada = ano < trajetoria.count ? trajetoria[ano] : (trajetoria.last ?? 0.045)
                    
                    // Cálculo real
                    let montanteNominal = investimento.calcular(
                        valor: valorInicialDouble,
                        meses: meses,
                        inflacao: inflacaoSorteada,
                        indicador: cdiBase
                    )
                    
                    // Debug (Opcional: coloque em comentário se não quiser ver no console)
                    if ano == tempoInvestimento && montanteNominal <= 0 {
                        print("DEBUG: Investimento \(card.tipo.tituloPrincipal) resultou em \(montanteNominal).")
                    }
                    
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
    
    // Retorna o valor real, sem travas, para que você veja lucros ou prejuízos reais
    func obterMontanteFinal(noIndice index: Int) -> Double {
        guard index >= 0 && index < dadosDosCards.count else { return 0.0 }
        
        let card = dadosDosCards[index]
        let legendaExata = "\(index + 1). \(card.tipo.tituloPrincipal)"
        
        let pontosBrutos = dadosPorCenario[cenarioAtual] ?? []
        let pontoFinal = pontosBrutos.last(where: { $0.nomeInvestimento == legendaExata })
        
        if mostrarValorReal {
            return pontoFinal?.montanteReal ?? 0.0
        } else {
            return pontoFinal?.montanteNominal ?? 0.0
        }
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
