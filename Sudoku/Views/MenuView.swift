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
    @EnvironmentObject var colorModeManager: ColorModeManager
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    var body: some View {
        let spacing: CGFloat = isPhone ? 20.0 : 30.0    // velikost mezery mezi tlačítky
        let imageSize: CGFloat = isPhone ? 200.0 : 400.0    // velikost úvodního obrázku
        let imageName: String = self.colorModeManager.isDarkMode ? "sudoku_dark" : "sudoku_light" // úvodní obrázek
        let buttonWidth: CGFloat = isPhone ? 250.0 : 350.0  // šířka tlačítka
        let buttonHeight: CGFloat = isPhone ? 35.0 : 60.0   // výška tlačítka
        let titleFontSize: CGFloat = isPhone ? 30.0 : 50.0  // velikost nadpisu
        let fontColor: Color = self.colorModeManager.isDarkMode ? .white : .black   // barva fontu
        
        // barvy tlačítek
        let buttonContinueColor: Color = self.colorModeManager.isDarkMode ? BOX_COLOR_PURPLE_DARK : BOX_COLOR_PURPLE_LIGHT
        let buttonEasyColor: Color = self.colorModeManager.isDarkMode ? COLOR_EASY_DARK : COLOR_EASY_LIGHT
        let buttonMediumColor: Color = self.colorModeManager.isDarkMode ? COLOR_MEDIUM_DARK : COLOR_MEDIUM_LIGHT
        let buttonHardColor: Color = self.colorModeManager.isDarkMode ? COLOR_HARD_DARK : COLOR_HARD_LIGHT
        let buttonDemoColor: Color = self.colorModeManager.isDarkMode ? COLOR_DEMO_DARK : COLOR_DEMO_LIGHT
        let buttonSettingsColor: Color = self.colorModeManager.isDarkMode ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT
        
        // landscape mode
        if (orientation.isLandscape) {
            HStack (spacing: spacing * 4) {
                VStack (spacing: 0) {
                    ImageView(imageName: imageName, imageSize: imageSize)
                    
                    TitleView(fontSize: titleFontSize, fontColor: fontColor)
                }
                
                VStack (spacing: spacing) {
                    ButtonsView(setState: self.setState,
                                setDifficulty: self.setDifficulty,
                                setContinuingGame: self.setContinuingGame,
                                newGame: self.newGame,
                                continueGame: self.continueGame,
                                buttonWidth: buttonWidth,
                                buttonHeight: buttonHeight,
                                buttonContinueColor: buttonContinueColor,
                                buttonEasyColor: buttonEasyColor,
                                buttonMediumColor: buttonMediumColor,
                                buttonHardColor: buttonHardColor,
                                buttonDemoColor: buttonDemoColor,
                                buttonSettingsColor: buttonSettingsColor)
                }
            }
        }
        // portait mode
        else {
            VStack (spacing: spacing) {
                ImageView(imageName: imageName, imageSize: imageSize)
                
                TitleView(fontSize: titleFontSize, fontColor: fontColor)
                
                ButtonsView(setState: self.setState,
                            setDifficulty: self.setDifficulty,
                            setContinuingGame: self.setContinuingGame,
                            newGame: self.newGame,
                            continueGame: self.continueGame,
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            buttonContinueColor: buttonContinueColor,
                            buttonEasyColor: buttonEasyColor,
                            buttonMediumColor: buttonMediumColor,
                            buttonHardColor: buttonHardColor,
                            buttonDemoColor: buttonDemoColor,
                            buttonSettingsColor: buttonSettingsColor)
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
    /// název úvodního obrázku
    let imageName: String
    /// velikost úvodního obrázku
    let imageSize: CGFloat
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imageSize, height: imageSize)
            .padding()
    }
}

/// zobrazení názvu hry
struct TitleView: View {
    let fontSize: CGFloat
    let fontColor: Color
    
    var body: some View {
        Text(LocalizedStringKey("sudoku"))
            .padding()
            .font(.system(size: fontSize))
            .foregroundStyle(fontColor)
    }
}

/// zobrazení tlačítek v menu
struct ButtonsView: View {
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
    
    // barvy tlačítek
    let buttonContinueColor: Color
    let buttonEasyColor: Color
    let buttonMediumColor: Color
    let buttonHardColor: Color
    let buttonDemoColor: Color
    let buttonSettingsColor: Color
    
    var body: some View {
        if (StorageManager.instance.isContinueGameStored()) {
            Button(action: {
                self.setContinuingGame(true)
                self.setDifficulty(StorageManager.instance.getContinueGameDifficulty())
                self.continueGame()

            }) {
                (Text(LocalizedStringKey("continue"))
                 + Text(" (")
                 + Text(LocalizedStringKey(StorageManager.instance.getContinueGameDifficulty().toString()))
                 + Text(")"))
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(buttonContinueColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.easy)
            self.newGame()
        }) {
            Text(LocalizedStringKey("easy"))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonEasyColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // střední obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.medium)
            self.newGame()
        }) {
            Text(LocalizedStringKey("medium"))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonMediumColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // těžká obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.hard)
            self.newGame()
        }) {
            Text(LocalizedStringKey("hard"))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonHardColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // demo obtížnost
        Button(action: {
            self.setContinuingGame(false)
            self.setDifficulty(.demo)
            self.newGame()
        }) {
            Text(LocalizedStringKey("demo"))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonDemoColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // nastavení
        Button(action: {
            self.setState(.settings)
        }) {
            Text(LocalizedStringKey("settings"))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonSettingsColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

