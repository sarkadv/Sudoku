class StringHelper {
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
            
            if num != nil {
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
}

