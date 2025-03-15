/// audio na pozadí
enum AudioType: String, CaseIterable {
    case forest
    case ocean
    case rain
    case river
    
    public func toString() -> String {
        return rawValue
    }

}

