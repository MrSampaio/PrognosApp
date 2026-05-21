//
//  TelaSelecaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI


struct TelaSelecaoView: View {
    
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

                Spacer()
                VStack{
                    ScrollView {
                        
                        LazyVGrid(
                            columns: [
                             GridItem(.adaptive(minimum: 104))
                            ],
                            spacing: 10
                        ) {
                            
                            CardInvestimento(
                                title: "Tesouro",
                                subtitle: "Prefixado",
                                isSelected: selectedCards.contains("Card1")
                            )
                            .onTapGesture {
                                toggleSelection("Card1")
                            }
                            
                            
                            CardInvestimento(
                                title: "Tesouro",
                                subtitle: "Selic",
                                isSelected: selectedCards.contains("Card2")
                            )
                            .onTapGesture {
                                toggleSelection("Card2")
                            }
                            
                            CardInvestimento(
                                title: "Tesouro",
                                subtitle: "Híbrido",
                                isSelected: selectedCards.contains("Card3")
                            )
                            .onTapGesture {
                                toggleSelection("Card3")
                            }
                            CardInvestimento(
                                title: "CDB / LC",
                                subtitle: "Prefixado",
                                isSelected: selectedCards.contains("Card4")
                            )
                            .onTapGesture {
                                toggleSelection("Card4")
                            }
                            CardInvestimento(
                                title: "CDB / LC",
                                subtitle: "Pós-fixado",
                                isSelected: selectedCards.contains("Card5")
                            )
                            .onTapGesture {
                                toggleSelection("Card5")
                            }
                            CardInvestimento(
                                title: "CDB / LC",
                                subtitle: "Híbrido",
                                isSelected: selectedCards.contains("Card6")
                            )
                            .onTapGesture {
                                toggleSelection("Card6")
                            }
                            
                            CardInvestimento(
                                title: "LCI / LCA",
                                subtitle: "Prefixado",
                                isSelected: selectedCards.contains("Card7")
                            )
                            .onTapGesture {
                                toggleSelection("Card7")
                            }
                            CardInvestimento(
                                title: "LCI / LCA",
                                subtitle: "Pós-fixado",
                                isSelected: selectedCards.contains("Card8")
                            )
                            .onTapGesture {
                                toggleSelection("Card8")
                            }
                            CardInvestimento(
                                title: "LCI / LCA",
                                subtitle: "Híbrido",
                                isSelected: selectedCards.contains("Card9")
                            )
                            .onTapGesture {
                                toggleSelection("Card9")
                            }

                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                    }
                }
                
                NavigationLink {
                    
                    TelaInformacoesView()
                    
                } label: {
                    
                    Text("Continuar")
                        .font(.custom("BaiJamJuree-SemiBold", size: 20))
                        .foregroundColor(Color("Fonte"))
                        .frame(width: 215, height: 48)
                        .background(Color("CorSelecionado"))
                        .cornerRadius(30)
                }
                
                
            }
            .padding()
            
        }
        
        
      
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
       
    }


#Preview {
    TelaSelecaoView()
}
