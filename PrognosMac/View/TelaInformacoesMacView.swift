//
//  TelaInformacoesMacView.swift
//  Prognos
//
//  Created by Julio Sampaio on 27/05/26.
//

import SwiftUI

struct TelaInformacoesMacView: View {
    
    @State var viewModels: [CardViewModel]
    
    init(investimentos: [TipoDeInvestimento]) {
        let vmsMapeados = investimentos.map { CardViewModel(tipo: $0) }
        _viewModels = State(initialValue: vmsMapeados)
    }
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]

    var body: some View {
        
        HStack {
            CaixaValorTempo(modeloValor: $valorGlobal, modeloTempo: $tempoGlobal)
        }
        
        VStack(spacing: 10) {
            ForEach(viewModels) { viewModelDoCard in
                
                InvestimentosMacView(viewModel: viewModelDoCard,
                                     valorInvestido: 1000,
                                     tempoDeInvestimento: 13,
                                     corGrafico: .blue)
                
            }
        }
        
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
    
    NavigationStack {
        TelaInformacoesMacView(investimentos: investimentosSimulacao)
    }
}
