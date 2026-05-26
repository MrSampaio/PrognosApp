//
//  LinhaInvestimentoView.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//
import SwiftUI

struct LinhaInvestimentoView: View {
    
    let tituloInicio: String
    let tituloFinal: String
    let descricao: String
    let mostrarLinhaDivisoria: Bool
    
    @State private var estaExpandido: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0){
            Button(action : {
                withAnimation(.easeInOut(duration: 0.3)){
                    estaExpandido.toggle()
                }
            }){
              
                    HStack{
                        Text(tituloInicio + " ")
                            .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                            .foregroundColor(Color.corPrimaria)
                        Text(tituloFinal)
                            .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .body))
                            .foregroundColor(Color.corFonte)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.corFonte)
                            .font(.system(size: 14, weight: .bold))
                        // Faz a setinha girar 180 graus quando está aberto
                            .rotationEffect(.degrees(estaExpandido ? 180 : 0))
                    
                }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if estaExpandido {
                VStack(alignment: .leading){
                    Text(descricao)
                    .font(.custom("BaiJamjuree-Medium", size: 14, relativeTo: .subheadline))
                    .foregroundColor(Color.corFonte.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            if mostrarLinhaDivisoria {
                Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
            }
        }
    }
}
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            LinhaInvestimentoView(
                tituloInicio: "Investimento",
                tituloFinal: "1",
                descricao: "Aqui entra o texto explicativo sobre o que é este investimento e como ele funciona.",
                mostrarLinhaDivisoria: true
            )
            LinhaInvestimentoView(
                tituloInicio: "Investimento",
                tituloFinal: "2",
                descricao: "Outra explicação de investimento.",
                mostrarLinhaDivisoria: false
            )
        }
        .background(Color.corCaixas)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding()
    }
}
