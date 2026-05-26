import SwiftUI
import Charts

struct TelaResultadosView: View {
    
    @StateObject private var viewModel: TelaResultadosViewModel
    
    init(dados: DadosDaSimulacao) {
        _viewModel = StateObject(wrappedValue: TelaResultadosViewModel(dados: dados))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Projeção do Investimento")
                .font(.title2.bold())
            
            
            Picker("Cenário", selection: $viewModel.cenarioAtual) {
                ForEach(CenarioEconomico.allCases, id: \.self) { cenario in
                    Text(cenario.rawValue).tag(cenario)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Chart {
                ForEach(viewModel.pontosDoGrafico) { ponto in
                    LineMark(
                        x: .value("Ano", ponto.ano),
                        y: .value("Saldo", ponto.saldo)
                    )
                    .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                    
                    PointMark(
                        x: .value("Ano", ponto.ano),
                        y: .value("Saldo", ponto.saldo)
                    )
                    .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                }
            }
            // Animação para a transição das curvas quando o Picker muda
            // .animation(.spring(response: 0.6, dampingFraction: 0.7), value: viewModel.pontosDoGrafico)
            .frame(height: 300)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Resultados")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// O Preview para desenhar a tela no Canvas
#Preview {
    let investimentosMock = [
        InvestimentoConfigurado(tipo: .cdbCdi, taxaDigitada: 105.0),
        InvestimentoConfigurado(tipo: .tesouroPrefixado, taxaDigitada: 11.5)
    ]
    
    let pacoteDaSimulacao = DadosDaSimulacao(
        valorInicial: 1500.50,
        tempoAnos: 5,
        investimentos: investimentosMock
    )
    
    NavigationStack {
        TelaResultadosView(dados: pacoteDaSimulacao)
    }
}
