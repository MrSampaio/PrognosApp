//
//  TelaInformacoesView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI

struct TelaInformacoesView: View {
    var investimentos: [TipoDeInvestimento]
    @State var valor = CaixaTextoViewModel.caixaTexto[0]
    @State var tempo = CaixaTextoViewModel.caixaTexto[1]
    
    @State var modeloCardGenerico = CaixaTextoViewModel.caixaTexto[2]
    
    var body: some View {
        ScrollView{
            
            HStack{
                CaixaValorTempo(modeloValor: $valor, modeloTempo: $tempo)
            } .frame(width: 350)
            
            
            let valorConvertido = Float(valor.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
                        
            let tempoConvertido = Int(tempo.texto) ?? 0
            
            ForEach(investimentos) { tipo in
                
                @State var valor = CaixaTextoViewModel.caixaTexto[2]
                
                HStack{
                    CardView(
                        modeloCard: $modeloCardGenerico,
                        tipoInvestimento: tipo.tituloPrincipal,
                        mediaMeses: tipo.mediaHistorica,
                        exemploValor: "Ex.: 123%",
                        tipoRetornoInvestimento: "Rendimento",
                        valorInvestido: valorConvertido,
                        tempoDeInvestimento: tempoConvertido,
                        corGrafico: .black
                    )
                } .frame(width: 350, height: 300)
                
            }
        }

    }
}

#Preview {
    
        let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
        
        TelaInformacoesView(investimentos: investimentosSimulacao)
}
