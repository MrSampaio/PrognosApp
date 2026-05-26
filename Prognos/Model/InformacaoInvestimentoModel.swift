//
//  InformacaoInvestimentoModel.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 25/05/26.
//
import Foundation

struct InformacaoInvestimentoModel: Identifiable, Hashable {
    
    let id = UUID()
    let titulo: String
    let descricao: String
}
