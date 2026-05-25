//
//  BotaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI

struct BotaoView: View {
    let texto: String
    var habilitado: Bool
        
        var body: some View {
            
            Text(texto)
                .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .subheadline))
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color("FonteUniversal"))
                .frame(width: 215, height: 48)
                .background(habilitado ? Color("CorPrimaria") : Color("CorCaixas"))
                .cornerRadius(30)
                .opacity(habilitado ? 1 : 0.5)
                .disabled(!habilitado)
                .animation(.easeInOut(duration: 0.3), value: habilitado)
            
        }
    }


#Preview {
    BotaoView(
        texto: "Continuar",
        habilitado: false
    )

}
