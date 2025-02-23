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
        
        // tužka aktivní, je přidáván kandidát
        if (!pencilActive) {
            if (self.cells[row!][column!].getValue() == value) {
                // kandidát se již v buňce nachází -> odstranění
                self.cells[row!][column!].setValue(value: 0)
            }
            else {
                // přidání kandidáta
                self.cells[row!][column!].setValue(value: value)
            }
        }
        // tužka neaktivní, přidávána výsledná hodnota
        else {
            if (self.cells[row!][column!].getCandidates().contains(value)) {
                // hodnota se již v buňce nachází -> odstranění
                self.cells[row!][column!].removeCandidate(candidate: value)
            }
            else {
                // přidání hodnoty
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
    
    
    private func signalizeChange() -> Void {
        self.change += 1
    }
    
}

