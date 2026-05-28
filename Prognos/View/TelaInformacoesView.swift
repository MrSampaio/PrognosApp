import SwiftUI
// MARK: - Extensão para o Teclado do iPhone
#if canImport(UIKit)
extension View {
    func esconderTeclado() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct TelaInformacoesView: View {
    
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 20
    @ScaledMetric(relativeTo: .title) var espacamentoTitulo: CGFloat = 24
    @ScaledMetric(relativeTo: .body) var espacamentoGrid: CGFloat = 10
    
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    @StateObject var gerente: SimuladorInvestimentosViewModel
    
    @State private var irParaResultados = false
    
    init(investimentos: [TipoDeInvestimento]) {
      
        _gerente = StateObject(wrappedValue: SimuladorInvestimentosViewModel(tiposEscolhidos: investimentos))
       
    }
    
    var body: some View {
        ZStack {
            // Fundo principal da tela
            Color("CorFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) { // Espaço entre a parte de cima e o "Grande Card"
                    
                    // ==========================================
                    // 1. PARTE SUPERIOR (Fundo normal)
                    // ==========================================
                    VStack(spacing: paddingAdaptativo) {
                        Text("Dados dos investimentos")
                            .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("CorFonteTitulo"))
                            .padding(.top, 10)
                        
                        Text("Insira o valor e o tempo que você gostaria de consultar o seu investimento")
                            .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .subheadline))
                            .lineLimit(nil)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color("CorFonte"))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                        
                        HStack {
                            CaixaValorTempo(modeloValor: $valorGlobal, modeloTempo: $tempoGlobal)
                        }
                        .frame(maxWidth: 360)
                    }
                    .padding(.horizontal)
                    
                    
                    // ==========================================
                    // 2. O GRANDE CARD DE BAIXO
                    // ==========================================
                    VStack(spacing: paddingAdaptativo) {
                        
                        Text("Informe os parâmetros\nde cada investimento")
                            .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title2))
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("CorFonte"))
                            .padding(.top, 30) // Respiro no topo do card
                        
                        let valorConvertido = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                        let tempoConvertido = Int(tempoGlobal.texto) ?? 0
                        
                        // Lista de cartões
                        ForEach(gerente.cardsDeInvestimento) { viewModelDoCard in
                            CardView(
                                viewModel: viewModelDoCard,
                                valorInvestido: valorConvertido,
                                tempoDeInvestimento: tempoConvertido,
                                corGrafico: Color(viewModelDoCard.tipo.cores)
                            )
                            .frame(maxWidth: 350)
                        }
                        
                        let podeSimular = !valorGlobal.texto.isEmpty && !tempoGlobal.texto.isEmpty
                        
                        Button {
                            irParaResultados = true
                        } label: {
                            BotaoView(texto: "Simular", habilitado: podeSimular)
                        }
                        .disabled(!podeSimular)
                        .padding(.top, 24)
                        .padding(.bottom, 40) // Respiro no fundo do card
                        
                        .navigationDestination(isPresented: $irParaResultados) {
                                            
                            // 1. Limpeza Pesada do Dinheiro (Tira o R$, tira o ponto e arruma a vírgula)
                            let valorLimpo = valorGlobal.texto
                                .replacingOccurrences(of: "R$", with: "")
                                .replacingOccurrences(of: ".", with: "")
                                .replacingOccurrences(of: ",", with: ".")
                                .trimmingCharacters(in: .whitespaces)
                            
                            let valorConvertidoParaPassar = Float(valorLimpo) ?? 0.0
                            
                            // 2. Limpeza do Tempo (Pega só os números digitados para não dar bug)
                            let tempoApenasNumeros = tempoGlobal.texto.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                            let tempoConvertidoParaPassar = Int(tempoApenasNumeros) ?? 1
                            
                            // 3. Chamando a Tela 2 do jeito correto, passando os dados puros!
                            let viewModelResultados = TelaResultadosViewModel(
                                valorInvestido: valorConvertidoParaPassar,
                                tempoInvestimento: tempoConvertidoParaPassar,
                                dadosDosCards: gerente.cardsDeInvestimento
                            )
                            
                            // 4. Chamamos a tela passando o pacote fechado
                            TelaResultadosView(viewModel: viewModelResultados)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    // 🎨 TROQUE A COR AQUI EMBAIXO:
                    .background(Color.corCaixaCard)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                }
            }
        }
        
        .onTapGesture {
                    #if canImport(UIKit)
                    esconderTeclado()
                    #endif
                }
                // 👇 Opcional, mas muito recomendado (iOS 16+): esconde o teclado se o usuário rolar a tela para baixo
                .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
    return NavigationStack {
        TelaInformacoesView(investimentos: investimentosSimulacao)
    }
}
