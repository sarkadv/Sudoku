import SwiftUI

/// zobrazení hlavního menu
struct MenuView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// pokračování v minulé nedohrané hře?
    @Binding var continuingGame: Bool
    
    /// aktuální sudoku mřížka
    @EnvironmentObject var board: Board
    
    /// orientace zařízení
    @Binding var orientation: UIDeviceOrientation
    
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    var body: some View {
        let spacing: CGFloat = isPhone ? 20.0 : 30.0    // velikost mezery mezi tlačítky
        let imageSize: CGFloat = isPhone ? 200.0 : 400.0    // velikost úvodního obrázku
        let buttonWidth: CGFloat = isPhone ? 250.0 : 350.0  // šířka tlačítka
        let buttonHeight: CGFloat = isPhone ? 35.0 : 60.0   // výška tlačítka
        let titleFontSize: CGFloat = isPhone ? 30.0 : 50.0  // velikost nadpisu
        
        // landscape mode
        if (orientation.isLandscape) {
            HStack (spacing: spacing * 4) {
                VStack (spacing: 0) {
                    ImageView(imageSize: imageSize)
                    
                    TitleView(fontSize: titleFontSize)
                }
                
                VStack (spacing: spacing) {
                    ButtonsView(setState: self.setState,
                                setDifficulty: self.setDifficulty,
                                setContinuingGame: self.setContinuingGame,
                                newGame: self.newGame,
                                continueGame: self.continueGame,
                                buttonWidth: buttonWidth,
                                buttonHeight: buttonHeight)
                }
            }
        }
        // portait mode
        else {
            VStack (spacing: spacing) {
                ImageView(imageSize: imageSize)
                
                TitleView(fontSize: titleFontSize)
                
                ButtonsView(setState: self.setState,
                            setDifficulty: self.setDifficulty,
                            setContinuingGame: self.setContinuingGame,
                            newGame: self.newGame,
                            continueGame: self.continueGame,
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight)
            }
        }
    }
    
    /// Vygenerování nové hratelné sudoku mřížky
    private func newGame() -> Void {
        self.board.newGame(difficulty: self.difficulty)
        self.state = .game
    }
    
    /// Nastavení mřížky pro pokračování v minulé hře
    private func continueGame() -> Void {
        self.board.continueGame()
        self.state = .game
    }
    
    private func setState(state: ViewState) -> Void {
        self.state = state
    }
    
    private func setDifficulty(difficulty: Difficulty) -> Void {
        self.difficulty = difficulty
    }
    
    private func setContinuingGame(continuingGame: Bool) -> Void {
        self.continuingGame = continuingGame
    }
}

/// zobrazení úvodního obrázku
struct ImageView: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// velikost úvodního obrázku
    let imageSize: CGFloat
    
    var body: some View {
        Image(self.colorModeManager.getSudokuImageName())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize, height: imageSize)
            .padding()
    }
}

/// zobrazení názvu hry
struct TitleView: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    let fontSize: CGFloat
    
    var body: some View {
        Text(LocalizedStringKey("sudoku"))
            .padding()
            .font(.system(size: fontSize))
            .foregroundStyle(self.colorModeManager.getFontColor())
    }
}

/// zobrazení tlačítek v menu
struct ButtonsView: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// callback pro změnu stavu aplikace
    let setState: (ViewState) -> Void
    /// callback pro změnu aktuální obtížnosti hry
    let setDifficulty: (Difficulty) -> Void
    /// callback pro změnu hodnoty pokračování v minulé nedohrané hře
    let setContinuingGame: (Bool) -> Void
    
    /// callback pro vyvolání nové hry
    let newGame: () -> Void
    /// callback pro pokračování ve hře
    let continueGame: () -> Void
    
    /// šířka tlačítka
    let buttonWidth: CGFloat
    /// výška tlačítka
    let buttonHeight: CGFloat
    
    var body: some View {
        if (StorageManager.instance.isContinueGameStored()) {
            Button(action: {
                self.setContinuingGame(true)
                self.setDifficulty(StorageManager.instance.getContinueGameDifficulty())
                self.continueGame()

            }) {
                (Text(LocalizedStringKey(ButtonType.continuing.toString()))
                 + Text(" (")
                 + Text(LocalizedStringKey(StorageManager.instance.getContinueGameDifficulty().toString()))
                 + Text(")"))
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(self.colorModeManager.getButtonColor(type: .continuing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.easy)
            self.newGame()
        }) {
            Text(LocalizedStringKey(ButtonType.easy.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .easy))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // střední obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.medium)
            self.newGame()
        }) {
            Text(LocalizedStringKey(ButtonType.medium.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .medium))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // těžká obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.hard)
            self.newGame()
        }) {
            Text(LocalizedStringKey(ButtonType.hard.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .hard))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // demo obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.demo)
            self.newGame()
        }) {
            Text(LocalizedStringKey(ButtonType.demo.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .demo))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // nastavení
        Button(action: {
            self.setState(.settings)
        }) {
            Text(LocalizedStringKey(ButtonType.settings.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .settings))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

