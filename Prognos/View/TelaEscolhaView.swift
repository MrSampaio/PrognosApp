//
//  TelaEscolha.swift
//  Prognos
//
//  Created by Julio Sampaio on 20/05/26.
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
                
        }
    }
}


struct TelaEscolha: View {
    
    @State private var selecionados: [TipoDeInvestimento] = []
    @State private var desabilitarBotoes: Bool = false
    
        
    let maximoDeSelecao: Int = 2
    @State var texto: String = "sla"
    
    let colunas = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: colunas, spacing: 16) {
            ForEach(TipoDeInvestimento.allCases) { tipo in
                       
                let selecionado = selecionados.contains(tipo)
                
                CardInvestimento(
                            title: tipo.tituloPrincipal,
                            subtitle: tipo.subtitulo,
                            isSelected: selecionado
                        ) .onTapGesture {
                            toggleSelection(tipo)
                            texto = tipo.tituloPrincipal
                        }
                        
                        .disabled(desabilitarBotoes)
            }
        }
        .padding()
        
        Text(texto)
        
        
    }
    
    func toggleSelection(_ tipo: TipoDeInvestimento) {
        
        if let index = selecionados.firstIndex(of: tipo) {
            selecionados.remove(at: index)
            desabilitarBotoes = false
            
        } else if (selecionados.count < maximoDeSelecao){
            selecionados.append(tipo)
        }
        
        if selecionados.count == maximoDeSelecao{
            desabilitarBotoes = true
        }
       
    }
    
    
}

#Preview {
    TelaEscolha()
}
