import SwiftUI

struct InvestimentosMacView: View {
    
    @ObservedObject var viewModel: CardViewModel
    @ScaledMetric(relativeTo: .subheadline) var tamanhoDoCirculo: CGFloat = 20
    let valorInvestido: Float
    let tempoDeInvestimento: Int
    let corGrafico: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 1. THE HEADER (Colored Dot + Title)
            HStack(spacing: 8) {
                Circle()
                    // ⚠️ CORREÇÃO APLICADA AQUI ⚠️
                    .fill(corGrafico)
                    .frame(width: tamanhoDoCirculo, height: tamanhoDoCirculo)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                // Swap "CDI" with your enum property, e.g., viewModel.tipo.tituloPrincipal
                Text(viewModel.tipo.tituloPrincipal)
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color.corFonte)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            
            CaixaTextoView(caixa: $viewModel.caixaTexto)
            
            Text(viewModel.tipo.mediaHistorica)
                .font(.custom("BaiJamjuree-Medium", size: 14, relativeTo: .title3))
                .foregroundColor(Color.corFonte)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)
        }
        // This ensures the component stretches correctly inside any grid or container!
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    InvestimentosMacView(
        viewModel: CardViewModel(tipo: .cdbCdi),
        valorInvestido: 1000.00,
        tempoDeInvestimento: 3,
        corGrafico: .cyan
    )
    .padding()
}
