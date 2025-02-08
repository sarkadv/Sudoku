/// kontrola dodržení pravidel sudoku
class SudokuChecker
{
    /// Zkontroluje veškerá pravidla sudoku.
    /// - Parameters:
    ///   - cells: 2D mřížka
    ///   - row: index řádku
    ///   - column: index sloupce
    ///   - value: nově vkládaná hodnota na pozici
    /// - Returns: true - sudoku bude po vložení hodnoty validní / false jinak
    public static func checkPlacement(cells: [[Cell]], row: Int, column: Int, value: Int) -> Bool {
        let rowCheck: Bool = rowCheck(cells: cells, row: row, value: value)
        let columnCheck: Bool = columnCheck(cells: cells, column: column, value: value)
        let boxCheck: Bool = boxCheck(cells: cells, row: row, column: column, value: value)
        
        return rowCheck && columnCheck && boxCheck
    }
    
    /// Zkontroluje, zda jsou čísla v řádku unikátní.
    /// - Parameters:
    ///   - cells: 2D mřížka
    ///   - row: index řádku
    ///   - value: nově vkládaná hodnota do řádku
    /// - Returns: true - řádek bude mít po vložení hodnoty stále unikátní čísla / false jinak
    private static func rowCheck(cells: [[Cell]], row: Int, value: Int) -> Bool {
        let columnCount: Int = cells[0].count   // počet sloupců
        
        for i in 0..<columnCount {
            if (cells[row][i].getValue() == value) {
                // hodnota už v řádku je
                return false
            }
        }
        
        return true
    }
    
    /// Zkontroluje, zda jsou čísla ve sloupci unikátní.
    /// - Parameters:
    ///   - cells: 2D mřížka
    ///   - column: index sloupce
    ///   - value: nově vkládaná hodnota do sloupce
    /// - Returns: true - sloupec bude mít po vložení hodnoty stále unikátní čídla / false jinak
    private static func columnCheck(cells: [[Cell]], column: Int, value: Int) -> Bool {
        let rowCount: Int = cells.count // počet řádků
        
        for i in 0..<rowCount {
            if (cells[i][column].getValue() == value) {
                // hodnota už ve sloupci je
                return false
            }
        }
        
        return true
    }
    
    /// Zkontroluje, zda jsou čísla v boxu unikátní.
    /// - Parameters:
    ///   - cells: 2D mřížka
    ///   - row: index řádku
    ///   - column: index sloupce
    ///   - value: nově vkládaná hodnota na pozici
    /// - Returns: true - box bude mít po vložení hodnoty stále unikátní čísla / false jinak
    private static func boxCheck(cells: [[Cell]], row: Int, column: Int, value: Int) -> Bool {
        let boxStartRow: Int = row - (row % 3)  // řádek levého horního rohu boxu
        let boxStartColumn: Int = column - (column % 3) // sloupec levého horního rohu boxu
        
        // box má rozsah 3x3 buňky
        for i in boxStartRow..<(boxStartRow + 3) {
            for j in boxStartColumn..<(boxStartColumn + 3) {
                if (cells[i][j].getValue() == value) {
                    // hodnota už v boxu je
                    return false
                }
            }
        }
        
        return true
    }
}

