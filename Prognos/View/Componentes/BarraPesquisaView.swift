//
//  BarraPesquisaView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI

struct BarraPesquisaView: View {
    
    @Binding var pesquisar: BarraPesquisaModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 20
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(pesquisar.corTexto.opacity(0.7))
          
         
           
                
                ZStack(alignment: .leading){
                if pesquisar.pesquisa.isEmpty {
                    Text(pesquisar.placeholder)
                        .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                        .foregroundColor(pesquisar.corTexto.opacity(0.6))
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                    TextField("", text: $pesquisar.pesquisa, axis: .vertical)
                        .textFieldStyle(.plain)
                        .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                        .foregroundColor(pesquisar.corTexto)
                        .lineLimit(1...4)
                
            }
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, paddingAdaptativo)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(pesquisar.corFundo.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: pesquisar.arredondamento))
    }
}

#Preview {
    @Previewable @State var testeBarra = BarraPesquisaModel(
        arredondamento: 30,
        corFundo: Color.gray.opacity(0.2),
        placeholder: "Pesquise um investimento",
        corTexto: Color.white,
        pesquisa: ""
    )
    
    BarraPesquisaView(pesquisar: $testeBarra)
        .padding()
        .background(Color.black)
}
