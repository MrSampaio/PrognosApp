//
//  CardResultadoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 27/05/26.
//
import SwiftUI

struct CardResultadoView: View {
    
    // MARK: - MÉTRICAS RESPONSIVAS
    // Aumenta os tamanhos automaticamente com base nas configurações de fonte do sistema do usuário
    @ScaledMetric(relativeTo: .title) var tamanhoIcone: CGFloat = 36
    @ScaledMetric(relativeTo: .body) var paddingCard: CGFloat = 24
    
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    let titulo: String
    let lucroLiquido: Double
    let eOMelhor: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 1. HEADER (Ícone + Título lado a lado)
            HStack(spacing: 12) {
                
                // Ícone Perfeito
                ZStack {
                    Circle()
                        .fill(eOMelhor ? Color.green : Color.red)
                        .frame(width: tamanhoIcone, height: tamanhoIcone)
                    
                    Image(systemName: eOMelhor ? "checkmark" : "exclamationmark")
                        .font(.system(size: tamanhoIcone * 0.5, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Título
                Text(titulo)
                    .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title2))
                    .foregroundStyle(Color("CorFonte"))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            
            // 2. CORPO (Lucro Líquido)
            Text("Lucro Líquido: R$ \(lucroLiquido, format: .number.precision(.fractionLength(2)))")
                .font(.custom("BaiJamjuree-Medium", size: 18, relativeTo: .body))
                .foregroundStyle(Color("CorFonte").opacity(0.8))
                .lineLimit(3)
                .minimumScaleFactor(0.8)
        }
        .padding(paddingCard)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CorCaixas"))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        
        // MARK: - ACESSIBILIDADE (VoiceOver)
        // Ignora os textos soltos e lê uma frase limpa e profissional para o usuário
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(eOMelhor ? "Melhor rendimento: \(titulo)." : "Resultado em atenção: \(titulo).")
        .accessibilityValue("Lucro líquido de R$ \(lucroLiquido, format: .number.precision(.fractionLength(2))).")
    }
}

// MARK: - PREVIEW
#Preview {
    VStack(spacing: 40) {
        CardResultadoView(
            titulo: "Debênt. Pós",
            lucroLiquido: 1250.50,
            eOMelhor: true
        )
        
        CardResultadoView(
            titulo: "Debênt. Pré",
            lucroLiquido: 890.20,
            eOMelhor: false
        )
    }
    .padding()
    .background(Color.black)
}
