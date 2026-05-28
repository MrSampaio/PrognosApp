import SwiftUI
import Charts

struct TelaResultadosView: View {
    
    @ObservedObject var viewModel: TelaResultadosViewModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 20
    
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    var body: some View {
        ScrollView {
            VStack(spacing: paddingAdaptativo) {
                
                // MARK: - TÍTULO PRINCIPAL
                Text("Simulação")
                    .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("CorFonteTitulo"))
                    .accessibilityAddTraits(.isHeader)
                
                // MARK: - VALOR DO INVESTIMENTO
                ViewThatFits {
                    HStack {
                        VStack(spacing: 4) {
                            Text("Valor do investimento")
                                .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .subheadline))
                                .foregroundStyle(Color("FonteUniversal"))
                            Text("R$ \(viewModel.valorInvestido, format: .number.precision(.fractionLength(2)))")
                                .font(.custom("BaiJamjuree-SemiBold", size: 32, relativeTo: .largeTitle))
                                .foregroundStyle(Color("FonteUniversal"))
                                .foregroundColor(Color.primary)
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Valor do investimento")
                            .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .subheadline))
                            .foregroundStyle(Color("FonteUniversal"))
                        Text("R$ \(viewModel.valorInvestido, format: .number.precision(.fractionLength(2)))")
                            .font(.custom("BaiJamjuree-SemiBold", size: 32, relativeTo: .largeTitle))
                            .foregroundStyle(Color("FonteUniversal"))
                            .foregroundColor(Color.primary)
                    }
                    .padding()
                }
                .frame(maxWidth: 400)
                .frame(minHeight: 100)
                .background(Color("CorPrimaria"))
                .cornerRadius(14)
                .padding(.horizontal)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Valor do investimento: R$ \(viewModel.valorInvestido, format: .number.precision(.fractionLength(2)))")
                
                // MARK: - HEADER (Cenário da Inflação)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cenário da")
                            .font(.custom("BaiJamjuree-Medium", size: 20, relativeTo: .title3))
                            .foregroundColor(.gray)
                        
                        Text("Inflação \(viewModel.cenarioAtual.rawValue)")
                            .font(.custom("BaiJamjuree-SemiBold", size: 28, relativeTo: .title))
                            .foregroundColor(Color.primary)
                            .animation(.default, value: viewModel.cenarioAtual)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .accessibilityElement(children: .combine)
                
                // MARK: - TOGGLE ANIMADO
                Toggle(isOn: $viewModel.mostrarValorReal.animation(.easeInOut(duration: 0.6))) {
                    Text("Descontar Inflação (Poder de Compra)")
                        .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .tint(.green)
                .accessibilityHint("Liga ou desliga o desconto da inflação no gráfico e nos resultados")
                
                // MARK: - GRÁFICO ANIMADO
                Chart(viewModel.pontosDoGrafico) { ponto in
                    LineMark(
                        x: .value("Ano", ponto.ano),
                        y: .value("Valor", viewModel.mostrarValorReal ? ponto.montanteReal : ponto.montanteNominal)
                    )
                    .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                    .interpolationMethod(.monotone)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: viewModel.tempoInvestimento))
                }
                .chartXAxisLabel("Anos", alignment: .center)
                // 👇 Configuração para colocar o eixo Y à direita
                .chartYAxis {
                    AxisMarks(position: .trailing) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .currency(code: "BRL"))
                    }
                }
                // ------------------------------------
                .chartForegroundStyleScale(
                    domain: viewModel.nomesLegendas,
                    range: viewModel.coresLegendas
                )
                .frame(height: 350)
                .padding(.horizontal)
                .animation(.easeInOut(duration: 0.6), value: viewModel.pontosDoGrafico)
                .animation(.easeInOut(duration: 0.6), value: viewModel.mostrarValorReal)
                .accessibilityLabel("Gráfico de linha mostrando a evolução do montante ao longo de \(viewModel.tempoInvestimento) anos.")
                
                // MARK: - CONTROLES DE CENÁRIO (< | >)
                HStack {
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) { viewModel.cenarioAnterior() }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Cenário anterior")
                        
                        Divider().frame(height: 16)
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) { viewModel.proximoCenario() }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Próximo cenário")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(30)
                    Spacer()
                }
                .padding(.top, 10)
                
                // MARK: - TÍTULO DA COMPARAÇÃO
                VStack(spacing: paddingAdaptativo) {
                    Text("Comparação de resultados")
                        .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("CorFonteTitulo"))
                        .accessibilityAddTraits(.isHeader)
                }
                .padding(.top, 10)
                
                // MARK: - LISTA DE CARDS DINÂMICOS
                VStack(spacing: 16) {
                    ForEach(viewModel.dadosDosCards, id: \.id) { card in
                        
                        // ⚠️ CORREÇÃO DA SINTAXE MÁGICA AQUI:
                        let montanteFinal = viewModel.obterMontanteFinal(para: card)
                        let melhor = viewModel.eOMelhorInvestimento(card)
                        
                        let lucroCalculado = montanteFinal - Double(viewModel.valorInvestido)
                        
                        CardResultadoView(
                            titulo: card.tipo.tituloPrincipal,
                            lucroLiquido: lucroCalculado,
                            eOMelhor: melhor
                        )
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // MARK: - BOTÃO DE RECOMEÇAR
                    Button(action: {
                        // Ação para resetar ou voltar telas
                    }) {
                        HStack(spacing: 8) {
                            Text("Recomeçar consulta")
                        }
                        .font(.custom("BaiJamjuree-SemiBold", size: 22, relativeTo: .title3))
                        .foregroundColor(Color("FonteUniversal"))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 300)
                        .frame(minHeight: 48)
                        .padding(.horizontal)
                        .background(Color("CorPrimaria"))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Volta para a tela inicial para fazer uma nova simulação.")
                }
                .id("\(viewModel.cenarioAtual.rawValue)-\(viewModel.mostrarValorReal)")
                .padding(.horizontal, 24)
                .padding(.bottom, 42)
            }
            .padding(.vertical)
            .cornerRadius(24)
        }
    }
}

#Preview {
    let mockVM = TelaResultadosViewModel(
        valorInvestido: 5000,
        tempoInvestimento: 5,
        dadosDosCards: [
            CardViewModel(tipo: .cdbCdi),
            CardViewModel(tipo: .tesouroPrefixado)
        ]
    )
    
    return NavigationStack {
        TelaResultadosView(viewModel: mockVM)
    }
}
