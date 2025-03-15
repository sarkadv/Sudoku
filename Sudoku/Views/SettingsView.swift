import SwiftUI

/// zobrazení nastavení
struct SettingsView: View {
    /// stav aplikace
    @Binding var state: ViewState
    
    /// správce barevného módu
    @EnvironmentObject var colorModeManager: ColorModeManager
    
    /// správce jazyka aplikace
    @EnvironmentObject var languageManager: LanguageManager

    /// velikost displeje
    @Environment(\.horizontalSizeClass) var sizeClass: UserInterfaceSizeClass?
    
    /// vybrané barevné schéma
    @State private var selectedColorMode: ColorMode = StorageManager.instance.getColorMode()
    
    /// vybraný jazyk aplikace
    @State private var selectedLanguage: Language = StorageManager.instance.getLanguage()
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    private let CIRCLE_IMAGE_FILLED_NAME: String = "largecircle.fill.circle"
    
    private let CIRCLE_IMAGE_UNFILLED_NAME: String = "circle"
    
    var body: some View {
        let optionPadding: CGFloat = isPhone ? 5.0 : 7.0     // padding mezi možnostmi
        let buttonPadding: CGFloat = isPhone ? 50.0 : 100.0     // padding tlačtítka
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        let buttonWidth: CGFloat = isPhone ? 125.0 : 300.0  // šířka tlačítka menu
        let buttonHeight: CGFloat = isPhone ? 40.0 : 60.0     // výška tlačítka menu
        let buttonColor: Color = self.colorModeManager.isDarkMode ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT   // barva tlačítka menu
        let fontColor: Color = self.colorModeManager.isDarkMode ? .white : .black
        
        VStack {
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
            .padding(buttonPadding)
            
            VStack {
                (Text(LocalizedStringKey("color_mode")) + Text(":"))
                    .font(.headline)
                    .foregroundStyle(fontColor)

                ForEach(ColorMode.allCases, id: \.self) { mode in
                    let circleImageName: String = selectedColorMode == mode ? CIRCLE_IMAGE_FILLED_NAME : CIRCLE_IMAGE_UNFILLED_NAME
                    
                    HStack {
                        Image(systemName: circleImageName)
                            .foregroundStyle(.gray)
                        
                        Text(LocalizedStringKey(mode.toString()))
                            .foregroundStyle(fontColor)
                    }
                    .onTapGesture {
                        self.setSelectedColorMode(mode: mode)
                    }
                    .padding(optionPadding)
                }
            }
            .padding()
            
            VStack {
                (Text(LocalizedStringKey("language")) + Text(":"))
                    .font(.headline)
                    .foregroundStyle(fontColor)

                ForEach(Language.allCases, id: \.self) { language in
                    let circleImageName: String = selectedLanguage == language ? CIRCLE_IMAGE_FILLED_NAME : CIRCLE_IMAGE_UNFILLED_NAME
                    
                    HStack {
                        Image(systemName: circleImageName)
                            .foregroundStyle(.gray)
                        
                        Text(LocalizedStringKey(language.toString()))
                            .foregroundStyle(fontColor)
                    }
                    .onTapGesture {
                        self.setSelectedLanguage(language: language)
                    }
                    .padding(optionPadding)
                }
            }
            .padding()
        }
    }
    
    private func setSelectedColorMode(mode: ColorMode) -> Void {
        self.selectedColorMode = mode
        self.colorModeManager.setColorMode(mode: mode)
    }
    
    private func setSelectedLanguage(language: Language) -> Void {
        self.selectedLanguage = language
        self.languageManager.setLocale(language: language)
    }
}







