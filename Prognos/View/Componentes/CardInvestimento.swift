//
//  CardInvestimento.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 20/05/26.
//

import SwiftUI

struct CardInvestimento: View {
    let title: String
       let subtitle: String
       let isSelected: Bool
       
       var body: some View {
           
           VStack(spacing: 6) {
               
               Text(title)
                   .font(.system(size: 22, weight: .bold))
                   .foregroundColor(Color("Fonte"))
               
               Text(subtitle)
                   .font(.system(size: 14, weight: .medium))
                   .foregroundColor(Color("CorFonteCard"))
           }
           .frame(height: 112)
           .frame(maxWidth: .infinity)
           .background(
               isSelected
               ? Color("CorSelecionado")
               : Color("CorSecundaria")
           )
           .cornerRadius(24)
           .animation(.easeInOut(duration: 0.2), value: isSelected)
       }
   }
    
    #Preview {
        CardInvestimento( title: "CDB",
                          subtitle: "IPCA+",
                          isSelected: true
                      )
    }
