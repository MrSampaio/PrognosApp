//
//  CenarioInvestimentoModel.swift
//  Prognos
//
//  Created by Julio Sampaio on 27/05/26.
//

import Foundation

// MARK: - Model: Cenários de Inflação
enum CenarioInflacao: String, CaseIterable {
    case boa = "Boa (Controlada)"
    case ruim = "Ruim (Alta)"
    case historica = "Histórica (Randômica)"
    
    // Agora as taxas são trajetórias estáveis, não elementos isolados
    var trajetoria: [Double] {
        switch self {
        case .boa:
            // Inflação constante e baixa (3.5% ao ano)
            return Array(repeating: 0.035, count: 20)
        case .ruim:
            // Inflação alta e persistente (9% ao ano)
            return Array(repeating: 0.09, count: 20)
        case .historica:
            // Trajetória que simula um ciclo de economia (sobe e desce suave)
            return [0.04, 0.045, 0.06, 0.08, 0.10, 0.08, 0.06, 0.05, 0.04, 0.035] + Array(repeating: 0.035, count: 10)
        }
    }
    
    // Função para pegar a taxa do ano correspondente sem sortear nada
    func obterTaxaParaAno(_ ano: Int) -> Double {
        let array = trajetoria
        // Se o ano for maior que a trajetória, repete o último valor
        return ano < array.count ? array[ano] : array.last!
    }
}
