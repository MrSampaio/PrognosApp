//
//  CaixaTextoViewModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 21/05/26.
//

import SwiftUI

class CaixaTextoViewModel {
    // Array estático que serve como banco de dados falso (mock) para usarmos nos Previews.
    public static let caixaTexto = [
        CaixaTextoModel(placeholder: "Digite o valor", texto: "", arredondamento: 30, cor: .corCaixas),
        CaixaTextoModel(placeholder: "Digite o tempo", texto: "", arredondamento: 30, cor: .corCaixas),
        CaixaTextoModel(placeholder: "123%", texto: "", arredondamento: 6, cor: .corPrimaria)
    ]
}
