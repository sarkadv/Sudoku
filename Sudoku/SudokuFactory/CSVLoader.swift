import Foundation

/// třída pro načítání dat z CSV souboru
class CSVLoader
{
    /// název CSV souboru
    private let resourceName: String = "sudokus"
    
    /// přípona CSV souboru
    private let resourceExtension: String = "csv"
    
    /// oddělovač řádků v CSV souboru
    private let rowSeparator: String = "\n"
    
    /// oddělovač sloupců v CSV souboru
    private let columnSeparator: String = ","
    
    /// Načte a vrátí všechna sudoku z CSV souboru.
    /// - Returns: všechna sudoku z CSV souboru
    public func loadFromCSV() -> [FileResponse] {
        var sudokus: [FileResponse] = []

        let url: URL = Bundle.main.url(forResource: self.resourceName, withExtension: self.resourceExtension)!
        
        do {
            // veškerý obsah souboru
            let content = try String(contentsOf: url, encoding: .utf8)
            
            // odstranění první a poslední řádky
            let rows = content.components(separatedBy: self.rowSeparator).dropFirst().dropLast()
            
            for row in rows {
                if row.isEmpty {
                    continue
                }
                
                let sudoku: FileResponse = processRow(row: row)
                sudokus.append(sudoku)
            }
        }
        catch {
            print("Error loading file: \(error)")
        }
        
        return sudokus
    }
    
    /// Zpracuje jeden řádek z CSV souboru a vrátí objekt obsahující informace o sudoku.
    /// - Parameter row: řádek z CSV souboru
    /// - Returns: objekt FileResponse s informacemi o sudoku
    private func processRow(row: String) -> FileResponse {
        // rozdělení řádky na části
        let columns = row.components(separatedBy: self.columnSeparator)
        
        let difficulty: Difficulty = Difficulty.fromString(difficultyString: columns[0])!
        let valueString = columns[1]
        let solutionString = columns[2]
        
        // 81 čísel je převedeno na 9x9 pole
        let valueGrid = StringHelper.stringTo2DArray(gridString: valueString)
        let solutionGrid = StringHelper.stringTo2DArray(gridString: solutionString)
        
        return FileResponse(value: valueGrid, solution: solutionGrid, difficulty: difficulty)
    }
}

