//
//  TelaInvestimentoView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI


struct TelaInvestimentosView: View {
    
    
    
    @StateObject var viewModel = TelaInvestimentosViewModel(
        investimentosIniciais: InformacaoInvestimentoViewModel.listaInvestimentos
        )
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                
                ScrollView(showsIndicators: false) {
                    
                    Text("Conheça os investimentos")
                        .font(.custom("BaiJamjuree-Medium" , size:  24, relativeTo: .body))
                        .foregroundStyle(Color.corFonteTitulo)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                    Text("Veja abaixo informações sobre cada investimento antes de comparar.")
                        .font(.custom("BaiJamjuree-Medium" , size:  16, relativeTo: .title))
                        .foregroundStyle(Color.corFonte)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                    VStack(spacing: 0) {
                        
                        
                        if viewModel.investimentosFiltrados.isEmpty {
                            Text("Nenhum investimento encontrado")
                                .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                                .foregroundColor(.corFonteTitulo)
                                .padding(.vertical, 32)
                                .padding(.horizontal, 32)
                        } else {
                            ForEach(Array(viewModel.investimentosFiltrados.enumerated()), id: \.element.id) { index, item in
                                
                                LinhaInvestimentoView(
                                    tituloInicio: item.tituloInicio,
                                    tituloFinal: item.tituloFinal,
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
                    
                }
                
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
