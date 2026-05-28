import SwiftUI
import Charts

struct TelaResultadosView: View {
    // 👇 Voltamos para o formato correto: apenas recebe a ViewModel pronta da tela anterior!
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
                
                HStack {
                    VStack {
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
                .background(Color("CorPrimaria"))
                .cornerRadius(14)
                .padding(.horizontal)
                
                // MARK: - Header (Cenário da Inflação)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cenário da")
                            .font(.custom("BaiJamjuree-Medium", size: 20))
                            .foregroundColor(.gray)
                        
                        Text("Inflação \(viewModel.cenarioAtual.rawValue)")
                            .font(.custom("BaiJamjuree-SemiBold", size: 28))
                            .foregroundColor(Color.primary)
                            .animation(.default, value: viewModel.cenarioAtual)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: - Toggle Animado
                Toggle(isOn: $viewModel.mostrarValorReal.animation(.easeInOut(duration: 0.6))) {
                    Text("Descontar Inflação (Poder de Compra)")
                        .font(.custom("BaiJamjuree-Medium", size: 16))
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
                .animation(.easeInOut(duration: 0.6), value: viewModel.pontosDoGrafico)
                .animation(.easeInOut(duration: 0.6), value: viewModel.mostrarValorReal)
                
                // MARK: - Controles (< | >)
                HStack {
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.cenarioAnterior()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        
                        Divider().frame(height: 16)
                        
                        Button(action: {
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
                
                // MARK: - TÍTULO DA COMPARAÇÃO
                VStack(spacing: paddingAdaptativo) {
                    Text("Comparação de resultados")
                        .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color("CorFonteTitulo"))
                }
                .padding(.top, 10)
                
                // MARK: - LISTA DE CARDS DINÂMICOS
                VStack(spacing: 16) {
                    ForEach(viewModel.dadosDosCards, id: \.id) { card in
                        let montanteFinal = viewModel.obterMontanteFinal(para: card)
                        let melhor = viewModel.eOMelhorInvestimento(card)
                        
                        CardResultadoView(
                            titulo: card.tipo.tituloPrincipal,
                            lucroLiquido: max(0, montanteFinal - Double(viewModel.valorInvestido)),
                            eOMelhor: melhor
                        )
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // Botão de Recomeçar
                    Button(action: {
                        // Ação para resetar ou voltar telas
                    }) {
                        HStack(spacing: 8) {
                            Text("Recomeçar consulta")
                        }
                        .font(.custom("BaiJamjuree-SemiBold", size: 22, relativeTo: .title3))
                        .foregroundColor(Color("FonteUniversal"))
                        .frame(width: 300, height: 48)
                        .background(Color("CorPrimaria"))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 42)
            }
            .padding(.vertical)
            .cornerRadius(24)
        }
    }
}

// MARK: - Extensão de Lógica Reativa
extension TelaResultadosViewModel {
    func obterMontanteFinal(para card: CardViewModel) -> Double {
        let pontos = pontosDoGrafico
        let anoFinal = tempoInvestimento
        return pontos.first(where: { $0.nomeInvestimento.contains(card.tipo.tituloPrincipal) && $0.ano == anoFinal })?.montanteNominal ?? 0.0
    }
    
    func eOMelhorInvestimento(_ card: CardViewModel) -> Bool {
        let montantes = dadosDosCards.map { obterMontanteFinal(para: $0) }
        let maximo = montantes.max() ?? 0.0
        return obterMontanteFinal(para: card) == maximo
    }
}

// MARK: - Preview iPhone
#Preview {
    let cardCdb = CardViewModel(tipo: .cdbCdi)
    cardCdb.caixaTexto.texto = "100"
    
    let cardTesouro = CardViewModel(tipo: .tesouroPrefixado)
    cardTesouro.caixaTexto.texto = "11.5"
    
    // Criamos uma ViewModel falsa só para o Preview rodar bonito
    let mockVM = TelaResultadosViewModel(
        valorInvestido: 5000,
        tempoInvestimento: 5,
        dadosDosCards: [cardCdb, cardTesouro]
    )
    
    return NavigationStack {
        TelaResultadosView(viewModel: mockVM)
    }
}
