import SwiftUI
import Combine

class SimuladorInvestimentosViewModel: ObservableObject {
    // O cofre que guarda os cartões protegidos
    @Published var cardsDeInvestimento: [CardViewModel] = []
    
    // Variáveis que vão para o gráfico depois
    @Published var valorGlobal: Float = 5000.00
    @Published var tempoGlobal: Int = 5
    
    // ⚠️ MUDANÇA AQUI: Agora ele exige saber qual foi o escolhido!
    init(tipoEscolhido: TipoDeInvestimento) {
        // Cria apenas UM cartão baseado no que o usuário tocou
        self.cardsDeInvestimento = [CardViewModel(tipo: tipoEscolhido)]
    }
}
