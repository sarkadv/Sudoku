import SwiftUI

/// zobrazení loading baru
struct LoadingView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// aktuální sudoku mřížka
    @Binding var board: Board?
    
    /// světlé / tmavé barevné schéma
    @Environment(\.colorScheme) var colorScheme
    /// velikost displeje
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        let loadingBarColor: Color = (colorScheme == .dark) ? .white : .black  // barva loading baru
        
        VStack {
            Text("Loading...")
                .font(.headline)
                .padding()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: loadingBarColor))
                .scaleEffect(2)
                .padding()
        }
        .onAppear {
            // při zobrazení loading baru se začne ve vlastním vlákně generovat sudoku mřížka
            Task {
                await self.generate()
            }
        }
        
    }
    
    /// Asynchronní vygenerování sudoku mřížky
    /// - Returns: Void
    func generate() async -> Void {
        self.board = Board(difficulty: self.difficulty)
        self.state = .game
    }
}






