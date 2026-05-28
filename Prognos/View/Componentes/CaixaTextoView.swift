import SwiftUI

struct CaixaTextoView: View {
    
    // @Binding funciona como um controle remoto.
    // Ele não guarda o texto, ele altera o texto que está na tela principal.
    @Binding var caixa: CaixaTextoModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 10

    
    var body: some View {
        TextField("", text: $caixa.texto, prompt: Text(caixa.placeholder)
            .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
            .foregroundColor(Color(.corFonte))
        )
        .keyboardType(.decimalPad)
        .textFieldStyle(.plain) // Remove o fundo branco padrão do Mac/iOS
        .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
        .foregroundColor(Color(.corFonte))
        .padding(.horizontal, 20)
        .padding(.vertical, paddingAdaptativo)
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(caixa.cor.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: caixa.arredondamento))
        
    }
}

#Preview {
    // Usamos o mock do CaixaTextoViewModel para o Preview
    @Previewable @State var caixa: CaixaTextoModel = CaixaTextoViewModel.caixaTexto[0]
    CaixaTextoView(caixa: $caixa)
        .padding()
}
