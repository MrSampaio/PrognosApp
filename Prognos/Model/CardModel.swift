//
//  CardModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 21/05/26.
//
import SwiftUI

// O "molde" dos dados do investimento.
// Nenhuma lógica matemática ou visual de tela entra aqui, apenas variáveis puras.
struct CardModel: Hashable {
    let tipoInvestimento: String
    let mediaMeses: String
    let exemploValor: String
    let tipoRetornoInvestimento: String
    let valorInvestido: Float
    let tempoDeInvestimento: Int
    let corGrafico: Color
    
    init(tipoInvestimento: String, mediaMeses: String, exemploValor: String, tipoRetornoInvestimento: String, valorInvestido: Float, tempoDeInvestimento: Int, corGrafico: Color) {
        self.tipoInvestimento = tipoInvestimento
        self.mediaMeses = mediaMeses
        self.exemploValor = exemploValor
        self.tipoRetornoInvestimento = tipoRetornoInvestimento
        self.valorInvestido = valorInvestido
        self.tempoDeInvestimento = tempoDeInvestimento
        self.corGrafico = corGrafico
    }
}
