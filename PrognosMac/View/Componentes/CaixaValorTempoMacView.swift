//
//  CaixaValorTempoMacView.swift
//  PrognosMac
//
//  Created by Mariana Fracaroli Lopes on 27/05/26.
//

import SwiftUI

struct CaixaValorTempoMacView: View {
    @Binding var modeloValor: CaixaTextoModel
        @Binding var modeloTempo: CaixaTextoModel
        
        @ScaledMetric(relativeTo: .body)
        var paddingAdaptativo: CGFloat = 20
        
        @Environment(\.dynamicTypeSize)
        var tipoDeTamanho
        
        var body: some View {
            
            Group {
                
                // ACESSIBILIDADE
                
                if tipoDeTamanho.isAccessibilitySize {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Valor")
                                .font(
                                    .custom(
                                        "Avenir Next Demi Bold",
                                        size: 20,
                                        relativeTo: .title
                                    )
                                )
                                .foregroundStyle(Color.corFonte)
                            
                            CaixaTextoView(caixa: $modeloValor)
                        }
                        
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.corCaixas)
                            .frame(height: 2)
                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Tempo")
                                .font(
                                    .custom(
                                        "Avenir Next Demi Bold",
                                        size: 20,
                                        relativeTo: .title
                                    )
                                )
                                .foregroundStyle(Color.corFonte)
                            
                            CaixaTextoView(caixa: $modeloTempo)
                        }
                    }
                    
                } else {
                    
                    // MAC / TELAS GRANDES
                    
                    HStack(spacing: 28) {
                        
                        // VALOR
                        
                        HStack(spacing: 18) {
                            
                            Text("Valor")
                                .font(
                                    .custom(
                                        "Avenir Next Demi Bold",
                                        size: 20,
                                        relativeTo: .title
                                    )
                                )
                                .foregroundStyle(Color.corFonte)
                            
                            CaixaTextoView(caixa: $modeloValor)
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        // LINHA
                        
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.corCaixas)
                            .frame(width: 2, height: 48)
                        
                        
                        // TEMPO
                        
                        HStack(spacing: 18) {
                            
                            Text("Tempo")
                                .font(
                                    .custom(
                                        "Avenir Next Demi Bold",
                                        size: 20,
                                        relativeTo: .title
                                    )
                                )
                                .foregroundStyle(Color.corFonte)
                            
                            CaixaTextoView(caixa: $modeloTempo)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(paddingAdaptativo)
            .frame(maxWidth: .infinity)
            .background(Color.corFundo)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.corPrimaria, lineWidth: 2)
            )
            .padding(.horizontal)
        }
    }

    #Preview {
        
        @Previewable @State var valor = CaixaTextoViewModel.caixaTexto[0]
        @Previewable @State var tempo = CaixaTextoViewModel.caixaTexto[1]
        
        VStack {
            
            CaixaValorTempoMacView(
                modeloValor: $valor,
                modeloTempo: $tempo
            )
        }
    }
