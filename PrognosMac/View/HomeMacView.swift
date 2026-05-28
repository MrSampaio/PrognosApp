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
            
            GeometryReader { geometry in

                HStack(spacing: 0) {

                    // IMAGEM

                    Image("Image")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width * 0.50
                        )
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



                    // LADO DIREITO

                    VStack(alignment: .leading, spacing: 20) {

                        Spacer()

                        Image("LogoMac")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())

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
                            .frame(width: 240, height: 55)
                            .background(Color("CorPrimaria"))
                            .cornerRadius(30)
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .frame(
                        width: geometry.size.width * 0.28
                    )
                    .padding(.horizontal, 40)
                }
            }
            .ignoresSafeArea()
            }
        }
                
        }
            
            
        
    


#Preview {
    HomeMacView()
}
