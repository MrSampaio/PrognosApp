import SwiftUI

struct CaixaTextoView: View {
    
    @Binding var caixa: CaixaTextoModel
    
    var body: some View {
        TextField("", text: $caixa.texto, prompt: Text(caixa.placeholder)
            .font(.custom("BaiJamjuree-Medium", size: 20, relativeTo: .title))
            .foregroundColor(Color(.corFonte))
        )
        .textFieldStyle(.plain)
        .font(.custom("BaiJamjuree-Medium", size: 20, relativeTo: .title))
        .foregroundColor(Color(.corFonte))
        .padding(.horizontal, 20)
        .padding(.vertical)
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
