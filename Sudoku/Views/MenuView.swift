import SwiftUI

/// zobrazení hlavního menu
struct MenuView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    
    /// aktuální sudoku mřížka
    @EnvironmentObject var board: Board
    
    /// orientace zařízení
    @Binding var orientation: UIDeviceOrientation
    
    /// světlé / tmavé barevné schéma
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    var body: some View {
        let spacing: CGFloat = isPhone ? 20.0 : 30.0    // velikost mezery mezi tlačítky
        let imageSize: CGFloat = isPhone ? 200.0 : 400.0    // velikost úvodního obrázku
        let imageName: String = (colorScheme == .dark) ? "sudoku_dark" : "sudoku_light" // úvodní obrázek
        let buttonWidth: CGFloat = isPhone ? 150.0 : 350.0  // šířka tlačítka
        let buttonHeight: CGFloat = isPhone ? 40.0 : 60.0   // výška tlačítka
        let titleFontSize: CGFloat = isPhone ? 30.0 : 50.0  // velikost nadpisu
        
        // barvy tlačítek
        let buttonEasyColor: Color = (colorScheme == .dark) ? COLOR_EASY_DARK : COLOR_EASY_LIGHT
        let buttonMediumColor: Color = (colorScheme == .dark) ? COLOR_MEDIUM_DARK : COLOR_MEDIUM_LIGHT
        let buttonHardColor: Color = (colorScheme == .dark) ? COLOR_HARD_DARK : COLOR_HARD_LIGHT
        let buttonDemoColor: Color = (colorScheme == .dark) ? COLOR_DEMO_DARK : COLOR_DEMO_LIGHT
        let buttonSettingsColor: Color = (colorScheme == .dark) ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT
        
        // landscape mode
        if (orientation.isLandscape) {
            HStack (spacing: spacing * 4) {
                VStack (spacing: 0) {
                    ImageView(imageName: imageName, imageSize: imageSize)
                    
                    TitleView(fontSize: titleFontSize)
                }
                
                VStack (spacing: spacing) {
                    ButtonsView(state: self.$state,
                                difficulty: self.$difficulty,
                                buttonWidth: buttonWidth,
                                buttonHeight: buttonHeight,
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
                
                TitleView(fontSize: titleFontSize)
                
                ButtonsView(state: self.$state,
                            difficulty: self.$difficulty,
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            buttonEasyColor: buttonEasyColor,
                            buttonMediumColor: buttonMediumColor,
                            buttonHardColor: buttonHardColor,
                            buttonDemoColor: buttonDemoColor,
                            buttonSettingsColor: buttonSettingsColor)
            }
        }
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
    
    var body: some View {
        Text("sudoku")
            .padding()
            .font(.system(size: fontSize))
    }
}

/// zobrazení tlačítek v menu
struct ButtonsView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    
    /// šířka tlačítka
    let buttonWidth: CGFloat
    /// výška tlačítka
    let buttonHeight: CGFloat
    
    // barvy tlačítek
    let buttonEasyColor: Color
    let buttonMediumColor: Color
    let buttonHardColor: Color
    let buttonDemoColor: Color
    let buttonSettingsColor: Color
    
    var body: some View {
        Button(action: {
            self.difficulty = .easy
            self.state = .loading
        }) {
            Text("Easy")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonEasyColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // střední obtížnost
        Button(action: {
            self.difficulty = .medium
            self.state = .loading
        }) {
            Text("Medium")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonMediumColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // těžká obtížnost
        Button(action: {
            self.difficulty = .hard
            self.state = .loading
        }) {
            Text("Hard")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonHardColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // demo obtížnost
        Button(action: {
            self.difficulty = .demo
            self.state = .loading
        }) {
            Text("Demo")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonDemoColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        
        // nastavení
        Button(action: {
            self.state = .settings
        }) {
            Text("Settings")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonSettingsColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

