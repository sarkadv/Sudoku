class TimeScore {
    private let seconds: Int
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    public func getSeconds() -> Int {
        return self.seconds
    }
    
    public func getTimeString() -> String {
        let minutes = self.seconds / 60
        let seconds = self.seconds % 60
        
        // %d = integer, 02 = právě dvě číslice, nula zleva pokud potřeba
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

