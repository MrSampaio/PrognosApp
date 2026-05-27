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
    
    @ScaledMetric(relativeTo: .title3)
    var larguraCard: CGFloat = 260
    
    @ScaledMetric(relativeTo: .body)
    var alturaCard: CGFloat = 82
    
    @ScaledMetric(relativeTo: .body)
    var tamanhoCirculo: CGFloat = 34
    
    @ScaledMetric(relativeTo: .title3)
    var fonteTitulo: CGFloat = 18
    
    @ScaledMetric(relativeTo: .body)
    var fonteSubtitulo: CGFloat = 12
    
    @ScaledMetric(relativeTo: .body)
    var paddingHorizontal: CGFloat = 16
    
    
    var body: some View {
        
        Button {
            
            selecionado.toggle()
            
        } label: {
            
            HStack {
           
                
                VStack(alignment: .leading,
                       spacing: 2) {
                    
                    Text(titulo)
                        .font(
                            .custom(
                                "Avenir Next Demi Bold",
                                size: fonteTitulo
                            )
                        )
                        .foregroundStyle(
                            Color("FonteUniversal")
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    
                    Text(subtitulo)
                        .font(
                            .custom(
                                "Avenir Next Medium",
                                size: fonteSubtitulo
                            )
                        )
                        .foregroundStyle(
                            Color("CorSubtitulo")
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                
                Spacer()
                

                
                ZStack {
                    
                    Circle()
                        .fill(
                            selecionado
                            ? Color("CorPrimaria")
                            : Color.gray.opacity(0.15)
                        )
                        .frame(
                            width: tamanhoCirculo,
                            height: tamanhoCirculo
                        )
                    
                    
                    if selecionado {
                        
                        Image(systemName: "checkmark")
                            .font(
                                .system(
                                    size: tamanhoCirculo * 0.4,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, paddingHorizontal)
            .frame(
                width: larguraCard,
                height: alturaCard
            )
            .background(
                selecionado
                ? Color("CardSelecionado")
                : Color("CardNaoSelecionado")
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            )
        }
        .buttonStyle(.plain)
        .animation(
            .easeInOut(duration: 0.15),
            value: selecionado
        )
    }
}


#Preview {
    
    CardInvestimentoView(
        titulo: "Tesouro",
        subtitulo: "Prefixado",
        selecionado: .constant(true)
    )
    .padding()
}

