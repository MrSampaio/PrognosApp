//
//  SimulacaoModel.swift
//  Prognos
//
//  Created by Julio Sampaio on 26/05/26.
//

import Foundation

// O "pacote" que viaja da TelaInformacoesView para a TelaResultadosView
struct DadosDaSimulacao: Hashable {
    let valorInicial: Float
    let tempoAnos: Int
    let investimentos: [InvestimentoConfigurado]
}

// O que o usuário digitou em cada card
struct InvestimentoConfigurado: Hashable {
    let tipo: TipoDeInvestimento
    let taxaDigitada: Float
}

// Os cenários que o usuário pode escolher no topo do gráfico
enum CenarioEconomico: String, CaseIterable {
    case otimista = "Otimista"
    case historico = "Histórico"
    case pessimista = "Pessimista"
    
    var taxaIpcaProjetada: Float {
        switch self {
        case .otimista: return 3.5
        case .historico: return 5.8
        case .pessimista: return 9.0
        }
    }
    
    var taxaCdiProjetada: Float {
        switch self {
        case .otimista: return 8.0
        case .historico: return 10.5
        case .pessimista: return 13.5
        }
    }
}

// O molde exato que o SwiftCharts precisa para plotar X e Y
struct PontoDoGrafico: Identifiable {
    let id = UUID()
    let nomeInvestimento: String
    let ano: Int
    let saldo: Float
}
