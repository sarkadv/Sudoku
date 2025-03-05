import SwiftUI

/// zobrazení herního pole
struct GameView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
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
    
    /// světlé / tmavé barevné schéma
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// aplikace v popředí / pozadí
    @Environment(\.scenePhase) var scenePhase: ScenePhase
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    var body: some View {
        let cellSize: CGFloat = isPhone ? 35.0 : 65.0   // velikost buňky
        let borderWidth: CGFloat = isPhone ? 1.0 : 2.0  // šířka ohraničení
        let borderColor: Color = (colorScheme == .dark) ? .white : .black   // barva ohraničení
        let valueFontSize: CGFloat = isPhone ? 24.0 : 40.0  // velikost číselné hodnoty buňky
        let candidatesFontSize: CGFloat = isPhone ? 8 : 16.0  // velikost kandidátů na hodnotu buňky
        let candidatesHSpacing: CGFloat = isPhone ? 3.5 : 8.0   // horizontální prostor mezi kandidáty
        let toolsPadding: CGFloat = isPhone ? 40.0 : 80.0     // padding nástrojů
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        let buttonWidth: CGFloat = isPhone ? 125.0 : 300.0  // šířka tlačítka menu
        let buttonHeight: CGFloat = isPhone ? 40.0 : 60.0     // výška tlačítka menu
        let buttonColor: Color = (colorScheme == .dark) ? COLOR_GRAY_DARK : COLOR_GRAY_LIGHT   // barva tlačítka menu
        let timerFont: Font = isPhone ? .headline : .title
        
        // souřadnice buněk viditelných z vybrané buňky uživatelem
        let visibleCellCoords: [(Int, Int)] = self.board.getVisibleCellCoords(row: self.selectedRow, column: self.selectedColumn)
        
        // landscape mode - hlavní Stack je HStack
        if (orientation.isLandscape) {
            HStack {
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
                                               borderColor: borderColor,
                                               candidatesHSpacing: candidatesHSpacing,
                                               row: row,
                                               column: column,
                                               selectedRow: self.selectedRow,
                                               selectedColumn: self.selectedColumn,
                                               highlighted: highlighted,
                                               visible: visible,
                                               correct: correct,
                                               colorScheme: self.colorScheme)
                                
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
                    MenuButton(buttonWidth: buttonWidth,
                               buttonHeight: buttonHeight,
                               cornerRadius: cornerRadius,
                               buttonColor: buttonColor,
                               state: $state)
                        .padding(.bottom, toolsPadding/2)
                    
                    Text(TimeHelper.getTimeString(seconds: self.timer.getElapsedTime()))
                        .bold()
                        .font(timerFont)
                    
                    ToolsView(fontSize: valueFontSize,
                              cellSize: cellSize,
                              borderWidth: borderWidth,
                              toolsPadding: toolsPadding,
                              cornerRadius: cornerRadius,
                              board: self.board,
                              selectedRow: self.selectedRow,
                              selectedColumn: self.selectedColumn,
                              pencilActive: $pencilActive,
                              state: $state,
                              difficulty: $difficulty,
                              finalScoreSeconds: $finalScoreSeconds,
                              elapsedTime: self.timer.getElapsedTime(),
                              colorScheme: self.colorScheme,
                              orientation: self.orientation)
                    .padding(.top, toolsPadding/2)
                }
            }
            .onAppear(perform: self.timer.start)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                self.handleScenePhaseChange(newPhase: newPhase)
            }
        }
        // portrait mode - hlavní Stack je VStack
        else {
            VStack {
                MenuButton(buttonWidth: buttonWidth,
                           buttonHeight: buttonHeight,
                           cornerRadius: cornerRadius,
                           buttonColor: buttonColor,
                           state: $state)
                    .padding(toolsPadding)
                
                Text(TimeHelper.getTimeString(seconds: self.timer.getElapsedTime()))
                    .bold()
                    .font(timerFont)
                
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
                                               borderColor: borderColor,
                                               candidatesHSpacing: candidatesHSpacing,
                                               row: row,
                                               column: column,
                                               selectedRow: self.selectedRow,
                                               selectedColumn: self.selectedColumn,
                                               highlighted: highlighted,
                                               visible: visible,
                                               correct: correct,
                                               colorScheme: self.colorScheme)
                                    
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
                          board: self.board,
                          selectedRow: self.selectedRow,
                          selectedColumn: self.selectedColumn,
                          pencilActive: $pencilActive,
                          state: $state,
                          difficulty: $difficulty,
                          finalScoreSeconds: $finalScoreSeconds,
                          elapsedTime: self.timer.getElapsedTime(),
                          colorScheme: self.colorScheme,
                          orientation: self.orientation)
                    .padding(toolsPadding)
            }
            .onAppear(perform: self.timer.start)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(newPhase: newPhase)
            }
        }
    }
    
    /// Pozastaví / nastartuje časovač podle toho, zda je byla aplikace dána do pozadí / popředí.
    /// - Parameter newPhase: aplikace v popředí / pozadí
    /// - Returns: Void
    private func handleScenePhaseChange(newPhase: ScenePhase) -> Void {
        if newPhase == .background {
            self.timer.pause()
        }
        else if newPhase == .active {
            self.timer.resume()
        }
    }
}

struct MenuButton: View {
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let cornerRadius: CGFloat
    let buttonColor: Color
    
    @Binding var state: ViewState
    
    var body: some View {
        Button(action: {
            self.state = .menu
        }) {
            Text("Menu")
                .font(.headline)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(cornerRadius)
        }
    }
}


/// zobrazení jedné buňky
struct SudokuCellView: View {
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
    /// barva ohraničení
    let borderColor: Color
    /// horizontální prostor mezi kandidáty
    let candidatesHSpacing: CGFloat
    
    /// souřadnice buňky
    let row: Int
    let column: Int
    
    /// souřadnice uživatelem vybrané buňky
    let selectedRow: Int?
    let selectedColumn: Int?
    
    /// je buňka uživatelem zvýrazněná?
    let highlighted: Bool
    /// je buňka viditelná z uživatelem vybrané buňky?
    let visible: Bool
    /// je uživatelem určená hodnota správně?
    let correct: Bool
    
    /// barevné schéma
    let colorScheme: ColorScheme
    
    var body: some View {
        let backgroundColor: Color = self.determineCellColor()
        let valueColor: Color = self.colorScheme == .dark ? .white : .black
        let finalValueColor: Color = self.correct ? valueColor : .red
        let finalBorderColor: Color = self.highlighted ? COLOR_HIGHLIGHT : self.borderColor
        let finalBorderWidth: CGFloat = self.highlighted ? self.borderWidth * 4 : borderWidth
        
        ZStack {
            if value != 0 {
                // buňka má danou hodnotu
                Text("\(value)")
                    .foregroundStyle(finalValueColor)
            }
            else {
                // buňka nemá hodnotu -> zobrazení 3x3 mřížky pro kandidáty
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: candidatesHSpacing) {
                            ForEach(0..<3, id: \.self) { col in
                                let number: Int = row * 3 + col + 1 // kandidát
                                let numberOpacity: CGFloat = candidates.contains(number) ? 1.0 : 0.0
                                
                                // kandidát zobrazen jen pokud je v množině kandidátů
                                Text("\(number)")
                                    .opacity(numberOpacity)
                                    .bold()
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
    
    /// Určí barvu buňky podle příslušnosti k boxu a uživatelem vybrané buňky.
    /// - Returns: barva buňky
    func determineCellColor() -> Color {
        let color1: Color = (self.colorScheme == .dark) ? BOX_COLOR_PURPLE_DARK.opacity(0.7) : BOX_COLOR_PURPLE_LIGHT.opacity(0.5)
        let color2: Color = (self.colorScheme == .dark) ? BOX_COLOR_PINK_DARK.opacity(0.7) : BOX_COLOR_PINK_LIGHT.opacity(0.5)
        
        // barva buňky vybrané uživatelem
        let selectedColor: Color = (self.colorScheme == .dark) ? .black : .white
        
        // barva pro sloupec, řádek a sloupec příslušícím vybrané buňce
        let neighborColor: Color = (self.colorScheme == .dark) ? BOX_COLOR_GREEN_DARK : BOX_COLOR_GREEN_LIGHT
        
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
    
    /// sudoku mřížka
    let board: Board
    /// řádek uživatelem vybrané buňky
    let selectedRow: Int?
    /// sloupec uživatelem vybrané buňky
    let selectedColumn: Int?
    /// je aktivní nástroj tužka?
    @Binding var pencilActive: Bool
    /// status aplikace
    @Binding var state: ViewState
    /// obtížnost aktuální hry
    @Binding var difficulty: Difficulty
    /// čas v sekundách poslední dohrané hry
    @Binding var finalScoreSeconds: Int
    /// čas aktuální hry
    let elapsedTime: Int
    
    /// barevné schéma
    let colorScheme: ColorScheme
    /// orientace zařízení
    let orientation: UIDeviceOrientation
    
    var body: some View {
        let basicFontColor: Color = (self.colorScheme == .dark) ? .white : .black
        let finalFontColor: Color = (self.board.isPreFilled(row: self.selectedRow, column: self.selectedColumn)) ? .gray : basicFontColor
        
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
                        Text(STRING_PENCIL_TOOL)
                            .font(.system(size: fontSize))
                            .background(pencilToolBackground)
                            .cornerRadius(self.cornerRadius)
                            .onTapGesture {
                                // aktivování / deaktivování nástroje tužka
                                self.pencilActive = !self.pencilActive
                            }
                        
                        // nástroj zvýrazňovač
                        Text(STRING_HIGHLIGHTER_TOOL)
                            .font(.system(size: fontSize))
                            .onTapGesture {
                                // zvýraznění / odstranění zvýraznění aktuálně vybrané buňky
                                self.board.highlight(row: self.selectedRow, column: self.selectedColumn)
                            }
                    }
                    HStack(spacing: toolsPadding/2) {
                        // nástroj odstranění zvýrazňovače
                        Text(STRING_HIGHLIGHTER_REMOVE_TOOL)
                            .font(.system(size: fontSize))
                            .onTapGesture {
                                // odstraní zvýraznění ze všech buněk
                                self.board.removeAllHighlights()
                            }
                        
                        // nástroj vymazat
                        Text(STRING_REMOVE_TOOL)
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
                    Text(STRING_PENCIL_TOOL)
                        .font(.system(size: fontSize))
                        .background(pencilToolBackground)
                        .cornerRadius(self.cornerRadius)
                        .onTapGesture {
                            // aktivování / deaktivování nástroje tužka
                            self.pencilActive = !self.pencilActive
                        }
                    
                    // nástroj zvýrazňovač
                    Text(STRING_HIGHLIGHTER_TOOL)
                        .font(.system(size: fontSize))
                        .onTapGesture {
                            // zvýraznění / odstranění zvýraznění aktuálně vybrané buňky
                            self.board.highlight(row: self.selectedRow, column: self.selectedColumn)
                        }
                    
                    // nástroj odstranění zvýrazňovače
                    Text(STRING_HIGHLIGHTER_REMOVE_TOOL)
                        .font(.system(size: fontSize))
                        .onTapGesture {
                            // odstraní zvýraznění ze všech buněk
                            self.board.removeAllHighlights()
                        }
                    
                    // nástroj vymazat
                    Text(STRING_REMOVE_TOOL)
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
                                    .foregroundStyle(finalFontColor)
                                    .frame(width: cellSize, height: cellSize)
                                    .multilineTextAlignment(.center)
                                    .border(finalFontColor, width: borderWidth)
                                
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
                            .foregroundStyle(finalFontColor)
                            .frame(width: cellSize, height: cellSize)
                            .multilineTextAlignment(.center)
                            .border(finalFontColor, width: borderWidth)
                        
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
    
    private func fillValue(value: Int) -> Void {
        self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: value, pencilActive: self.pencilActive)
        
        if (self.board.isWin()) {
            self.handleWin()
        }
    }
    
    private func handleWin() -> Void {
        self.finalScoreSeconds = self.elapsedTime   // uložení skóre
        
        // pokud jde o nejlepší skóre pro obtížnost -> uložení do perzistentního úložiště
        StorageManager.setHighscore(difficulty: self.difficulty, seconds: self.elapsedTime)
        
        self.state = .win   // změna obrazovky na vítěznou
    }
}
