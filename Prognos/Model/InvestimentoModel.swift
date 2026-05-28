//
//  InvestimentoModel.swift
//  Prognos
//
//  Created by Julio Sampaio on 19/05/26.
//

import Foundation

struct Investimento {
    let regraDeRentabilidade: (_ valor: Double, _ meses: Int, _ inflacao: Double, _ indicador: Double) -> Double
    let regraDeImposto: (_ lucroBruto: Double, _ meses: Int) -> Double
    let regraDeTaxasExtras: (_ valorBruto: Double, _ meses: Int) -> Double
    
    func calcular(valor: Double, meses: Int, inflacao: Double, indicador: Double) -> Double {
        let valorBruto = regraDeRentabilidade(valor, meses, inflacao, indicador)
        
        // O lucro é a diferença entre o que você tem e o que investiu
        let lucro = valorBruto - valor
        
        // IMPOSTO: Só é cobrado se houver lucro
        let imposto = lucro > 0 ? regraDeImposto(lucro, meses) : 0.0
        
        // TAXAS:
        let taxas = regraDeTaxasExtras(valorBruto, meses)
        
        let resultadoFinal = valorBruto - imposto - taxas
        
        // 👇 O SEGREDO:
        // Se o resultado for menor que o valor investido (prejuízo real),
        // retornamos o valor investido para que o gráfico não fique vazio/zerado.
        return max(valor, resultadoFinal)
    }
}

struct RegrasMatematicas{
    
    // uma função que retorna uma outra função (closure) que recebe quatro outros parâmetros e retornan um double
    static func prefixado(taxaAnual: Double) -> (Double, Int, Double, Double) -> Double {
        return { valor, meses, _, _ in
            let taxaMensal = pow(1.0 + taxaAnual, 1.0 / 12.0) - 1.0
            return valor * pow(1.0 + taxaMensal, Double(meses))
        }
    }
    
    static func posFixado(percentual: Double) -> (Double, Int, Double, Double) -> Double {
        return { valor, meses, _, indicadorAnual in
            let taxaAnualFinal = indicadorAnual * percentual
            let taxaMensal = pow(1.0 + taxaAnualFinal, 1.0 / 12.0) - 1.0
            return valor * pow(1.0 + taxaMensal, Double(meses))
        }
    }
    
    static func hibrido(taxaFixa: Double) -> (Double, Int, Double, Double) -> Double {
        return { valor, meses, inflacao, _ in
            let taxaAnualFinal = ((1.0 + taxaFixa) * (1.0 + inflacao)) - 1.0
            let taxaMensal = pow(1.0 + taxaAnualFinal, 1.0 / 12.0) - 1.0
            return valor * pow(1.0 + taxaMensal, Double(meses))
        }
    }
    
    // Impostos
    static func isento() -> (Double, Int) -> Double { return { _, _ in 0.0 } }
    
    static func tabelaRegressiva() -> (Double, Int) -> Double {
        return { lucro, meses in
            let dias = meses * 30
            switch dias {
            case 0...180: return lucro * 0.225
            case 181...360: return lucro * 0.20
            case 361...720: return lucro * 0.175
            default: return lucro * 0.15
            }
        }
    }
    
    // Taxas
    static func semTaxas() -> (Double, Int) -> Double { return { _, _ in 0.0 } }
    
    static func taxaB3() -> (Double, Int) -> Double {
        return { valorBruto, meses in
            return valorBruto * (0.002 * (Double(meses) / 12.0))
        }
    }
    
    static func taxaFundo(adm: Double) -> (Double, Int) -> Double {
        return { valorBruto, meses in
            return valorBruto * (adm * (Double(meses) / 12.0))
        }
    }
}
