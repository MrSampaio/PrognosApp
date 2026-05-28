//
//  BarraPesquisaViewModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI
import Combine

class BarraPesquisaViewModel: ObservableObject {
    
    @Published var barraAtual: BarraPesquisaModel
    
    init(barraInicial: BarraPesquisaModel) {
            self.barraAtual = barraInicial
        }
    
   public static let barraPesquisa = [
    BarraPesquisaModel(arredondamento: 30, corFundo: .corInfos, placeholder: "Pesquisa", corTexto: .corFonte, pesquisa: "")
   ]
    
}
