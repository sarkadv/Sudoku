import SwiftUI

/// Třída poskytuje perzistentní uložení dat mezi vypnutím a zapnutím aplikace.
class StorageManager {
    /// jedináček
    public static var instance = StorageManager()
    
    private static let INT_INITIALIZER: Int = Int.max
    private static let STRING_INITIALIZER: String = ""
    private static let DIFFICULTY_INITIALIZER: Difficulty = .easy
    private static let COLOR_MODE_INITIALIZER: ColorMode = .auto
    private static let LANGUAGE_INITIALIZER: Language = .english
    
    // nejnižší čas v sekundách pro každou obtížnost
    @AppStorage("highscoreDemo") private var highscoreDemo: Int = INT_INITIALIZER
    @AppStorage("highscoreEasy") private var highscoreEasy: Int = INT_INITIALIZER
    @AppStorage("highscoreMedium") private var highscoreMedium: Int = INT_INITIALIZER
    @AppStorage("highscoreHard") private var highscoreHard: Int = INT_INITIALIZER
    
    // údaje o uložené nedohrané hře
    @AppStorage("continueGameStored") private var continueGameStored: Bool = false   // je uložená nedohraná hra?
    @AppStorage("continueGameStarterValues") private var continueGameStarterValues: String = STRING_INITIALIZER  // počáteční hodnoty buněk
    @AppStorage("continueGameValue") private var continueGameValue: String = STRING_INITIALIZER  // aktuální hodnoty buněk
    @AppStorage("continueGameSolution") private var continueGameSolution: String = STRING_INITIALIZER    // řešení buněk
    @AppStorage("continueGameCandidates") private var continueGameCandidates: String = STRING_INITIALIZER    // kandidáti všech buněk
    @AppStorage("continueGameDifficulty") private var continueGameDifficulty: Difficulty = DIFFICULTY_INITIALIZER    // obtížnost
    @AppStorage("continueGameTime") private var continueGameTime: Int = INT_INITIALIZER  // uplynulý čas v sekundách
    
    // uživatelské nastavení
    @AppStorage("colorMode") private var colorMode: ColorMode = COLOR_MODE_INITIALIZER
    @AppStorage("language") private var language: Language = LANGUAGE_INITIALIZER
    
    private init() {}
    
    public func setColorMode(mode: ColorMode) -> Void {
        self.colorMode = mode
    }
    
    public func getColorMode() -> ColorMode {
        return self.colorMode
    }
    
    public func setLanguage(language: Language) -> Void {
        self.language = language
    }
    
    public func getLanguage() -> Language {
        return self.language
    }
    
    /// Uloží do perzistentního úložiště nedohranou hru.
    /// - Parameters:
    ///   - gameStarterValues: počáteční hodnoty buněk
    ///   - gameValue: aktuální hodnoty buněk
    ///   - gameSolution: řešení buněk
    ///   - candidates: kandidáti všech buněk
    ///   - difficulty: obtížnost
    ///   - timeSeconds: uplynulý čas v sekundách
    public func addStoredGame(gameStarterValues: [[Int]], gameValue: [[Int]], gameSolution: [[Int]], candidates: [[[Int]]], difficulty: Difficulty, timeSeconds: Int)
    -> Void {
        self.continueGameStored = true
        self.continueGameDifficulty = difficulty
        self.continueGameTime = timeSeconds
        
        self.continueGameStarterValues = StringHelper.arrayToString(grid: gameStarterValues)
        self.continueGameValue = StringHelper.arrayToString(grid: gameValue)
        self.continueGameSolution = StringHelper.arrayToString(grid: gameSolution)
        
        self.continueGameCandidates = StringHelper.candidatesToString(candidates: candidates)
    }
    
    /// Odstraní z úložiště nedohranou hru, pokud v úložišti je.
    public func removeStoredGame() -> Void {
        if (self.continueGameStored) {
            self.continueGameStored = false
            self.continueGameStarterValues = StorageManager.STRING_INITIALIZER
            self.continueGameValue = StorageManager.STRING_INITIALIZER
            self.continueGameSolution = StorageManager.STRING_INITIALIZER
            self.continueGameCandidates = StorageManager.STRING_INITIALIZER
            self.continueGameDifficulty = StorageManager.DIFFICULTY_INITIALIZER
            self.continueGameTime = StorageManager.INT_INITIALIZER
        }
    }
    
    public func getContinueGameStarterValues() -> [[Int]] {
        return StringHelper.stringTo2DIntArray(gridString: self.continueGameStarterValues)
    }
    
    public func getContinueGameValue() -> [[Int]] {
        return StringHelper.stringTo2DIntArray(gridString: self.continueGameValue)
    }
    
    public func getContinueGameSolution() -> [[Int]] {
        return StringHelper.stringTo2DIntArray(gridString: self.continueGameSolution)
    }
    
    public func getContinueGameCandidates() -> [[[Int]]] {
        return StringHelper.stringTo3DIntArray(candidatesString: self.continueGameCandidates)
    }
    
    public func isContinueGameStored() -> Bool {
        return self.continueGameStored
    }
    
    public func getContinueGameTime() -> Int {
        return self.continueGameTime
    }
    
    public func setContinueGameTime(continueGameTime: Int) -> Void {
        self.continueGameTime = continueGameTime
    }
    
    public func getContinueGameDifficulty() -> Difficulty {
        return self.continueGameDifficulty
    }
    
    public func setContinueGameDifficulty(continueGameDifficulty: Difficulty) -> Void {
        self.continueGameDifficulty = continueGameDifficulty
    }
    
    /// - Parameter difficulty: obtížnost hry
    /// - Returns: nejnižší čas v sekundách podle obtížnosti
    public func getHighscore(difficulty: Difficulty) -> Int {
        switch difficulty {
            case .demo:
                return self.highscoreDemo
                
            case .easy:
                return self.highscoreEasy
                
            case .medium:
                return self.highscoreMedium
                
            case .hard:
                return self.highscoreHard
        }
    }
    
    /// Uloží čas jako nejlepší skóre, pokud je nižší než akutální nejlepší skóre pro danou obtížnost.
    /// - Parameters:
    ///   - difficulty: obtížnost hry
    ///   - seconds: čas řešení sudoku
    public func setHighscore(difficulty: Difficulty, seconds: Int) -> Void {
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
    
    private func setHighScoreDemo(seconds: Int) -> Void {
        if seconds < self.highscoreDemo {
            self.highscoreDemo = seconds
        }
    }
    
    private func setHighScoreEasy(seconds: Int) -> Void {
        if seconds < self.highscoreEasy {
            self.highscoreEasy = seconds
        }
    }
    
    private func setHighScoreMedium(seconds: Int) -> Void {
        if seconds < self.highscoreMedium {
            self.highscoreMedium = seconds
        }
    }
    
    private func setHighScoreHard(seconds: Int) -> Void {
        if seconds < self.highscoreHard {
            self.highscoreHard = seconds
        }
    }
    
}
