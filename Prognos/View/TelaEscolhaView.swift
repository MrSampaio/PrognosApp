//
//  TelaEscolha.swift
//  Prognos
//
//  Created by Julio Sampaio on 20/05/26.
//

import SwiftUI



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
                
                let atingiuLimite = selecionados.count == maximoDeSelecao
                
                let deveDesabilitar = atingiuLimite && !selecionado
                
                CardInvestimento(
                            title: tipo.tituloPrincipal,
                            subtitle: tipo.subtitulo,
                            isSelected: selecionado,
                            isDisabled: deveDesabilitar
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
            
            
        } else if (selecionados.count < maximoDeSelecao){
            selecionados.append(tipo)
        }
    }
}

#Preview {
    TelaEscolha()
}
