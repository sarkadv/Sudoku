import Foundation
import Combine

/// Třída představuje timer pro časování aktuálního sudoku.
class GameTimer: ObservableObject {
    /// uběhlý čas za aktuální sudoku
    @Published private var elapsedTime = 0
    
    /// timer aktivní / vypnutý
    @Published private var isOn = false
    
    /// objekt generující událost každou sekundu
    private var timer: AnyCancellable?

    public func start() -> Void {
        if (self.isOn) {
            // timer už zapnutý
            return
        }
        
        self.isOn = true
        
        self.timer = Timer.publish(every: 1, on: .main, in: .common)    // objekt pro generování události běží v hlavním vlákně
            .autoconnect()  // zapnutí timeru
            .sink { _ in    // odebírá událost, zavolá funkci pro inkrementaci elapsedTime
                self.elapsedTime += 1
            }
    }
    
    public func getTimeString() -> String {
        let minutes = self.elapsedTime / 60
        let seconds = self.elapsedTime % 60
        
        // %d = integer, 02 = právě dvě číslice, nula zleva pokud potřeba
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public func stop() -> Void {
        self.timer?.cancel()    // resetuje generátor událostí
        self.timer = nil    // nastavení na nil pro umožnění příštího zapnutí
        
        self.isOn = false
    }
    
    public func reset() -> Void {
        self.stop()
        self.elapsedTime = 0
    }
    
    public func pause() -> Void {
        self.isOn = false
    }

    public func resume() -> Void {
        self.isOn = true
    }
}

