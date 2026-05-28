//
//  TelaInformacoesMacView.swift
//  PrognosMac
//
//  Created by Leonardo Gonçalves da Silva on 27/05/26.
//

import SwiftUI
import Charts
import Combine

struct TelaInformacoesMacView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var gerente: SimuladorInvestimentosViewModel
    @StateObject var chartViewModel: TelaResultadosViewModel
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    // 1. CÁLCULOS MOVIDOS PARA FORA DO VIEWBUILDER
    // Isto evita que o SwiftUI se perca e dispare os erros de Generic/Binding
    private var valorConvertido: Float {
        let limpo = valorGlobal.texto
            .replacingOccurrences(of: "R$", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        return Float(limpo) ?? 0.0
    }
    
    private var tempoConvertido: Int {
        return Int(tempoGlobal.texto.trimmingCharacters(in: .whitespaces)) ?? 0
    }
    
    init(investimentos: [TipoDeInvestimento]) {
        let novoGerente = SimuladorInvestimentosViewModel(tiposEscolhidos: investimentos)
        _gerente = StateObject(wrappedValue: novoGerente)
        
        _chartViewModel = StateObject(wrappedValue: TelaResultadosViewModel(
            valorInvestido: 0,
            tempoInvestimento: 0,
            dadosDosCards: novoGerente.cardsDeInvestimento
        ))
    }
    
    private func dispararAtualizacaoDoGrafico() {
        withAnimation(.easeInOut(duration: 0.4)) {
            chartViewModel.recalcularSimulacao(
                novoValor: valorConvertido,
                novoTempo: tempoConvertido,
                cardsAtualizados: gerente.cardsDeInvestimento
            )
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
                // MARK: - HEADER
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("Simulação")
                            .font(.custom("BaiJamjuree-SemiBold", size: 36, relativeTo: .largeTitle))
                            .foregroundColor(Color("CorPrimaria"))
                        
                        Text("Insira o valor e o tempo que você gostaria de consultar o seu investimento:")
                            .font(.custom("Avenir Next Medium", size: 20))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                // MARK: - INPUTS GLOBAIS (Valor e Tempo)
                CaixaValorTempoMacView(modeloValor: $valorGlobal, modeloTempo: $tempoGlobal)
                    .frame(maxWidth: 800)
                    .onChange(of: valorGlobal.texto) { _ in dispararAtualizacaoDoGrafico() }
                    .onChange(of: tempoGlobal.texto) { _ in dispararAtualizacaoDoGrafico() }
                
                // MARK: - DIVISÃO PRINCIPAL EM DUAS COLUNAS
                HStack(alignment: .top, spacing: 40) {
                    
                    // =========================================
                    // COLUNA ESQUERDA: GRÁFICO E RESULTADOS
                    // =========================================
                    VStack(spacing: 30) {
                        
                        // 1. CAIXA DO GRÁFICO
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // Header do Gráfico + Toggle
                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Cenário da")
                                        .font(.custom("BaiJamjuree-Medium", size: 16))
                                        .foregroundColor(.gray)
                                    
                                    Text("Inflação \(chartViewModel.cenarioAtual.rawValue)")
                                        .font(.custom("BaiJamjuree-SemiBold", size: 28))
                                        .foregroundColor(.white)
                                        .animation(.default, value: chartViewModel.cenarioAtual)
                                }
                                
                                Spacer()
                                
                                Toggle(isOn: $chartViewModel.mostrarValorReal.animation(.easeInOut(duration: 0.6))) {
                                    Text("Descontar Inflação")
                                        .font(.custom("BaiJamjuree-Medium", size: 14))
                                        .foregroundColor(.gray)
                                }
                                .toggleStyle(.switch)
                                .tint(Color("CorPrimaria"))
                            }
                            
                            // View do Gráfico
                            GraficoInvestimentosView(
                                pontosDoGrafico: chartViewModel.pontosDoGrafico,
                                tempoInvestimento: chartViewModel.tempoInvestimento,
                                mostrarValorReal: chartViewModel.mostrarValorReal,
                                nomesLegendas: chartViewModel.nomesLegendas,
                                coresLegendas: chartViewModel.coresLegendas
                            )
                            .frame(height: 350)
                            
                            // Controles do Gráfico (< | >)
                            HStack {
                                Spacer()
                                HStack(spacing: 16) {
                                    Button(action: { withAnimation(.easeInOut(duration: 0.6)) { chartViewModel.cenarioAnterior() } }) {
                                        Image(systemName: "chevron.left").foregroundColor(.white)
                                    }
                                    Divider().frame(height: 16).background(Color.gray)
                                    Button(action: { withAnimation(.easeInOut(duration: 0.6)) { chartViewModel.proximoCenario() } }) {
                                        Image(systemName: "chevron.right").foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 24).padding(.vertical, 12)
                                .background(Color.white.opacity(0.1)).cornerRadius(30)
                                Spacer()
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(30)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(24)
                        
                        // Mini-cards de resultado abaixo do gráfico
                        HStack(spacing: 16) {
                            
                            // 2. FOR EACH CORRIGIDO (Usando a coleção direta com id)
                            ForEach(chartViewModel.dadosDosCards, id: \.id) { card in
                                let montante = chartViewModel.obterMontanteFinal(para: card)
                                let melhor = chartViewModel.eOMelhorInvestimento(card)
                                
                                CardResultadoView(
                                    titulo: card.tipo.tituloPrincipal,
                                    lucroLiquido: montante - Double(chartViewModel.valorInvestido),
                                    eOMelhor: melhor
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // =========================================
                    // COLUNA DIREITA: CARDS DE INPUT
                    // =========================================
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Informe os parâmetros\nde cada investimento")
                            .font(.custom("BaiJamjuree-SemiBold", size: 24))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                
                                // 3. FOR EACH CORRIGIDO (Lê diretamente a coleção do gerente)
                                ForEach(gerente.cardsDeInvestimento, id: \.id) { cardVM in
                                    InvestimentosMacView(
                                        viewModel: cardVM,
                                        valorInvestido: valorConvertido,
                                        tempoDeInvestimento: tempoConvertido,
                                        corGrafico: Color(cardVM.tipo.cores)
                                    )
                                    .onReceive(cardVM.objectWillChange) { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            dispararAtualizacaoDoGrafico()
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    .frame(width: 350)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // MARK: - FOOTER (Botões de Ação)
                HStack(spacing: 24) {
                    Button(action: {
                        // Ação Download
                    }) {
                        HStack {
                            Text("Download do dashboard")
                            Image(systemName: "square.and.arrow.down")
                        }
                        .font(.custom("BaiJamjuree-SemiBold", size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(30)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: { dismiss() }) {
                        HStack {
                            Text("Refazer simulação")
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .font(.custom("BaiJamjuree-SemiBold", size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color("CorPrimaria"))
                        .cornerRadius(30)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("")
        .onAppear {
            dispararAtualizacaoDoGrafico()
        }
    }
}

#Preview {
    TelaInformacoesMacView(investimentos: [.cdbCdi, .tesouroPrefixado, .lciIpca])
        .frame(width: 1200, height: 800)
}
