import SwiftUI

struct CaixaTextoView: View {
    
    @Binding var caixa: CaixaTextoModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 10
    
    var body: some View {
        TextField("", text: $caixa.texto, prompt: Text(caixa.placeholder)
            .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
            .foregroundColor(Color(.corFonte))
        )
        .textFieldStyle(.plain)
        .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title2))
        .foregroundColor(Color(.corFonte))
        .padding(.horizontal, 20)
        .padding(.vertical, paddingAdaptativo )
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(caixa.cor)
        .clipShape(RoundedRectangle(cornerRadius: caixa.arredondamento))
    }
}

#Preview {
    @Previewable @State var caixa: CaixaTextoModel = CaixaTextoViewModel.caixaTexto[0]
    CaixaTextoView(caixa: $caixa)
        .padding()
}
