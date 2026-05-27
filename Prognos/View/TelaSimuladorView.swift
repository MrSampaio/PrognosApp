import SwiftUI

struct TelaSimuladorView: View {
    
    @StateObject var gerente: SimuladorInvestimentosViewModel
    
    // ⚠️ MUDANÇA AQUI: A porta de entrada da tela
    init(tipoEscolhido: TipoDeInvestimento) {
        // É assim que o SwiftUI injeta um dado de fora para dentro de um Gerente
        _gerente = StateObject(wrappedValue: SimuladorInvestimentosViewModel(tipoEscolhido: tipoEscolhido))
    }
    
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 400, maximum: .infinity), spacing: 40)
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: colunasResponsivas, spacing: 40) {
                
                ForEach(gerente.cardsDeInvestimento) { cardVM in
                    
                    #if os(macOS)
                    InvestimentosMacView(
                        viewModel: cardVM,
                        valorInvestido: gerente.valorGlobal,
                        tempoDeInvestimento: gerente.tempoGlobal,
                        corGrafico: Color(cardVM.tipo.cores)
                    )
                    #else
                    CardView(
                        viewModel: cardVM,
                        valorInvestido: gerente.valorGlobal,
                        tempoDeInvestimento: gerente.tempoGlobal,
                        corGrafico: Color(cardVM.tipo.cores)
                    )
                    #endif
                }
            }
            .padding(40)
        }
    }
}

// O preview agora precisa de um dado falso para funcionar
#Preview {
    TelaSimuladorView(tipoEscolhido: .cdbCdi)
}
