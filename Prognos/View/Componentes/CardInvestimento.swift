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
    let isDisabled: Bool
       
   var body: some View {
       
       VStack(spacing: 6) {
           
           Text(title)
               .font(.system(size: 20, weight: .bold))
               .foregroundColor(isDisabled ? Color.gray : Color("CorFonte"))
           
           Text(subtitle)
               .font(.system(size: 14, weight: .medium))
               .foregroundColor(Color("CorFonteCard"))
       }
       .frame(height: 112)
       .frame(maxWidth: .infinity)
       .background(
        isDisabled ? Color.gray.opacity(0.2) :
                        (isSelected ? Color("CorSelecionado") : Color("CorSecundaria"))
       )
       .cornerRadius(16)
       .animation(.easeInOut(duration: 0.2), value: isSelected)
   }
   }
    
    #Preview {
        CardInvestimento( title: "CDB",
                          subtitle: "IPCA+",
                          isSelected: true,
                          isDisabled: true
                      )
    }
