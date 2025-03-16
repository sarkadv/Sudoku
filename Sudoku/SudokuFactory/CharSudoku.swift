/// sudoku nahrané ze souboru obsahující znaky místo čísel
class CharSudoku {
    private let value: [[Character]]
    private let solution: [[Character]]
    private let difficulty: Difficulty
    
    init(value: [[Character]], solution: [[Character]], difficulty: Difficulty) {
        self.value = value
        self.solution = solution
        self.difficulty = difficulty
    }
    
    public func getValueGrid() -> [[Character]] {
        return self.value
    }
    
    public func getSolutionGrid() -> [[Character]] {
        return self.solution
    }

    public func getDifficulty() -> Difficulty {
        return self.difficulty
    }
}
