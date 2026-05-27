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
        VStack(alignment: .leading){
            HStack(){
                Text(tituloInicio)
                    .font(.custom("Avenir Next Bold", size: 24, relativeTo: .body))
                    .foregroundColor(Color.fonteUniversal)
                Text(tituloFinal)
                    .font(.custom("Avenir Next Medium", size: 24, relativeTo: .body))
                    .foregroundColor(Color.fonteUniversal)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.corPrimaria)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(descricao)
            .font(.custom("Avenir Next Medium", size: 16, relativeTo: .subheadline))
            .foregroundColor(Color.corFonte.opacity(0.7))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#Preview {
    InformacaoInvestimentoMacView(tituloInicio: "sla",tituloFinal: "1", descricao: "sla2.0")
}
