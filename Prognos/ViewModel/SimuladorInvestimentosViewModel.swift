import SwiftUI
import Combine

class SimuladorInvestimentosViewModel: ObservableObject {
    @Published var cardsDeInvestimento: [CardViewModel] = []
    
   
    @Published var valorGlobal: Float = 5000.00
    @Published var tempoGlobal: Int = 5
    
    
    init(tipoEscolhido: TipoDeInvestimento) {
        self.cardsDeInvestimento = [CardViewModel(tipo: tipoEscolhido)]
    }
}
