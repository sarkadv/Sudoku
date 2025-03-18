enum ButtonType: String {
    case menu
    case continuing
    case easy
    case medium
    case hard
    case demo
    case settings
    
    public func toString() -> String {
        return rawValue
    }
}

