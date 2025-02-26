/// obtížnost hry
enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard
    case demo
    
    public static func fromString(difficultyString: String) -> Difficulty? {
        return Difficulty(rawValue: difficultyString.lowercased())
    }
}

