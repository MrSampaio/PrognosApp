import SwiftUI

struct CardView: View {
    
    // CORREÇÃO: Substituímos as variáveis soltas pelo ViewModel!
    // @ObservedObject escuta a antena do CardViewModel.
    @ObservedObject var viewModel: CardViewModel
    
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 24
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    @ScaledMetric(relativeTo: .subheadline) var tamanhoDaBola: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- SEÇÃO VERDE ---
            HStack(alignment: .top) {
                // Lendo os dados diretamente do 'viewModel.card'
                Text(viewModel.card.tipoInvestimento)
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color(.corFonte))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 9) {
                    Text(viewModel.card.mediaMeses)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                        .foregroundColor(Color(.corFonte))
                    
                    Text("Média últimos 12 meses")
                        .font(.custom("BaiJamjuree-Medium", size: 11, relativeTo: .title))
                        .foregroundColor(Color(.corFonte).opacity(0.8))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, paddingAdaptativo)
            .padding(.vertical, 12)
            .background(Color.corPrimaria)
            
            // --- SEÇÃO CINZA ---
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.card.tipoRetornoInvestimento)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                    
                    // Conectando a caixa de texto ao modelo salvo no ViewModel
                    CaixaTextoView(caixa: $viewModel.caixaTexto)
                }
                
                // Mágica Responsiva: Tenta o layout Horizontal. Se não couber, usa o Vertical.
                ViewThatFits {
                    
                    // 🥇 LAYOUT HORIZONTAL
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Valor Investido")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                            HStack {
                                Text("R$")
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                                
                                Text(viewModel.card.valorInvestido, format: .number.notation(.compactName))
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tempo")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                            Text("\(viewModel.card.tempoDeInvestimento) anos")
                                .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cor no gráfico")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                            Circle()
                                .fill(viewModel.card.corGrafico)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        }
                    }
                    
                    // 🥈 LAYOUT VERTICAL (Para telas estreitas ou fontes grandes)
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Valor Investido")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                                .lineLimit(2) // Permite quebrar linha
                                .minimumScaleFactor(0.7) // Permite diminuir a fonte se espremer
                                .fixedSize(horizontal: false, vertical: true)
                            HStack {
                                Text("R$")
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                                
                                Text(viewModel.card.valorInvestido, format: .number.notation(.compactName))
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tempo")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                            Text("\(viewModel.card.tempoDeInvestimento) anos")
                                .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cor no gráfico")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // A bola cresce junto com o texto usando o @ScaledMetric
                            Circle()
                                .fill(viewModel.card.corGrafico)
                                .frame(width: tamanhoDaBola, height: tamanhoDaBola)
                                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        }
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
    CardView(
        viewModel: CardViewModel(
            cardDeTeste: CardViewModel.dadosDeTeste[0],
            caixaTexto: CaixaTextoViewModel.caixaTexto[2]
        )
    )
    .padding()
}
