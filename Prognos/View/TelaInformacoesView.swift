import SwiftUI

struct TelaInformacoesView: View {
    
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 20
    @ScaledMetric(relativeTo: .title) var espacamentoTitulo: CGFloat = 24
    @ScaledMetric(relativeTo: .body) var espacamentoGrid: CGFloat = 10

    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    // ⚠️ MUDANÇA ARQUITETURAL AQUI:
    // Trocamos o @State solto pelo nosso Gerente do cofre forte!
    @StateObject var gerente: SimuladorInvestimentosViewModel
    
    @State private var irParaResultados = false
    
    // O init recebe as escolhas da tela anterior e cria o Gerente
    init(investimentos: [TipoDeInvestimento]) {
        _gerente = StateObject(wrappedValue: SimuladorInvestimentosViewModel(tiposEscolhidos: investimentos))
    }
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: paddingAdaptativo){
                
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
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                Text("Informe os parâmetros de cada investimento")
                    .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title2))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("CorFonte"))
                    .padding(.vertical, 5)
                
                let valorConvertido = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let tempoConvertido = Int(tempoGlobal.texto) ?? 0
                
                // ⚠️ AQUI ENCAIXAMOS OS CARDS:
                // Varremos a lista segura que está dentro do Gerente
                ForEach(gerente.cardsDeInvestimento) { viewModelDoCard in
                    
                    CardView(
                        viewModel: viewModelDoCard,
                        valorInvestido: valorConvertido,
                        tempoDeInvestimento: tempoConvertido,
                        // ⚠️ CORRIGIDO: Puxando a cor certa do Enum em vez de .black
                        corGrafico: Color(viewModelDoCard.tipo.cores)
                    )
                    .frame(maxWidth: 350)
                    .padding(.bottom, 12)
                    
                }
                
                let podeSimular = !valorGlobal.texto.isEmpty && !tempoGlobal.texto.isEmpty
                
                Button {
                    // Ao clicar, disparamos o gatilho da navegação
                    irParaResultados = true
                } label: {
                    BotaoView(texto: "Simular", habilitado: podeSimular)
                }
                .disabled(!podeSimular)
                .padding(.top, 12)
                .padding(.bottom, 24)
                .navigationDestination(isPresented: $irParaResultados) {
                    
                    // 1. Convertendo os valores de String para Float/Int
                    let valorConvertidoParaPassar = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                    let tempoConvertidoParaPassar = Int(tempoGlobal.texto) ?? 0
                    
                    // 2. Instanciando a ViewModel da próxima tela
                    let viewModelResultados = TelaResultadosViewModel(
                        valorInvestido: valorConvertidoParaPassar,
                        tempoInvestimento: tempoConvertidoParaPassar,
                        // ⚠️ Passamos os dados do Gerente para a tela de resultados finais
                        dadosDosCards: gerente.cardsDeInvestimento
                    )
                    
                    // 3. Chamando a View e passando a ViewModel
                    TelaResultadosView(viewModel: viewModelResultados)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
        }
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
    // Coloquei dentro de um NavigationStack no preview para o botão poder ser clicado
    return NavigationStack {
        TelaInformacoesView(investimentos: investimentosSimulacao)
    }
}
