//
//  TelaCarregamento.swift
//  Prognos
//
//  Created by Julio Sampaio on 19/05/26.
//

import SwiftUI

struct TelaCarregamento: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) { // spacing: 0 evita espaços em branco indesejados
            
            // --- ÁREA SUPERIOR (Fundo + Logo) ---
            ZStack(alignment: .bottom) {
                
                Image("Imagem")
                    .resizable()
                    .scaledToFill()
                    // 1. Deixa a largura fluida para caber em qualquer iPhone
                    .frame(maxWidth: .infinity)
                    // 2. Trava a altura em 350, igual ao container
                    .frame(height: 500)
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
            VStack {
                Text("Seu aplicativo de comparação de investimentos!")
                    .font(.custom("BaiJamjuree-semibold", size: 22))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.corFonte) // Troque por Color.black se der erro
                    // Ajuste do padding para acomodar a metade do logo que desceu (50) + espaço extra
                    .padding(.top, 70)
                    .padding(.horizontal, 16)
            }
            
            Spacer() // Empurra o botão para baixo
            
            // --- BOTÃO ---
            VStack {
                Button(action: {
                    print("Botão clicado")
                }) {
                    HStack {
                        Text("Continuar")
                        Image(systemName: "chevron.right")
                    }
                    .font(.custom("BaiJamjuree-semibold", size: 20))
                    .foregroundColor(.corFonte) // Troque por Color.black se der erro
                    .frame(width: 200, height: 16)
                    .padding(.vertical, 18)
                    .background(Color.corPrimaria) // Troque por Color.green se der erro
                    .cornerRadius(60)
                }
            }
            .padding(.bottom, 40) // Dá um respiro da borda de baixo da tela
        }
        .background(Color.white) // Garante que o fundo geral seja branco
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    TelaCarregamento()
}
