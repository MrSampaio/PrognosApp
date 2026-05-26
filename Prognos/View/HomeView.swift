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
    var tamanhoLogo: CGFloat = 100

    @ScaledMetric(relativeTo: .title)
    var alturaImagem: CGFloat = 350
    
    @ScaledMetric(relativeTo: .title)
    var zoomImagem: CGFloat = 1.01

    @Environment(\.dynamicTypeSize)
    var tipoDeTamanho
    
    
    var body: some View {
        VStack(spacing: paddingAdaptativo) { // spacing: 0 evita espaços em branco indesejados
            
            // --- ÁREA SUPERIOR (Fundo + Logo) ---
            ZStack(alignment: .bottom) {
                
                Image("Imagem")
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(zoomImagem)
                    //.scaleEffect(1.1)
                    // 1. Deixa a largura fluida para caber em qualquer iPhone
                    .frame(maxWidth: .infinity)
                    // 2. Trava a altura em 350, igual ao container
                    .frame(height: 500)
                   // .clipped()
                    // 3. Arredonda apenas os cantos inferiores
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 40,
                            bottomTrailingRadius: 40,
                            topTrailingRadius: 0
                        )
                    )
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    // 4. Joga o logo exatamente para a linha de corte (metade da altura dele)
                    .offset(y: 50)
                
            }
            .frame(height: 350) // Define a altura total desse bloco superior
            .ignoresSafeArea(edges: .top) // Ignora a área segura só no topo
            
            // --- TEXTO ---
            
            VStack(spacing: paddingAdaptativo) {
                
                Text("Seu aplicativo de comparação de investimentos!")
                    .font(.custom("BaiJamjuree-semibold", size: 20, relativeTo: .title2))
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("CorFonte")) // Troque por Color.black se der erro
                    // Ajuste do padding para acomodar a metade do logo que desceu (50) + espaço extra
                    .padding(.top, tamanhoLogo / 2 + 20)
                    .padding(.horizontal, 16)
            }
            
            Spacer() // Empurra o botão para baixo
            
            // --- BOTÃO ---
            VStack {
                NavigationLink {
                        
                        TelaSelecaoView()
                        
                    } label: {
                    HStack {
                        Text("Continuar")
                        Image(systemName: "chevron.right")
                    }
                    .font(.custom("BaiJamjuree-semibold", size: 20, relativeTo: .title2))
                    .lineLimit(4)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.corFonte) // Troque por Color.black se der erro
                    .frame(width: 200, height: 16)
                    .padding(.vertical, 18)
                    .background(Color.corPrimaria) // Troque por Color.green se der erro
                    .cornerRadius(60)
                }
            }
            .padding(.bottom, 40) // Dá um respiro da borda de baixo da tela
        }
         // Garante que o fundo geral seja branco
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TelaCarregamento()
}
