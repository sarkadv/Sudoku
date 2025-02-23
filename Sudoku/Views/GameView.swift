import SwiftUI

/// zobrazení herního pole
struct GameView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// aktuální sudoku mřížka - observed object, při změně je překreslena mřížka
    @EnvironmentObject var board: Board
    
    /// orientace zařízení
    @Binding var orientation: UIDeviceOrientation
    
    /// světlé / tmavé barevné schéma
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    /// true - iPhone / false - iPad
    private let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    /// souřadnice uživatelem vybrané buňky
    @State private var selectedRow: Int? = nil
    @State private var selectedColumn: Int? = nil
    
    /// je aktivní nástroj tužka?
    @State private var pencilActive: Bool = false
    
    var body: some View {
        let cellSize: CGFloat = isPhone ? 35.0 : 65.0   // velikost buňky
        let borderWidth: CGFloat = isPhone ? 1.0 : 2.0  // šířka ohraničení
        let borderColor: Color = (colorScheme == .dark) ? .white : .black   // barva ohraničení
        let valueFontSize: CGFloat = isPhone ? 24.0 : 40.0  // velikost číselné hodnoty buňky
        let candidatesFontSize: CGFloat = isPhone ? 8 : 16.0  // velikost kandidátů na hodnotu buňky
        let candidatesHSpacing: CGFloat = isPhone ? 3.5 : 8.0   // horizontální prostor mezi kandidáty
        let toolsPadding: CGFloat = isPhone ? 40.0 : 80.0     // padding nástrojů
        let cornerRadius: CGFloat = isPhone ? 4.0 : 8.0  // zaoblení rohů
        
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
                          colorScheme: self.colorScheme,
                          orientation: self.orientation)
                .padding(toolsPadding)
            }
        }
        // portrait mode - hlavní Stack je VStack
        else {
            VStack {
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
                          colorScheme: self.colorScheme,
                          orientation: self.orientation)
                    .padding(toolsPadding)
            }
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
        
        // pokud je buňka vybraná uživatelem, není potřeba další výpočty
        if (self.row == self.selectedRow && self.column == self.selectedColumn) {
            return selectedColor
        }
        
        // výsledná vrácená barva
        var resultColor: Color
        
        // určení barvy podle příslušnosti buňky k boxu
        if (self.row <= 2) {
            if (self.column <= 2) {
                resultColor = color1
            }
            else if (self.column <= 5) {
                resultColor = color2
            }
            else {
                resultColor = color1
            }
        }
        else if (self.row <= 5) {
            if (self.column <= 2) {
                resultColor = color2
            }
            else if (self.column <= 5) {
                resultColor = color1
            }
            else {
                resultColor = color2
            }
        }
        else {
            if (self.column <= 2) {
                resultColor = color1
            }
            else if (self.column <= 5) {
                resultColor = color2
            }
            else {
                resultColor = color1
            }
        }
        
        // zvýraznění buňky, pokud se nachází ve stejném sloupci / řádku / boxu jako vybraná buňka
        if (self.selectedRow != nil && self.selectedColumn != nil) {
            // test sloupce nebo řádku
            if (self.row == self.selectedRow! || self.column == self.selectedColumn!) {
                resultColor = neighborColor
            }

            // test boxu
            let boxStartRow: Int = self.row - (self.row % 3)  // řádek levého horního rohu boxu
            let boxStartColumn: Int = self.column - (self.column % 3) // sloupec levého horního rohu boxu
            
            if ((self.selectedRow! - boxStartRow < 3 && self.selectedRow! - boxStartRow >= 0) &&
                (self.selectedColumn! - boxStartColumn < 3 && self.selectedColumn! - boxStartColumn >= 0)) {
                resultColor = neighborColor
            }
            
        }
        
        return resultColor
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
                                        self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: number, pencilActive: self.pencilActive)
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
                                self.board.fill(row: self.selectedRow, column: self.selectedColumn, value: i, pencilActive: self.pencilActive)
                            }
                    }
                }
            }
        }
    }
}
