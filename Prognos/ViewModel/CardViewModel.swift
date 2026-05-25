    //
    //  CardViewModel.swift
    //  Prognos
    //
    //  Created by Leonardo Gonçalves da Silva on 21/05/26.
    //
import SwiftUI
import Combine
// ObservableObject permite que essa classe "transmita" mudanças para a View.
class CardViewModel: ObservableObject {
    
    // @Published avisa a tela: "Ei, se esse valor mudar, desenhe a tela de novo!"
    @Published var card: CardModel
    @Published var caixaTexto: CaixaTextoModel
    
    // O init recebe as informações e monta o CardModel final.
    // Ele depende do Enum TipoDeInvestimento do código do Júlio.
    init(tipoEscolhido: TipoDeInvestimento, valorInvestido: Float, tempo: Int, caixaTexto: CaixaTextoModel) {
        
        let novoCard = CardModel(
            tipoInvestimento: tipoEscolhido.tituloPrincipal,
            mediaMeses: tipoEscolhido.mediaHistorica,
            exemploValor: "Ex.: 123%",
            tipoRetornoInvestimento: tipoEscolhido.subtitulo,
            valorInvestido: valorInvestido,
            tempoDeInvestimento: tempo,
            corGrafico: .black
        )
        
        self.card = novoCard
        self.caixaTexto = caixaTexto
    }
    init(cardDeTeste: CardModel, caixaTexto: CaixaTextoModel) {
            self.card = cardDeTeste
            self.caixaTexto = caixaTexto
        }
    // Dados de teste para o Xcode Preview não quebrar
    public static let dadosDeTeste = [
        CardModel(
            tipoInvestimento: "CDI",
            mediaMeses: "102%",
            exemploValor: "Ex.: 123%",
            tipoRetornoInvestimento: "Rendimento",
            valorInvestido: 150.90,
            tempoDeInvestimento: 4,
            corGrafico: .black
        )
    ]
}
