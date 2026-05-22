//
//  OpcoesInvestimento.swift
//  Prognos
//
//  Created by Julio Sampaio on 19/05/26.
//

import SwiftUI

struct BotaoInvestimento: View {
    let titulo: String
    let estaSelecionado: Bool
    let acao: () -> Void
    
    var body: some View {
        Button(action: acao) {
            Text(titulo)
                .font(.system(size: 14, weight: .bold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(estaSelecionado ? Color.green : Color.green.opacity(0.2))
                .foregroundColor(estaSelecionado ? .white : .black)
                .cornerRadius(16)
                .animation(.easeInOut(duration: 0.3), value: estaSelecionado)
                
        }
    }
}
#Preview {
    BotaoInvestimento(titulo: "Investimento", estaSelecionado: true, acao: {})
}
