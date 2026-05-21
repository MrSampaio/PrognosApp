import SwiftUI

struct CaixaValorTempo: View {
    
    var altura: CGFloat
    
    // 1. Change these bindings to use your custom model instead of Strings
    @Binding var modeloValor: CaixaTextoModel
    @Binding var modeloTempo: CaixaTextoModel
    
    private var calcularTamanhoFonte: CGFloat {
        altura * 0.75
    }
    
    var body: some View {
        
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 20) {
            
            GridRow {
                Text("Valor")
                    .font(.custom("BaiJamjuree-SemiBold", size: calcularTamanhoFonte))
                    .foregroundStyle(.corFonte)
                
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.corCaixas)
                    .frame(height: 2)
                
                GridRow {
                    Text("Tempo")
                        .font(.custom("BaiJamjuree-SemiBold", size: calcularTamanhoFonte))
                        .foregroundStyle(.corFonte)
                    
                    
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.corPrimaria, lineWidth: 2)
            )
            .padding(.horizontal)
        }
    }
}
#Preview {
   
    
}
