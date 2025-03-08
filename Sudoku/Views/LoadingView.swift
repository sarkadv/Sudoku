import SwiftUI

/// zobrazení loading baru
struct LoadingView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// pokračování v minulé nedohrané hře?
    @Binding var continuingGame: Bool
    /// aktuální sudoku mřížka
    @EnvironmentObject var board: Board
    
    /// správce barevného módu
    @EnvironmentObject var colorModeManager: ColorModeManager
    
    /// velikost displeje
    @Environment(\.horizontalSizeClass) var sizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let fontColor: Color = self.colorModeManager.isDarkMode ? .white : .black  // barva fontu
        
        VStack {
            Text("Loading...")
                .font(.headline)
                .foregroundStyle(fontColor)
                .padding()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: fontColor))
                .scaleEffect(2)
                .padding()
        }
        .onAppear {
            if (!self.continuingGame) {
                // při zobrazení loading baru se začne ve vlastním vlákně generovat sudoku mřížka
                Task {
                    await self.generate()
                }
            }
            else {
                self.continueGame()
            }
        }
        
    }
    
    /// Asynchronní vygenerování sudoku mřížky
    /// - Returns: Void
    private func generate() async -> Void {
        await self.board.generate(difficulty: self.difficulty)
        self.state = .game
    }
    
    /// Nastavení mřížky pro pokračování v minulé hře
    /// - Returns: Void
    private func continueGame() -> Void {
        self.board.continueGame()
        self.state = .game
    }
}






