import Foundation

class Cell
{
    /// aktuální hodnota buňky (0 pokud prázdná)
    private var value: Int
    /// uživatelem vybraní kandidáti na hodnotu buňky
    private var candidates: Set<Int>
    /// správné řešení buňky
    private var solution: Int
    
    /// řádek buňky
    private var row: Int
    /// sloupec buňky
    private var column: Int
    
    /// z předvyplněných buněk nemůže uživatel vymazat hodnotu
    private var deletable: Bool
    
    public init(row: Int, column: Int, value: Int = 0, candidates: Set<Int> = [], solution: Int = 0, deletable: Bool = false) {
        self.row = row
        self.column = column
        self.value = value
        self.candidates = candidates
        self.solution = solution
        self.deletable = deletable
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
    
    public func getSolution() -> Int {
        return self.solution
    }
    
    public func setSolution(solution: Int) -> Void {
        self.solution = solution
    }
    
    public func getDeletable() -> Bool {
        return self.deletable
    }
    
    public func setDeletable(deletable: Bool) -> Void {
        self.deletable = deletable
    }
}

