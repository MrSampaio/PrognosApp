import SwiftUI

struct CardView: View {
    
    // Ouve as mudanças da caixa de texto do card (ex: "102%")
    @ObservedObject var viewModel: CardViewModel
    
    // Suas variáveis de responsividade originais
    @ScaledMetric(relativeTo: .body) var paddingAdaptativo: CGFloat = 24
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    @ScaledMetric(relativeTo: .subheadline) var tamanhoDaBola: CGFloat = 20
    
    // Variáveis que vêm da TelaPrincipal (os inputs globais)
    let valorInvestido: Float
    let tempoDeInvestimento: Int
    let corGrafico: Color
    
    var body: some View {
        VStack(spacing: 0) {
            
            // --- SEÇÃO VERDE (CABEÇALHO) ---
            HStack(alignment: .top) {
                // Puxa o título direto do Enum inteligente!
                Text(viewModel.tipo.tituloPrincipal)
                    .font(.custom("BaiJamjuree-Bold", size: 28, relativeTo: .largeTitle))
                    .foregroundColor(Color.corFonte)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 9) {
                    Text(viewModel.tipo.mediaHistorica)
                        .font(.custom("BaiJamjuree-Bold", size: 16, relativeTo: .title))
                        .foregroundColor(Color.corFonte)
                    
                    Text("Média últimos 12 meses")
                        .font(.custom("BaiJamjuree-Medium", size: 11, relativeTo: .title))
                        .foregroundColor(Color.corFonte.opacity(0.8))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, paddingAdaptativo)
            .padding(.vertical, 12)
            .background(Color.corPrimaria)
            
            // --- SEÇÃO CINZA (CORPO) ---
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.tipo.nomeDoInputPrincipal)
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
                    
                    // 🥈 LAYOUT VERTICAL (Para telas estreitas ou fontes grandes)
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Valor Investido")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                                .fixedSize(horizontal: false, vertical: true)
                            HStack {
                                Text("R$")
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                                
                                Text(valorInvestido, format: .number.notation(.compactName))
                                    .font(.custom("BaiJamjuree-Bold", size: 15, relativeTo: .headline))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tempo")
                                .font(.custom("BaiJamjuree-Medium", size: 13, relativeTo: .subheadline))
                            Text("\(tempoDeInvestimento) anos")
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
                                .fill(corGrafico)
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

// Preview atualizado para a lógica final do MVVM
#Preview {
    let viewModelDeTeste = CardViewModel(tipo: .cdbCdi)
    
    CardView(
        viewModel: viewModelDeTeste,
        valorInvestido: 1000.00,
        tempoDeInvestimento: 3,
        corGrafico: .cyan
    )
    .padding()
}
