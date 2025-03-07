import Foundation

/// vytvoří sudoku mřížku připravenou pro hru
class SudokuFetcher
{
    /// URL adresa použitého API
    private let API_URL: String = "https://sudoku-api.vercel.app/api/dosuku"
    
    /// limit API volání pro získání jednoho sudoku
    private let API_CALL_LIMIT: Int = 5
    
    /// timeout pro API volání v sekundách
    private let TIMEOUT_S: Double = 1
    
    /// čas uspání mezi jednotlivými API voláními v ms
    private let SLEEP_MS: UInt32 = 200_000
    
    /// instance s nacachovanými sudoku
    private let cache: SudokuCache
    
    init() {
        self.cache = SudokuCache()
    }
    
    /// Vrátí sudoku dané obtížnosti.
    /// Nejdříve se pokusí sudoku získat z cache, pokud zde žádné vhodné není,
    /// pokusí se získat sudoku dané obtížnosti pomocí API.
    /// Po vyčerpání limitu na počet API volání je sudoku získáno z textového souboru.
    /// - Parameter difficulty: požadovaná obtížnost
    /// - Returns: 2D mřížka Cell instancí
    public func fetchPuzzle(difficulty: Difficulty) async -> [[Cell]] {
        // demo je pouze ze souboru
        if (difficulty == .demo) {
            return self.fetchFromFile(difficulty: .demo)
        }
        
        // zkusíme, zda sudoku dané obtížnosti není v cache
        let cachedResponse: Response? = self.cache.popFromApiCache(difficulty: difficulty)
        
        if (cachedResponse != nil) {
            return self.mapResponseToCells(response: cachedResponse!)
        }
        
        // získání URL objektu obsahující adresu API
        let url = URL(string: API_URL)
        
        // vytvoření session
        let session = self.createSession()
        
        do {
            // počet API volání
            var tries: Int = 0
            
            // dotazy na API, dokud sudoku není dané obtížnosti nebo nevyprší limit dotazů
            while (tries < self.API_CALL_LIMIT) {
                // asynchronní získání dat pomocí API
                let (data, _) = try await session.data(from: url!)
                
                // odpověď ve formátu JSON je dekódována do struktury ApiResponse
                let decoder = JSONDecoder()
                let response = try decoder.decode(ApiResponse.self, from: data)
                
                // sudoku je správné obtížnosti
                if (response.getDifficulty() == difficulty) {
                    // odpověď je namapována na formát mřížky aplikace
                    return self.mapResponseToCells(response: response)
                }
                else {
                    // přidání sudoku s nesprávnou obtížností do cache
                    self.cache.addToApiCache(response: response)
                    
                    // uspání, aby nebyly dotazy na API moc rychle za sebou
                    usleep(self.SLEEP_MS)
                    tries += 1
                }
            }
            
            // vypršel limit na počet API volání
            return self.fetchFromFile(difficulty: difficulty)
        }
        catch {
            // došlo k chybě nebo timeoutu při API volání
            return self.fetchFromFile(difficulty: difficulty)
        }
        
    }
    
    /// - Returns: rozehrané sudoku z perzistentního úložiště
    public func fetchContinueGame() -> [[Cell]] {
        let starterGrid: [[Int]] = StorageManager.getContinueGameStarterValues()
        let valueGrid: [[Int]] = StorageManager.getContinueGameValue()
        let solutionGrid: [[Int]] = StorageManager.getContinueGameSolution()
        
        var cells: [[Cell]] = []
        
        for row in 0..<valueGrid.count {
            var cellsRow: [Cell] = []
            
            for column in 0..<valueGrid[row].count {
                let value: Int = valueGrid[row][column]
                let solution: Int = solutionGrid[row][column]
                let preFilled: Bool = starterGrid[row][column] != 0
                
                cellsRow.append(Cell(row: row, column: column, solution: solution, value: value, preFilled: preFilled))
            }
            
            cells.append(cellsRow)
        }
        
        return cells
    }
    
    /// Vrátí náhodné sudoku dané obtížnosti z textového souboru.
    /// - Parameter difficulty: požadovaná obtížnost
    /// - Returns: sudoku ze souboru
    private func fetchFromFile(difficulty: Difficulty) -> [[Cell]] {
        let response: Response = self.cache.getRandomFromFileCache(difficulty: difficulty)
        return self.mapResponseToCells(response: response)
    }
    
    /// Z ApiResponse objektu vytvoří 2D mřížku Cell instancí.
    /// - Parameter response: odpověď od API
    /// - Returns: 2D mřížka Cell instancí
    private func mapResponseToCells(response: Response) -> [[Cell]] {
        let valueGrid: [[Int]] = response.getValueGrid()
        let solutionGrid: [[Int]] = response.getSolutionGrid()
        
        var cells: [[Cell]] = []
        
        for row in 0..<valueGrid.count {
            var cellsRow: [Cell] = []
            
            for column in 0..<valueGrid[row].count {
                let value: Int = valueGrid[row][column]
                let solution: Int = solutionGrid[row][column]
                let preFilled: Bool = value != 0
                
                cellsRow.append(Cell(row: row, column: column, solution: solution, value: value, preFilled: preFilled))
            }
            
            cells.append(cellsRow)
        }
        
        return cells
    }
    
    /// Vytvoří a vrátí Session objekt s vlastní konfigurací timeoutů.
    /// - Returns: Session objekt
    private func createSession() -> URLSession {
        let config = URLSessionConfiguration.default
        
        // vlastní nastavení timeoutu
        config.timeoutIntervalForRequest = self.TIMEOUT_S
        config.timeoutIntervalForResource = self.TIMEOUT_S

        // použití vlastní konfigurace
        return URLSession(configuration: config)
    }
}





