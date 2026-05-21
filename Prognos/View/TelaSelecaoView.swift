//
//  TelaSelecaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI


struct TelaSelecaoView: View {
    init() {
        
        UIPageControl.appearance().currentPageIndicatorTintColor =
        UIColor(Color("CorPrimaria"))
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    @State private var selectedCards: [String] = []
    let maxSelection = 2
    
    var body: some View {
        
        ZStack {
            VStack {
                Text("Selecione os investimentos")
                    .font(.custom("BaiJamjuree-SemiBold", size: 24))
                    .foregroundColor(Color("CorFonteTitulo"))
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.vertical, 5)
                Text("Escolha dois tipos de investimento que você gostaria de comparar")
                    .font(.custom("BaiJamjuree-Medium", size: 16))
                    .foregroundColor(Color("CorFonte"))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 24)
                
                HStack {
                    Spacer()
                    Image("Duvidas")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                    // .foregroundStyle(Color("CorCaixa2"))
                    
                }
                VStack{
                    TabView {
                        
                        
                        pageGrid(cards: [
                            ("Tesouro", "Prefixado", "Card1"),
                            ("Tesouro", "Selic", "Card2"),
                            ("Tesouro", "Híbrido", "Card3"),
                            ("CDB / LC", "Prefixado", "Card4"),
                            ("CDB / LC", "Pós-fixado", "Card5"),
                            ("CDB / LC", "Híbrido", "Card6"),
                            ("LCI / LCA", "Prefixado", "Card7"),
                            ("LCI / LCA", "Pós-fixado", "Card8"),
                            ("LCI / LCA", "Híbrido", "Card9")
                        ])
                        
                        
                        
                        pageGrid(cards: [
                            ("Debênture", "Prefixado", "Card10"),
                            ("Debênture", "Pós-fixado", "Card11"),
                            ("Debênture", "Híbrido", "Card12"),
                            ("CRI / CRA", "Prefixado", "Card13"),
                            ("CRI / CRA", "Pós-fixado", "Card14"),
                            ("CRI / CRA", "Híbrido", "Card15"),
                            ("Fundo", "Renda fixa", "Card16"),
                            
                        ])
                    }
                    
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 430)
                }
                
                Spacer()
                    .frame(height: 40)
                
                NavigationLink {
                    
                    TelaInformacoesView()
                    
                } label: {
                    
                    BotaoView(
                        texto: "Continuar"
                    )
                }
                
            }
            
        }
        .padding()
        
    }
    
    
    
    
    
    func toggleSelection(_ card: String) {
        
        if selectedCards.contains(card) {
            
            selectedCards.removeAll {
                $0 == card
            }
            
        } else {
            
            if selectedCards.count < maxSelection {
                
                selectedCards.append(card)
            }
        }
    }
    
    func pageGrid(cards: [(String, String, String)]) -> some View {
        
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 104))
            ],
            spacing: 10
        ) {
            
            ForEach(cards, id: \.2) { card in
                
                CardInvestimento(
                    title: card.0,
                    subtitle: card.1,
                    isSelected: selectedCards.contains(card.2)
                )
                .onTapGesture {
                    toggleSelection(card.2)
                }
            }
        }
        .padding(.horizontal, 20)
          .padding(.bottom, 40)
    }
}
    


#Preview {
    TelaSelecaoView()
}
