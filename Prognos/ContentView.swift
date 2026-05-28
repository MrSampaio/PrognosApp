import SwiftUI

struct ContentView: View {
    var body: some View {
        // O SwiftUI decide qual "casa" abrir dependendo do aparelho
        #if os(macOS)
            // No Mac, a HomeMacView já possui o seu próprio NavigationStack
            HomeMacView()
        #else
            // No iPhone, iniciamos a HomeView dentro da pilha de navegação
            NavigationStack {
                HomeView()
            }
        #endif
    }
}

#Preview {
    ContentView()
}
