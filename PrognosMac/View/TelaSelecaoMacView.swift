import SwiftUI

struct TelaSelecaoMacView: View {
    
    @State private var selecionados: [TipoDeInvestimento] = []
    
    let maximoDeSelecao: Int = 4
    
    @StateObject var viewModel = TelaInvestimentosViewModel(
        investimentosIniciais: InformacaoInvestimentoViewModel.listaInvestimentos
    )
    
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 260, maximum: .infinity), spacing: 40)
    ]
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                
                LazyVGrid(columns: colunasResponsivas, spacing: 40) {
                    
                    ForEach(TipoDeInvestimento.allCases) { item in
                        
                        let selecionado = selecionados.contains(item)
                        let atingiuLimite = selecionados.count == maximoDeSelecao
                        let deveDesabilitar = atingiuLimite && !selecionado
                        
                        // 1. Criamos o Binding com a regra de limite AQUI, antes do Card
                        let isSelected = Binding(
                            get: { selecionado },
                            set: { selecionadoAgora in
                                if selecionadoAgora {
                                    // Só permite adicionar se não atingiu o limite de 4
                                    if selecionados.count < maximoDeSelecao {
                                        selecionados.append(item)
                                    }
                                } else {
                                    // Sempre permite desmarcar um item
                                    selecionados.removeAll { $0 == item }
                                }
                            }
                        )
                        
                        // 2. Passamos o Binding 'isSelected' para dentro do Card
                        CardInvestimentoView(
                            titulo: item.tituloPrincipal,
                            subtitulo: item.subtitulo,
                            selecionado: isSelected
                        )
                        .frame(maxHeight: .infinity, alignment: .top)
                        // 3. (BÔNUS DE UX) Desabilita o clique e deixa os não-selecionados transparentes se o limite foi atingido
                        .disabled(deveDesabilitar)
                        .opacity(deveDesabilitar ? 0.7 : 1.0)
                        
                    }
                }
                .padding(40)
            }
        }
    }
}

#Preview {
    TelaSelecaoMacView()
}
