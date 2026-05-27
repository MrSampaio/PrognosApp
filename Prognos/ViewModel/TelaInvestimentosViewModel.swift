//
//  TelaInvestimentoViewModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//
import SwiftUI
import Combine

class TelaInvestimentosViewModel: ObservableObject {
    @Published var todosInvestimentos: [InformacaoInvestimentoModel]
    @Published var modeloBusca: BarraPesquisaModel
    
    init(investimentosIniciais: [InformacaoInvestimentoModel]) {
        self.todosInvestimentos = investimentosIniciais
                self.modeloBusca = BarraPesquisaModel(
                    arredondamento: 30,
                    corFundo: Color.corFonte.opacity(0.1),
                    placeholder: "Pesquise um investimento...",
                    corTexto: .corFonte,
                    pesquisa: ""
                )
    }
    var investimentosFiltrados: [InformacaoInvestimentoModel] {
        if modeloBusca.pesquisa.isEmpty {
            return todosInvestimentos
        } else {
            return todosInvestimentos.filter { item in
                item.tituloInicio.localizedCaseInsensitiveContains(modeloBusca.pesquisa)
            }
        }
    }
}
