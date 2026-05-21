//
//  Teste.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 20/05/26.
//

import SwiftUI

struct Teste: View {
    
    @State private var selectedCards: [String] = []
        
    let maxSelection = 2
        
    var body: some View {
           
           ScrollView {
               
               LazyVGrid(
                   columns: [
                    GridItem(.adaptive(minimum: 105))
                   ],
                   spacing: 10
               ) {
                   
                   CardInvestimento(
                       title: "CDB",
                       subtitle: "IPCA+",
                       isSelected: selectedCards.contains("CDB")
                   )
                   .onTapGesture {
                       toggleSelection("CDB")
                   }
                   
                   
                   CardInvestimento(
                       title: "CDI",
                       subtitle: "LCA",
                       isSelected: selectedCards.contains("CDI")
                   )
                   .onTapGesture {
                       toggleSelection("CDI")
                   }
                   
                   
                   CardInvestimento(
                       title: "LCI",
                       subtitle: "95%",
                       isSelected: selectedCards.contains("LCI")
                   )
                   .onTapGesture {
                       toggleSelection("LCI")
                   }
                   
                   
                   CardInvestimento(
                       title: "RDB",
                       subtitle: "120%",
                       isSelected: selectedCards.contains("RDB")
                   )
                   .onTapGesture {
                       toggleSelection("RDB")
                   }
               }
               .frame(maxWidth: .infinity)
               .padding(.horizontal, 20)
               .padding(.top, 30)
           }
        
       }
       

       
       func toggleSelection(_ card: String) {
           
           if selectedCards.contains(card) {
               
               selectedCards.removeAll {
                   $0 == card
               }
               
           } else {
               
               if selectedCards.count < maxSelection {
                   
                   selectedCards.append(card)
               }
           }
       }
   }


#Preview {
    Teste()
}
