//
//  CardResultadoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 27/05/26.
//
import SwiftUI

struct CardResultadoView: View {
    // Mantendo suas propriedades escaláveis para responsividade
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    let titulo: String
    let lucroLiquido: Double
    let eOMelhor: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // CONTEÚDO DO CARD
            VStack(alignment: .leading, spacing: 10) {
                Text(titulo)
                    .font(.custom("BaiJamjuree-SemiBold", size: 24))
                    .foregroundStyle(Color("CorFonte"))
                    .lineLimit(1)
                
                Text("Lucro Líquido: R$ \(lucroLiquido, format: .number.precision(.fractionLength(2)))")
                    .font(.custom("BaiJamjuree-Medium", size: 18))
                    .foregroundStyle(Color("CorFonte").opacity(0.8))
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("CorCaixas"))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            
            // ÍCONE (Sempre posicionado no canto superior esquerdo)
            ZStack {
                Circle()
                    .fill(Color.white) // Fundo branco atrás do ícone
                    .frame(width: 58, height: 58)
                
                Circle()
                    .fill(eOMelhor ? Color.green : Color.red)
                    .frame(width: 44, height: 44)
                
                Image(systemName: eOMelhor ? "checkmark" : "exclamationmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(x: -10, y: -10)
        }
        .padding(.top, 10) // Espaço para o ícone não cortar no topo
    }
}

// MARK: - PREVIEW CORRIGIDO
#Preview {
    VStack(spacing: 40) {
        // Caso 1: O Vencedor (Verde)
        CardResultadoView(
            titulo: "CDB",
            lucroLiquido: 1250.50,
            eOMelhor: true
        )
        
        // Caso 2: O Perdedor (Vermelho)
        CardResultadoView(
            titulo: "CDI",
            lucroLiquido: 890.20,
            eOMelhor: false
        )
    }
    .padding()
    .background(Color.black) // Simulando o fundo do app
}
