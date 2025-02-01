class Board
{
    public let ROWS = 9
    public let COLUMNS = 9
    
    private var cells: [[Cell]]
    
    public init() {
        self.cells = []
        
        for _ in 0..<self.ROWS {
            var row: [Cell] = []
            
            for _ in 0..<self.COLUMNS {
                let cell: Cell = Cell(value: 0)
                row.append(cell)
            }
            
            self.cells.append(row)
        }
    }
    
    public func setValue(row: Int, column: Int, value: Int) -> Void {
        self.cells[row][column].setValue(value: value)
    }
    
    public func getValue(row: Int, column: Int) -> Int {
        return self.cells[row][column].getValue()
    }
    
    public func getCandidates(row: Int, column: Int) -> [Int] {
        return self.cells[row][column].getCandidates()
    }
    
    public func addCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].addCandidate(candidate: candidate)
    }
    
    public func removeCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].removeCandidate(candidate: candidate)
    }
    
    public func printBoard() -> Void {
        for i in 0..<self.ROWS {
            for j in 0..<self.COLUMNS {
                let value: Int = self.cells[i][j].getValue()
                
                if (value != 0) {
                    print(value, terminator: "")
                }
                else {
                    print(" ", terminator: "")
                }
            }
            print("")
        }
    }
    
}

