//
//  TelaInvestimentoView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI

struct TelaInvestimentosView: View {
    
    @StateObject var viewModel = TelaInvestimentosViewModel(
            investimentosIniciais: InformacaoInvestimentoViewModel.testes
        )
    var body: some View {
        ZStack{
            VStack(spacing: 24){
               
                VStack(spacing: 0){
                    if viewModel.investimentosFiltrados.isEmpty {
                        Text("Nenhum investimento encontrado")
                        .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                        .foregroundColor(.corFonte)
                        .padding(.vertical, 32)
                        .padding(.horizontal, 32)
                    }else{
                        ForEach(Array(viewModel.investimentosFiltrados.enumerated()), id: \.element.id) { index, item in
                            
                            LinhaInvestimentoView(
                                titulo: item.titulo,
                                descricao: item.descricao,
                                mostrarLinhaDivisoria: index < (viewModel.investimentosFiltrados.count - 1)
                            )
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(Color.corCaixas)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 20)
                
                Spacer()
                BarraPesquisaView(pesquisar: $viewModel.modeloBusca)
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
        }
    }
}
#Preview {
    TelaInvestimentosView()
}
