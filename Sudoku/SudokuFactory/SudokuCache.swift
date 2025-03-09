import Foundation

/// třída poskytující cachování sudoku získaných z CSV souboru
class SudokuCache
{
    /// cache pro sudoku získaná z CSV souboru
    private var fileCache: [Difficulty: [CharSudoku]]
    
    /// objekt pro načtení sudoku z CSV souboru
    private let csvLoader: CSVLoader

    init() {
        self.csvLoader = CSVLoader()
        
        self.fileCache = [:]
        
        self.fileCache = self.initializeCache()
        
        self.loadToFileCache()
    }
    
    /// Vybere náhodné sudoku dané obtížnosti z fileCache a vrátí ho.
    /// - Parameter difficulty: vybraná obtížnost
    /// - Returns: sudoku z cache
    public func getRandomFromFileCache(difficulty: Difficulty) -> CharSudoku {
        return self.fileCache[difficulty]!.randomElement()!
    }
    
    /// Přidá do fileCache všechna sudoku ze souboru sudokus.csv
    /// - Returns: Void
    private func loadToFileCache() -> Void {
        let sudokus: [CharSudoku] = self.csvLoader.loadFromCSV()
        
        for sudoku in sudokus {
            self.fileCache[sudoku.getDifficulty()]!.append(sudoku)
        }
    }
    
    private func initializeCache() -> [Difficulty: [CharSudoku]] {
        var cache: [Difficulty: [CharSudoku]] = [:]
        
        for difficulty in Difficulty.allCases {
            cache[difficulty] = []
        }
        
        return cache
    }
}

