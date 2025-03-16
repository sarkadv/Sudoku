import SwiftUI

/// zobrazení vítězné obrazovky
struct WinView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// čas v sekundách poslední dohrané hry
    @Binding var finalScoreSeconds: Int
    
    /// správce barevného módu
    @EnvironmentObject var colorModeManager: ColorModeManager
    
    /// velikost displeje
    @Environment(\.horizontalSizeClass) var sizeClass: UserInterfaceSizeClass?
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    /// orientace zařízení
    @Binding var orientation: UIDeviceOrientation
    
    var body: some View {
        let padding: CGFloat = isPhone ? 50.0 : 100.0
        let buttonWidth: CGFloat = isPhone ? 125.0 : 300.0  // šířka tlačítka menu
        let buttonHeight: CGFloat = isPhone ? 40.0 : 60.0     // výška tlačítka menu
        let buttonColor: Color = self.colorModeManager.isDarkMode ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT   // barva tlačítka menu
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        let fontColor: Color = self.colorModeManager.isDarkMode ? .white : .black
        
        let currentTimeString = TimeHelper.getTimeString(seconds: self.finalScoreSeconds)
        let bestTimeString = TimeHelper.getTimeString(seconds: StorageManager.instance.getHighscore(difficulty: self.difficulty))
        
        if (orientation.isLandscape) {
            // landscape mode
            HStack {
                AnimatedImageView(colorModeManager: self.colorModeManager)
                
                VStack {
                    Text(LocalizedStringKey("you_won"))
                        .font(.headline)
                        .foregroundStyle(fontColor)
                        .padding(padding)
                    
                    (Text(LocalizedStringKey("time")) + Text(": \(currentTimeString)"))
                        .foregroundStyle(fontColor)
                        .padding(.bottom, padding / 2)
                    
                    (Text(LocalizedStringKey("best_time_difficulty"))
                     + Text(" ")
                     + Text(LocalizedStringKey(self.difficulty.toString()))
                     + Text(": \(bestTimeString)"))
                        .foregroundStyle(fontColor)
                        .padding(.bottom, padding / 2)
                    
                    ReturnButton(buttonWidth: buttonWidth,
                                 buttonHeight: buttonHeight,
                                 buttonColor: buttonColor,
                                 cornerRadius: cornerRadius,
                                 setState: self.setState)
                    .padding(.top, padding / 2)
                }
            }
        }
        else {
            // portrait mode
            VStack {
                Text(LocalizedStringKey("you_won"))
                    .font(.headline)
                    .foregroundStyle(fontColor)
                    .padding(.top, padding)
                
                AnimatedImageView(colorModeManager: self.colorModeManager)
                
                (Text(LocalizedStringKey("time")) + Text(": \(currentTimeString)"))
                    .foregroundStyle(fontColor)
                    .padding(.bottom, padding / 2)
                
                (Text(LocalizedStringKey("best_time_difficulty"))
                 + Text(" ")
                 + Text(LocalizedStringKey(self.difficulty.toString()))
                 + Text(": \(bestTimeString)"))
                    .foregroundStyle(fontColor)
                    .padding(.bottom, padding)
                
                ReturnButton(buttonWidth: buttonWidth,
                             buttonHeight: buttonHeight,
                             buttonColor: buttonColor,
                             cornerRadius: cornerRadius,
                             setState: self.setState)
                .padding(.bottom, padding)
            }
        }
    }
    
    private func setState(state: ViewState) -> Void {
        self.state = state
    }
}

/// zobrazení tlačítka pro návrat do menu
struct ReturnButton: View {
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let buttonColor: Color
    let cornerRadius: CGFloat
    
    let setState: (ViewState) -> Void
    
    var body: some View {
        Button(action: {
            self.setState(.menu)
        }) {
            Text(LocalizedStringKey("menu"))
                .font(.headline)
                .padding()
                .frame(width: self.buttonWidth, height: self.buttonHeight)
                .background(self.buttonColor)
                .foregroundColor(.white)
                .cornerRadius(self.cornerRadius)
        }
    }
}

/// zobrazení animovaného obrázku
struct AnimatedImageView: View {
    /// index snímku animace
    @State private var currentFrameIndex: Int = 0
    
    /// počet snímků animace
    private let frameCount: Int = 2
    
    /// rychlost změny snímku v sekundách
    private let timeInterval: TimeInterval = 0.4
    
    /// správce barevného módu
    let colorModeManager: ColorModeManager
    
    var body: some View {
        let frames: [String] = self.colorModeManager.isDarkMode ? ["trophy_dark_1", "trophy_dark_2"] : ["trophy_light_1", "trophy_light_2"]
        
        Image(frames[currentFrameIndex])
            .resizable()
            .scaledToFit()
            .onAppear {
                startAnimation()
            }
    }
    
    /// Nastartuje animaci s daným časovým intervalem.
    private func startAnimation() -> Void {
        Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true) { _ in
            currentFrameIndex = (currentFrameIndex + 1) % self.frameCount
        }
    }
}








