//
//  BarraPesquisaView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI

struct BarraPesquisaView: View {
    
    @Binding var pesquisar: BarraPesquisaModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 10
    @FocusState private var focado: Bool
    
    var body: some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(pesquisar.corTexto.opacity(0.7))
            TextField("", text: $pesquisar.pesquisa, prompt: Text(pesquisar.placeholder)
                .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
                .foregroundColor(pesquisar.corTexto)
            )
            .textFieldStyle(.plain)
            .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
            .foregroundColor(pesquisar.corTexto)
            .focused($focado)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, focado ? paddingAdaptativo + 8 : paddingAdaptativo)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(focado ? pesquisar.corFundo.opacity(0.8) : pesquisar.corFundo)
        .clipShape(RoundedRectangle(cornerRadius: pesquisar.arredondamento))
        .animation(.easeInOut(duration: 0.2), value: focado)
    }
}

#Preview {
    // We create a mock variable so the @Binding has something to connect to!
    @Previewable @State var mockBarra = BarraPesquisaModel(
        arredondamento: 30,
        corFundo: Color.gray.opacity(0.2),
        placeholder: "Pesquise um investimento...",
        corTexto: Color.white,
        pesquisa: ""
    )
    
    BarraPesquisaView(pesquisar: $mockBarra)
        .padding()
        // Adding a black background to the preview so the gray/white colors pop
        .background(Color.black)
}
