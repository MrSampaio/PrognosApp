import SwiftUI
import Charts
import Combine

struct TelaInformacoesMacView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var viewModels: [CardViewModel]
    @StateObject var chartViewModel: TelaResultadosViewModel
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    init(investimentos: [TipoDeInvestimento]) {
        let vmsMapeados = investimentos.map { CardViewModel(tipo: $0) }
        _viewModels = State(initialValue: vmsMapeados)
        
        _chartViewModel = StateObject(wrappedValue: TelaResultadosViewModel(
            valorInvestido: 0,
            tempoInvestimento: 0,
            dadosDosCards: vmsMapeados
        ))
    }
    
    private func dispararAtualizacaoDoGrafico() {
        let valorLimpo = valorGlobal.texto
            .replacingOccurrences(of: "R$", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
            
        let novoValorFloat = Float(valorLimpo) ?? 0.0
        let novoTempoInt = Int(tempoGlobal.texto.trimmingCharacters(in: .whitespaces)) ?? 1
            
        withAnimation(.easeInOut(duration: 0.4)) {
            chartViewModel.recalcularSimulacao(
                novoValor: novoValorFloat,
                novoTempo: novoTempoInt,
                cardsAtualizados: viewModels
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
                        
                        ForEach(0..<chartViewModel.dadosDosCards.count, id: \.self) { indice in
                            let card = chartViewModel.dadosDosCards[indice]
                            let montante = chartViewModel.obterMontanteFinal(para: card)
                            let melhor = chartViewModel.eOMelhorInvestimento(card)
                            
                            CardResultadoView(
                                titulo: card.tipo.tituloPrincipal,
                                lucroLiquido: montante - Double(chartViewModel.valorInvestido),
                                eOMelhor: melhor
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Informe os parâmetros\nde cada investimento")
                            .font(.custom("BaiJamjuree-SemiBold", size: 24))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(0..<viewModels.count, id: \.self) { indice in
                                    
                                    let bindingDoTexto = Binding(
                                        get: { viewModels[indice].caixaTexto.texto },
                                        set: { novoTexto in
                                            viewModels[indice].caixaTexto.texto = novoTexto
                                            dispararAtualizacaoDoGrafico()
                                        }
                                    )
                                    
                                    InvestimentosMacView(
                                        viewModel: viewModels[indice],
                                        valorInvestido: 1000,
                                        tempoDeInvestimento: 13,
                                        corGrafico: .blue
                                    )
                                    .onReceive(viewModels[indice].objectWillChange) { _ in
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
