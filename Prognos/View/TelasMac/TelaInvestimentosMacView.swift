//
//  TelaInvestimentosView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 26/05/26.
//
import SwiftUI

struct TelaInvestimentosMacView: View {
    

    @StateObject var viewModel = TelaInvestimentosViewModel(
        investimentosIniciais: InformacaoInvestimentoViewModel.listaInvestimentos
        )
    
    
    let colunasResponsivas = [
        GridItem(.adaptive(minimum: 400, maximum: .infinity), spacing: 90)
    ]
    
    var body: some View {
        VStack {
            
           
            
            ScrollView(.vertical) {
                
                BarraPesquisaView(pesquisar: $viewModel.modeloBusca)
                    .frame(maxWidth: 600)
                    .padding(.vertical, 40)
                    .padding(.horizontal, 40)
                
                LazyVGrid(columns: colunasResponsivas, spacing: 40) {
                    
                    ForEach(viewModel.investimentosFiltrados, id: \.self) { item in
                        
                        InformacaoInvestimentoMacView(
                            tituloInicio: item.tituloInicio,
                            tituloFinal: item.tituloFinal,
                            descricao: item.descricao
                        )
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
                .padding(40)
            }
        }
    }
}

#Preview {
    TelaInvestimentosMacView()
}
