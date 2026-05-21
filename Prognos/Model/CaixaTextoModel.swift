//
//  CaixaTextoModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 21/05/26.
//

import SwiftUI

struct CaixaTextoModel: Hashable {
    let placeholder: String
    var texto: String
    let arredondamento: CGFloat
    
    init(placeholder: String, texto: String, arredondamento: CGFloat) {
        self.placeholder = placeholder
        self.texto = texto
        self.arredondamento = arredondamento
    }
}
