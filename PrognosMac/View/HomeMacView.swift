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

                // IMAGEM

                Image("Imagem")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .clipped()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 32,
                            topTrailingRadius: 32
                        )
                    )
                    .layoutPriority(1)


                // LADO DIREITO

                VStack(alignment: .leading, spacing: 20) {

                    Spacer()

                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)

                    Text("""
                    Seu aplicativo
                    de consulta de
                    investimentos
                    """)
                    .font(.custom("Avenir Next Demi Bold", size: 36))
                    .foregroundStyle(Color("CorFonte"))

                    NavigationLink {

                    } label: {

                        HStack(spacing: 10) {

                            Text("Consultar")

                            Image(systemName: "arrow.right")
                        }
                        .font(.custom("Avenir Next Demi Bold", size: 20))
                        .foregroundStyle(Color("FonteUniversal"))
                        .frame(width: 240, height: 58)
                        .background(Color("CorPrimaria"))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .frame(width: 420)
                .padding(.horizontal, 60)
            }
            }
                
            }
            
            
        }
    


#Preview {
    HomeMacView()
}
