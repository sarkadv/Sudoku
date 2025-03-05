import SwiftUI

/// Třída poskytuje perzistentní uložení dat mezi vypnutím a zapnutím aplikace.
class StorageManager {
    @AppStorage("highscoreDemo") private static var highscoreDemo: Int = Int.max
    @AppStorage("highscoreEasy") private static var highscoreEasy: Int = Int.max
    @AppStorage("highscoreMedium") private static var highscoreMedium: Int = Int.max
    @AppStorage("highscoreHard") private static var highscoreHard: Int = Int.max
    
    public static func getHighscore(difficulty: Difficulty) -> Int {
        switch difficulty {
            case .demo:
                return StorageManager.highscoreDemo
                
            case .easy:
                return StorageManager.highscoreEasy
                
            case .medium:
                return StorageManager.highscoreMedium
                
            case .hard:
                return StorageManager.highscoreHard
        }
    }
    
    /// Uloží čas jako nejlepší skóre, pokud je nižší než akutální nejlepší skóre pro danou obtížnost.
    /// - Parameters:
    ///   - difficulty: obtížnost hry
    ///   - seconds: čas řešení sudoku
    /// - Returns: Void
    public static func setHighscore(difficulty: Difficulty, seconds: Int) -> Void {
        switch difficulty {
            case .demo:
                setHighScoreDemo(seconds: seconds)
                
            case .easy:
                setHighScoreEasy(seconds: seconds)
                
            case .medium:
                setHighScoreMedium(seconds: seconds)
                
            case .hard:
                setHighScoreHard(seconds: seconds)
        }
    }
    
    private static func setHighScoreDemo(seconds: Int) -> Void {
        if seconds < StorageManager.highscoreDemo {
            StorageManager.highscoreDemo = seconds
        }
    }
    
    private static func setHighScoreEasy(seconds: Int) -> Void {
        if seconds < StorageManager.highscoreEasy {
            StorageManager.highscoreEasy = seconds
        }
    }
    
    private static func setHighScoreMedium(seconds: Int) -> Void {
        if seconds < StorageManager.highscoreMedium {
            StorageManager.highscoreMedium = seconds
        }
    }
    
    private static func setHighScoreHard(seconds: Int) -> Void {
        if seconds < StorageManager.highscoreHard {
            StorageManager.highscoreHard = seconds
        }
    }
    
}
