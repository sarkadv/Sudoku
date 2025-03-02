class TimeHelper {
    public static func getTimeString(seconds: Int) -> String {
        let minutes = seconds / 60
        let secondsLeft = seconds % 60
        
        // %d = integer, 02 = právě dvě číslice, nula zleva pokud potřeba
        return String(format: "%02d:%02d", minutes, secondsLeft)
    }
}

