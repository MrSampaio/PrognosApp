//
//  TelaCarregamento.swift
//  Prognos
//
//  Created by Julio Sampaio on 19/05/26.
//

import SwiftUI

struct HomeView: View {
    
    @ScaledMetric(relativeTo: .body)
    var paddingAdaptativo: CGFloat = 20
    
    @ScaledMetric(relativeTo: .title)
    var alturaImagem: CGFloat = 360
    
    @ScaledMetric(relativeTo: .title)
    var tamanhoLogo: CGFloat = 95
    
    @ScaledMetric(relativeTo: .body)
    var larguraBotao: CGFloat = 205
    
    @ScaledMetric(relativeTo: .body)
    var alturaBotao: CGFloat = 56
    
    @ScaledMetric(relativeTo: .title)
    var zoomImagem: CGFloat = 1.03
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                // MARK: IMAGEM SUPERIOR
                
                ZStack(alignment: .bottom) {
                    
                    Image("Imagem")
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(zoomImagem)
                        .frame(maxWidth: .infinity)
                        .frame(height: alturaImagem)
                        .clipped()
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 42,
                                bottomTrailingRadius: 42,
                                topTrailingRadius: 0
                            )
                        )
                    
                    
                    // MARK: LOGO
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: tamanhoLogo,
                               height: tamanhoLogo)
                        .clipShape(Circle())
                        .offset(y: tamanhoLogo / 2)
                }
                .frame(height: alturaImagem)
                .ignoresSafeArea(edges: .top)
                
                
                // MARK: TEXO
                
                VStack(spacing: paddingAdaptativo) {
                    
                    Text("Seu aplicativo de comparação de investimentos.")
                        .font(
                            .custom(
                                "BaiJamjuree-SemiBold",
                                size: 24,
                                relativeTo: .title2
                            )
                        )
                        .foregroundColor(Color("CorFonte"))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.75)
                        .padding(.top, tamanhoLogo / 2 + 26)
                        .padding(.horizontal, 28)
                }
                
                Spacer()
                
                
                // MARK: BOTÃO
                
                NavigationLink {
                    
                    TelaSelecaoView()
                    
                } label: {
                    
                    HStack(spacing: 8) {
                        
                        Text("Consultar")
                        
                        Image(systemName: "chevron.right")
                    }
                    .font(
                        .custom(
                            "BaiJamjuree-SemiBold",
                            size: 22,
                            relativeTo: .title3
                        )
                    )
                    .foregroundColor(Color("FonteUniversal"))
                    .frame(width: larguraBotao,
                           height: alturaBotao)
                    .background(Color("CorPrimaria"))
                    .clipShape(Capsule())
                }
                .padding(.bottom, 42)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    
    NavigationStack {
        HomeView()
    }
}
