//
//  CardInvestimentoView.swift
//  PrognosMac
//
//  Created by Mariana Fracaroli Lopes on 26/05/26.
//

import SwiftUI

struct CardInvestimentoView: View {
    
    let titulo: String
    let subtitulo: String
    
    @Binding var selecionado: Bool
    
    var body: some View {
        
        Button {
            
            selecionado.toggle()
            
        } label: {
            
            HStack {
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    Text(titulo)
                        .font(
                            .custom(
                                "Avenir Next Demi Bold",
                                size: 18
                            )
                        )
                        .foregroundStyle(Color("FonteUniversal"))
                    
                    Text(subtitulo)
                        .font(
                            .custom(
                                "Avenir Next Medium",
                                size: 12
                            )
                        )
                        .foregroundStyle(Color("CorSubtitulo"))
                }
                
                Spacer()
                
                ZStack {
                    
                    Circle()
                        .fill(
                            selecionado
                            ? Color("CorPrimaria")
                            : Color.gray.opacity(0.15)
                        )
                        .frame(width: 34, height: 34)
                    
                    if selecionado {
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(width: 260, height: 82)
            .background(
                selecionado
                ? Color("CardSelecionado")
                : Color("CardNaoSelecionado")
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: selecionado)
    }
}

#Preview {
    
    CardInvestimentoView(
        titulo: "Tesouro",
        subtitulo: "Prefixado",
        selecionado: .constant(true)
    )
}

