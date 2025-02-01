import SwiftUI

var selectedDifficulty: Difficulty = .easy

struct ContentView: View {
    @State private var state: ViewState = .menu
    
    var body: some View {
        VStack {
            if (state == .menu) {
                MenuView(state: $state)
            }
            else if (state == .game) {
                GameView(state: $state)
            }
        }
    }
}

#Preview {
    ContentView()
}
