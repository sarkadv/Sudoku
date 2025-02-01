class Cell
{
    private var value: Int
    private var candidates: [Int]
    
    public init(value: Int) {
        self.value = value
        self.candidates = []
    }
    
    public func setValue(value: Int) -> Void {
        self.value = value
    }
    
    public func getValue() -> Int {
        return self.value
    }
    
    public func getCandidates() -> [Int] {
        return self.candidates
    }
    
    public func addCandidate(candidate: Int) -> Void {
        if (candidate < 1 || candidate > 9) {
            return
        }
        
        if (!self.candidates.contains(candidate)) {
            self.candidates.append(candidate)
        }
    }
    
    public func removeCandidate(candidate: Int) -> Void {
        if (candidate < 1 || candidate > 9) {
            return
        }
        
        let index: Int? = self.candidates.firstIndex(of: candidate)
        
        if (index != nil) {
            self.candidates.remove(at: index!)
        }
    }
    
}

