//
//  TelaSelecaoMacView.swift
//  PrognosMac
//
//  Created by Mariana Fracaroli Lopes on 26/05/26.
//

import SwiftUI

struct TelaSelecaoMacView: View {
    
    @State private var tesouroSelecionado = false
    
    var body: some View {
       
        VStack {
                    
                    CardInvestimentoView(
                        titulo: "Tesouro",
                        subtitulo: "Prefixado",
                        selecionado: $tesouroSelecionado
                    )
                }
                
            
        
    }
}

#Preview {
    TelaSelecaoMacView()
}
