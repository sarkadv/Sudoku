import SwiftUI

/// Třída poskytuje perzistentní uložení dat mezi vypnutím a zapnutím aplikace.
class StorageManager {
    private static let INT_INITIALIZER: Int = Int.max
    private static let STRING_INITIALIZER: String = ""
    private static let DIFFICULTY_INITIALIZER: Difficulty = .easy
    private static let COLOR_MODE_INITIALIZER: ColorMode = .auto
    private static let LANGUAGE_INITIALIZER: Language = .english
    
    // nejnižší čas v sekundách pro každou obtížnost
    @AppStorage("highscoreDemo") private static var highscoreDemo: Int = INT_INITIALIZER
    @AppStorage("highscoreEasy") private static var highscoreEasy: Int = INT_INITIALIZER
    @AppStorage("highscoreMedium") private static var highscoreMedium: Int = INT_INITIALIZER
    @AppStorage("highscoreHard") private static var highscoreHard: Int = INT_INITIALIZER
    
    // údaje o uložené nedohrané hře
    @AppStorage("continueGameStored") private static var continueGameStored: Bool = false   // je uložená nedohraná hra?
    @AppStorage("continueGameStarterValues") private static var continueGameStarterValues: String = STRING_INITIALIZER  // počáteční hodnoty buněk
    @AppStorage("continueGameValue") private static var continueGameValue: String = STRING_INITIALIZER  // aktuální hodnoty buněk
    @AppStorage("continueGameSolution") private static var continueGameSolution: String = STRING_INITIALIZER    // řešení buněk
    @AppStorage("continueGameCandidates") private static var continueGameCandidates: String = STRING_INITIALIZER    // kandidáti všech buněk
    @AppStorage("continueGameDifficulty") private static var continueGameDifficulty: Difficulty = DIFFICULTY_INITIALIZER    // obtížnost
    @AppStorage("continueGameTime") private static var continueGameTime: Int = INT_INITIALIZER  // uplynulý čas v sekundách
    
    // uživatelské nastavení
    @AppStorage("colorMode") private static var colorMode: ColorMode = COLOR_MODE_INITIALIZER
    @AppStorage("language") private static var language: Language = LANGUAGE_INITIALIZER
    
    public static func setColorMode(mode: ColorMode) -> Void {
        StorageManager.colorMode = mode
    }
    
    public static func getColorMode() -> ColorMode {
        return StorageManager.colorMode
    }
    
    public static func setLanguage(language: Language) -> Void {
        StorageManager.language = language
    }
    
    public static func getLanguage() -> Language {
        return StorageManager.language
    }
    
    /// Uloží do perzistentního úložiště nedohranou hru.
    /// - Parameters:
    ///   - gameStarterValues: počáteční hodnoty buněk
    ///   - gameValue: aktuální hodnoty buněk
    ///   - gameSolution: řešení buněk
    ///   - candidates: kandidáti všech buněk
    ///   - difficulty: obtížnost
    ///   - timeSeconds: uplynulý čas v sekundách
    public static func addStoredGame(gameStarterValues: [[Int]], gameValue: [[Int]], gameSolution: [[Int]], candidates: [[[Int]]], difficulty: Difficulty, timeSeconds: Int)
    -> Void {
        StorageManager.continueGameStored = true
        StorageManager.continueGameDifficulty = difficulty
        StorageManager.continueGameTime = timeSeconds
        
        StorageManager.continueGameStarterValues = StringHelper.arrayToString(grid: gameStarterValues)
        StorageManager.continueGameValue = StringHelper.arrayToString(grid: gameValue)
        StorageManager.continueGameSolution = StringHelper.arrayToString(grid: gameSolution)
        
        StorageManager.continueGameCandidates = StringHelper.candidatesToString(candidates: candidates)
    }
    
    /// Odstraní z úložiště nedohranou hru, pokud v úložišti je.
    public static func removeStoredGame() -> Void {
        if (StorageManager.continueGameStored) {
            StorageManager.continueGameStored = false
            StorageManager.continueGameStarterValues = STRING_INITIALIZER
            StorageManager.continueGameValue = STRING_INITIALIZER
            StorageManager.continueGameSolution = STRING_INITIALIZER
            StorageManager.continueGameCandidates = STRING_INITIALIZER
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
    
    public static func getContinueGameCandidates() -> [[[Int]]] {
        return StringHelper.stringTo3DArray(candidatesString: StorageManager.continueGameCandidates)
    }
    
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
    
    /// - Parameter difficulty: obtížnost hry
    /// - Returns: nejnižší čas v sekundách podle obtížnosti
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
