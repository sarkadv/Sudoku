/// sudoku nahrané ze souboru a očíslované náhodným mapováním znaku na číslo
class NumberedSudoku {
    private var value: [[Int]]
    private var solution: [[Int]]
    private let difficulty: Difficulty
    
    init(charSudoku: CharSudoku, mapping: [Character : Int]) {
        // všechny znaky namapovány na čísla
        
        self.value = charSudoku.getValueGrid().map { row in
            row.map { mapping[$0]! }
        }
        
        self.solution = charSudoku.getSolutionGrid().map { row in
            row.map { mapping[$0]! }
        }
        
        self.difficulty = charSudoku.getDifficulty()
    }
    
    public func getValueGrid() -> [[Int]] {
        return self.value
    }
    
    public func setValueGrid(valueGrid: [[Int]]) -> Void {
        self.value = valueGrid
    }
    
    public func getSolutionGrid() -> [[Int]] {
        return self.solution
    }
    
    public func setSolutionGrid(solutionGrid: [[Int]]) -> Void {
        self.solution = solutionGrid
    }

    public func getDifficulty() -> Difficulty {
        return self.difficulty
    }
}


