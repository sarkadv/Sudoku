import SwiftUI

/// hlavní okno hry
struct ContentView: View {
    /// stav aplikace
    @State private var state: ViewState = .menu
    /// aktuální obtížnost hry
    @State private var difficulty: Difficulty = .easy
    /// aktuální sudoku mřížka
    @State private var board: Board? = nil
    
    var body: some View {
        VStack {
            // výběr okna podle stavu aplikace
            if (state == .menu) {
                MenuView(state: $state, difficulty: $difficulty, board: $board)
            }
            else if (state == .loading) {
                LoadingView(state: $state, difficulty: $difficulty, board: $board)
            }
            else if (state == .game) {
                GameView(state: $state, difficulty: $difficulty, board: $board)
            }
        }
    }
}

#Preview {
    ContentView()
}
