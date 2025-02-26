import Foundation

/// třída poskytující cachování sudoku získaných z API nebo z CSV souboru
class SudokuCache
{
    /// maximální počet sudoku jedné obtížnosti v apiCache
    private let API_CACHE_LIMIT: Int = 5
    
    /// cache pro sudoku získaná z API
    private var apiCache: [Difficulty: [Response]]
    
    /// cache pro sudoku získaná z CSV souboru
    private var fileCache: [Difficulty: [Response]]
    
    /// objekt pro načtení sudoku z CSV souboru
    private let csvLoader: CSVLoader

    init() {
        self.csvLoader = CSVLoader()
        
        self.apiCache = [:]
        self.fileCache = [:]
        
        self.apiCache = self.initializeCache()
        self.fileCache = self.initializeCache()
        
        self.loadToFileCache()
    }
    
    /// Přidá sudoku zabalené v objektu response do apiCache, pokud je zde dostatek místa.
    /// - Parameters:
    ///   - response: objekt s informacemi o sudoku
    /// - Returns: Void
    public func addToApiCache(response: Response) -> Void {
        let count: Int = self.apiCache[response.getDifficulty()]!.count
        
        if (count < self.API_CACHE_LIMIT) {
            self.apiCache[response.getDifficulty()]!.append(response)
        }
    }
    
    /// Vybere první sudoku dané obtížnosti z apiCache, vymaže ho z cache a vrátí ho.
    /// - Parameter difficulty: vybraná obtížnost
    /// - Returns: sudoku z cache / nil pokud cache prázdná
    public func popFromApiCache(difficulty: Difficulty) -> Response? {
        let count: Int = self.apiCache[difficulty]!.count
        
        if (count == 0) {
            return nil
        }
        
        return self.apiCache[difficulty]!.removeFirst()
    }
    
    /// Vybere náhodné sudoku dané obtížnosti z fileCache a vrátí ho.
    /// - Parameter difficulty: vybraná obtížnost
    /// - Returns: sudoku z cache
    public func getRandomFromFileCache(difficulty: Difficulty) -> Response {
        return self.fileCache[difficulty]!.randomElement()!
    }
    
    /// Přidá do fileCache všechna sudoku ze souboru sudokus.csv
    /// - Returns: Void
    private func loadToFileCache() -> Void {
        let responses: [FileResponse] = self.csvLoader.loadFromCSV()
        
        for response in responses {
            self.fileCache[response.getDifficulty()]!.append(response)
        }
    }
    
    private func initializeCache() -> [Difficulty: [Response]] {
        var cache: [Difficulty: [Response]] = [:]
        
        for difficulty in Difficulty.allCases {
            cache[difficulty] = []
        }
        
        return cache
    }
}

