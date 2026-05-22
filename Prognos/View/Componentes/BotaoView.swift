//
//  BotaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI

struct BotaoView: View {
    let texto: String
        
        var body: some View {
            
            Text(texto)
                .font(.custom("BaiJamJuree-SemiBold", size: 20))
                .foregroundColor(Color("Fonte"))
                .frame(width: 215, height: 48)
                .background(Color("CorSelecionado"))
                .cornerRadius(30)
        }
    }


#Preview {
    BotaoView(
        texto: "Continuar"
    )

}
