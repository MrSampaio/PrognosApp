//
//  InformacaoInvestimentoViewModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//

import SwiftUI
import Combine

class InformacaoInvestimentoViewModel: ObservableObject {
    @Published var investimentos: [InformacaoInvestimentoModel]
    
    init(investimentos: [InformacaoInvestimentoModel]) {
            self.investimentos = investimentos
        }
    public static let testes = [
            InformacaoInvestimentoModel(
                titulo: "CDB Prefixado",
                descricao: "Rendimento fixo garantido no momento da aplicação. Ideal para quem quer segurança e sabe exatamente quando vai resgatar."
            ),
            InformacaoInvestimentoModel(
                titulo: "Tesouro IPCA+",
                descricao: "Protege seu dinheiro contra a inflação e ainda paga uma taxa fixa. Ótimo para o longo prazo."
            ),
            InformacaoInvestimentoModel(
                titulo: "LCI / LCA",
                descricao: "Investimentos isentos de Imposto de Renda. O dinheiro é usado para financiar o setor imobiliário ou o agronegócio."
            )
        ]
}
