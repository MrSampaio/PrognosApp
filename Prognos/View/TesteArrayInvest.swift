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
            
            // CAIXAS GLOBAIS (Valor e Tempo)
            HStack {
                CaixaValorTempo(modeloValor: $valorGlobal, modeloTempo: $tempoGlobal)
            }
            .frame(width: 350)
            
            // Conversão segura em tempo real
            let valorConvertido = Float(valorGlobal.texto.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let tempoConvertido = Int(tempoGlobal.texto) ?? 0
            
            // RENDERIZAÇÃO DOS CARDS
            ForEach(viewModels) { viewModelDoCard in
                
                // Chamamos apenas UM CardView por item, passando os dados necessários
                CardView(
                    viewModel: viewModelDoCard,
                    valorInvestido: valorConvertido,
                    tempoDeInvestimento: tempoConvertido,
                    corGrafico: .black // Aqui você pode colocar a lógica da sua cor
                )
                .frame(width: 350) // Mantendo a largura que você definiu
                .padding(.vertical, 10) // Um respiro entre os cards
                
            }
        }
    }
}

#Preview {
    let investimentosSimulacao = [TipoDeInvestimento.cdbPrefixado, TipoDeInvestimento.cdbCdi]
    TelaInformacoesView(investimentos: investimentosSimulacao)
}
