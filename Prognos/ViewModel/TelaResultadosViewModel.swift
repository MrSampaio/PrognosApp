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
    
    // 1. Controle do Cenário Atual
    @Published var cenarioAtual: CenarioInflacao = .randomica {
        didSet {
            // Toda vez que o cenário muda, recalculamos o gráfico!
            gerarDadosDoGrafico()
        }
    }
    
    @Published var pontosDoGrafico: [PontoEvolucao] = []
    
    init(valorInvestido: Float, tempoInvestimento: Int, dadosDosCards: [CardViewModel]) {
        self.valorInvestido = valorInvestido
        self.tempoInvestimento = tempoInvestimento
        self.dadosDosCards = dadosDosCards
        
        gerarDadosDoGrafico()
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
    
    // MARK: - Motor de Geração
    private func gerarDadosDoGrafico() {
        var novosDados: [PontoEvolucao] = []
        let valorInicialDouble = Double(valorInvestido)
        
        // Vamos simular um indicador CDI que também flutua levemente acompanhando a inflação
        let cdiBase = 0.104
        
        for card in dadosDosCards {
            let nomeLegenda = "\(card.tipo.tituloPrincipal)"
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
                
                // SORTEIO: Pega uma inflação aleatória baseada no cenário escolhido!
                let inflacaoSorteada = cenarioAtual.sortearTaxa()
                
                let montanteFinal = investimento.calcular(
                    valor: valorInicialDouble,
                    meses: meses,
                    inflacao: inflacaoSorteada,
                    indicador: cdiBase // Se quiser, pode randomizar o CDI aqui também!
                )
                
                novosDados.append(PontoEvolucao(
                    nomeInvestimento: nomeLegenda,
                    ano: ano,
                    montante: montanteFinal
                ))
            }
        }
        
        self.pontosDoGrafico = novosDados
    }
}
