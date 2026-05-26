//
//  TelaInvestimentosView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 26/05/26.
//
import SwiftUI

struct TelaGradeInvestimentosMacView: View {
    
    // We bring in your ViewModel to get the data
    @StateObject var viewModel = InformacaoInvestimentoViewModel(
        investimentos: InformacaoInvestimentoViewModel.listaInvestimentos
    )
    
    // 🎯 THE RESPONSIVE RULE:
    // Columns will be at least 320pts wide, with 24pts of empty space between them.
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 320, maximum: .infinity), spacing: 24)
    ]
    
    var body: some View {
        ZStack {
            // The dark background from your screenshot
            Color(red: 0.12, green: 0.12, blue: 0.12).ignoresSafeArea()
            
            // A ScrollView so the user can scroll down to see the rest of the items
            ScrollView(showsIndicators: false) {
                
                // 🎯 THE GRID
                LazyVGrid(columns: colunasResponsivas, spacing: 24) {
                    
                    // We loop through your list of investments
                    ForEach(viewModel.investimentos, id: \.tituloFinal) { item in
                        
                        // We use the component you just built!
                        InformacaoInvestimentoMacView(
                            tituloInicio: item.tituloInicio,
                            tituloFinal: item.tituloFinal,
                            descricao: item.descricao
                        )
                        // Make sure the cards stretch to fill their grid space uniformly
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding(32) // Gives nice breathing room around the edges of the screen
            }
        }
    }
}

#Preview {
    TelaGradeInvestimentosMacView()
}
