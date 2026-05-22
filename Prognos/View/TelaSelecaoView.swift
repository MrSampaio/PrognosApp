//
//  TelaSelecaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI


struct TelaSelecaoView: View {
    
    @State private var selecionados: [TipoDeInvestimento] = []
    @State private var desabilitarBotoes: Bool = false
    
    let maximoDeSelecao: Int = 2
    
    var paginasDeInvestimento: [[TipoDeInvestimento]] {
            let todos = TipoDeInvestimento.allCases
            let tamanhoDaPagina = 9
            var paginas: [[TipoDeInvestimento]] = []
            
            for i in stride(from: 0, to: todos.count, by: tamanhoDaPagina) {
                let fim = min(i + tamanhoDaPagina, todos.count)
                let pedaco = Array(todos[i..<fim])
                paginas.append(pedaco)
            }
            return paginas
        }
    
    let colunas = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        
        UIPageControl.appearance().currentPageIndicatorTintColor =
        UIColor(Color("CorPrimaria"))
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    
    
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
                        ForEach(0..<paginasDeInvestimento.count, id: \.self) { index in
                            pageGrid(tiposDaPagina: paginasDeInvestimento[index])
                        }
                    }
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .frame(height: 450)
                    
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
    
    
    
    func pageGrid(tiposDaPagina: [TipoDeInvestimento]) -> some View {
        
        let colunas = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: colunas, spacing: 10) {
            
            ForEach(tiposDaPagina) { tipo in

                let selecionado = selecionados.contains(tipo)
                
                let atingiuLimite = selecionados.count == maximoDeSelecao
                
                let deveDesabilitar = atingiuLimite && !selecionado
                
                CardInvestimento(
                            title: tipo.tituloPrincipal,
                            subtitle: tipo.subtitulo,
                            isSelected: selecionado,
                            isDisabled: deveDesabilitar
                        ) .onTapGesture {
                            toggleSelection(tipo)
                        }
                        
                        .disabled(deveDesabilitar)
            }
        }
        .padding(.horizontal, 20)
          .padding(.bottom, 40)
    }
    
    func toggleSelection(_ tipo: TipoDeInvestimento) {
        
        if let index = selecionados.firstIndex(of: tipo) {
            selecionados.remove(at: index)
            
            
        } else if (selecionados.count < maximoDeSelecao){
            selecionados.append(tipo)
        }
    }
}
    


#Preview {
    TelaSelecaoView()
}
