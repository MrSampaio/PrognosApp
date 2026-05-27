//
//  GraficoEvolucaoView.swift
//  Prognos
//
//  Created by Julio Sampaio on 26/05/26.
//

import SwiftUI
import Charts

struct GraficoEvolucaoView: View {
    // Parâmetros que o componente precisa para desenhar o gráfico
    let dados: [PontoEvolucao]
    let tempoInvestimento: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Chart(dados) { ponto in
                LineMark(
                    x: .value("Ano", ponto.ano),
                    y: .value("Valor (R$)", ponto.montante)
                )
                // Diferencia a cor da linha pelo nome do investimento
                .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                // Adiciona marcadores (bolinhas/quadrados) em cada ponto
                .symbol(by: .value("Investimento", ponto.nomeInvestimento))
                // Deixa a curva levemente arredondada
                .interpolationMethod(.monotone)
            }
            .frame(height: 320)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: tempoInvestimento))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview do Componente Isolado
#if DEBUG
#Preview {
    // Criando alguns dados falsos apenas para testar o visual do componente
    let dadosMock = [
        PontoEvolucao(nomeInvestimento: "CDB", ano: 0, montante: 1000),
        PontoEvolucao(nomeInvestimento: "CDB", ano: 1, montante: 1100),
        PontoEvolucao(nomeInvestimento: "CDB", ano: 2, montante: 1210),
        
        PontoEvolucao(nomeInvestimento: "LCI", ano: 0, montante: 1000),
        PontoEvolucao(nomeInvestimento: "LCI", ano: 1, montante: 1080),
        PontoEvolucao(nomeInvestimento: "LCI", ano: 2, montante: 1170)
    ]
    
    return GraficoEvolucaoView(dados: dadosMock, tempoInvestimento: 2)
        .padding()
}
#endif
