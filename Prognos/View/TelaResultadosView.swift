import SwiftUI
import Charts

struct TelaResultadosView: View {
    // Escuta a ViewModel
    @ObservedObject var viewModel: TelaResultadosViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: - Header (Cenário da Inflação)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cenário da")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Text("Inflação \(viewModel.cenarioAtual.rawValue)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.primary)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            
            // MARK: - Gráfico
            Chart(viewModel.pontosDoGrafico) { ponto in
                LineMark(
                    x: .value("Ano", ponto.ano),
                    y: .value("Valor", ponto.montante)
                )
                .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                .interpolationMethod(.monotone)
                
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: viewModel.tempoInvestimento))
            }
            .frame(height: 350)
            .padding(.horizontal)
            
            // MARK: - Controles (< | >)
            HStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.cenarioAnterior()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                        .frame(height: 16)
                    
                    Button(action: {
                        viewModel.proximoCenario()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(30)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(.vertical)
        .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
        .cornerRadius(24)
    }
}
// MARK: - Preview
#Preview {
    let cdbPos = CardViewModel(tipo: .cdbCdi)
    cdbPos.caixaTexto.texto = "110"
    
    let tesouroPre = CardViewModel(tipo: .tesouroPrefixado)
    tesouroPre.caixaTexto.texto = "12,5"
    
    let lciPre = CardViewModel(tipo: .lciPrefixado)
    lciPre.caixaTexto.texto = "10,5"
    
    // Iniciamos a ViewModel primeiro
    let mockViewModel = TelaResultadosViewModel(
        valorInvestido: 10000.0,
        tempoInvestimento: 5,
        dadosDosCards: [cdbPos, tesouroPre, lciPre]
    )
    
    return NavigationStack {
        // Passamos a ViewModel para a View
        TelaResultadosView(viewModel: mockViewModel)
    }
}
