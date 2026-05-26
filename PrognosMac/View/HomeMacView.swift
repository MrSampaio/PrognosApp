//
//  HomeMacView.swift
//  PrognosMac
//
//  Created by Mariana Fracaroli Lopes on 26/05/26.
//

import SwiftUI

struct HomeMacView: View {
    
    var body: some View {
        
        NavigationStack {
            
            HStack(spacing: 0) {
                

                
                Image("Imagem")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 360, height: 520)
                    .clipped()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 32,
                            topTrailingRadius: 32
                        )
                    )
                
                
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer()
                    
                    
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    
                    
                    Text("""
                    Seu aplicativo
                    de consulta de
                    investimentos
                    """)
                    .font(
                        .custom("Avenir Next Regular",size: 22))
                    .foregroundStyle(Color("CorFonte"))
                    .lineSpacing(4)
                    
                    
                    
                    NavigationLink {
                        
                        TelaSelecaoMacView()
                        
                    } label: {
                        
                        HStack(spacing: 10) {
                            
                            Text("Consultar")
                            
                            Image(systemName: "arrow.right")
                        }
                        .font(
                            .custom(
                                "Avenir Next Demi Bold",
                                size: 14
                            )
                        )
                        .foregroundStyle(Color("FonteUniversal"))
                        .frame(width: 150, height: 35)
                        .background(Color("CorPrimaria"))
                        .cornerRadius(120)
                    }
                    .buttonStyle(.plain)
                    
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .offset(x: -30)
                
            }
            .frame(width: 760, height: 520)
            
        }
    }
}

#Preview {
    HomeMacView()
}
