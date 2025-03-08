/// jazyk aplikace pro lokalizaci
enum Language: String, CaseIterable {
    case english
    case czech
    
    public func toString() -> String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

}
