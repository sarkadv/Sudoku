/// obtížnost hry
enum Difficulty: String {
    case easy
    case medium
    case hard
    
    public static func fromString(difficultyString: String) -> Difficulty? {
        return Difficulty(rawValue: difficultyString.lowercased())
    }
}

