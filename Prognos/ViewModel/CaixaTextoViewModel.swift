//
//  CaixaTextoViewModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 21/05/26.
//

internal import CoreFoundation
class CaixaTextoViewModel {
    public static let caixaTexto = [

        CaixaTextoModel(placeholder: "Digite o valor", texto: "", arredondamento: 30, cor: .corCaixas),
        CaixaTextoModel(placeholder: "Digite o tempo", texto: "", arredondamento: 30, cor: .corCaixas),
        CaixaTextoModel(placeholder: "Digite o valor", texto: "", arredondamento: 30, cor: .corCaixa2),
        

        CaixaTextoModel(placeholder: "Digite o valor", texto: "", arredondamento: 30),
        CaixaTextoModel(placeholder: "Digite o tempo", texto: "", arredondamento: 30)

    ]
}
