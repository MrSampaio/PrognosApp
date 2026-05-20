//
//  CatalogoInvestimentoModel.swift
//  Prognos
//
//  Created by Julio Sampaio on 20/05/26.
//

import Foundation

enum TipoDeInvestimento: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    // 1. Tesouro Direto
    case tesouroPrefixado = "Tesouro Prefixado"
    case tesouroSelic = "Tesouro Selic"
    case tesouroIpca = "Tesouro IPCA+"
    
    // 2. CDB / LC
    case cdbPrefixado = "CDB/LC Prefixado"
    case cdbCdi = "CDB/LC Pós (CDI)"
    case cdbIpca = "CDB/LC Híbrido"
    
    // 3. LCI / LCA
    case lciPrefixado = "LCI/LCA Prefixado"
    case lciCdi = "LCI/LCA Pós(CDI)"
    case lciIpca = "LCI/LCA Híbrido"
    
    // 4. Debêntures Comuns
    case debComumPrefixada = "Deb. Comum Prefixada"
    case debComumCdi = "Deb. Comum Pós(CDI)"
    case debComumIpca = "Deb. Comum Híbrida"
    
    // 5. CRI / CRA / Deb. Incentivadas
    case isentoPrefixado = "CRI/CRA Prefixado"
    case isentoCdi = "CRI/CRA Pós(CDI)"
    case isentoIpca = "CRI/CRA Híbrido"
    
    // 6. Fundos
    case fundoRendaFixa = "Fundo Renda Fixa"
    
    // --- REGRAS DE INTERFACE (para definir quais inputs aparecerão)
    var pedeTaxaPrefixada: Bool {
        switch self {
        case .tesouroPrefixado, .tesouroIpca, .cdbPrefixado, .cdbIpca, .lciPrefixado, .lciIpca, .debComumPrefixada, .debComumIpca, .isentoPrefixado, .isentoIpca: return true
        default: return false
        }
    }
    
    var pedePercentualCDI: Bool {
        switch self {
        case .cdbCdi, .lciCdi, .debComumCdi, .isentoCdi: return true
        default: return false
        }
    }
    
    var pedeTaxaB3: Bool {
        switch self {
        case .tesouroPrefixado, .tesouroSelic, .tesouroIpca: return true
        default: return false
        }
    }
    
    var pedeTaxasDeFundo: Bool {
        return self == .fundoRendaFixa
    }
    
    func criarInvestimento(taxaFixa: Double, percentualCDI: Double, taxaAdministracao: Double) -> Investimento {
        switch self {
            
        // FAMÍLIA TESOURO DIRETO (Tabela Regressiva + Taxa B3)
        case .tesouroPrefixado:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.prefixado(taxaAnual: taxaFixa),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.taxaB3()
            )
        case .tesouroSelic:
            // Tesouro Selic rende próximo a 100% da Selic
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.posFixado(percentual: 1.0),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.taxaB3()
            )
        case .tesouroIpca:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.hibrido(taxaFixa: taxaFixa),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.taxaB3()
            )
            
        // TÍTULOS BANCÁRIOS TRIBUTÁVEIS E DEBÊNTURES COMUNS
        case .cdbPrefixado, .debComumPrefixada:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.prefixado(taxaAnual: taxaFixa),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )
        case .cdbCdi, .debComumCdi:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.posFixado(percentual: percentualCDI),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )
        case .cdbIpca, .debComumIpca:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.hibrido(taxaFixa: taxaFixa),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )

        // TÍTULOS ISENTOS (LCI/LCA, CRI/CRA, Debêntures Incentivadas)
        // (Isento de IR + Sem taxas extras)
        case .lciPrefixado, .isentoPrefixado:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.prefixado(taxaAnual: taxaFixa),
                regraDeImposto: RegrasMatematicas.isento(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )
        case .lciCdi, .isentoCdi:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.posFixado(percentual: percentualCDI),
                regraDeImposto: RegrasMatematicas.isento(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )
        case .lciIpca, .isentoIpca:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.hibrido(taxaFixa: taxaFixa),
                regraDeImposto: RegrasMatematicas.isento(),
                regraDeTaxasExtras: RegrasMatematicas.semTaxas()
            )
            
        // FUNDOS DE INVESTIMENTO
        // (Tabela Regressiva + Taxa de Administração)
        case .fundoRendaFixa:
            return Investimento(
                regraDeRentabilidade: RegrasMatematicas.posFixado(percentual: 1.0),
                regraDeImposto: RegrasMatematicas.tabelaRegressiva(),
                regraDeTaxasExtras: RegrasMatematicas.taxaFundo(adm: taxaAdministracao)
            )
        }
    }
    
    
    
}
