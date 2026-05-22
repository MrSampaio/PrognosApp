import SwiftUI

struct CardView: View {
    
    @Binding var modeloCard: CaixaTextoModel
    
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 24
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(alignment: .top) {
                Text("CDI")
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color(.corFonte))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("102%")
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                        .foregroundColor(Color(.corFonte))
                    
                    Text("Média últimos 12 meses")
                        .font(.custom("BaiJamjuree-Medium", size: 12, relativeTo: .title))
                        .foregroundColor(Color(.corFonte).opacity(0.8))
                }
            }
            .padding(paddingAdaptativo)
            .background(Color.corPrimaria)
            
            
          
            VStack(alignment: .leading, spacing: 24) {
                
              
                VStack(alignment: .leading, spacing: 8) {
                    Text("Rendimento")
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                    
                    CaixaTextoView(caixa: $modeloCard)
                }
                
                
                HStack(alignment: .top) {
                   
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Valor Investido")
                            .font(.custom("BaiJamjuree-Medium", size: 14, relativeTo: .subheadline))
                        Text("R$1000,00")
                            .font(.custom("BaiJamjuree-Bold", size: 18, relativeTo: .headline))
                    }
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tempo")
                            .font(.custom("BaiJamjuree-Medium", size: 14, relativeTo: .subheadline))
                        Text("3 anos")
                            .font(.custom("BaiJamjuree-Bold", size: 18, relativeTo: .headline))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cor no gráfico")
                            .font(.custom("BaiJamjuree-Medium", size: 14, relativeTo: .subheadline))
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    }
                }
            }
            .padding(paddingAdaptativo)
            .background(Color.corCaixas)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
}

#Preview {
    @Previewable @State var valor = CaixaTextoViewModel.caixaTexto[2]
    CardView(modeloCard: $valor)
        .padding()
}
