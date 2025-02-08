/// generuje sudoku mřížku připravenou pro hru
class SudokuGenerator
{
    /// počet řádek
    private static let ROWS = 9
    /// počet sloupců
    private static let COLUMNS = 9
    
    /// všechny možné hodnoty buňky
    private static let allCandidates: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    /// počet prázdných buněk podle obtížnosti
    private static var holes: [Difficulty : Int] = [.easy : 30, .medium : 40, .hard : 50]
    
    /// Vygeneruje sudoku mřížku připravenou pro hru.
    /// - Parameter difficulty: obtížnost hry
    /// - Returns: 2D mřížka buněk
    public static func generatePlayableSudoku(difficulty: Difficulty) -> [[Cell]] {
        // inicializace všech buněk na prázdnou hodnotu 0
        var cells: [[Cell]] = initializeCells()
        
        // vygenerování vyplněného sudoku
        cells = generateCompleteBoard(cells: cells)!
        
        // některé buňky udělat prázdné (počet dle obtížnosti)
        cells = makeBoardIncomplete(holes: holes[difficulty]!, cells: cells)
        
        return cells
    }
    
    /// Vytvoří a inicializuje všechny buňky mřížky na prázdnou hodnotu 0.
    /// - Returns: 2D mřížka prázdných buněk
    private static func initializeCells() -> [[Cell]] {
        var cells: [[Cell]] = []
        
        for row in 0..<ROWS {
            var rowArray: [Cell] = []
            
            for column in 0..<COLUMNS {
                let cell: Cell = Cell(row: row, column: column)
                rowArray.append(cell)
            }
            
            cells.append(rowArray)
        }
        
        return cells
    }
    
    /// Vygeneruje vyplněné sudoku.
    /// - Parameter cells: 2D pole prázdných sudoku buněk
    /// - Returns: 2D pole vyplněných sudoku buněk
    private static func generateCompleteBoard(cells: [[Cell]]) -> [[Cell]]? {
        // všechny možné hodnoty buňky zamíchané
        let candidates: [Int] = allCandidates.shuffled()
        
        // nalezení první prázdné buňky
        let emptyCell: Cell? = findEmptyCell(cells: cells)
        
        if emptyCell == nil {
            // všechny buňky zaplněné
            return cells
        }
        
        let row: Int = emptyCell!.getRow()
        let column: Int = emptyCell!.getColumn()
        
        // vyzkoušení umístění všech kandidátů, dokud není nalezen vhodný
        for candidate in candidates {
            
            if (!SudokuChecker.checkPlacement(cells: cells, row: row, column: column, value: candidate)) {
                // nelze umístit do buňky kandidáta a zachovat pravidla sudoku
                continue
            }

            cells[row][column].setValue(value: candidate)
            cells[row][column].setSolution(solution: candidate)
            
            // umístění dalšího čísla do prázdné buňky
            let result: [[Cell]]? = generateCompleteBoard(cells: cells)
            
            if result != nil {
                // další buňka byla zaplněna
                // není nutné zkoušet další kandidáty
                return cells
            }
            else {
                // do další buňky nemohlo být umístěno žádné číslo
                // reset a vyzkoušení dalšího kandidáta
                cells[row][column].setValue(value: 0)
                cells[row][column].setSolution(solution: 0)
            }

        }
        
        // nebylo možné umístit žádné číslo -> backtracking
        return nil
        
    }
    
    /// Vytvoří ve 2D mřížce některé prázdné buňky.
    /// - Parameters:
    ///   - holes: počet prázdných buněk
    ///   - cells: 2D sudoku mřížka
    /// - Returns: 2D pole buněk, některé prázdná hodnota
    private static func makeBoardIncomplete(holes: Int, cells: [[Cell]]) -> [[Cell]] {
        // nalezení všech možných souřadnic mřížky
        var allCoordinates: [(Int, Int)] = []
        
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                allCoordinates.append((row, column))
            }
        }
        
        allCoordinates = allCoordinates.shuffled()
        
        var removedValues: Int = 0  // počet odstraněných hodnot z buněk
        var i: Int = 0  // index do pole souřadnic
        
        // odstraňování hodnot, dokud jich není daný počet prázdný nebo dokud nebyly vyzkoušeny všechny souřadnice
        while (removedValues < holes) || (i == allCoordinates.count) {
            
            // výběr náhodné souřadnice
            let coordinates: (Int, Int) = allCoordinates[i]
            i += 1
            
            let row: Int = coordinates.0
            let column: Int = coordinates.1
            
            // uložení aktuální hodnoty buňky do pomocné proměnné
            let oldValue: Int = cells[row][column].getValue()
            
            // buňka prázdná
            cells[row][column].setValue(value: 0)
            
            // má sudoku po odstranění hodnoty z buňky právě jedno řešení?
            let isOneSolution: Bool = isOneSolution(cells: cells)
            
            if isOneSolution {
                removedValues += 1
                
                // prázdnou buňku smí hráč modifikovat a vymazat
                cells[row][column].setDeletable(deletable: true)
            }
            else {
                // sudoku nemá právě jedno řešení, nutné hodnotu do buňky vrátit
                cells[row][column].setValue(value: oldValue)
            }
        }
        
        return cells
        
    }
    
    /// Určí, jestli má sudoku právě jedno řešení. Jedná se o heuristiku.
    /// - Parameter cells: 2D sudoku mřížka
    /// - Returns: true - sudoku má právě jedno řešení / jinak false
    private static func isOneSolution(cells: [[Cell]]) -> Bool {
        var solution: [[Cell]]? = nil
        
        // všechny prázdné buňky v mřížce
        let emptyCells: [Cell] = getEmptyCells(cells: cells)
        
        // postupně vyplňovány prázdné buňky, pokaždé start v i-té buňce
        // prázdné buňky musí být pokaždé vyplněny stejně, aby existovalo právě jedno řešení
        for i in 0..<emptyCells.count {
            // naklonování prázdných buněk, aby původní nebyly modifikovány
            var clonedEmptyCells: [Cell] = Cloner.cloneCells(cells: emptyCells)
            
            // naklonování celé mřížky, aby původní nebyla modifikována
            let clonedBoard: [[Cell]] = Cloner.cloneBoard(cells: cells)
            
            // startovní buňka
            let startCcell: Cell = clonedEmptyCells[i]
            
            // startovní buňka na začátek pole
            clonedEmptyCells.remove(at: i)
            clonedEmptyCells.insert(startCcell, at: 0)
            
            // vyplnění prázdných buněk postupně podle indexu
            let newSolution = generateBoardFromArray(cells: clonedBoard, solveCells: clonedEmptyCells, solveCellIndex: 0)
            
            if solution == nil {
                solution = newSolution
                continue
            }
            
            if newSolution == nil {
                continue
            }
            
            if (areSolutionsDifferent(cells1: solution!, cells2: newSolution!)) {
                // více řešení
                return false
            }
        }
        
        // pokud nil, sudoku nemá řešení
        return solution != nil
    }
    
    /// Vyplní prázdné buňky v sudoku mřížce validním řešením. Prázdné buňky jsou vyplňovány postupně dle pořadí v poli.
    /// - Parameters:
    ///   - cells: 2D mřížka
    ///   - solveCells: buňky k vyplnění
    ///   - solveCellIndex: index do pole solveCells s první prázdnou buňkou
    /// - Returns: vyplněná sudoku mřížka
    private static func generateBoardFromArray(cells: [[Cell]], solveCells: [Cell], solveCellIndex: Int) -> [[Cell]]? {
        if solveCellIndex == solveCells.count {
            // všechny buňky vyplněné
            return cells
        }
        
        // buňka k vyplnění
        let solveCell: Cell? = solveCells[solveCellIndex]
        
        // všechny možné hodnoty buněk
        let candidates: [Int] = allCandidates.shuffled()
        
        // vyzkoušení umístění všech kandidátů, dokud není nalezen vhodný
        for candidate in candidates {
            let row: Int = solveCell!.getRow()
            let column: Int = solveCell!.getColumn()
            
            if (!SudokuChecker.checkPlacement(cells: cells, row: row, column: column, value: candidate)) {
                // nelze umístit do buňky kandidáta a zachovat pravidla sudoku
                continue
            }
            
            cells[row][column].setValue(value: candidate)
            solveCell!.setValue(value: candidate)
            
            // umístění dalšího čísla do prázdné buňky
            let result: [[Cell]]? = generateBoardFromArray(cells: cells, solveCells: solveCells, solveCellIndex: solveCellIndex + 1)
            
            if result != nil {
                // další buňka byla zaplněna
                // není nutné zkoušet další kandidáty
                return cells
            }
            else {
                // do další buňky nemohlo být umístěno žádné číslo
                // reset a vyzkoušení dalšího kandidáta
                cells[row][column].setValue(value: 0)
                solveCell!.setValue(value: 0)
            }
        }
        
        return nil
    }
    
    /// Zjistí, zda jsou vyplněné mřížky číselně stejné.
    /// - Parameters:
    ///   - cells1: první 2D mřížka
    ///   - cells2: druhá 2D mřížka
    /// - Returns: true - mřížky jsou číselně stejné / false jinak
    private static func areSolutionsDifferent(cells1: [[Cell]], cells2: [[Cell]]) -> Bool {
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                if (cells1[row][column].getValue() != cells2[row][column].getValue()) {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// Najde a vrátí všechny buňky v mřížce, které jsou prázdné.
    /// - Parameter cells: 2D mřížka
    /// - Returns: všechny prázdné buňky v mřížce
    private static func getEmptyCells(cells: [[Cell]]) -> [Cell] {
        var emptyCells: [Cell] = []
        
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                let cell: Cell = cells[row][column]
                if (cell.getValue() == 0) {
                    emptyCells.append(cell)
                }
                
            }
        }
        
        return emptyCells
    }
    
    /// Najde a vrátí první buňku v mřížce, která je prázdná.
    /// - Parameter cells: 2D mřížka
    /// - Returns: prázdná buňka / nil pokud žádná není prázdná
    private static func findEmptyCell(cells: [[Cell]]) -> Cell? {
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                let value: Int = cells[row][column].getValue()
                
                if (value == 0) {
                    return cells[row][column]
                }
            }
        }
        
        return nil
    }
}

