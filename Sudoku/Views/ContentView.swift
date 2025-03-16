import SwiftUI

/// hlavní okno hry
struct ContentView: View {
    /// stav aplikace
    @State private var state: ViewState = .menu
    /// aktuální obtížnost hry
    @State private var difficulty: Difficulty = .easy
    /// aktuální sudoku mřížka - observable object
    @StateObject private var board: Board = Board()
    /// pokračování v minulé nedohrané hře?
    @State private var continuingGame: Bool = false
    /// čas v sekundách poslední dohrané hry
    @State private var finalScoreSeconds: Int = 0
    
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager()
    /// pro nastavení colorModeManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// správce jazyka aplikace
    @StateObject var languageManager = LanguageManager()
    
    /// orientace zařízení
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        ZStack {
            // barva pozadí podle barevného módu
            if (self.colorModeManager.isDarkMode) {
                Color.black.ignoresSafeArea()
            }
            else {
                Color.white.ignoresSafeArea()
            }
            
            VStack {
                // výběr okna podle stavu aplikace
                if (state == .menu) {
                    MenuView(state: $state, difficulty: $difficulty, continuingGame: $continuingGame, orientation: $orientation)
                        .environmentObject(board)
                        .environmentObject(colorModeManager)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .game) {
                    GameView(state: $state, difficulty: $difficulty, continuingGame: $continuingGame, finalScoreSeconds: $finalScoreSeconds, orientation: $orientation)
                        .environmentObject(board)
                        .environmentObject(colorModeManager)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .win) {
                    WinView(state: $state, difficulty: $difficulty, finalScoreSeconds: $finalScoreSeconds, orientation: $orientation)
                        .environmentObject(colorModeManager)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .settings) {
                    SettingsView(state: $state)
                        .environmentObject(colorModeManager)
                        .environment(\.locale, languageManager.locale)
                        .environmentObject(languageManager)
                }
            }
            .onAppear {
                // při zobrazení update orientace zařízení
                updateOrientation()
                
                // určení barevného módu
                updateDeviceColorMode()
            }
            .onChange(of: colorScheme) {
                updateDeviceColorMode()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                // při změně orientace update orientace zařízení
                updateOrientation()
            }
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
    
    private func updateDeviceColorMode() {
        self.colorModeManager.setDeviceColorMode(deviceColorMode: self.colorScheme == .dark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
