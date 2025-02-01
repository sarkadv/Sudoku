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
    
}

