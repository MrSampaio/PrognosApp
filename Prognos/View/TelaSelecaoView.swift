//
//  TelaSelecaoView.swift
//  Prognos
//
//  Created by Mariana Fracaroli Lopes on 21/05/26.
//

import SwiftUI


struct TelaSelecaoView: View {
    @ScaledMetric(relativeTo: .body)
    var paddingAdaptativo: CGFloat = 20

    @ScaledMetric(relativeTo: .title)
    var espacamentoTitulo: CGFloat = 24

    @ScaledMetric(relativeTo: .body)
    var espacamentoGrid: CGFloat = 10

    @Environment(\.dynamicTypeSize)
    var tipoDeTamanho
    @State private var selecionados: [TipoDeInvestimento] = []
    
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
    
    #if os(iOS)
    
    init() {
        
        UIPageControl.appearance().currentPageIndicatorTintColor =
        UIColor(Color("CorPrimaria"))
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
    #endif
    
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: paddingAdaptativo) {
 
                Text("Selecione os investimentos")
                    .font(.custom("BaiJamjuree-SemiBold", size: 24, relativeTo: .title))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("CorFonteTitulo"))
                   
                                    
                Text("Escolha dois tipos de investimento que você gostaria de comparar")
                    .font(.custom("BaiJamjuree-Medium", size: 16, relativeTo: .subheadline))
                    .lineLimit(nil)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color("CorFonte"))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 24)
                
            #if os(iOS)

                VStack(spacing: paddingAdaptativo){
                    ViewThatFits {
                        
                        TabView {
                            ForEach(0..<paginasDeInvestimento.count, id: \.self) { index in
                                pageGrid(tiposDaPagina: paginasDeInvestimento[index])
                            }
                        }
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: tipoDeTamanho.isAccessibilitySize ? 520 : 430)
                    }
                }
                
                Spacer(minLength: paddingAdaptativo)
                

            #endif
                
            }
            
            
        }
    #if os(iOS)
        .toolbar {
                ToolbarItem(placement: .topBarTrailing) {

                    NavigationLink{
                       TelaInvestimentosView()
                    } label: {

                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 25, weight: .semibold))
                        
                    }
                }
            }

            .toolbarTitleDisplayMode(.inline)
        .padding()
        .frame(maxWidth: .infinity)
        
        #endif
        
        NavigationLink {
            
            TelaInformacoesView(investimentos: selecionados)
            
        } label: {
            
            BotaoView(
                texto: "Continuar",
                habilitado: selecionados.count == maximoDeSelecao
            )
        }
        
        .disabled(selecionados.count != maximoDeSelecao)
       
        
    }
    
    
    func pageGrid(tiposDaPagina: [TipoDeInvestimento]) -> some View {
        
        let colunas = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: colunas, spacing: espacamentoGrid) {
            
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
        .padding(.horizontal, paddingAdaptativo)
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
    NavigationStack{
        TelaSelecaoView()
    }
    
}
