/// barevný mód aplikace
enum ColorMode: String, CaseIterable {
    case auto   // dle nastavení zařízení
    case dark
    case light
    
    public func toString() -> String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

}
