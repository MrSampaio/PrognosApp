//
//  sla.swift
//  Prognos
//
//  Created by Julio Sampaio on 27/05/26.
//

import SwiftUI
import Charts

struct GraficoInvestimentosView: View {
    
    let pontosDoGrafico: [PontoEvolucao]
    let tempoInvestimento: Int
    let mostrarValorReal: Bool
    
    var nomesLegendas: [String]? = nil
    var coresLegendas: [Color]? = nil
    
    var body: some View {
        Chart(pontosDoGrafico) { ponto in
            LineMark(
                x: .value("Ano", ponto.ano),
                y: .value("Valor", mostrarValorReal ? ponto.montanteReal : ponto.montanteNominal)
            )
            .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
            
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: tempoInvestimento))
        }
        // Força a paleta de cores criada na ViewModel
        .chartForegroundStyleScale(
            domain: nomesLegendas ?? [],
            range: coresLegendas ?? []
        )
        // Animações fluidas quando os dados mudam
        .animation(.easeInOut(duration: 0.6), value: pontosDoGrafico)
        .animation(.easeInOut(duration: 0.6), value: mostrarValorReal)
    }
}

