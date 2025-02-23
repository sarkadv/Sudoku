/// sudoku nahrané ze souboru
struct FileResponse: Response {
    private let value: [[Int]]
    private let solution: [[Int]]
    private let difficulty: Difficulty
    
    init(value: [[Int]], solution: [[Int]], difficulty: Difficulty) {
        self.value = value
        self.solution = solution
        self.difficulty = difficulty
    }
    
    public func getValueGrid() -> [[Int]] {
        return self.value
    }
    
    public func getSolutionGrid() -> [[Int]] {
        return self.solution
    }

    public func getDifficulty() -> Difficulty {
        return self.difficulty
    }
}
