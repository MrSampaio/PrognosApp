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
    case tesouroPrefixado = "tesouro_prefixado"
    case tesouroSelic = "tesouro_selic"
    case tesouroIpca = "tesouro_ipca"
    
    // 2. CDB / LC
    case cdbPrefixado = "cdb_prefixado"
    case cdbCdi = "cdb_cdi"
    case cdbIpca = "cdb_ipca"
    
    // 3. LCI / LCA
    case lciPrefixado = "lci_prefixado"
    case lciCdi = "lci_cdi"
    case lciIpca = "lci_ipca"
    
    // 4. Debêntures Comuns
    case debComumPrefixada = "deb_comum_prefixada"
    case debComumCdi = "deb_comum_cdi"
    case debComumIpca = "deb_comum_ipca"
    
    // 5. CRI / CRA / Deb. Incentivadas
    case isentoPrefixado = "isento_prefixado"
    case isentoCdi = "isento_cdi"
    case isentoIpca = "isento_ipca"
    
    // 6. Fundos
    case fundoRendaFixa = "fundo_renda_fixa"
    

    // MARK: - REGRAS DE TEXTO PARA O CARD
    
    var tituloPrincipal: String {
        switch self {
        case .tesouroPrefixado, .tesouroSelic, .tesouroIpca: return "Tesouro"
        case .cdbPrefixado, .cdbCdi, .cdbIpca: return "CDB/LC"
        case .lciPrefixado, .lciCdi, .lciIpca: return "LCI/LCA"
        case .debComumPrefixada, .debComumCdi, .debComumIpca: return "Debênt."
        case .isentoPrefixado, .isentoCdi, .isentoIpca: return "CRI/CRA"
        case .fundoRendaFixa: return "Fundo"
        }
    }
    
    var subtitulo: String {
        switch self {
        case .tesouroPrefixado, .cdbPrefixado, .lciPrefixado, .debComumPrefixada, .isentoPrefixado:
            return "Prefixado"
            
        case .tesouroSelic:
            return "Selic"
            
        case .cdbCdi, .lciCdi, .debComumCdi, .isentoCdi:
            return "Pós-fixado"
            
        case .tesouroIpca, .cdbIpca, .lciIpca, .debComumIpca, .isentoIpca:
            return "Híbrido"
            
        case .fundoRendaFixa:
            return "Renda Fixa"
        }
    }
    
    // MARK: - REGRAS DE INTERFACE (Inputs)
    
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
    
    
    // MARK: - MOTOR MATEMÁTICO

    
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
