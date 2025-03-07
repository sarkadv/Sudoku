/// obtížnost hry
enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
    case demo
    
    public func toString() -> String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
    
    public static func fromString(difficultyString: String) -> Difficulty? {
        return Difficulty(rawValue: difficultyString.lowercased())
    }

}

