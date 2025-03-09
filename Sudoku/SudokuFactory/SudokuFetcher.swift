import Foundation

/// vytvoří sudoku mřížku připravenou pro hru
class SudokuFetcher
{
    /// instance s nacachovanými sudoku ze souboru
    private let cache: SudokuCache = SudokuCache()
    
    /// - Returns: rozehrané sudoku z perzistentního úložiště
    public func fetchContinueGame() -> [[Cell]] {
        let starterGrid: [[Int]] = StorageManager.getContinueGameStarterValues()
        let valueGrid: [[Int]] = StorageManager.getContinueGameValue()
        let solutionGrid: [[Int]] = StorageManager.getContinueGameSolution()
        let candidates: [[[Int]]] = StorageManager.getContinueGameCandidates()
        
        var cells: [[Cell]] = []
        
        for row in 0..<valueGrid.count {
            var cellsRow: [Cell] = []
            
            for column in 0..<valueGrid[row].count {
                let value: Int = valueGrid[row][column]
                let solution: Int = solutionGrid[row][column]
                let preFilled: Bool = starterGrid[row][column] != 0
                
                let cell: Cell = Cell(row: row, column: column, solution: solution, value: value, preFilled: preFilled)
                
                for candidate in candidates[row][column] {
                    cell.addCandidate(candidate: candidate)
                }
                
                cellsRow.append(cell)
            }
            
            cells.append(cellsRow)
        }
        
        return cells
    }

    /// Úpravou sudoku ze souboru vytvoří nové hratelné sudoku.
    /// - Parameter difficulty: požadovaná obtížnost
    /// - Returns: hratelné sudoku
    public func fetchNewGame(difficulty: Difficulty) -> [[Cell]] {
        // sudoku se znaky místo čísel
        let charSudoku: CharSudoku = self.cache.getRandomFromFileCache(difficulty: difficulty)
        
        // náhodné mapování znaků na čísla
        let mapping: [Character : Int] = self.getRandomMapping()
        
        // očíslované sudoku podle mapování
        var numberedSudoku: NumberedSudoku = NumberedSudoku(charSudoku: charSudoku, mapping: mapping)
        
        // náhodná rotace o 90, 180 nebo 270 stupňů
        numberedSudoku = self.randomlyRotate(numberedSudoku: numberedSudoku)
        
        // nic nebo vertikální překlopení
        numberedSudoku = self.randomVerticalFlip(numberedSudoku: numberedSudoku)
        
        // nic nebo horizontální překlopení
        numberedSudoku = self.randomHorizontalFlip(numberedSudoku: numberedSudoku)
        
        return self.mapNumberedSudokuToCells(numberedSudoku: numberedSudoku)
    }
    
    private func getRandomMapping() -> [Character : Int] {
        var allChars: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
        var allNumbers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        var mapping: [Character : Int] = ["0" : 0]
        
        while (allChars.count > 0) {
            let char: Character = allChars.randomElement()!
            let charIndex: Int = allChars.firstIndex(of: char)!
            allChars.remove(at: charIndex)
            
            let number: Int = allNumbers.randomElement()!
            let numberIndex: Int = allNumbers.firstIndex(of: number)!
            allNumbers.remove(at: numberIndex)
            
            mapping[char] = number
        }
        
        return mapping
    }
    
    /// Náhodná rotace mřížky o 90, 180 nebo 270 stupňů.
    /// - Parameter numberedSudoku: očíslované sudoku
    /// - Returns: rotované sudoku
    private func randomlyRotate(numberedSudoku: NumberedSudoku) -> NumberedSudoku {
        let rotations: Int = Int.random(in: 0...3)
        var rotatedSudoku: NumberedSudoku = numberedSudoku
        
        for _ in 0..<rotations {
            rotatedSudoku = rotate90Degrees(numberedSudoku: rotatedSudoku)
        }
        
        return rotatedSudoku
    }
    
    /// Rotace mřížky o 90 stupňů.
    /// - Parameter numberedSudoku: očíslované sudoku
    /// - Returns: rotované sudoku
    private func rotate90Degrees(numberedSudoku: NumberedSudoku) -> NumberedSudoku {
        var rotatedSudoku: NumberedSudoku = numberedSudoku
        
        rotatedSudoku.setValueGrid(valueGrid: MatrixHelper.rotate90DegreesClockwise(matrix: numberedSudoku.getValueGrid()))
        rotatedSudoku.setSolutionGrid(solutionGrid: MatrixHelper.rotate90DegreesClockwise(matrix: numberedSudoku.getSolutionGrid()))
        
        return rotatedSudoku
    }
    
    /// Metoda náhodně sudoku vertikálně překlopí nebo ne.
    /// - Parameter numberedSudoku: očíslované sudoku
    /// - Returns: překlopené nebo stejné sudoku
    private func randomVerticalFlip(numberedSudoku: NumberedSudoku) -> NumberedSudoku {
        var flippedSudoku: NumberedSudoku = numberedSudoku
        let flip: Bool = Bool.random()
        
        if (flip) {
            flippedSudoku.setValueGrid(valueGrid: MatrixHelper.verticalFlip(matrix: numberedSudoku.getValueGrid()))
            flippedSudoku.setSolutionGrid(solutionGrid: MatrixHelper.verticalFlip(matrix: numberedSudoku.getSolutionGrid()))
        }
        
        return flippedSudoku
    }
    
    /// Metoda náhodně sudoku horizontálně překlopí nebo ne.
    /// - Parameter numberedSudoku: očíslované sudoku
    /// - Returns: překlopené nebo stejné sudoku
    private func randomHorizontalFlip(numberedSudoku: NumberedSudoku) -> NumberedSudoku {
        var flippedSudoku: NumberedSudoku = numberedSudoku
        let flip: Bool = Bool.random()
        
        if (flip) {
            flippedSudoku.setValueGrid(valueGrid: MatrixHelper.horizontalFlip(matrix: numberedSudoku.getValueGrid()))
            flippedSudoku.setSolutionGrid(solutionGrid: MatrixHelper.horizontalFlip(matrix: numberedSudoku.getSolutionGrid()))
        }
        
        return flippedSudoku
    }
    
    
    /// Z instance očíslovaného sudoku vyrobí 2D mřížku buněk.
    /// - Parameter numberedSudoku: očíslované sudoku
    /// - Returns: 2D mřížka buněk
    private func mapNumberedSudokuToCells(numberedSudoku: NumberedSudoku) -> [[Cell]] {
        let valueGrid: [[Int]] = numberedSudoku.getValueGrid()
        let solutionGrid: [[Int]] = numberedSudoku.getSolutionGrid()
        
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
}





