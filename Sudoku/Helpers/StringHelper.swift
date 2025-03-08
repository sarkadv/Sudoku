class StringHelper {
    
    /// oddělovač buněk v řetězci kandidátů
    private static let CANDIDATES_CELL_SEPARATOR = ";"
    
    /// Řetězec skládající se z 81 čísel převede na 9x9 pole.
    /// - Parameter gridString: řetězec 81 čísel
    /// - Returns: 9x9 pole čísel
    public static func stringTo2DArray(gridString: String) -> [[Int]] {
        var grid: [[Int]] = []
        var row: [Int] = []
        
        for i in 0..<gridString.count
        {
            // index do řetězce
            let index: String.Index = gridString.index(gridString.startIndex, offsetBy: i)
            
            // znak na daném indexu
            let char: Character = gridString[index]
            
            // převod znaku na číslo
            let num: Int? = Int(String(char))
            
            if (num != nil) {
                row.append(num!)
            }
            
            if row.count == 9
            {
                // bylo přidáno 9 čísel, řádek je hotový
                grid.append(row)
                
                // reset řádku
                row = []
            }
        }
        
        return grid
    }
    
    /// 9x9 pole převede na řetězec skládající se z 81 čísel.
    /// - Parameter grid: 9x9 pole čísel
    /// - Returns: řetězec 81 čísel
    public static func arrayToString(grid: [[Int]]) -> String {
        var result: String = ""
        
        for row in 0..<grid.count {
            for column in 0..<grid[row].count {
                result += "\(grid[row][column])"
            }
        }
        
        return result
    }
    
    /// 9x9x9 pole převede na řetězec skládající se z kandidátů pro každou buňku
    /// - Parameter candidates: 9x9x9 pole kanditátů
    /// - Returns: řetězec kandidátů, jednotlivé buňky odděleny středníkem
    public static func candidatesToString(candidates: [[[Int]]]) -> String {
        var result: String = ""
        
        for row in 0..<candidates.count {
            for column in 0..<candidates[row].count {
                for candidate in candidates[row][column] {
                    result += "\(candidate)"
                }
                result += CANDIDATES_CELL_SEPARATOR
            }
        }
        
        return result
    }
    
    /// Řetězec skládající se z max 9x9x9 čísel převede na 9x9x9 pole kandidátů.
    /// - Parameter candidatesString: řetězec max 9x9x9 čísel
    /// - Returns: 9x9x9 pole kandidátů
    public static func stringTo3DArray(candidatesString: String) -> [[[Int]]] {
        var result: [[[Int]]] = []
        var row: [[Int]] = []
        var cellCandidates: [Int] = []
        
        for i in 0..<candidatesString.count
        {
            // index do řetězce
            let index: String.Index = candidatesString.index(candidatesString.startIndex, offsetBy: i)
            
            // znak na daném indexu
            let char: Character = candidatesString[index]
            
            // pokud znak je ukončovací znak buňky
            if (char == CANDIDATES_CELL_SEPARATOR.first) {
                // byli přidáni všichni kanditáti, pole je hotové
                row.append(cellCandidates)
                
                // reset kanditátů
                cellCandidates = []
                
                if (row.count) == 9
                {
                    // bylo přidáno 9 polí, řádek je hotový
                    result.append(row)
                    
                    // reset řádku
                    row = []
                    
                }
                
                continue
            }
            
            // převod znaku na číslo
            let num: Int? = Int(String(char))
            
            if (num != nil && num != 0) {
                cellCandidates.append(num!)
            }
        }
        
        return result
    }
}

