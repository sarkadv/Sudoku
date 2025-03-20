import SwiftUI

/// zobrazení herního pole
struct GameView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// pokračování v minulé nedohrané hře?
    @Binding var continuingGame: Bool
    /// aktuální sudoku mřížka - observed object, při změně je překreslena mřížka
    @EnvironmentObject var board: Board
    
    /// souřadnice uživatelem vybrané buňky
    @State private var selectedRow: Int? = nil
    @State private var selectedColumn: Int? = nil
    
    /// je aktivní nástroj tužka?
    @State private var pencilActive: Bool = false
    
    /// timer pro čas řešení aktuálního sudoku
    @StateObject private var timer = GameTimer()
    /// čas v sekundách poslední dohrané hry
    @Binding var finalScoreSeconds: Int
    
    /// orientace zařízení
    @Binding var orientation: UIDeviceOrientation
    
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// aplikace v popředí / pozadí
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    var body: some View {
        let cellSize: CGFloat = isPhone ? 35.0 : 65.0   // velikost buňky
        let borderWidth: CGFloat = isPhone ? 1.0 : 2.0  // šířka ohraničení
        let valueFontSize: CGFloat = isPhone ? 24.0 : 40.0  // velikost číselné hodnoty buňky
        let candidatesFontSize: CGFloat = isPhone ? 8 : 16.0  // velikost kandidátů na hodnotu buňky
        let candidatesHSpacing: CGFloat = isPhone ? 3.5 : 8.0   // horizontální prostor mezi kandidáty
        let toolsPadding: CGFloat = isPhone ? 40.0 : 80.0     // padding nástrojů
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        let buttonWidth: CGFloat = isPhone ? 125.0 : 175.0  // šířka tlačítek
        let buttonHeight: CGFloat = isPhone ? 40.0 : 50.0     // výška tlačítek
        let timerFont: Font = isPhone ? .headline : .title
        
        let visibleCellCoords: [(Int, Int)] = self.getVisibleCellCoords()   // souřadnice buněk viditelných z vybrané buňky uživatelem
        
        // landscape mode - hlavní Stack je HStack
        if (orientation.isLandscape) {
            HStack {
                VStack (spacing: 0) {
                    MenuButton(buttonWidth: buttonWidth,
                               buttonHeight: buttonHeight,
                               cornerRadius: cornerRadius,
                               setState: self.setState,
                               saveGame: self.saveGame)
                    .padding(.bottom)
                    
                    AudioMenuView(buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              cornerRadius: cornerRadius)
                    .padding(.top)
                }
                VStack (spacing: 0) {
                    ForEach(0..<self.board.ROWS, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0..<self.board.COLUMNS, id: \.self) { column in
                                // číselná hodnota buňky
                                let value: Int = self.board.getValue(row: row, column: column)
                                
                                // kandidáti na hodnotu buňky
                                let candidates: Set<Int> = self.board.getCandidates(row: row, column: column)
                                
                                // velikost textu podle existence hodnoty / kandidátů
                                let fontSize: CGFloat = value == 0 ? candidatesFontSize : valueFontSize
                                
                                // je buňka uživatelem zvýrazněná?
                                let highlighted: Bool = self.board.isHighlighted(row: row, column: column)
                                
                                // je buňka viditelná z uživatelem vybrané buňky?
                                let visible: Bool = visibleCellCoords.contains(where: {$0 == (row, column)})
                                
                                // je uživatelem určená hodnota správně?
                                let correct: Bool = self.board.isCorrect(row: row, column: column)
                                
                                // vykreslení jedné buňky
                                SudokuCellView(value: value,
                                               candidates: candidates,
                                               fontSize: fontSize,
                                               cellSize: cellSize,
                                               borderWidth: borderWidth,
                                               candidatesHSpacing: candidatesHSpacing,
                                               row: row,
                                               column: column,
                                               selectedRow: self.selectedRow,
                                               selectedColumn: self.selectedColumn,
                                               selectedNumber: self.getSelectedNumber(),
                                               highlighted: highlighted,
                                               visible: visible,
                                               correct: correct)
                                
                                // událost při kliknutí na buňku
                                .onTapGesture {
                                    // update vybrané buňky
                                    self.selectedRow = row
                                    self.selectedColumn = column
                                }
                            }
                        }
                    }
                }
                .padding(toolsPadding)
                
                VStack {
                    TimerText(elapsedTime: self.timer.getElapsedTime(), timerFont: timerFont)
                    
                    ToolsView(fontSize: valueFontSize,
                              cellSize: cellSize,
                              borderWidth: borderWidth,
                              toolsPadding: toolsPadding,
                              cornerRadius: cornerRadius,
                              pencilActive: self.pencilActive,
                              difficulty: self.difficulty,
                              board: self.board,
                              selectedRow: self.selectedRow,
                              selectedColumn: self.selectedColumn,
                              setPencilActive: self.setPencilActive,
                              setState: self.setState,
                              setFinalScoreSeconds: self.setFinalScoreSeconds,
                              elapsedTime: self.timer.getElapsedTime(),
                              orientation: self.orientation)
                    .padding(.top, toolsPadding/2)
                }
            }
            .onAppear {
                self.timer.start(elapsedTime: self.continuingGame ? StorageManager.instance.getContinueGameTime() : self.timer.getElapsedTime())
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                self.handleScenePhaseChange(newPhase: newPhase)
            }
        }
        // portrait mode - hlavní Stack je VStack
        else {
            VStack {
                HStack {
                    MenuButton(buttonWidth: buttonWidth,
                               buttonHeight: buttonHeight,
                               cornerRadius: cornerRadius,
                               setState: self.setState,
                               saveGame: self.saveGame)
                    
                    AudioMenuView(buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              cornerRadius: cornerRadius)
                }
                .padding(.top, toolsPadding)
                
                TimerText(elapsedTime: self.timer.getElapsedTime(), timerFont: timerFont)
                    .padding(.top, toolsPadding)
                
                VStack (spacing: 0) {
                    ForEach(0..<self.board.ROWS, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0..<self.board.COLUMNS, id: \.self) { column in
                                // číselná hodnota buňky
                                let value: Int = self.board.getValue(row: row, column: column)
                                
                                // kandidáti na hodnotu buňky
                                let candidates: Set<Int> = self.board.getCandidates(row: row, column: column)
                                
                                // velikost textu podle existence hodnoty / kandidátů
                                let fontSize: CGFloat = value == 0 ? candidatesFontSize : valueFontSize
                                
                                // je buňka uživatelem zvýrazněná?
                                let highlighted: Bool = self.board.isHighlighted(row: row, column: column)
                                
                                // je buňka viditelná z uživatelem vybrané buňky?
                                let visible: Bool = visibleCellCoords.contains(where: {$0 == (row, column)})
                                
                                // je uživatelem určená hodnota správně?
                                let correct: Bool = self.board.isCorrect(row: row, column: column)
                                
                                // vykreslení jedné buňky
                                SudokuCellView(value: value,
                                               candidates: candidates,
                                               fontSize: fontSize,
                                               cellSize: cellSize,
                                               borderWidth: borderWidth,
                                               candidatesHSpacing: candidatesHSpacing,
                                               row: row,
                                               column: column,
                                               selectedRow: self.selectedRow,
                                               selectedColumn: self.selectedColumn,
                                               selectedNumber: self.getSelectedNumber(),
                                               highlighted: highlighted,
                                               visible: visible,
                                               correct: correct)
                                
                                // událost při kliknutí na buňku
                                .onTapGesture {
                                    // update vybrané buňky
                                    self.selectedRow = row
                                    self.selectedColumn = column
                                }
                            }
                        }
                    }
                }
                .padding(toolsPadding)
                
                ToolsView(fontSize: valueFontSize,
                          cellSize: cellSize,
                          borderWidth: borderWidth,
                          toolsPadding: toolsPadding,
                          cornerRadius: cornerRadius,
                          pencilActive: self.pencilActive,
                          difficulty: self.difficulty,
                          board: self.board,
                          selectedRow: self.selectedRow,
                          selectedColumn: self.selectedColumn,
                          setPencilActive: self.setPencilActive,
                          setState: self.setState,
                          setFinalScoreSeconds: self.setFinalScoreSeconds,
                          elapsedTime: self.timer.getElapsedTime(),
                          orientation: self.orientation)
                .padding(toolsPadding)
            }
            .onAppear {
                self.timer.start(elapsedTime: self.continuingGame ? StorageManager.instance.getContinueGameTime() : self.timer.getElapsedTime())
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(newPhase: newPhase)
            }
        }
    }
    
    /// Vrátí hodnotu v buňce vybrané uživatelem nebo nil.
    /// - Returns: hodnota v buňce vybrané uživatelem / nil pokud uživatel nemá vybranou buňku nebo vybraná buňka nemá hodnotu
    private func getSelectedNumber() -> Int? {
        var selectedNumber: Int? = nil
        
        if (self.selectedRow != nil && self.selectedColumn != nil) {
            // uživatel má vybranou buňku
            selectedNumber = self.board.getValue(row: self.selectedRow!, column: self.selectedColumn!)
        }
        
        if (selectedNumber == 0) {
            // buňka nemá hodnotu
            return nil
        }
        
        return selectedNumber
    }
    
    /// - Returns: souřadnice buněk viditelných z vybrané buňky uživatelem
    private func getVisibleCellCoords() -> [(Int, Int)] {
        // souřadnice buněk viditelných z vybrané buňky uživatelem
        return self.board.getVisibleCellCoords(row: self.selectedRow, column: self.selectedColumn)
    }
    
    /// Pozastaví / nastartuje časovač a uloží hru podle toho, zda je byla aplikace dána do pozadí / popředí.
    /// - Parameter newPhase: aplikace v popředí / pozadí
    /// - Returns: Void
    private func handleScenePhaseChange(newPhase: ScenePhase) -> Void {
        if (newPhase == .background) {
            self.timer.pause()
            self.saveGame()
            AudioManager.instance.muteMusic()
        }
        else if (newPhase == .active) {
            self.timer.resume()
            AudioManager.instance.unmuteMusic()
        }
    }
    
    /// Uloží nedohranou hru do perzistentního úložiště.
    /// - Returns: Void
    private func saveGame() -> Void {
        StorageManager.instance.addStoredGame(gameStarterValues: self.board.getStarterValuesAs2DArray(),
                                              gameValue: self.board.getValueAs2DArray(),
                                              gameSolution: self.board.getSolutionAs2DArray(),
                                              candidates: self.board.getCandidatesAs3DArray(),
                                              difficulty: self.difficulty,
                                              timeSeconds: self.timer.getElapsedTime())
    }
    
    private func setState(state: ViewState) -> Void {
        self.state = state
    }
    
    private func setDifficulty(difficulty: Difficulty) -> Void {
        self.difficulty = difficulty
    }
    
    private func setPencilActive(pencilActive: Bool) -> Void {
        self.pencilActive = pencilActive
    }
    
    private func setFinalScoreSeconds(finalScoreSeconds: Int) -> Void {
        self.finalScoreSeconds = finalScoreSeconds
    }
}

struct TimerText: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    let elapsedTime: Int
    let timerFont: Font
    
    var body: some View {
        Text(TimeHelper.getTimeString(seconds: elapsedTime))
            .bold()
            .font(timerFont)
            .foregroundStyle(self.colorModeManager.getFontColor())
    }
}

/// tlačítko pro návrat do Menu
struct MenuButton: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let cornerRadius: CGFloat
    
    /// callback pro změnu stavu aplikace
    let setState: (ViewState) -> Void
    
    /// callback pro uložení nedohrané hry
    let saveGame: () -> Void
    
    var body: some View {
        Button(action: {
            self.saveGame()
            self.setState(.menu)
            AudioManager.instance.stopMusic()
        }) {
            Text(LocalizedStringKey(ButtonType.menu.toString()))
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(self.colorModeManager.getButtonColor(type: .menu))
                .foregroundColor(.white)
                .cornerRadius(cornerRadius)
        }
    }
}


/// zobrazení jedné buňky
struct SudokuCellView: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// číselná hodnota buňky
    let value: Int
    /// kandidáti na hodnotu buňky
    let candidates: Set<Int>
    /// velikost textu v buňce
    let fontSize: CGFloat
    /// velikost buňly
    let cellSize: CGFloat
    /// šířka ohraničení
    let borderWidth: CGFloat
    /// horizontální prostor mezi kandidáty
    let candidatesHSpacing: CGFloat
    
    /// souřadnice buňky
    let row: Int
    let column: Int
    
    /// souřadnice uživatelem vybrané buňky
    let selectedRow: Int?
    let selectedColumn: Int?
    
    /// hodnota v uživatelem vybrané buňce
    let selectedNumber: Int?
    
    /// je buňka uživatelem zvýrazněná?
    let highlighted: Bool
    /// je buňka viditelná z uživatelem vybrané buňky?
    let visible: Bool
    /// je uživatelem určená hodnota správně?
    let correct: Bool
    
    var body: some View {
        let backgroundColor: Color = self.determineCellColor()  // barva pozadí buňky
        
        let valueColor: Color = self.determineValueColor()  // barva hodnoty buňky
        
        let finalBorderColor: Color = self.highlighted ? COLOR_HIGHLIGHT : self.colorModeManager.getBorderColor()
        let finalBorderWidth: CGFloat = self.highlighted ? self.borderWidth * 2 : borderWidth   // barva hranic buňky
        
        ZStack {
            if value != 0 {
                // buňka má danou hodnotu
                Text("\(value)")
                    .foregroundStyle(valueColor)
            }
            else {
                // buňka nemá hodnotu -> zobrazení 3x3 mřížky pro kandidáty
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: candidatesHSpacing) {
                            ForEach(0..<3, id: \.self) { col in
                                let number: Int = row * 3 + col + 1 // kandidát
                                let numberOpacity: CGFloat = candidates.contains(number) ? 1.0 : 0.0
                                
                                // kandidát je zvýrazněn pokud má stejné číslo jako uživatelem právě vybraná buňka
                                let fontColor: Color = self.determineCandidateFontColor(number: number)
                                
                                // kandidát zobrazen jen pokud je v množině kandidátů
                                Text("\(number)")
                                    .opacity(numberOpacity)
                                    .bold()
                                    .foregroundStyle(fontColor)
                            }
                        }
                    }
                }
            }
        }
        .font(.system(size: fontSize))
        .frame(width: cellSize, height: cellSize)
        .multilineTextAlignment(.center)
        .border(finalBorderColor, width: finalBorderWidth)
        .background(backgroundColor)
    }
    
    /// - Parameter number: kandidát
    /// - Returns: barva jednoho kandidáta v buňce
    private func determineCandidateFontColor(number: Int) -> Color {
        return (number == self.selectedNumber) ? COLOR_SAME_NUMBER : self.colorModeManager.getFontColor()
    }
    
    /// - Returns: barva hodnoty buňky
    private func determineValueColor() -> Color {
        // hodnota je zvýrazněna pokud má stejné číslo jako uživatelem právě vybraná buňka
        let valueColor: Color = (self.value == self.selectedNumber) ? COLOR_SAME_NUMBER : self.colorModeManager.getFontColor()
        
        // hodnota je červeně pokud je špatně
        let finalValueColor: Color = self.correct ? valueColor : .red
        
        return finalValueColor
    }
    
    /// Určí barvu buňky podle příslušnosti k boxu a uživatelem vybrané buňky.
    /// - Returns: barva buňky
    private func determineCellColor() -> Color {
        let color1: Color = colorModeManager.getCellColor(type: true)
        let color2: Color = colorModeManager.getCellColor(type: false)
        
        // barva buňky vybrané uživatelem
        let selectedColor: Color = colorModeManager.getSelectedCellColor()
        
        // barva pro sloupec, řádek a sloupec příslušícím vybrané buňce
        let neighborColor: Color = colorModeManager.getNeighborCellColor()
        
        // pokud je buňka vybraná uživatelem
        if (self.row == self.selectedRow && self.column == self.selectedColumn) {
            return selectedColor
        }
        
        // zvýraznění buňky, pokud se nachází ve stejném sloupci / řádku / boxu jako vybraná buňka
        if (self.visible) {
            return neighborColor
        }
        
        // určení barvy podle příslušnosti buňky k boxu
        if (self.row <= 2) {
            if (self.column <= 2) {
                return color1
            }
            else if (self.column <= 5) {
                return color2
            }
            else {
                return color1
            }
        }
        else if (self.row <= 5) {
            if (self.column <= 2) {
                return color2
            }
            else if (self.column <= 5) {
                return color1
            }
            else {
                return color2
            }
        }
        else {
            if (self.column <= 2) {
                return color1
            }
            else if (self.column <= 5) {
                return color2
            }
            else {
                return color1
            }
        }
    }
}

// zobrazení nástrojů
struct ToolsView: View {
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    /// velikost textu v buňce
    let fontSize: CGFloat
    /// velikost buňly
    let cellSize: CGFloat
    /// šířka ohraničení
    let borderWidth: CGFloat
    /// padding nástrojů
    let toolsPadding: CGFloat
    /// zaoblení rohů
    let cornerRadius: CGFloat
    /// je nástroj tužka aktivní?
    let pencilActive: Bool
    /// aktuální obtížnost hry
    let difficulty: Difficulty
    
    /// sudoku mřížka
    let board: Board
    /// řádek uživatelem vybrané buňky
    let selectedRow: Int?
    /// sloupec uživatelem vybrané buňky
    let selectedColumn: Int?
    /// callback pro změnu aktivnosti nástroje tužka
    let setPencilActive: (Bool) -> Void
    /// callback pro změnu stavu aplikace
    let setState: (ViewState) -> Void
    /// čas v sekundách poslední dohrané hry
    let setFinalScoreSeconds: (Int) -> Void
    /// čas aktuální hry
    let elapsedTime: Int
    
    /// orientace zařízení
    let orientation: UIDeviceOrientation
    
    var body: some View {
        let fontColor: Color = (self.board.isPreFilled(row: self.selectedRow, column: self.selectedColumn)) ? self.colorModeManager.getInactiveToolsColor() : self.colorModeManager.getFontColor()
        
        // pro předvyplněné buňky není nástroj vymazat viditelný
        let removeToolVisibility: CGFloat = (self.board.isPreFilled(row: self.selectedRow, column: self.selectedColumn)) ? 0.0 : 1.0
        
        // zvýraznění nástroje tužka, jestliže je aktivní
        let pencilToolBackground: Color = self.pencilActive ? COLOR_HIGHLIGHT : COLOR_HIGHLIGHT.opacity(0.0)
        
        VStack (spacing: toolsPadding/2) {
            // landscape mode - nástroje v boxu
            if (orientation.isLandscape) {
                VStack(spacing: toolsPadding/2) {
                    HStack(spacing: toolsPadding/2) {
                        // nástroj tužka pro kandidáty
                        Text(LocalizedStringKey("pencil_tool"))
                            .font(.system(size: fontSize))
                            .background(pencilToolBackground)
                            .cornerRadius(self.cornerRadius)
                            .onTapGesture {
                                // aktivování / deaktivování nástroje tužka
                                self.setPencilActive(!self.pencilActive)
                            }
                        
                        // nástroj zvýrazňovač
                        Text(LocalizedStringKey("highlighter_tool"))
                            .font(.system(size: fontSize))
                            .onTapGesture {
                                // zvýraznění / odstranění zvýraznění aktuálně vybrané buňky
                                self.board.highlight(row: self.selectedRow, column: self.selectedColumn)
                            }
                    }
                    HStack(spacing: toolsPadding/2) {
                        // nástroj odstranění zvýrazňovače
                        Text(LocalizedStringKey("highlighter_remove_tool"))
                            .font(.system(size: fontSize))
                            .onTapGesture {
                                // odstraní zvýraznění ze všech buněk
                                self.board.removeAllHighlights()
                            }
                        
                        // nástroj vymazat
                        Text(LocalizedStringKey("remove_tool"))
                            .font(.system(size: fontSize))
                            .opacity(removeToolVisibility)  // nastavení viditelnosti
                            .onTapGesture {
                                // odstranění hodnoty i kandidátů z buňky
                                self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: 0)
                            }
                    }
                }
            }
            
            // portrait mode - nástroje v jedné řádce
            else {
                HStack(spacing: toolsPadding) {
                    // nástroj tužka pro kandidáty
                    Text(LocalizedStringKey("pencil_tool"))
                        .font(.system(size: fontSize))
                        .background(pencilToolBackground)
                        .cornerRadius(self.cornerRadius)
                        .onTapGesture {
                            // aktivování / deaktivování nástroje tužka
                            self.setPencilActive(!self.pencilActive)
                        }
                    
                    // nástroj zvýrazňovač
                    Text(LocalizedStringKey("highlighter_tool"))
                        .font(.system(size: fontSize))
                        .onTapGesture {
                            // zvýraznění / odstranění zvýraznění aktuálně vybrané buňky
                            self.board.highlight(row: self.selectedRow, column: self.selectedColumn)
                        }
                    
                    // nástroj odstranění zvýrazňovače
                    Text(LocalizedStringKey("highlighter_remove_tool"))
                        .font(.system(size: fontSize))
                        .onTapGesture {
                            // odstraní zvýraznění ze všech buněk
                            self.board.removeAllHighlights()
                        }
                    
                    // nástroj vymazat
                    Text(LocalizedStringKey("remove_tool"))
                        .font(.system(size: fontSize))
                        .opacity(removeToolVisibility)  // nastavení viditelnosti
                        .onTapGesture {
                            // odstranění hodnoty i kandidátů z buňky
                            self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: 0)
                        }
                }
            }
            
            // landscape mode - čísla v boxu 3x3
            if (orientation.isLandscape) {
                VStack (spacing: 0) {
                    ForEach(0...2, id: \.self) { row in
                        HStack (spacing: 0) {
                            ForEach(0...2, id: \.self) { column in
                                let number: Int = row * 3 + column + 1
                                
                                Text("\(number)")
                                    .font(.system(size: fontSize))
                                    .foregroundStyle(fontColor)
                                    .frame(width: cellSize, height: cellSize)
                                    .multilineTextAlignment(.center)
                                    .border(fontColor, width: borderWidth)
                                
                                    // událost při kliknutí na číslo
                                    .onTapGesture {
                                        // vyplnění aktuálně vybrané buňky číslem
                                        self.fillValue(value: number)
                                    }
                            }
                        }
                    }
                }
            }
            
            // portrait mode - čísla v jedné řádce
            else {
                HStack (spacing: 0) {
                    ForEach(1...9, id: \.self) { i in
                        Text("\(i)")
                            .font(.system(size: fontSize))
                            .foregroundStyle(fontColor)
                            .frame(width: cellSize, height: cellSize)
                            .multilineTextAlignment(.center)
                            .border(fontColor, width: borderWidth)
                        
                            // událost při kliknutí na číslo
                            .onTapGesture {
                                // vyplnění aktuálně vybrané buňky číslem
                                self.fillValue(value: i)
                            }
                    }
                }
            }
        }
    }
    
    /// Nastaví hodnotu buňky.
    /// - Parameter value: hodnota buňky
    /// - Returns: Void
    private func fillValue(value: Int) -> Void {
        self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: value, pencilActive: self.pencilActive)
        
        if (self.board.isWin()) {
            self.handleWin()
        }
    }
    
    /// Zpracuje výhru ve hře.
    /// - Returns: Void
    private func handleWin() -> Void {
        self.setFinalScoreSeconds(self.elapsedTime)   // uložení skóre
        
        // pokud jde o nejlepší skóre pro obtížnost -> uložení do perzistentního úložiště
        StorageManager.instance.setHighscore(difficulty: self.difficulty, seconds: self.elapsedTime)
        
        // vymazání uložené hry
        StorageManager.instance.removeStoredGame()
        
        AudioManager.instance.stopMusic()
        
        self.setState(.win)   // změna obrazovky na vítěznou
    }
}

/// komponenta pro přehrávání hudby
struct AudioMenuView: View {
    /// správce hudby (observed objekt)
    @StateObject private var audioManager = AudioManager.instance
    
    /// správce barevného módu
    @StateObject private var colorModeManager: ColorModeManager = ColorModeManager.instance
    
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        HStack {
            Button(action: {
                AudioManager.instance.toggleMusic()
            }) {
                Image(systemName: AudioManager.instance.isPlaying ? "pause.fill" : "play.fill")
            }
            
            Menu {
                ForEach(AudioType.allCases, id: \.self) { sound in
                    Button(action: {
                        AudioManager.instance.startMusic(audio: sound)
                    }) {
                        Text(LocalizedStringKey(sound.toString()))
                    }
                }
            } label: {
                Text(LocalizedStringKey(AudioManager.instance.currentMusic.toString()))
                    .fixedSize(horizontal: true, vertical: false)   // celý text je zobrazen, i když není dostatek místa
            }
        }
        .padding()
        .font(.headline)
        .frame(width: self.buttonWidth, height: self.buttonHeight)
        .foregroundStyle(.white)
        .background(self.colorModeManager.getButtonColor(type: .menu))
        .cornerRadius(self.cornerRadius)
    }
    
    
}

