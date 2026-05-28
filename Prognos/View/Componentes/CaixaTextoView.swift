import SwiftUI

struct CaixaTextoView: View {
    
    @Binding var caixa: CaixaTextoModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 10
    
    // ✅ PARÂMETROS OPCIONAIS COM VALOR PADRÃO (nil)
    // Se você não passar nada, a caixa usa as cores padrões do modelo ou do app.
    var corFundoCustomizada: Color? = nil
    var corPlaceholderCustomizada: Color? = nil
    var corTextoCustomizada: Color? = nil

    var body: some View {
        TextField("", text: $caixa.texto, prompt: Text(caixa.placeholder)
            .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
            // ✅ Usa a cor customizada do placeholder se ela for passada, senão usa a padrão
            .foregroundColor(corPlaceholderCustomizada ?? Color("CorFonte"))
        )
        
        #if canImport(UIKit)
                .keyboardType(.decimalPad)
        #endif

        .textFieldStyle(.plain) // Remove o fundo branco padrão do Mac/iOS
        .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
        // ✅ Usa a cor customizada do texto se ela for passada, senão usa a padrão
        .foregroundColor(corTextoCustomizada ?? Color("CorFonte"))
        .padding(.horizontal, 20)
        .padding(.vertical, paddingAdaptativo)
        
        .frame(maxWidth: .infinity, alignment: .leading)
        // ✅ Usa o fundo customizado se ele existir, senão cai no comportamento padrão do modelo
        .background(corFundoCustomizada ?? caixa.cor.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: caixa.arredondamento))
    }
}

#Preview {
    @Previewable @State var caixa: CaixaTextoModel = CaixaTextoViewModel.caixaTexto[0]
    
    VStack(spacing: 20) {
        // Caso 1: Uso padrão (vai ler a cor que já vem dentro do modelo 'caixa.cor')
        CaixaTextoView(caixa: $caixa)
        
        // Caso 2: Forçando uma cor de fundo e placeholder totalmente diferentes para outro lugar do app
        CaixaTextoView(
            caixa: $caixa,
            corFundoCustomizada: Color.white.opacity(0.15),
            corPlaceholderCustomizada: Color.gray
        )
    }
    .padding()
    .background(Color.black)
}
