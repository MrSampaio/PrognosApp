import SwiftUI
import Combine

class CardViewModel: ObservableObject, Identifiable {
    
    let id = UUID() // Exigência do SwiftUI para usar no ForEach
    let tipo: TipoDeInvestimento
    
    // Controla apenas a caixa de texto deste card específico
    @Published var caixaTexto: CaixaTextoModel
    
    init(tipo: TipoDeInvestimento) {
        self.tipo = tipo
        
        // Puxamos as informações dinâmicas direto do seu Enum (Catalogo)
        self.caixaTexto = CaixaTextoModel(
            placeholder: tipo.nomeDoInputPrincipal,
            texto: "",
            arredondamento: 10,
            cor: .white // Ajuste para Color("CorCaixas") se preferir
        )
    }
}
