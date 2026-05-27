//
//  CenarioInvestimentoModel.swift
//  Prognos
//
//  Created by Julio Sampaio on 27/05/26.
//

import Foundation

// MARK: - Model: Cenários de Inflação
enum CenarioInflacao: String, CaseIterable {
    case boa = "Boa (controlada)"
    case ruim = "Ruim (alta)"
    case randomica = "Histórica"
    
    // Histórico fictício/aproximado dos últimos 10 anos
    var taxasPossiveis: [Double] {
        switch self {
        case .boa:
            // Anos de inflação na meta (ex: 3% a 4.5%)
            return [0.03, 0.032, 0.035, 0.04, 0.045]
        case .ruim:
            // Anos de crise/inflação estourada (ex: 8% a 11%)
            return [0.08, 0.085, 0.09, 0.10, 0.106, 0.11]
        case .randomica:
            // Um mix de todos os anos
            return [0.03, 0.04, 0.085, 0.035, 0.106, 0.045, 0.09]
        }
    }
    
    // Sorteia uma taxa do pool correspondente ao cenário
    func sortearTaxa() -> Double {
        return taxasPossiveis.randomElement() ?? 0.045
    }
}
