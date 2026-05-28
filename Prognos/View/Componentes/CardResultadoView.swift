import SwiftUI

struct CardResultadoView: View {
    
    // MARK: - MÉTRICAS RESPONSIVAS
    @ScaledMetric(relativeTo: .title) var tamanhoIcone: CGFloat = 36
    @ScaledMetric(relativeTo: .body) var paddingCard: CGFloat = 24
    
    @Environment(\.dynamicTypeSize) var tipoDeTamanho
    
    let titulo: String
    let lucroLiquido: Double
    let eOMelhor: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 1. HEADER RESPONSIVO (Usa ViewThatFits para evitar quebrar o texto)
            ViewThatFits {
                // Layout Padrão: Ícone e Título Lado a Lado
                HStack(spacing: 12) {
                    iconeStatus
                    tituloPrincipal
                }
                
                // Layout de Acessibilidade: Ícone em cima, Título embaixo
                VStack(alignment: .leading, spacing: 8) {
                    iconeStatus
                    tituloPrincipal
                }
            }
            
            // 2. CORPO (Lucro Líquido)
            Text("Lucro Líquido: R$ \(lucroLiquido, format: .number.precision(.fractionLength(2)))")
                .font(.custom("BaiJamjuree-Medium", size: 18, relativeTo: .body))
                .foregroundStyle(Color("CorFonte").opacity(0.8))
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                // Garante que o texto possa crescer verticalmente se for muito grande
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(paddingCard)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CorCaixas"))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        
        // MARK: - ACESSIBILIDADE (VoiceOver)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(eOMelhor ? "Melhor rendimento: \(titulo)." : "Resultado em atenção: \(titulo).")
        .accessibilityValue("Lucro líquido de R$ \(lucroLiquido, format: .number.precision(.fractionLength(2))).")
    }
    
    // MARK: - COMPONENTES REUTILIZÁVEIS
    private var iconeStatus: some View {
        ZStack {
            Circle()
                .fill(eOMelhor ? Color.green : Color.red)
                .frame(width: tamanhoIcone, height: tamanhoIcone)
            
            Image(systemName: eOMelhor ? "checkmark" : "exclamationmark")
                .font(.system(size: tamanhoIcone * 0.5, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    private var tituloPrincipal: some View {
        Text(titulo)
            .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title2))
            .foregroundStyle(Color("CorFonte"))
            .lineLimit(nil) // Libera o limite de linhas se a fonte for muito grande
            .minimumScaleFactor(0.8)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - PREVIEW
#Preview {
    VStack(spacing: 40) {
        CardResultadoView(
            titulo: "Debênt. Pós",
            lucroLiquido: 1250.50,
            eOMelhor: true
        )
        
        CardResultadoView(
            titulo: "Debênt. Pré",
            lucroLiquido: 890.20,
            eOMelhor: false
        )
    }
    .padding()
    .background(Color.black)
}
