import SwiftUI

struct CaixaValorTempo: View {
    
    // Recebe o controle remoto das duas caixas de texto
    @Binding var modeloValor: CaixaTextoModel
    @Binding var modeloTempo: CaixaTextoModel
    
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 20
    
    // Lê a configuração de tamanho de fonte do iPhone do usuário
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    var body: some View {
        Group {
            // Acessibilidade: Se o usuário usa uma fonte gigante, empilha tudo na vertical (VStack)
            if tipoDeTamanho.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Valor")
                            .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title))
                            .foregroundStyle(Color.corFonte)
                        CaixaTextoView(caixa: $modeloValor)
                    }
                    
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.corCaixas)
                        .frame(height: 2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tempo")
                            .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title))
                            .foregroundStyle(Color.corFonte)
                        CaixaTextoView(caixa: $modeloTempo)
                    }
                }
            } else {
                
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
                    GridRow {
                        Text("Valor")
                            .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title))
                            .foregroundStyle(Color.corFonte)
                        CaixaTextoView(caixa: $modeloValor)
                    }
                    
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.corCaixas)
                        .frame(height: 2)
                        .gridCellColumns(2)
                    
                    GridRow {
                        Text("Tempo")
                            .font(.custom("BaiJamjuree-SemiBold", size: 20, relativeTo: .title))
                            .foregroundStyle(Color.corFonte)
                        CaixaTextoView(caixa: $modeloTempo)
                    }
                }
            }
        }
        .padding(paddingAdaptativo)
        .frame(maxWidth: .infinity)
        .background(Color.corFundo)
        .clipShape(RoundedRectangle(cornerRadius: 24))
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
        CaixaValorTempo(modeloValor: $valor, modeloTempo: $tempo)
    }
}
