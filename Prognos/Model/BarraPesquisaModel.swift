//
//  BarraPesquisaModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI

struct BarraPesquisaModel: Hashable {
    let arredondamento: CGFloat
    let corFundo: Color
    let placeholder: String
    let corTexto: Color
    var pesquisa: String
    
    init(arredondamento: CGFloat, corFundo: Color, placeholder: String, corTexto: Color, pesquisa: String) {
        self.arredondamento = arredondamento
        self.corFundo = corFundo
        self.placeholder = placeholder
        self.corTexto = corTexto
        self.pesquisa = pesquisa
    }
}
