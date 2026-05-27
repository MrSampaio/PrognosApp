import SwiftUI
import Charts

struct TelaResultadosView: View {
    @ObservedObject var viewModel: TelaResultadosViewModel
    
    @ScaledMetric(relativeTo: .body)
    var paddingAdaptativo: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: paddingAdaptativo) {
               
                    
                    Text("Simulação")
                    .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("CorFonteTitulo"))
                    
                
                    
                
                HStack{
                    VStack{
                        Text("Valor do investimento")
                            .font(.custom("BaiJamjuree-Medium", size: 16))
                            .foregroundStyle(Color("FonteUniversal"))
                        Text("R$ \(viewModel.valorInvestido, format: .number.precision(.fractionLength(2)))")
                            .font(.custom("BaiJamjuree-SemiBold", size: 32))
                            .foregroundStyle(Color("FonteUniversal"))
                            .foregroundColor(Color.primary)
                    }
                    .padding()
                }
                .frame(maxWidth: 400)
                .frame(height: 100)
                .background(Color("CorPrimaria")) // Ajuste para a sua corPrimaria
                .cornerRadius(14)
                .padding(.horizontal)
                    
                // MARK: - Header (Cenário da Inflação)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cenário da")
                            .font(.custom("BaiJamjujuree-Medium", size: 20))
                            .foregroundColor(.gray)
                        
                        Text("Inflação \(viewModel.cenarioAtual.rawValue)")
                            .font(.custom("BaiJamjuree-SemiBold", size: 28))
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
                        .font(.custom("BaiJamjujuree-Medium", size: 16))
                        .foregroundColor(.gray)
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
               // Spacer()
                
                VStack(spacing: paddingAdaptativo){
                    
                    Text("Comparação de resultados")
                        .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("CorFonteTitulo"))
                    
                }
                .padding(.top, 10)
                
                VStack(spacing: 36) {
                    
                    CardResultadoView(
                        titulo: "CDB",
                        descricao: "O investimento em CDB apresenta um melhor rendimento ao final da simulação",
                        icone: "checkmark",
                        corIcone: .corPrimaria
                    )
                    
                    CardResultadoView(
                        titulo: "CDI",
                        descricao: "O investimento em CDI apresenta um pior resultado ao final da simulação",
                        icone: "exclamationmark",
                        corIcone: .iconeCard
                    )
                    Spacer()
                    
                    NavigationLink {
                        
                        TelaSelecaoView()
                        
                    } label: {
                        
                        HStack(spacing: 8) {
                            
                            Text("Recomeçar consulta")
                            
                        }
                        .font(
                            .custom(
                                "BaiJamjuree-SemiBold",
                                size: 22,
                                relativeTo: .title3
                            )
                        )
                        .foregroundColor(Color("FonteUniversal"))
                        .frame(width: 300,
                               height: 48)
                        .background(Color("CorPrimaria"))
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, 42)
                }
                .padding()
                
            }
            .padding(.vertical)
            //.background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            .cornerRadius(24)
        }
#if os(iOS)
    .toolbar {
            ToolbarItem(placement: .topBarTrailing) {

                Button {

                } label: {

                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.system(size: 18, weight: .medium))
                    
                }
            }
        }

        .toolbarTitleDisplayMode(.inline)
    //.padding()
    .frame(maxWidth: .infinity)
    
    #endif
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
