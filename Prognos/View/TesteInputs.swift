//
//  TesteInputs.swift
//  Prognos
//
//  Created by Julio Sampaio on 20/05/26.
//
import SwiftUI

struct TesteInputs: View {
    var body: some View {
        
        let investimento = TipoDeInvestimento.debComumCdi
    
            
            if investimento.pedeTaxaPrefixada {
                Text("aí vc poe o input de taxa prefixada né")            }
            if investimento.pedePercentualCDI {
                Text("aí vc poe o input de percentual né")
            }
        
            if investimento.pedeTaxaB3 {
                Text("aí vc poe o input de taxa b3 né")
            }
        
            if investimento.pedeTaxasDeFundo {
                Text("aí vc poe o input de taxa de fundo né")
            }
    }
}

#Preview {
    TesteInputs()
}
