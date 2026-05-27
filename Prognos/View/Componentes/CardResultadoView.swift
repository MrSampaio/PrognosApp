//
//  CardResultadoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 27/05/26.
//

import SwiftUI

struct CardResultadoView: View {
    
    let titulo: String
    let descricao: String
    
    let icone: String
    let corIcone: Color
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            // CARD
            
            VStack(alignment: .leading, spacing: 20) {
                
                Spacer()
                
                // TÍTULO
                
                Text(titulo)
                    .font(
                        .custom(
                            "BaiJamjuree-SemiBold",
                            size: 44
                        )
                    )
                    .foregroundStyle(Color("CorFonte"))
                
                
                // DESCRIÇÃO
                
                Text(descricao)
                    .font(
                        .custom(
                            "BaiJamjuree-Medium",
                            size: 16
                        )
                    )
                    .foregroundStyle(Color("CorFonte"))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(Color("CorCaixas"))
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            
            
            // ÍCONE
            
            ZStack {
                
                Circle()
                    .fill(.white)
                    .frame(width: 58, height: 58)
                
                Circle()
                    .stroke(corIcone, lineWidth: 4)
                    .frame(width: 60, height: 58)
                
                Circle()
                    .fill(corIcone)
                    .frame(width: 42, height: 42)
                
                Image(systemName: icone)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
            }
            .offset(x: 20, y: -25)
        }
        .padding(.top, 20)
    }
}

#Preview {
    
    VStack(spacing: 40) {
        
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
