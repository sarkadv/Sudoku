import AVFoundation

/// spravuje přehrávání zvuku
class AudioManager: ObservableObject {
    /// jedináček
    public static let instance = AudioManager()
    
    /// je právě puštěná hudba? (observable atribut)
    @Published public var isPlaying = false
    
    /// aktuálně vybraná hudba (observable atribut)
    @Published public var currentMusic: AudioType = .forest
    
    /// přehrávač
    private var audioPlayer: AVAudioPlayer?
    
    /// cache s načtenými soubory zvuků
    private var cache: [AudioType : URL]
    
    private init() {
        self.cache = [:]
        
        // načtení všech zvuků do cache
        for audio in AudioType.allCases {
            self.cache[audio] = Bundle.main.url(forResource: audio.toString(), withExtension: "mp3")
        }
    }
    
    /// Zastaví / znovu spustí hudbu.
    public func toggleMusic() -> Void {
        if (self.isPlaying) {
            self.stopMusic()
        }
        else {
            self.startCurrentMusic()
        }
    }
    
    
    /// Spustí právě vybranou hudbu.
    public func startCurrentMusic() -> Void {
        self.startMusic(audio: self.currentMusic)
    }
    
    /// Spustí hudbu vybranou parametrem.
    /// - Parameter audio: vybraná hudba
    public func startMusic(audio: AudioType) -> Void {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: self.cache[audio]!)
        }
        catch {
            print("Error playing audio: \(error.localizedDescription)")
            return
        }
        
        self.audioPlayer!.numberOfLoops = -1    // nekonečná smyčka
        self.audioPlayer!.play()
        
        self.currentMusic = audio
        self.isPlaying = true

    }
    
    /// Pozastaví hudbu bez změny stavu, zda je hudba puštěná,
    public func muteMusic() -> Void {
        self.audioPlayer?.stop()
    }
    
    /// Pokud je podle atributu hudba puštěná, bude nyní znovu slyšitelná.
    public func unmuteMusic() -> Void {
        if (self.isPlaying) {
            self.startCurrentMusic()
        }
    }
    
    /// Zastaví hudbu.
    public func stopMusic() -> Void {
        self.audioPlayer?.stop()
        self.isPlaying = false
    }
}

