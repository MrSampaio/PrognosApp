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
       
       VStack(spacing: 2) {
           
           Text(title)
               .font(.custom("BaiJamjuree-SemiBold", size: 21, relativeTo: .subheadline))
               .lineLimit(4)
               .minimumScaleFactor(0.7)
               .fixedSize(horizontal: false, vertical: true)
               //.font(.system(size: 22, weight: .bold))
               .foregroundColor(isDisabled ? Color.gray : Color("FonteUniversal"))
      

           
           Text(subtitle)
               .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .subheadline))
               .lineLimit(4)
               .minimumScaleFactor(0.7)
               .fixedSize(horizontal: false, vertical: true)
               .foregroundColor(Color("Subtitulos"))
               .frame(maxWidth: .infinity, alignment: .trailing)
               .padding(.trailing, 12)

              // Text(subtitle)
                //   .font(.custom("BaiJamjuree-Medium", size: 12))
               //.font(.system(size: 12, weight: .medium))
                 //  .foregroundColor(Color("Subtitulos"))
  
           
          
       }
       .frame(height: 106)
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
