//
//  InformacaoInvestimentoView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//
import SwiftUI

struct InformacaoInvestimentoView: View {
    
    @StateObject var viewModel: InformacaoInvestimentoViewModel
    
    var body: some View {
        VStack {
            VStack {
                ForEach(Array(viewModel.investimentos.enumerated()), id: \.element.id) { index, item in
                    
                    LinhaInvestimentoView(
                        tituloInicio: item.tituloInicio,
                        tituloFinal: item.tituloFinal,
                        descricao: item.descricao,
                        mostrarLinhaDivisoria: index < (viewModel.investimentos.count - 1)
                    )
                }
            }
        }
    }
}

#Preview {
    InformacaoInvestimentoView(
        viewModel: InformacaoInvestimentoViewModel(
            investimentos: InformacaoInvestimentoViewModel.listaInvestimentos
        )
    )
}
