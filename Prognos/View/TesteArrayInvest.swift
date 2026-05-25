import SwiftUI

struct TelaInformacoesView: View {
    
    // Controles globais (Topo da tela)
    @State var valorGlobal = CaixaTextoViewModel.caixaTexto[0]
    @State var tempoGlobal = CaixaTextoViewModel.caixaTexto[1]
    
    // Lista de ViewModels que controlarão a tela
    @State var viewModels: [CardViewModel]
    
    // O Init transforma os Enums recebidos em ViewModels prontos
    init(investimentos: [TipoDeInvestimento]) {
        let vmsMapeados = investimentos.map { CardViewModel(tipo: $0) }
        _viewModels = State(initialValue: vmsMapeados)
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
            
            BotaoView(texto: "Simular", habilitado: false)
        }
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
    TelaInformacoesView(investimentos: investimentosSimulacao)
}
