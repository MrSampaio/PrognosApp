//
//  TelaInformacoesView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI

struct TelaInformacoesView: View {
    var investimentos: [TipoDeInvestimento]
    
    var body: some View {
        Text("chegaram esses aqui ó:")
        ForEach(investimentos) { tipo in
            
            Text("- \(tipo.tituloPrincipal) \(tipo.subtitulo)")
                .foregroundColor(.blue)
        }
        
    }
}

#Preview {
    
        let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
        
        TelaInformacoesView(investimentos: investimentosSimulacao)
}
