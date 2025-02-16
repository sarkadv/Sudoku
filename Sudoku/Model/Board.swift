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
    
    /// Konstruktor pro vytvoření instance sudoku mřížky.
    /// Mřížka je vytvořena prázdná a je později naplněna metodou generate().
    public init() {
        self.cells = []
        self.change = 0
    }
    
    /// Vygeneruje sudoku mřížku připravenou ke hře.
    /// - Parameter difficulty: obtížnost vygenerované mřížky
    public func generate(difficulty: Difficulty) {
        // vygenerování sudoku ke hře
        self.cells = SudokuGenerator.generatePlayableSudoku(difficulty: difficulty)
        
    }
    
    public func addCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].addCandidate(candidate: candidate)
        self.signalizeChange()
    }
    
    public func removeCandidate(row: Int, column: Int, candidate: Int) -> Void {
        self.cells[row][column].removeCandidate(candidate: candidate)
        self.signalizeChange()
    }
    
    public func setValue(row: Int?, column: Int?, value: Int) -> Void {
        if (row == nil || column == nil) {
            return
        }
        
        if (self.cells[row!][column!].isPreFilled()) {
            return
        }

        self.cells[row!][column!].setValue(value: value)
        self.signalizeChange()
    }
    
    public func getValue(row: Int, column: Int) -> Int {
        return self.cells[row][column].getValue()
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
    
    
    private func signalizeChange() -> Void {
        self.change += 1
    }
    
}

