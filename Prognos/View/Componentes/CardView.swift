import SwiftUI

struct CardView: View {
    
    @Binding var modeloCard: CaixaTextoModel
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 24
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    let tipoInvestimento: String
    let mediaMeses: String
    let exemploValor: String
    let tipoRetornoInvestimento: String
    let valorInvestido: Float
    let tempoDeInvestimento: Int
    let corGrafico: Color
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(alignment: .top) {
                Text(tipoInvestimento)
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color(.corFonte))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 9) {
                    Text(mediaMeses)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                        .foregroundColor(Color(.corFonte))
                    
                    Text("Média últimos 12 meses")
                        .font(.custom("BaiJamjuree-Medium", size: 11, relativeTo: .title))
                        .foregroundColor(Color(.corFonte).opacity(0.8))
                }
            }
            .padding(paddingAdaptativo)
            .background(Color.corPrimaria)
        
            
            
          
            VStack(alignment: .leading, spacing: 24) {
                
              
                VStack(alignment: .leading, spacing: 8) {
                    Text(tipoRetornoInvestimento)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                    
                    CaixaTextoView(caixa: $modeloCard)
                }
                
                
                HStack(alignment: .top) {
                   
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Valor Investido")
                            .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                        HStack(){
                            Text("R$")
                                .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                            
                            Text(valorInvestido, format: .number.notation(.compactName))
                                .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                        }
                    }
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tempo")
                            .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                        Text("\(tempoDeInvestimento) anos")
                            .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cor no gráfico")
                            .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                        Circle()
                            .fill(corGrafico)
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
    
    CardView(
        modeloCard: $valor,
        tipoInvestimento: "CDI",
        mediaMeses: "102%",
        exemploValor: "Ex.: 123%",
        tipoRetornoInvestimento: "Rendimento",
        valorInvestido: 150.90,
        tempoDeInvestimento: 4,
        corGrafico: .black
    )
    .padding()
}
