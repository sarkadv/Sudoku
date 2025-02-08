import SwiftUI

/// zobrazení herního pole
struct GameView: View {
    /// stav aplikace
    @Binding var state: ViewState
    /// aktuální obtížnost hry
    @Binding var difficulty: Difficulty
    /// aktuální sudoku mřížka
    @Binding var board: Board?
    
    /// světlé / tmavé barevné schéma
    @Environment(\.colorScheme) var colorScheme
    /// velikost displeje
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        let cellSize: CGFloat = (sizeClass == .compact) ? 35.0 : 65.0   // velikost buňky
        let borderWidth: CGFloat = (sizeClass == .compact) ? 1.0 : 2.0  // šířka ohraničení
        let borderColor: Color = (colorScheme == .dark) ? .white : .black   // barva ohraničení
        let valueFontSize: CGFloat = (sizeClass == .compact) ? 24.0 : 40.0  // velikost číselné hodnoty buňky
        let candidatesFontSize: CGFloat = (sizeClass == .compact) ? 8.5 : 16.0  // velikost kandidátů na hodnotu buňky
        let candidatesHSpacing: CGFloat = (sizeClass == .compact) ? 4.0 : 8.0   // horizontální prostor mezi kandidáty
        
        // vykreslení celé sudoku mřížky (9x9 buněk)
        VStack (spacing: 0) {
            ForEach(0..<self.board!.ROWS, id: \.self) { row in
                HStack (spacing: 0) {
                    ForEach(0..<self.board!.COLUMNS, id: \.self) { column in
                        // číselná hodnota buňky
                        let value: Int = self.board!.getValue(row: row, column: column)
                        
                        // kandidáti na hodnotu buňky
                        let candidates: Set<Int> = self.board!.getCandidates(row: row, column: column)
                        
                        // barva buňky podle příslušnosti k boxu
                        let backgroundColor: Color = self.determineBoxColor(row: row, column: column)
                        
                        // velikost textu podle existence hodnoty / kandidátů
                        let fontSize: CGFloat = value == 0 ? candidatesFontSize : valueFontSize
                        
                        // vykreslení jedné buňky
                        SudokuCellView(value: value, candidates: candidates, backgroundColor: backgroundColor, fontSize: fontSize, cellSize: cellSize, borderWidth: borderWidth, borderColor: borderColor, candidatesHSpacing: candidatesHSpacing)
                    }
                }
            }
        }
    }
    
    /// Určí barvu buňky podle příslušnosti k boxu.
    /// - Parameters:
    ///   - row: řádek buňky
    ///   - column: sloupec buňky
    /// - Returns: barva buňky
    func determineBoxColor(row: Int, column: Int) -> Color {
        if (row <= 2) {
            if (column <= 2) {
                return BOX_COLOR_PURPLE
            }
            else if (column <= 5) {
                return BOX_COLOR_PINK
            }
            else {
                return BOX_COLOR_PURPLE
            }
        }
        else if (row <= 5) {
            if (column <= 2) {
                return BOX_COLOR_PINK
            }
            else if (column <= 5) {
                return BOX_COLOR_PURPLE
            }
            else {
                return BOX_COLOR_PINK
            }
        }
        else {
            if (column <= 2) {
                return BOX_COLOR_PURPLE
            }
            else if (column <= 5) {
                return BOX_COLOR_PINK
            }
            else {
                return BOX_COLOR_PURPLE
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
    /// barva buňky
    let backgroundColor: Color
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
    
    var body: some View {
        ZStack {
            if value != 0 {
                // buňka má danou hodnotu
                Text("\(value)")
            }
            else {
                // buňka nemá hodnotu -> zobrazení 3x3 mřížky pro kandidáty
                VStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: candidatesHSpacing) {
                            ForEach(0..<3, id: \.self) { col in
                                let number: Int = row * 3 + col + 1 // kandidát
                                
                                // kandidát zobrazen jen pokud je v množině kandidátů
                                Text(candidates.contains(number) ? "\(number)" : "")
                            }
                        }
                    }
                }
            }
        }
        .font(.system(size: fontSize))
        .frame(width: cellSize, height: cellSize)
        .multilineTextAlignment(.center)
        .border(borderColor, width: borderWidth)
        .background(backgroundColor.opacity(0.5))
    }
}
