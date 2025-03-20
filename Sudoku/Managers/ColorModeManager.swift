import SwiftUI

/// správa barevného módu aplikace
class ColorModeManager: ObservableObject {
    /// jedináček
    public static let instance: ColorModeManager = ColorModeManager()
    
    /// aktuální barevný mód aplikace (observable atribut)
    @Published var colorMode: ColorMode
    
    /// barevný mód nastavený v zařízení
    private var deviceColorMode: ColorMode
    
    private init() {
        self.colorMode = .dark
        self.deviceColorMode = .dark
    }
    
    /// Nastaví barevný mód zařízení a aktualizuje observed atribut isDarkMode.
    /// - Parameter deviceColorMode: barevný mód zařízení
    public func setDeviceColorMode(deviceColorMode: ColorMode) {
        self.deviceColorMode = deviceColorMode
        self.colorMode = self.getColorMode()
    }
    
    /// Nastaví barevný mód aplikace v perzistentním úložišti a aktualizuje observable atribut colorMode.
    /// - Parameter mode: vybraný barevný mód aplikace
    public func setColorMode(mode: ColorMode) -> Void {
        StorageManager.instance.setColorMode(mode: mode)
        self.colorMode = self.getColorMode()
    }
    
    /// - Returns: Barevný mód uložený v perzistentním úložišti aplikace.
    public func getStoredColorMode() -> ColorMode {
        return StorageManager.instance.getColorMode()
    }
    
    /// Podle nastavení aplikace a zařízení určí výsledný barevný mód aplikace.
    /// - Returns: barevný mód aplikace
    private func getColorMode() -> ColorMode {
        let colorMode: ColorMode = StorageManager.instance.getColorMode()
        
        if (colorMode == .auto) {
            // podle zařízení
            return self.deviceColorMode == .dark ? .dark : .light
        }
        else {
            // podle nastavení aplikace
            return colorMode
        }
        
    }
    
    // METODY PRO ZÍSKÁNÍ BARVY PRVKŮ UI
    
    public func getBackgroundColor() -> Color {
        switch (self.colorMode) {
            case .dark: return .black
            case .light: return .white
            case .pastel: return COLOR_BACKGROUND_PASTEL
            
            default: return .clear
        }
    }
    
    public func getSudokuImageName() -> String {
        switch (self.colorMode) {
            case .dark: return "sudoku_dark"
            case .light: return "sudoku_light"
            case .pastel: return "sudoku_pastel"
            
            default: return ""
        }
    }
    
    public func getFontColor() -> Color {
        switch (self.colorMode) {
            case .dark: return .white
            case .light: return .black
            case .pastel: return .purple
            
            default: return .clear
        }
    }
    
    public func getButtonColor(type: ButtonType) -> Color {
        switch (type) {
            case .menu:
                switch (self.colorMode) {
                    case .dark: return COLOR_MENU_DARK
                    case .light: return COLOR_MENU_LIGHT
                    case .pastel: return COLOR_MENU_PASTEL
                    
                    default: return .clear
                }
            case .continuing:
                switch (self.colorMode) {
                    case .dark: return BOX_COLOR_1_DARK
                    case .light: return BOX_COLOR_1_LIGHT
                    case .pastel: return BOX_COLOR_1_PASTEL
                    
                    default: return .clear
                }
            case .easy:
                switch (self.colorMode) {
                    case .dark: return COLOR_EASY_DARK
                    case .light: return COLOR_EASY_LIGHT
                    case .pastel: return COLOR_EASY_PASTEL
                    
                    default: return .clear
                }
            case .medium:
                switch (self.colorMode) {
                    case .dark: return COLOR_MEDIUM_DARK
                    case .light: return COLOR_MEDIUM_LIGHT
                    case .pastel: return COLOR_MEDIUM_PASTEL
                    
                    default: return .clear
                }
            
            case .hard:
                switch (self.colorMode) {
                    case .dark: return COLOR_HARD_DARK
                    case .light: return COLOR_HARD_LIGHT
                    case .pastel: return COLOR_HARD_PASTEL
                    
                    default: return .clear
                }
            
            case .demo:
                switch (self.colorMode) {
                    case .dark: return COLOR_DEMO_DARK
                    case .light: return COLOR_DEMO_LIGHT
                    case .pastel: return COLOR_DEMO_PASTEL
                    
                    default: return .clear
                }
            
            case .settings:
                switch (self.colorMode) {
                    case .dark: return COLOR_MENU_DARK
                    case .light: return COLOR_MENU_LIGHT
                    case .pastel: return COLOR_MENU_PASTEL
                    
                    default: return .clear
                }
        }
    }
    
    public func getBorderColor() -> Color {
        switch (self.colorMode) {
            case .dark: return .white
            case .light: return .black
        case .pastel: return .purple
            
            default: return .clear
        }
    }
    
    public func getCellColor(type: Bool) -> Color {
        switch (type) {
            case true:
                switch (self.colorMode) {
                    case .dark: return BOX_COLOR_1_DARK.opacity(0.7)
                    case .light: return BOX_COLOR_1_LIGHT.opacity(0.5)
                    case .pastel: return BOX_COLOR_1_PASTEL.opacity(0.3)
                    
                    default: return .clear
                }
            case false:
                switch (self.colorMode) {
                    case .dark: return BOX_COLOR_2_DARK.opacity(0.7)
                    case .light: return BOX_COLOR_2_LIGHT.opacity(0.5)
                    case .pastel: return BOX_COLOR_2_PASTEL.opacity(0.3)
                    
                    default: return .clear
                }
        }
    }
    
    public func getSelectedCellColor() -> Color {
        switch (self.colorMode) {
            case .dark: return .black
            case .light: return .white
            case .pastel: return .white
            
            default: return .clear
        }
    }
    
    public func getNeighborCellColor() -> Color {
        switch (self.colorMode) {
            case .dark: return BOX_COLOR_NEIGHBOR_DARK.opacity(0.75)
            case .light: return BOX_COLOR_NEIGHBOR_LIGHT.opacity(0.75)
            case .pastel: return BOX_COLOR_NEIGHBOR_PASTEL.opacity(0.6)
            
            default: return .clear
        }
    }
    
    public func getInactiveToolsColor() -> Color {
        switch (self.colorMode) {
            case .dark: return .gray
            case .light: return .gray
            case .pastel: return COLOR_MENU_PASTEL
            
            default: return .clear
        }
    }
    
    public func getWinAnimationFrames() -> [String] {
        switch (self.colorMode) {
            case .dark: return ["trophy_dark_1", "trophy_dark_2"]
            case .light: return ["trophy_light_1", "trophy_light_2"]
            case .pastel: return ["trophy_light_1", "trophy_light_2"]
            
            default: return []
        }
    }

}

