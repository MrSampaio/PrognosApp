//
//  TelaEscolha.swift
//  Prognos
//
//  Created by Julio Sampaio on 20/05/26.
//

import SwiftUI

struct BotaoInvestimento: View {
    let titulo: String
    let estaSelecionado: Bool
    let acao: () -> Void
    
   
    
    var body: some View {
        Button(action: acao) {
            Text(titulo)
                .font(.system(size: 14, weight: .bold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(estaSelecionado ? Color.green : Color.green.opacity(0.2))
                .foregroundColor(estaSelecionado ? .white : .black)
                .cornerRadius(16)
        }
    }
}


struct TelaEscolha: View {
    
    @State private var selectedCards: [String] = []
        
    let maxSelection = 2
    
    let colunas = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: colunas, spacing: 16) {
            ForEach(TipoDeInvestimento.allCases) { tipo in
                       
                CardInvestimento(
                            title: tipo.tituloPrincipal,
                            subtitle: tipo.subtitulo,
                            isSelected: false
                        ) .onTapGesture {
                            toggleSelection("CDB")
                        }
                
            }
        }
        .padding()
        
        
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
    TelaEscolha()
}
