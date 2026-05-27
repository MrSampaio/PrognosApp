//
//  CardResultadoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 27/05/26.
//

import SwiftUI

struct CardResultadoView: View {
    
    @Environment(\.dynamicTypeSize)
    var tipoDeTamanho

    @ScaledMetric(relativeTo: .body)
    var alturaCard: CGFloat = 180

    @ScaledMetric(relativeTo: .body)
    var tamanhoTitulo: CGFloat = 44

    @ScaledMetric(relativeTo: .body)
    var tamanhoDescricao: CGFloat = 18

    @ScaledMetric(relativeTo: .body)
    var tamanhoIconeExterno: CGFloat = 58

    @ScaledMetric(relativeTo: .body)
    var tamanhoIconeInterno: CGFloat = 44

    @ScaledMetric(relativeTo: .body)
    var tamanhoImagem: CGFloat = 20

    @ScaledMetric(relativeTo: .body)
    var paddingHorizontal: CGFloat = 24

    @ScaledMetric(relativeTo: .body)
    var offsetIcone: CGFloat = 28
    
    
    let titulo: String
    let descricao: String
    
    let icone: String
    let corIcone: Color
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
       
            
            VStack(alignment: .leading,
                   spacing: tipoDeTamanho.isAccessibilitySize ? 14 : 10) {
                
                Spacer()
                
                
                // TÍTULO
                
                Text(titulo)
                    .font(
                        .custom(
                            "BaiJamjuree-SemiBold",
                            size: tamanhoTitulo,
                            relativeTo: .title2
                        )
                    )
                    .foregroundStyle(Color("CorFonte"))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                
                
                // DESCRIÇÃO
                
                Text(descricao)
                    .font(
                        .custom(
                            "BaiJamjuree-Medium",
                            size: tamanhoDescricao,
                            relativeTo: .body
                        )
                    )
                    .foregroundStyle(Color("CorFonte"))
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
                    .lineLimit(nil)
                
                
                Spacer()
            }
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, 8)
            .frame(
                height: tipoDeTamanho.isAccessibilitySize
                ? 210
                : alturaCard
            )
            .frame(maxWidth: .infinity)
            .background(Color("CorCaixas"))
            .clipShape(
                RoundedRectangle(cornerRadius: 22)
            )
            
            
            // ÍCONE
            
            ZStack {
                
                Circle()
                    .fill(.white)
                    .frame(
                        width: tamanhoIconeExterno,
                        height: tamanhoIconeExterno
                    )
                
                Circle()
                    .stroke(
                        corIcone,
                        lineWidth: 3
                    )
                    .frame(
                        width: tamanhoIconeExterno,
                        height: tamanhoIconeExterno
                    )
                
                Circle()
                    .fill(corIcone)
                    .frame(
                        width: tamanhoIconeInterno,
                        height: tamanhoIconeInterno
                    )
                
                Image(systemName: icone)
                    .font(
                        .system(
                            size: tamanhoImagem,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
            }
            .offset(
                x: offsetIcone,
                y: -offsetIcone
            )
        }
        .padding(.top, 14)
    }
}

#Preview {
    
    VStack(spacing: 36) {
        
        CardResultadoView(
            titulo: "CDB",
            descricao: "O investimento em CDB apresenta um melhor rendimento ao final da simulação",
            icone: "checkmark",
            corIcone: .corPrimaria
        )
        
        CardResultadoView(
            titulo: "CDI",
            descricao: "O investimento em CDI apresenta um pior resultado ao final da simulação",
            icone: "exclamationmark",
            corIcone: .iconeCard
        )
    }
    .padding()
}
