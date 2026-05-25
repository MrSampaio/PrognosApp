import SwiftUI

struct TelaInformacoesView: View {
    
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    @State var viewModels: [CardViewModel]
    @State private var irParaResultados = false
    
    init(investimentos: [TipoDeInvestimento]) {
        let vmsMapeados = investimentos.map { CardViewModel(tipo: $0) }
        _viewModels = State(initialValue: vmsMapeados)
    }
    
    var pacoteDeDados: DadosDaSimulacao {
            // Pega os valores globais
            let stringValor = valorGlobal.texto.replacingOccurrences(of: ",", with: ".")
            let stringTempo = tempoGlobal.texto
            
            let valorFim = Float(stringValor) ?? 0.0
            let tempoFim = Int(stringTempo) ?? 0
            
            // Pega as taxas de dentro de CADA card
            let investimentosProntos = viewModels.map { vm -> InvestimentoConfigurado in
                let stringTaxa = vm.caixaTexto.texto.replacingOccurrences(of: ",", with: ".")
                let taxaConvertida = Float(stringTaxa) ?? 0.0
                return InvestimentoConfigurado(tipo: vm.tipo, taxaDigitada: taxaConvertida)
            }
            
            return DadosDaSimulacao(
                valorInicial: valorFim,
                tempoAnos: tempoFim,
                investimentos: investimentosProntos
            )
        }
    
    var body: some View {
        ScrollView {
            
            HStack {
                CaixaValorTempo(modeloValor: $valorGlobal, modeloTempo: $tempoGlobal)
            }
            .frame(width: 350)
            
            let valorConvertido = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let tempoConvertido = Int(tempoGlobal.texto) ?? 0
            
            ForEach(viewModels) { viewModelDoCard in
                
                CardView(
                    viewModel: viewModelDoCard,
                    valorInvestido: valorConvertido,
                    tempoDeInvestimento: tempoConvertido,
                    corGrafico: .black
                )
                .frame(width: 350)
                .padding(.vertical, 10)
                
            }

            let podeSimular = !valorGlobal.texto.isEmpty && !tempoGlobal.texto.isEmpty
            
            Spacer()
                .frame(height: 30)
            
            Button {
                // Ao clicar, disparamos o gatilho da navegação
                irParaResultados = true
            } label: {
                BotaoView(texto: "Simular", habilitado: podeSimular)
            }
            .disabled(!podeSimular)
            .padding(.bottom, 40)
            // 4. O GATILHO INTELIGENTE: Puxa o "pacoteDeDados" fresquinho da memória!
            .navigationDestination(isPresented: $irParaResultados) {
                TelaResultadosView(dados: pacoteDeDados)
            }
            
        }
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
        // Coloquei dentro de um NavigationStack no preview para o botão poder ser clicado
        NavigationStack {
            TelaInformacoesView(investimentos: investimentosSimulacao)
        }
}
