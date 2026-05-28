import SwiftUI

struct TelaSimuladorView: View {
    
    @StateObject var gerente: SimuladorInvestimentosViewModel
    
    // ⚠️ ATUALIZAÇÃO: A tela agora exige um array de escolhas
    init(tiposEscolhidos: [TipoDeInvestimento]) {
        _gerente = StateObject(wrappedValue: SimuladorInvestimentosViewModel(tiposEscolhidos: tiposEscolhidos))
    }
    
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 400, maximum: .infinity), spacing: 40)
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: colunasResponsivas, spacing: 40) {
                
                // Vai desenhar EXATAMENTE os que o usuário marcou na tela anterior!
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
    TelaSimuladorView(tiposEscolhidos: [.cdbCdi, .cdbIpca])
}
