import SwiftUI

/// Třída poskytuje perzistentní uložení dat mezi vypnutím a zapnutím aplikace.
class StorageManager {
    private static let INT_INITIALIZER: Int = -1
    private static let STRING_INITIALIZER: String = ""
    private static let DIFFICULTY_INITIALIZER: Difficulty = .easy
    
    @AppStorage("highscoreDemo") private static var highscoreDemo: Int = INT_INITIALIZER
    @AppStorage("highscoreEasy") private static var highscoreEasy: Int = INT_INITIALIZER
    @AppStorage("highscoreMedium") private static var highscoreMedium: Int = INT_INITIALIZER
    @AppStorage("highscoreHard") private static var highscoreHard: Int = INT_INITIALIZER
    
    @AppStorage("continueGameStored") private static var continueGameStored: Bool = false
    @AppStorage("continueGameStarterValues") private static var continueGameStarterValues: String = STRING_INITIALIZER
    @AppStorage("continueGameValue") private static var continueGameValue: String = STRING_INITIALIZER
    @AppStorage("continueGameSolution") private static var continueGameSolution: String = STRING_INITIALIZER
    @AppStorage("continueGameDifficulty") private static var continueGameDifficulty: Difficulty = DIFFICULTY_INITIALIZER
    @AppStorage("continueGameTime") private static var continueGameTime: Int = INT_INITIALIZER
    
    public static func addStoredGame(gameStarterValues: [[Int]], gameValue: [[Int]], gameSolution: [[Int]], difficulty: Difficulty, timeSeconds: Int)
    -> Void {
        StorageManager.continueGameStored = true
        StorageManager.continueGameDifficulty = difficulty
        StorageManager.continueGameTime = timeSeconds
        
        StorageManager.continueGameStarterValues = StringHelper.arrayToString(grid: gameStarterValues)
        StorageManager.continueGameValue = StringHelper.arrayToString(grid: gameValue)
        StorageManager.continueGameSolution = StringHelper.arrayToString(grid: gameSolution)
    }
    
    /// Odstraní z úložiště nedohranou hru, pokud v úložišti je.
    /// - Returns: Void
    public static func removeStoredGame() -> Void {
        if (StorageManager.continueGameStored) {
            StorageManager.continueGameStored = false
            StorageManager.continueGameStarterValues = STRING_INITIALIZER
            StorageManager.continueGameValue = STRING_INITIALIZER
            StorageManager.continueGameSolution = STRING_INITIALIZER
            StorageManager.continueGameDifficulty = DIFFICULTY_INITIALIZER
            StorageManager.continueGameTime = INT_INITIALIZER
        }
    }
    
    public static func getContinueGameStarterValues() -> [[Int]] {
        return StringHelper.stringTo2DArray(gridString: StorageManager.continueGameStarterValues)
    }
    
    public static func getContinueGameValue() -> [[Int]] {
        return StringHelper.stringTo2DArray(gridString: StorageManager.continueGameValue)
    }
    
    public static func getContinueGameSolution() -> [[Int]] {
        return StringHelper.stringTo2DArray(gridString: StorageManager.continueGameSolution)
    }
    
    /// - Returns: true - existuje uložená nedohraná hra / false jinak
    public static func isContinueGameStored() -> Bool {
        return StorageManager.continueGameStored
    }
    
    public static func getContinueGameTime() -> Int {
        return StorageManager.continueGameTime
    }
    
    public static func setContinueGameTime(continueGameTime: Int) -> Void {
        StorageManager.continueGameTime = continueGameTime
    }
    
    public static func getContinueGameDifficulty() -> Difficulty {
        return StorageManager.continueGameDifficulty
    }
    
    public static func setContinueGameDifficulty(continueGameDifficulty: Difficulty) -> Void {
        StorageManager.continueGameDifficulty = continueGameDifficulty
    }
    
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
