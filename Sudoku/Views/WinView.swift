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
    
    var body: some View {
        let padding: CGFloat = isPhone ? 50.0 : 100.0
        let buttonWidth: CGFloat = isPhone ? 125.0 : 300.0  // šířka tlačítka menu
        let buttonHeight: CGFloat = isPhone ? 40.0 : 60.0     // výška tlačítka menu
        let buttonColor: Color = self.colorModeManager.isDarkMode ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT   // barva tlačítka menu
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        let fontColor: Color = self.colorModeManager.isDarkMode ? .white : .black
        
        let currentTimeString = TimeHelper.getTimeString(seconds: self.finalScoreSeconds)
        let bestTimeString = TimeHelper.getTimeString(seconds: StorageManager.instance.getHighscore(difficulty: self.difficulty))
        
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
                .padding(.bottom, padding)
            
            Button(action: {
                self.state = .menu
            }) {
                Text(LocalizedStringKey("menu"))
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(cornerRadius)
            }
        }
    }
}








