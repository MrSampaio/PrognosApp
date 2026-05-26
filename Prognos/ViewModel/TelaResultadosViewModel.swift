import Foundation
import Combine

class TelaResultadosViewModel: ObservableObject {
    
    private let dadosSimulacao: DadosDaSimulacao
    
    // A View vai ler essa lista para desenhar as linhas
    @Published var pontosDoGrafico: [PontoDoGrafico] = []
    
    // O didSet escuta o Picker e recalcula o gráfico automaticamente
    @Published var cenarioAtual: CenarioEconomico = .historico {
        didSet {
            recalcularGrafico()
        }
    }
    
    init(dados: DadosDaSimulacao) {
        self.dadosSimulacao = dados
        self.recalcularGrafico() // Roda a matemática ao abrir a tela
    }
    
    private func recalcularGrafico() {
        var novosPontos: [PontoDoGrafico] = []
        
        for inv in dadosSimulacao.investimentos {
            let valorInicialOriginal = Double(dadosSimulacao.valorInicial)
            let nomeParaLegenda = "\(inv.tipo.tituloPrincipal) \(inv.tipo.subtitulo)"
            
            // 1. Cria o Ponto Inicial (Ano 0 - Dinheiro sem rendimento)
            novosPontos.append(PontoDoGrafico(nomeInvestimento: nomeParaLegenda, ano: 0, saldo: Float(valorInicialOriginal)))
            
            // 2. Prepara a taxa decimal (ex: 105% vira 1.05)
            let taxaDecimal = Double(inv.taxaDigitada) / 100.0
            
            // 3. Cria a "máquina" que sabe as regras de Imposto e B3 deste título
            let motorDoInvestimento = inv.tipo.criarInvestimento(
                taxaFixa: taxaDecimal,
                percentualCDI: taxaDecimal,
                taxaAdministracao: taxaDecimal
            )
            
            // Puxa as projeções de inflação e juros do cenário atual (Otimista, Histórico, etc)
            let inflacaoCenario = Double(cenarioAtual.taxaIpcaProjetada) / 100.0
            let indicadorCenario = Double(cenarioAtual.taxaCdiProjetada) / 100.0
            
            // 4. Loop dos anos: pede pro motor calcular o valor líquido exato
            if dadosSimulacao.tempoAnos > 0 {
                for ano in 1...dadosSimulacao.tempoAnos {
                    
                    let mesesAcumulados = ano * 12
                    
                    // A mágica: calcula os juros sobre juros e abate os impostos reais
                    let saldoLiquidoNoAno = motorDoInvestimento.calcular(
                        valor: valorInicialOriginal,
                        meses: mesesAcumulados,
                        inflacao: inflacaoCenario,
                        indicador: indicadorCenario
                    )
                    
                    novosPontos.append(PontoDoGrafico(
                        nomeInvestimento: nomeParaLegenda,
                        ano: ano,
                        saldo: Float(saldoLiquidoNoAno)
                    ))
                }
            }
        }
        
        // Atualiza a tela com os novos dados processados
        self.pontosDoGrafico = novosPontos
    }
}
