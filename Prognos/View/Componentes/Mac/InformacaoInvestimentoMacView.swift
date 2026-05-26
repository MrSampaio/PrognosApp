//
//  InformacaoInvestimentoView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 26/05/26.
//
import SwiftUI

struct InformacaoInvestimentoMacView: View {
    let tituloInicio: String
    let tituloFinal: String
    let descricao: String
    
    
    var body: some View {
        VStack(){
            HStack(){
                Text(tituloInicio + " ")
                    .font(.custom("BaiJamjuree-Bold", size: 24, relativeTo: .body))
                    .foregroundColor(Color.fonteUniversal)
                Text(tituloFinal)
                    .font(.custom("BaiJamjuree-Medium", size: 24, relativeTo: .body))
                    .foregroundColor(Color.fonteUniversal)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .background(Color.corPrimaria)
            
            Text(descricao)
            .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .subheadline))
            .foregroundColor(Color.corFonte.opacity(0.7))
            .multilineTextAlignment(.leading)
        }
        .frame()
    }
}
#Preview {
    InformacaoInvestimentoMacView(tituloInicio: "sla",tituloFinal: "1", descricao: "sla2.0")
}
