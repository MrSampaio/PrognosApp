import SwiftUI

struct TelaInformacoesView: View {
    
    @ScaledMetric(relativeTo: .body)
    var paddingAdaptativo: CGFloat = 20

    @ScaledMetric(relativeTo: .title)
    var espacamentoTitulo: CGFloat = 24

    @ScaledMetric(relativeTo: .body)
    var espacamentoGrid: CGFloat = 10

    @Environment(\.dynamicTypeSize)
    var tipoDeTamanho
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    @State var viewModels: [CardViewModel]
    @State private var irParaResultados = false
    
    init(investimentos: [TipoDeInvestimento]) {
        let vmsMapeados = investimentos.map { CardViewModel(tipo: $0) }
        _viewModels = State(initialValue: vmsMapeados)
    }
    
    var pacoteDeDados: DadosDaSimulacao {
            // Pega os valores globais
            let stringValor = valorGlobal.texto.replacingOccurrences(of: ",", with: ".")
            let stringTempo = tempoGlobal.texto
            
            let valorFim = Float(stringValor) ?? 0.0
            let tempoFim = Int(stringTempo) ?? 0
            
            // Pega as taxas de dentro de CADA card
            let investimentosProntos = viewModels.map { vm -> InvestimentoConfigurado in
                // Limpa a string: troca vírgula por ponto, remove o '%' e tira os espaços
                let stringLimpa = vm.caixaTexto.texto
                    .replacingOccurrences(of: ",", with: ".")
                    .replacingOccurrences(of: "%", with: "")
                    .trimmingCharacters(in: .whitespaces)
                    
                let taxaConvertida = Float(stringLimpa) ?? 0.0
                return InvestimentoConfigurado(tipo: vm.tipo, taxaDigitada: taxaConvertida)
            }
            
            return DadosDaSimulacao(
                valorInicial: valorFim,
                tempoAnos: tempoFim,
                investimentos: investimentosProntos
            )
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
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
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
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.vertical, 5)
                
                let valorConvertido = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                let tempoConvertido = Int(tempoGlobal.texto) ?? 0
                
                ForEach(viewModels) { viewModelDoCard in
                    
                    CardView(
                        viewModel: viewModelDoCard,
                        valorInvestido: valorConvertido,
                        tempoDeInvestimento: tempoConvertido,
                        corGrafico: .black
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
                // 4. O GATILHO INTELIGENTE: Puxa o "pacoteDeDados" fresquinho da memória!
                .navigationDestination(isPresented: $irParaResultados) {
                    TelaResultadosView(dados: pacoteDeDados)
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
        NavigationStack {
            TelaInformacoesView(investimentos: investimentosSimulacao)
        }
}
