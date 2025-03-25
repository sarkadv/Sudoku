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
    
    /// pro nastavení colorModeManager
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// aplikace v popředí / pozadí
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    /// správce jazyka aplikace
    @StateObject var languageManager = LanguageManager.instance
    
    /// správce barevného módu
    @StateObject var colorModeManager = ColorModeManager.instance
    
    /// orientace zařízení
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var body: some View {
        ZStack {
            // barva pozadí podle barevného módu
            self.colorModeManager.getBackgroundColor().ignoresSafeArea()
            
            VStack {
                // výběr okna podle stavu aplikace
                if (state == .menu) {
                    MenuView(state: $state, difficulty: $difficulty, continuingGame: $continuingGame, orientation: $orientation)
                        .environmentObject(board)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .game) {
                    GameView(state: $state, difficulty: $difficulty, continuingGame: $continuingGame, finalScoreSeconds: $finalScoreSeconds, orientation: $orientation)
                        .environmentObject(board)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .win) {
                    WinView(state: $state, difficulty: $difficulty, finalScoreSeconds: $finalScoreSeconds, orientation: $orientation)
                        .environment(\.locale, languageManager.locale)
                }
                else if (state == .settings) {
                    SettingsView(state: $state)
                        .environment(\.locale, languageManager.locale)
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
            .onChange(of: scenePhase) { oldPhase, newPhase in
                updateOrientation()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                // při změně orientace update orientace zařízení
                updateOrientation()
            }
        }
    }
    
    /// Provede update aktuální orientace zařízení.
    private func updateOrientation() -> Void {
        let currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        // některé orientace ignorovány
        if (currentOrientation == .faceUp ||
            currentOrientation == .faceDown) {
            return
        }
        
        // poloha vzhůru nohama u iPhonu ignorována, u iPadu změněna
        if (currentOrientation == .portraitUpsideDown) {
            if (self.isPhone) {
                return
            }
            else {
                self.orientation = .portrait
                return
            }
        }
        
        self.orientation = currentOrientation
    }
    
    private func updateDeviceColorMode() -> Void {
        self.colorModeManager.setDeviceColorMode(deviceColorMode: self.colorScheme == .dark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
