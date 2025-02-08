/// celá sudoku mřížka
class Board
{
    /// počet řádek
    public let ROWS = 9
    /// počet sloupců
    public let COLUMNS = 9
    
    /// 2D mřížka tvořená buňkami
    private var cells: [[Cell]]
    
    public init(difficulty: Difficulty) {
        // vygenerování sudoku ke hře
        self.cells = SudokuGenerator.generatePlayableSudoku(difficulty: difficulty)
        
    }
    
    public func addCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].addCandidate(candidate: candidate)
    }
    
    public func removeCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].removeCandidate(candidate: candidate)
    }
    
    public func setValue(row: Int, column: Int, value: Int) -> Void {
        self.cells[row][column].setValue(value: value)
    }
    
    public func getValue(row: Int, column: Int) -> Int {
        return self.cells[row][column].getValue()
    }
    
    public func getCandidates(row: Int, column: Int) -> Set<Int> {
        return self.cells[row][column].getCandidates()
    }
    
}

