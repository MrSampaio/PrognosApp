//
//  TelaResultadosView.swift
//  Prognos
//
//  Created by Julio Sampaio on 25/05/26.
//

import SwiftUI
import Charts

struct DadosDaSimulacao {
    let valorInicial: Float
    let tempoAnos: Int
    let investimentos: [InvestimentoConfigurado]
}

struct InvestimentoConfigurado {
    let tipo: TipoDeInvestimento
    let taxaDigitada: Float
}

struct TelaResultadosView: View {
    
    let dados: DadosDaSimulacao
    
    var body: some View {
        VStack {
            Text("Pronto para os Gráficos!")
                .font(.title)
            
            Text("Valor Inicial: R$ \(dados.valorInicial)")
            Text("Tempo: \(dados.tempoAnos) anos")
            
            
            ForEach(dados.investimentos, id: \.tipo.id) { inv in
                Text("\(inv.tipo.tituloPrincipal): \(inv.taxaDigitada)%")
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Resultados")
    }
}

#Preview {
   
    let investimentosMock = [
        InvestimentoConfigurado(tipo: .cdbCdi, taxaDigitada: 105.0),
        InvestimentoConfigurado(tipo: .tesouroPrefixado, taxaDigitada: 11.5)
    ]
    
    
    let pacoteDaSimulacao = DadosDaSimulacao(
        valorInicial: 1500.50,
        tempoAnos: 3,
        investimentos: investimentosMock
    )
    

    NavigationStack {
        TelaResultadosView(dados: pacoteDaSimulacao)
    }
}
