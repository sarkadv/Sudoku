import Foundation

class Cell: ObservableObject
{
    /// správné řešení buňky
    private var solution: Int
    
    /// aktuální hodnota buňky (0 pokud prázdná)
    private var value: Int
    
    /// uživatelem vybraní kandidáti na hodnotu buňky
    private var candidates: Set<Int>
    
    /// řádek buňky
    private var row: Int
    /// sloupec buňky
    private var column: Int
    
    /// u předvyplněných buněk nemůže uživatel změnit hodnotu
    private var preFilled: Bool
    
    /// je buňka uživatelem zvýrazněná?
    private var highlighted: Bool
    
    public init(row: Int, column: Int, solution: Int, value: Int,preFilled: Bool, candidates: Set<Int> = [], highlighted: Bool = false) {
        self.row = row
        self.column = column
        self.solution = solution
        self.value = value
        self.preFilled = preFilled
        self.candidates = candidates
        self.highlighted = highlighted
    }
    
    public func addCandidate(candidate: Int) -> Void {
        self.candidates.insert(candidate)
    }
    
    public func removeCandidate(candidate: Int) -> Void {
        self.candidates.remove(candidate)
    }
    
    public func getRow() -> Int {
        return self.row
    }
    
    public func getColumn() -> Int {
        return self.column
    }
    
    public func setValue(value: Int) -> Void {
        self.value = value
        self.candidates = []
    }
    
    public func getValue() -> Int {
        return self.value
    }
    
    public func getCandidates() -> Set<Int> {
        return self.candidates
    }
    
    public func isPreFilled() -> Bool {
        return self.preFilled
    }
    
    public func setPreFilled(preFilled: Bool) -> Void {
        self.preFilled = preFilled
    }
    
    public func isHighlighted() -> Bool {
        return self.highlighted
    }
    
    public func setHighlighted(highlighted: Bool) -> Void {
        self.highlighted = highlighted
    }
    
    public func isCorrect() -> Bool {
        return self.value == self.solution
    }
}

