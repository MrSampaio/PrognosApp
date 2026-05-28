import SwiftUI

struct TelaSelecaoMacView: View {
    
    //@Environment(\.dismiss) var dismiss
    
    @State private var selecionados: [TipoDeInvestimento] = []
    
    let maximoDeSelecao: Int = 4
    
    @StateObject var viewModel = TelaInvestimentosViewModel(
        investimentosIniciais: InformacaoInvestimentoViewModel.listaInvestimentos
    )
    
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 260, maximum: .infinity), spacing: 40)
    ]
    
    @ScaledMetric(relativeTo: .body)
    var paddingAdaptativo: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                
                // MARK: - Header (Responsivo)
                VStack(spacing: 20) {
                    
                    HStack {
                        
                        Spacer()
                        
                        
                        Text("Investimentos")
                            .font(.custom("BaiJamjuree-SemiBold", size: 36, relativeTo: .largeTitle))
                            .foregroundColor(Color("CorPrimaria")) // Verde
                        
                        Spacer()
            
                        NavigationLink{
                            TelaInvestimentosMacView()
                        } label:{
                            Image(systemName: "info")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color.corFonte)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    
                    
                    Text("Escolha até quatro tipos de investimento que você gostaria de comparar:")
                        .font(.custom("Avenir Next Medium", size: 20, relativeTo: .title3))
                        .foregroundColor(Color.corFonte)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
                .padding(.horizontal, paddingAdaptativo)
                .padding(.top, 50)
                
                // MARK: - Grid de Cards
                LazyVGrid(columns: colunasResponsivas, spacing: 40) {
                    
                    ForEach(TipoDeInvestimento.allCases) { item in
                        
                        let selecionado = selecionados.contains(item)
                        let atingiuLimite = selecionados.count == maximoDeSelecao
                        let deveDesabilitar = atingiuLimite && !selecionado
                        
                        let estaSelecionado = Binding(
                            get: { selecionado },
                            set: { selecionadoAgora in
                                if selecionadoAgora {
                                    if selecionados.count < maximoDeSelecao {
                                        selecionados.append(item)
                                    }
                                } else {
                                    selecionados.removeAll { $0 == item }
                                }
                            }
                        )
                        
                        CardInvestimentoView(
                            titulo: item.tituloPrincipal,
                            subtitulo: item.subtitulo,
                            selecionado: estaSelecionado
                        )
                        .frame(maxHeight: .infinity, alignment: .top)
                        .disabled(deveDesabilitar)
                        .opacity(deveDesabilitar ? 0.6 : 1.0)
                    }
                }
                .padding(.horizontal, paddingAdaptativo)
                .padding(.vertical, 40)
                
                // MARK: - Botão Continuar
                NavigationLink {
                    TelaInformacoesMacView(investimentos: selecionados)
                } label: {
                    BotaoView(
                        texto: "Continuar",
                        habilitado: selecionados.count >= maximoDeSelecao / 2
                    )
                }
                .disabled(selecionados.count < maximoDeSelecao / 2)
                .buttonStyle(.plain)
                .padding(.bottom, 60) // Dá um respiro no final da rolagem
                
            }
        }
        .navigationTitle("")
        //.toolbar(.hidden, for: .windowToolbar)
    }
}

#Preview {
    NavigationStack {
        TelaSelecaoMacView()
    }
    .frame(width: 1000, height: 750)
    .preferredColorScheme(.dark)
}
