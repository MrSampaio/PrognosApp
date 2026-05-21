//
//  CaixaTexto.swift
//  Prognos
//
//  Created by Leonardo Gonçalves da Silva on 19/05/26.
//
import SwiftUI

struct CaixaTexto: View {
    @Binding var texto: String
    var placeholder: String
    var arredondamento: CGFloat
    var altura: CGFloat
    
    var body: some View {
       
        
        TextField(placeholder, text: $texto,prompt: Text(placeholder).foregroundColor(Color(white: 0.8)))
            .foregroundStyle(Color.white)
            .padding()
            .background(Color.gray)
            .frame(maxWidth: .infinity)
            .frame(height: altura)
            .cornerRadius(arredondamento)
        
    }
}
#Preview {
    CaixaTexto(texto: .constant(""), placeholder: "Digite seu nome", arredondamento: 20, altura: 400)
}
