import Foundation

/// celá sudoku mřížka
class Board: ObservableObject
{
    /// počet řádek
    public let ROWS = 9
    /// počet sloupců
    public let COLUMNS = 9
    
    /// 2D mřížka tvořená buňkami
    private var cells: [[Cell]]
    
    /// observed atribut, při změně je mřížka překreslena
    @Published private var change: Int
    
    /// objekt pro získávání sudoku mřížek připravených ke hře
    private let fetcher: SudokuFetcher
    
    /// Konstruktor pro vytvoření instance sudoku mřížky.
    /// Mřížka je vytvořena prázdná a je později naplněna metodou generate().
    public init() {
        self.cells = []
        self.change = 0
        self.fetcher = SudokuFetcher()
    }
    
    /// Vygeneruje sudoku mřížku připravenou ke hře.
    /// - Parameter difficulty: obtížnost vygenerované mřížky
    public func generate(difficulty: Difficulty) async -> Void {
        let result: [[Cell]]
        // vytvoření sudoku ke hře
        await result = self.fetcher.fetchPuzzle(difficulty: difficulty)
        
        self.cells = result
    }
    
    /// Vezme z perzistentního úložiště rozehranou uloženou hru.
    /// - Returns: Void
    public func continueGame() -> Void {
        self.cells = self.fetcher.fetchContinueGame()
    }
    
    /// Přidá / odstraní z buňky hodnotu / kandidáta. K odstranění dojde pokud se již číslo v dané buňce nachází.
    /// - Parameters:
    ///   - row: řádek buňky
    ///   - column: sloupec buňky
    ///   - value: přidávaná hodnota / kandidát
    ///   - pencilActive: true - přidávané číslo je kandidát / false - přidávané číslo je hodnota
    /// - Returns: Void
    public func fill(row: Int?, column: Int?, value: Int, pencilActive: Bool = false) -> Void {
        if (row == nil || column == nil) {
            return
        }
        
        // předvyplněné buňky nelze modifikovat
        if (self.cells[row!][column!].isPreFilled()) {
            return
        }
        
        // tužka neaktivní, přidávána výsledná hodnota
        if (!pencilActive) {
            if (self.cells[row!][column!].getValue() == value) {
                // hodnota se již v buňce nachází -> odstranění
                self.cells[row!][column!].setValue(value: 0)
            }
            else {
                // přidání hodnoty
                self.cells[row!][column!].setValue(value: value)
                
                // pokud je uživatelem zadaná hodnota správně
                if (self.cells[row!][column!].getSolution() == value) {
                    
                    // odstranění kanditátů se stejnou hodnotou z viditelných buněk
                    self.removeVisibleCellsCandidate(row: row!, column: column!, value: value)
                }
            }
        }
        
        // tužka aktivní, je přidáván kandidát
        else {
            if (self.cells[row!][column!].getCandidates().contains(value)) {
                // kandidát se již v buňce nachází -> odstranění
                self.cells[row!][column!].removeCandidate(candidate: value)
            }
            else {
                // přidání kandidáta
                self.cells[row!][column!].addCandidate(candidate: value)
            }
        }
        
        self.signalizeChange()
    }
    
    /// Použije nástroj zvýraznění na buňku. Jestliže buňka aktuálně není zvýrazněná, bude zvýrazněna a naopak.
    /// - Parameters:
    ///   - row: aktuálně vybraný řádek
    ///   - column: aktuálně vybraný sloupec
    /// - Returns: Void
    public func highlight(row: Int?, column: Int?) -> Void {
        if (row == nil || column == nil) {
            return
        }
        
        let currentHighlighted: Bool = self.cells[row!][column!].isHighlighted()
        self.cells[row!][column!].setHighlighted(highlighted: !currentHighlighted)  // boolean zvýraznění je přehozen
        self.signalizeChange()
    }
    
    /// Odstraní zvýraznění ze všech buněk.
    /// - Returns: Void
    public func removeAllHighlights() -> Void {
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                self.cells[row][column].setHighlighted(highlighted: false)
            }
        }
        self.signalizeChange()
    }
    
    public func getValue(row: Int, column: Int) -> Int {
        return self.cells[row][column].getValue()
    }
    
    public func getCandidates(row: Int, column: Int) -> Set<Int> {
        return self.cells[row][column].getCandidates()
    }
    
    public func isPreFilled(row: Int?, column: Int?) -> Bool {
        if (row == nil || column == nil) {
            return false
        }
        
        return self.cells[row!][column!].isPreFilled()
    }
    
    public func isHighlighted(row: Int, column: Int) -> Bool {
        return self.cells[row][column].isHighlighted()
    }
    
    public func isCorrect(row: Int, column: Int) -> Bool {
        return self.cells[row][column].isCorrect()
    }
    
    /// Zkontroluj
    /// - Returns: true - všechny buňky správně vyplněné (výhra) / jinak false
    public func isWin() -> Bool {
        for i in 0..<self.ROWS {
            for j in 0..<self.COLUMNS {
                if (!self.cells[i][j].isCorrect()) {
                    return false
                }
            }
        }
        
        return true
    }
    
    /// Vrátí souřadnice buněk viditelné z buňky dané parametrem.
    /// Buňka je pro jinou buňku viditelná, jestliže se nachází ve stejném boxu, sloupci, nebo řádku.
    /// - Parameters:
    ///   - row: řádek buňky
    ///   - column: sloupec buňky
    /// - Returns: souřadnice viditelných buněk z buňky dané parametrem
    public func getVisibleCellCoords(row: Int?, column: Int?) -> [(Int, Int)] {
        if (row == nil || column == nil) {
            return []
        }
        
        var result: [(Int, Int)] = []
        
        let boxStartRow: Int = row! - (row! % 3)  // řádek levého horního rohu boxu
        let boxStartColumn: Int = column! - (column! % 3) // sloupec levého horního rohu boxu
        
        for i in 0..<self.ROWS {
            for j in 0..<self.COLUMNS {
                // test sloupce nebo řádku
                if (row == i || column == j) {
                    result.append((i, j))
                }

                // test boxu
                if ((i - boxStartRow < 3 && i - boxStartRow >= 0) &&
                    (j - boxStartColumn < 3 && j - boxStartColumn >= 0)) {
                    result.append((i, j))
                }
            }
        }
        
        return result
    }
    
    /// - Returns: aktuální hodnota buněk jako 2D pole čísel
    public func getValueAs2DArray() -> [[Int]] {
        var result: [[Int]] = []
        
        for i in 0..<self.ROWS {
            var row: [Int] = []
            
            for j in 0..<self.COLUMNS {
                row.append(self.cells[i][j].getValue())
            }
            
            result.append(row)
        }
        
        return result
    }
    
    /// - Returns: řešení buněk jako 2D pole čísel
    public func getSolutionAs2DArray() -> [[Int]] {
        var result: [[Int]] = []
        
        for i in 0..<self.ROWS {
            var row: [Int] = []
            
            for j in 0..<self.COLUMNS {
                row.append(self.cells[i][j].getSolution())
            }
            
            result.append(row)
        }
        
        return result
    }
    
    /// - Returns: počáteční hodnota buněk jako 2D pole čísel
    public func getStarterValuesAs2DArray() -> [[Int]] {
        var result: [[Int]] = []
        
        for i in 0..<self.ROWS {
            var row: [Int] = []
            
            for j in 0..<self.COLUMNS {
                let value: Int = self.cells[i][j].isPreFilled() ? self.cells[i][j].getValue() : 0
                row.append(value)
            }
            
            result.append(row)
        }
        
        return result
    }
    
    /// - Returns: kandidáti buněk jako 3D pole čísel, buňky bez kandidátů obsahují pouze číslo 0
    public func getCandidatesAs3DArray() -> [[[Int]]] {
        var result: [[[Int]]] = []
        
        for i in 0..<self.ROWS {
            var row: [[Int]] = []
            
            for j in 0..<self.COLUMNS {
                let candidates: [Int] = Array(self.cells[i][j].getCandidates())
                
                if (candidates.count > 0) {
                    // buňka má kandidáty
                    row.append(candidates)
                }
                else {
                    // buňka nemá kandidáty
                    row.append([0])
                }
                
            }
            
            result.append(row)
        }
        
        return result
    }
    
    /// Odstraní kanditáty se stejnou hodnotou z buněk viditelných z buňky dané parametrem.
    /// - Parameters:
    ///   - row: řádek buňky
    ///   - column: sloupec buňky
    ///   - value: hodnota k odstranění
    /// - Returns: Void
    private func removeVisibleCellsCandidate(row: Int, column: Int, value: Int) -> Void {
        let visibleCellCoords: [(Int, Int)] = self.getVisibleCellCoords(row: row, column: column)
        
        for coords in visibleCellCoords {
            let row = coords.0
            let column = coords.1
            
            self.cells[row][column].removeCandidate(candidate: value)
        }
    }
    
    /// Signalizuje změnu stavu mřížky, aby došlo k překreslení v GameView.
    /// - Returns: Void
    private func signalizeChange() -> Void {
        self.change += 1
    }
    
}

