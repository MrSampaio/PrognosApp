//
//  CardInvestimento.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 20/05/26.
//

import SwiftUI

struct CardInvestimento: View {
    @Environment(\.dynamicTypeSize)
    var tipoDeTamanho

    @ScaledMetric(relativeTo: .body)
    var alturaCard: CGFloat = 106

    @ScaledMetric(relativeTo: .body)
    var paddingInterno: CGFloat = 12
    let title: String
    let subtitle: String
    let isSelected: Bool
    let isDisabled: Bool
       
   var body: some View {
       
       VStack(spacing: tipoDeTamanho.isAccessibilitySize ? 6 : 2) {
           
           Text(title)
               .font(.custom("BaiJamjuree-SemiBold", size: 21, relativeTo: .title3))
               .lineLimit(2)
               .minimumScaleFactor(0.6)
               .multilineTextAlignment(.center)
               //.font(.system(size: 22, weight: .bold))
               .foregroundColor(isDisabled ? Color.gray : Color("FonteUniversal"))
      

           
//           Text(subtitle)
//               .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .caption))
//               .lineLimit(2)
//               .minimumScaleFactor(0.6)
//               .multilineTextAlignment(.trailing)
//               .foregroundColor(Color("Subtitulos"))
//               .frame(maxWidth: .infinity, alignment: .trailing)
//               .padding(.trailing, paddingInterno)

              // Text(subtitle)
                //   .font(.custom("BaiJamjuree-Medium", size: 12))
               //.font(.system(size: 12, weight: .medium))
                 //  .foregroundColor(Color("Subtitulos"))
  
           
          
       }
       .padding(.horizontal, 6)
       .padding(.vertical, 4)
       .frame(height: tipoDeTamanho.isAccessibilitySize ? 130 : alturaCard)
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
