//
//  TelaResultadosView.swift
//  Prognos
//
//  Created by Julio Sampaio on 25/05/26.
//

import SwiftUI
import Charts

struct DadosDaSimulacao: Hashable {
    let valorInicial: Float
    let tempoAnos: Int
    let investimentos: [InvestimentoConfigurado]
}

struct InvestimentoConfigurado: Hashable {
    let tipo: TipoDeInvestimento
    let taxaDigitada: Float
}


struct TelaResultadosView: View {
    enum CenarioEconomico: String, CaseIterable {
        case otimista = "Otimista"
        case historico = "Histórico"
        case pessimista = "Pessimista"
        
        var taxaIpcaProjetada: Float {
            switch self {
            case .otimista: return 3.5  // Inflação baixa
            case .historico: return 5.8 // Média real
            case .pessimista: return 9.0 // Inflação alta
            }
        }
    }

    struct PontoDoGrafico: Identifiable {
        let id = UUID()
        let nomeInvestimento: String
        let ano: Int       // Eixo X
        let saldo: Float   // Eixo Y
    }

    
    // Instanciamos o ViewModel que vai cuidar das contas
    @StateObject private var viewModel: TelaResultadosViewModel
    
    // O Init injeta o pacote de dados dentro do ViewModel
    init(dados: DadosDaSimulacao) {
        _viewModel = StateObject(wrappedValue: TelaResultadosViewModel(dados: dados))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Projeção do Investimento")
                .font(.title2.bold())
            
            // 1. O CONTROLE DOS GRÁFICOS
            // Quando o usuário clica aqui, o viewModel recalcula as linhas automaticamente!
            Picker("Cenário", selection: $viewModel.cenarioAtual) {
                ForEach(CenarioEconomico.allCases, id: \.self) { cenario in
                    Text(cenario.rawValue).tag(cenario)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // 2. O GRÁFICO (SWIFTCHARTS)
            Chart {
                ForEach(viewModel.gerarPontosDoGrafico()) { ponto in
                    LineMark(
                        x: .value("Ano", ponto.ano),
                        y: .value("Saldo", ponto.saldo)
                    )
                    // Pinta cada linha de uma cor diferente baseado no nome do investimento
                    .foregroundStyle(by: .value("Investimento", ponto.nomeInvestimento))
                }
            }
            .frame(height: 300)
            .padding()
            
            Spacer()
        }
        .navigationTitle("Resultados")
        .navigationBarTitleDisplayMode(.inline)
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
