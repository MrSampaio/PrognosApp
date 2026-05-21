import SwiftUI

struct CaixaTextoView: View {
  
    
    @Binding var caixa: CaixaTextoModel
    @Binding var isEditing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let tamanhoFonte = geometry.size.width * 0.05
            let altura = geometry.size.height * 0.8
            
            TextField("", text: $caixa.texto, prompt: Text(caixa.placeholder)
                    .font(.custom("BaiJamjuree-Medium", size: tamanhoFonte))
                    .foregroundColor(Color(.corFonte))
            )
            .textFieldStyle(.plain)
            .font(.custom("BaiJamjuree-Medium", size: tamanhoFonte))
            .foregroundColor(Color(.corFonte))
            .padding(.horizontal, 20)
            
            .frame(minWidth: 50, maxWidth: .infinity, alignment: .leading)
            
            .frame(minHeight: altura, maxHeight: altura)
            
            .background(Color.corCaixas)
            .cornerRadius(2)
            .frame(height: altura)
        }
        
    }
}

#Preview {
    @Previewable @State var caixa: CaixaTextoModel = CaixaTextoViewModel.caixaTexto[0]
    CaixaTextoView(caixa: $caixa, isEditing: .constant(true))
}
