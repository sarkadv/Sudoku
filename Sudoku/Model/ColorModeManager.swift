import SwiftUI

/// správa barevného módu aplikace
class ColorModeManager: ObservableObject {
    /// má aplikace být zobrazena v tmavém módu? (observed atribut)
    @Published var isDarkMode: Bool
    
    /// barevný mód nastavený v zařízení
    private var deviceColorMode: ColorMode
    
    init() {
        self.isDarkMode = true
        self.deviceColorMode = .dark
    }
    
    /// Nastaví barevný mód zařízení a aktualizuje observed atribut isDarkMode.
    /// - Parameter deviceColorMode: barevný mód zařízení
    public func setDeviceColorMode(deviceColorMode: ColorMode) {
        self.deviceColorMode = deviceColorMode
        self.isDarkMode = self.getColorMode() == .dark
    }
    
    /// Nastaví barevný mód aplikace v perzistentním úložišti a aktualizuje observed atribut isDarkMode.
    /// - Parameter mode: vybraný barevný mód aplikace
    public func setColorMode(mode: ColorMode) -> Void {
        StorageManager.setColorMode(mode: mode)
        self.isDarkMode = getColorMode() == .dark
    }
    
    public func getStoredColorMode() -> ColorMode {
        return StorageManager.getColorMode()
    }
    
    /// Podle nastavení aplikace a zařízení určí výsledný barevný mód aplikace.
    /// - Returns: barevný mód aplikace
    private func getColorMode() -> ColorMode {
        let colorMode: ColorMode = StorageManager.getColorMode()
        
        if (colorMode == .auto) {
            // podle zařízení
            return self.deviceColorMode == .dark ? .dark : .light
        }
        else {
            // podle nastavení aplikace
            return colorMode
        }
        
    }

}

