import SwiftUI

/// hlavní okno hry
struct ContentView: View {
    /// stav aplikace
    @State private var state: ViewState = .menu
    /// aktuální obtížnost hry
    @State private var difficulty: Difficulty = .easy
    /// aktuální sudoku mřížka - observable object
    @StateObject private var board: Board = Board()
    /// čas v sekundách poslední dohrané hry
    @State private var finalScoreSeconds: Int = 0
    
    /// orientace zařízení
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        VStack {
            // výběr okna podle stavu aplikace
            if (state == .menu) {
                MenuView(state: $state, difficulty: $difficulty, orientation: $orientation)
                    .environmentObject(board)
            }
            
            else if (state == .loading) {
                LoadingView(state: $state, difficulty: $difficulty)
                    .environmentObject(board)
            }
            else if (state == .game) {
                GameView(state: $state, difficulty: $difficulty, finalScoreSeconds: $finalScoreSeconds, orientation: $orientation)
                    .environmentObject(board)
            }
            else if (state == .win) {
                WinView(state: $state, difficulty: $difficulty, finalScoreSeconds: $finalScoreSeconds)
            }
        }
        .onAppear {
            // při zobrazení update orientace zařízení
            updateOrientation()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // při změně orientace update orientace zařízení
            updateOrientation()
        }
    }
    
    /// Provede update aktuální orientace zařízení.
    private func updateOrientation() {
        let currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        // některé orientace ignorovány
        if (currentOrientation == .portraitUpsideDown ||
            currentOrientation == .faceUp ||
            currentOrientation == .faceDown) {
            return
        }
        
        self.orientation = currentOrientation
    }
}

#Preview {
    ContentView()
}
