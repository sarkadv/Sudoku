/// klonování objektů
class Cloner {
    
    /// Vytvoří hlubokou kopii pole buněk.
    /// - Parameter cells: buňky ke kopírování
    /// - Returns: pole hlubokých kopií buněk
    public static func cloneCells(cells: [Cell]) -> [Cell] {
        var newCells: [Cell] = []
        
        for i in 0..<cells.count {
            let oldCell: Cell = cells[i]
            let newCell: Cell = Cell(row: oldCell.getRow(), column: oldCell.getColumn(), value: oldCell.getValue())
            newCells.append(newCell)
        }
        
        return newCells
    }
    
    /// Vytvoří hlubokou kopii celé sudoku mřížky
    /// - Parameter cells: 2D pole mřížky
    /// - Returns: hluboká kopie mřížky
    public static func cloneBoard(cells: [[Cell]]) -> [[Cell]] {
        var newCells: [[Cell]] = []
        
        for row in 0..<cells.count {
            newCells.append(Cloner.cloneCells(cells: cells[row]))
        }
        
        return newCells
    }
}

