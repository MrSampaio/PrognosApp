//
//  CaixaTextoModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 21/05/26.
//

import SwiftUI

// Struct simples que guarda os dados visuais e o texto de uma caixa.
// Usamos Hashable para que o SwiftUI consiga identificar cada caixa em listas, se necessário.
struct CaixaTextoModel: Hashable {
    let placeholder: String
    var texto: String
    let arredondamento: CGFloat
    let cor: Color
    
    init(placeholder: String, texto: String, arredondamento: CGFloat, cor: Color) {
        self.placeholder = placeholder
        self.texto = texto
        self.arredondamento = arredondamento
        self.cor = cor
    }
}
