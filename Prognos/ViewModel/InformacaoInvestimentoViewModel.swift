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
    
    public static let listaInvestimentos = [
        InformacaoInvestimentoModel(
            tituloInicio: "Tesouro",
            tituloFinal: "Prefixado",
            descricao: "O Tesouro Prefixado é um investimento do governo onde a taxa de juros é travada no momento da compra. A sua grande vantagem é a previsibilidade: você sabe exatamente quantos reais vai receber no final do prazo estipulado, não importando as oscilações da economia."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Tesouro",
            tituloFinal: "Selic",
            descricao: "O Tesouro Selic é um título de dívida pública emitido pelo Governo Federal que tem a sua rentabilidade atrelada à Taxa Selic (a taxa básica de juros da economia). Em termos simples, é como se você estivesse emprestando dinheiro para o governo e ele te pagasse os juros que acompanham a economia brasileira dia após dia."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Tesouro",
            tituloFinal: "Híbrido",
            descricao: "O Tesouro IPCA é um título público que combina uma taxa de juros fixa com a variação da inflação, garantindo que o seu dinheiro sempre ganhe do aumento dos preços (o chamado ganho real). É o investimento ideal para proteger e multiplicar o seu patrimônio no longo prazo, como para uma aposentadoria. No entanto, ele exige planejamento: a garantia de rendimento só vale se o título for mantido até a data de vencimento."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CDB/LC",
            tituloFinal: "Prefixado",
            descricao: "O CDB (Certificado de Depósito Bancário) e a LC (Letra de Câmbio) Prefixados são investimentos onde você empresta seu dinheiro para um banco (no caso do CDB) ou para uma financeira (no caso da LC) e, em troca, recebe uma taxa de juros travada no momento da aplicação."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CDB/LC",
            tituloFinal: "Pós-Fixado",
            descricao: "O CDB/LC Pós-Fixado é um investimento onde você empresta seu dinheiro para um banco (CDB) ou para uma financeira (LC) e o seu rendimento acompanha um indicador da economia, quase sempre a taxa CDI (que anda lado a lado com a Taxa Selic)."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CDB/LC",
            tituloFinal: "Híbrido",
            descricao: "O CDB/LC Híbrido (muito mais conhecido no mercado e nos aplicativos de banco como CDB IPCA+ ou LC IPCA+) é um investimento onde você empresta seu dinheiro para um banco ou financeira e recebe uma rentabilidade composta por duas partes, exatamente como no Tesouro Híbrido (IPCA+)."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "LCI/LCA",
            tituloFinal: "Prefixada",
            descricao: "A LCI (Letra de Crédito Imobiliário) e a LCA (Letra de Crédito do Agronegócio) Prefixadas são investimentos onde você empresta dinheiro para o banco financiar especificamente o setor de imóveis ou de fazendas/agricultura, recebendo em troca uma taxa de juros travada e garantida no momento da aplicação."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "LCI/LCA",
            tituloFinal: "Pós-Fixado",
            descricao: "A LCI (Letra de Crédito Imobiliário) e a LCA (Letra de Crédito do Agronegócio) Pós-Fixadas são investimentos onde você empresta dinheiro para o banco financiar o setor de imóveis ou do agronegócio, e o rendimento acompanha as variações da economia (quase sempre atrelado à taxa CDI)."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "LCI/LCA",
            tituloFinal: "Híbrido",
            descricao: "A LCI (Letra de Crédito Imobiliário) e a LCA (Letra de Crédito do Agronegócio) Híbridas (geralmente encontradas nas corretoras como LCI IPCA+ ou LCA IPCA+) são investimentos que unem o melhor de dois mundos: a proteção contra a inflação e a isenção de impostos."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Debênture Comum",
            tituloFinal: "Prefixada",
            descricao: "A Debênture Prefixada é um investimento onde você empresta o seu dinheiro diretamente para uma grande empresa privada (como uma companhia de energia, uma rede de shoppings ou uma concessionária de pedágios) para que ela financie seus próprios projetos. Em troca, a empresa promete te pagar o valor de volta somado a uma taxa de juros fixa e travada no momento da compra."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Debênture Comum",
            tituloFinal: "Pós-Fixado",
            descricao: "A Debênture Pós-Fixada é um investimento onde você empresta o seu dinheiro diretamente para uma grande empresa privada (como uma concessionária de rodovias, uma empresa de energia ou de saneamento) e, em troca, recebe uma rentabilidade que flutua acompanhando a economia do país – quase sempre atrelada à taxa CDI."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Debênture Comum",
            tituloFinal: "Híbrido",
            descricao: "A Debênture Híbrida (muito mais conhecida nas corretoras como Debênture IPCA+) é um investimento onde você empresta seu dinheiro diretamente para uma grande empresa privada e, em troca, recebe uma rentabilidade composta por duas partes: a inflação do período (IPCA) somada a uma taxa de juros fixa (por exemplo, IPCA + 7% ao ano)."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CRI/CRA",
            tituloFinal: "Prefixado",
            descricao: "O CRI (Certificado de Recebíveis Imobiliários) e o CRA (Certificado de Recebíveis do Agronegócio) Prefixados são investimentos onde você ajuda a financiar projetos grandes do setor de imóveis ou de fazendas, mas com uma diferença importante: você não está emprestando para um banco, e sim para as empresas diretamente."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CRI/CRA",
            tituloFinal: "Pós-Fixado",
            descricao: "O CRI (Certificado de Recebíveis Imobiliários) e o CRA (Certificado de Recebíveis do Agronegócio) Pós-Fixados são investimentos onde você financia grandes projetos do setor de imóveis ou do agronegócio (sem usar um banco como intermediário) e recebe um rendimento que acompanha as variações da economia, quase sempre atrelado à taxa CDI."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "CRI/CRA",
            tituloFinal: "Híbrido",
            descricao: "O CRI (Certificado de Recebíveis Imobiliários) e o CRA (Certificado de Recebíveis do Agronegócio) Híbridos (mais encontrados nas corretoras como CRI IPCA+ ou CRA IPCA+) são investimentos onde você financia grandes projetos do setor de imóveis ou do agronegócio e recebe uma rentabilidade composta por duas partes: a variação da inflação (IPCA) mais uma taxa de juros fixa (por exemplo, IPCA + 8% ao ano)."
        ),
        InformacaoInvestimentoModel(
            tituloInicio: "Fundo de",
            tituloFinal: "Renda Fixa",
            descricao: "O Fundo de Renda Fixa funciona como uma grande \"vaquinha\" organizada. Em vez de você ter o trabalho de analisar, escolher e comprar seus próprios títulos (como Tesouro, CDBs ou Debêntures) um por um, você coloca o seu dinheiro nesse fundo e um gestor profissional faz todo o trabalho de montar a carteira de investimentos."
        )
    ]
}
