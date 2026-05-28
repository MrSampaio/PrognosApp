import SwiftUI
import Combine

class SimuladorInvestimentosViewModel: ObservableObject {
    @Published var cardsDeInvestimento: [CardViewModel] = []
    
    // Mantendo exatamente o que tínhamos combinado para o gráfico não nascer quebrado!
    @Published var valorGlobal: Float = 5000.00
    @Published var tempoGlobal: Int = 5
    
    init(tiposEscolhidos: [TipoDeInvestimento]) {
        self.cardsDeInvestimento = tiposEscolhidos.map { tipo in
            CardViewModel(tipo: tipo)
        }
    }
}
