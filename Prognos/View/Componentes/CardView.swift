import SwiftUI

struct CardView: View {
    
    // Ouve as mudanças da caixa de texto do card
    @ObservedObject var viewModel: CardViewModel
    
    // Mantendo a sua responsividade exata
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 24
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    // Variáveis que vêm da tela principal
    let valorInvestido: Float
    let tempoDeInvestimento: Int
    let corGrafico: Color
    
    var body: some View {
        VStack(spacing: 0) {
            
            // CABEÇALHO
            HStack(alignment: .top) {
                Text(viewModel.tipo.tituloPrincipal)
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color.corFonte) // Atualizado para a sua cor
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 9) {
                    Text(viewModel.tipo.mediaHistorica)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                        .foregroundColor(Color.corFonte)
                    
                    Text("Média últimos 12 meses")
                        .font(.custom("BaiJamjuree-Medium", size: 11, relativeTo: .title))
                        .foregroundColor(Color.corFonte.opacity(0.8))
                }
            }
            .padding(paddingAdaptativo)
            .background(Color.corPrimaria)
            
            // CORPO
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    // Puxa o label correto (ex: "Taxa de Administração")
                    Text(viewModel.tipo.nomeDoInputPrincipal)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                    
                    // O Bind vai direto para o ViewModel deste card
                    CaixaTextoView(caixa: $viewModel.caixaTexto)
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Valor Investido")
                            .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                        HStack {
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
            .background(Color.corCaixas) // Atualizado para a sua cor
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

#Preview {
    // 1. Criamos um ViewModel inicializado com um investimento real do seu Catálogo
    let viewModelDeTeste = CardViewModel(tipo: .cdbCdi)
    
    // 2. Passamos o ViewModel e os dados globais simulados para o Preview
    CardView(
        viewModel: viewModelDeTeste,
        valorInvestido: 1000.00,
        tempoDeInvestimento: 3,
        corGrafico: .cyan
    )
    .padding()
}
