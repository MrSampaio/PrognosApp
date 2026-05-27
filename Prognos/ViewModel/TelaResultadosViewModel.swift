import Foundation
import Combine

// MARK: - Model para o Gráfico
struct PontoEvolucao: Identifiable {
    let id = UUID()
    let nomeInvestimento: String
    let ano: Int
    let montante: Double
}

class TelaResultadosViewModel: ObservableObject {
    let valorInvestido: Float
    let tempoInvestimento: Int
    let dadosDosCards: [CardViewModel]
    
    // 1. "Cofre" que guarda os dados calculados de TODOS os cenários
    private var dadosPorCenario: [CenarioInflacao: [PontoEvolucao]] = [:]
    
    @Published var cenarioAtual: CenarioInflacao = .randomica {
        didSet {
            atualizarGraficoParaCenarioAtual()
        }
    }
    
    // Variável que a View efetivamente desenha
    @Published var pontosDoGrafico: [PontoEvolucao] = []
    
    init(valorInvestido: Float, tempoInvestimento: Int, dadosDosCards: [CardViewModel]) {
        self.valorInvestido = valorInvestido
        self.tempoInvestimento = tempoInvestimento
        self.dadosDosCards = dadosDosCards
        
        // 3. Ao nascer, a ViewModel já calcula e guarda o histórico dos 3 cenários de uma vez
        gerarTodosOsCenarios()
        
        // 4. Define o que vai aparecer primeiro na tela
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
    
    // Puxa do dicionário os pontos corretos e joga para a View
    private func atualizarGraficoParaCenarioAtual() {
        self.pontosDoGrafico = dadosPorCenario[cenarioAtual] ?? []
    }
    
    // Roda um Loop pelos 3 cenários e salva os cálculos definitivos no Dicionário
    private func gerarTodosOsCenarios() {
        for cenario in CenarioInflacao.allCases {
            dadosPorCenario[cenario] = calcularMatematica(para: cenario)
        }
    }
    
    // funcao que calcula os pontos do grafico ja recebendo o cenário
    private func calcularMatematica(para cenario: CenarioInflacao) -> [PontoEvolucao] {
            var novosDados: [PontoEvolucao] = []
            let valorInicialDouble = Double(valorInvestido)
            
            let cdiBase = 0.104
            
            // 1. Mudamos para .enumerated() para ter acesso ao índice (0, 1, 2...)
            for (index, card) in dadosDosCards.enumerated() {
                
                // 2. Criamos um nome ÚNICO para a legenda.
                // Ex: "1. Tesouro (12,5%)" e "2. Tesouro (10,5%)"
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
                    
                    let montanteFinal = investimento.calcular(
                        valor: valorInicialDouble,
                        meses: meses,
                        inflacao: inflacaoSorteada,
                        indicador: cdiBase
                    )
                    
                    novosDados.append(PontoEvolucao(
                        nomeInvestimento: nomeLegenda,
                        ano: ano,
                        montante: montanteFinal
                    ))
                }
            }
            
            return novosDados
        }
}
