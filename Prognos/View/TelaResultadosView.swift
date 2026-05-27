import SwiftUI
import Charts

struct TelaResultadosView: View {
    @ObservedObject var viewModel: TelaResultadosViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Valor do investimento")
                        Text("R$ \(viewModel.valorInvestido, format: .number.precision(.fractionLength(2)))")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.primary)
                    }
                    .padding()
                }
                .frame(maxWidth: 300)
                .frame(height: 100)
                .background(Color.green.opacity(0.3)) // Ajuste para a sua corPrimaria
                .cornerRadius(20)
                .padding(.horizontal)
                    
                // MARK: - Header (Cenário da Inflação)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cenário da")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Inflação \(viewModel.cenarioAtual.rawValue)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color.primary)
                            // Adicionando uma transição suave no título também
                            .animation(.default, value: viewModel.cenarioAtual)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: - Toggle Animado
                // Colocamos o .animation() direto no Binding.
                // Assim, quando o botão for clicado, o gráfico reage animando!
                Toggle(isOn: $viewModel.mostrarValorReal.animation(.easeInOut(duration: 0.6))) {
                    Text("Descontar Inflação (Poder de Compra)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .tint(.green)
                
                // MARK: - Gráfico Animado
                Chart(viewModel.pontosDoGrafico) { ponto in
                    LineMark(
                        x: .value("Ano", ponto.ano),
                        y: .value("Valor", viewModel.mostrarValorReal ? ponto.montanteReal : ponto.montanteNominal)
                    )
                    .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                    .interpolationMethod(.monotone)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: viewModel.tempoInvestimento))
                }
                .frame(height: 350)
                .padding(.horizontal)
                // quando há alteração em alguma dessas variáveis, a animacao roda
                .animation(.easeInOut(duration: 0.6), value: viewModel.pontosDoGrafico)
                .animation(.easeInOut(duration: 0.6), value: viewModel.mostrarValorReal)
                
                // MARK: - Controles (< | >)
                HStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            // Envolvendo a troca de cenário em uma animação
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.cenarioAnterior()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Divider()
                            .frame(height: 16)
                        
                        Button(action: {
                            // Envolvendo a troca de cenário em uma animação
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.proximoCenario()
                            }
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
