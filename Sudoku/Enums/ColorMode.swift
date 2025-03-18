/// barevný mód aplikace
enum ColorMode: String, CaseIterable {
    case auto   // dle nastavení zařízení
    case dark
    case light
    case pastel
    
    public func toString() -> String {
        return rawValue
    }

}
