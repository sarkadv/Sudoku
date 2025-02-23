/// odpověd od Sudoku API
struct ApiResponse: Response, Decodable {
    private let newboard: Newboard /// tělo odpovědi
    
    public func getValueGrid() -> [[Int]] {
        return self.newboard.getGrids().getValue()
    }
    
    public func getSolutionGrid() -> [[Int]] {
        return self.newboard.getGrids().getSolution()
    }

    public func getDifficulty() -> Difficulty {
        return self.newboard.getGrids().getDifficulty()
    }
}

struct Newboard: Decodable {
    private let grids: [Grids]  /// klíč obsahuje pole o jednom prvku
    private let results: Int    /// počet výsledků
    private let message: String /// zpráva o úspěchu
    
    public func getGrids() -> Grids {
        return self.grids[0]
    }
}

struct Grids: Decodable {
    private let value: [[Int]] /// řešitelné sudoku (prázdné buňky hodnota 0)
    private let solution: [[Int]] /// vyřešené sudoku
    private let difficulty: String  /// obtížnost (Easy, Medium, Hard)
    
    public func getValue() -> [[Int]] {
        return self.value
    }
    
    public func getSolution() -> [[Int]] {
        return self.solution
    }

    public func getDifficulty() -> Difficulty {
        return Difficulty.fromString(difficultyString: self.difficulty)!
    }
}

