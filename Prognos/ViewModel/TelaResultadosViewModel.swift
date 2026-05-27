import Foundation
import Combine

// MARK: - Model para o Gráfico
struct PontoEvolucao: Identifiable, Equatable {
    var id: String { "\(nomeInvestimento)-\(ano)" }
    
    let nomeInvestimento: String
    let ano: Int
    let montanteNominal: Double
    let montanteReal: Double
    
}
class TelaResultadosViewModel: ObservableObject {
    let valorInvestido: Float
    let tempoInvestimento: Int
    let dadosDosCards: [CardViewModel]
    
    // NOVO: Controle do Toggle na tela (começa ativado mostrando o Valor Real)
    @Published var mostrarValorReal: Bool = true
    
    private var dadosPorCenario: [CenarioInflacao: [PontoEvolucao]] = [:]
    
    @Published var cenarioAtual: CenarioInflacao = .randomica {
        didSet {
            atualizarGraficoParaCenarioAtual()
        }
    }
    
    @Published var pontosDoGrafico: [PontoEvolucao] = []
    
    init(valorInvestido: Float, tempoInvestimento: Int, dadosDosCards: [CardViewModel]) {
        self.valorInvestido = valorInvestido
        self.tempoInvestimento = tempoInvestimento
        self.dadosDosCards = dadosDosCards
        
        gerarTodosOsCenarios()
        atualizarGraficoParaCenarioAtual()
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
    
    // MARK: - Motores de Geração
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
            let taxaDigitada = card.caixaTexto.texto.isEmpty ? "0" : card.caixaTexto.texto
            let nomeLegenda = "\(index + 1). \(card.tipo.tituloPrincipal) (\(taxaDigitada)%)"
            
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
                let inflacaoSorteada = cenario.sortearTaxa()
                
                // 1. Calcula o montante nominal (bruto - taxas e impostos)
                let montanteNominal = investimento.calcular(
                    valor: valorInicialDouble,
                    meses: meses,
                    inflacao: inflacaoSorteada,
                    indicador: cdiBase
                )
                
                // 2. Calcula o montante real (descontando a inflação do período)
                let fatorDescontoInflacao = pow(1.0 + inflacaoSorteada, Double(ano))
                let montanteReal = montanteNominal / fatorDescontoInflacao
                
                novosDados.append(PontoEvolucao(
                    nomeInvestimento: nomeLegenda,
                    ano: ano,
                    montanteNominal: montanteNominal,
                    montanteReal: montanteReal // Salvando ambos no cofre
                ))
            }
        }
        
        return novosDados
    }
}
