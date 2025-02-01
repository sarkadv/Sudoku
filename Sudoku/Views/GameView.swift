import SwiftUI

struct GameView: View {
    @Binding var state: ViewState
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let board = createBoard()
    
    var body: some View {
        let cellSize: CGFloat = (sizeClass == .compact) ? 35.0 : 65.0
        let borderWidth: CGFloat = (sizeClass == .compact) ? 1.0 : 2.0
        let valueFontSize: CGFloat = (sizeClass == .compact) ? 24.0 : 40.0
        let candidatesFontSize: CGFloat = (sizeClass == .compact) ? 8.0 : 16.0
        
        VStack (spacing: 0) {
            ForEach(0..<board.ROWS, id: \.self) { row in
                HStack (spacing: 0) {
                    ForEach(0..<board.COLUMNS, id: \.self) { column in
                        let value: Int = board.getValue(row: row, column: column)
                        
                        let candidates: [Int] = board.getCandidates(row: row, column: column)
                        let candidatesString: String = candidatesToString(candidates: candidates)
                        
                        let text: String = value == 0 ? "\(candidatesString)" : "\(value)"
                        
                        let backgroundColor: Color = determineBoxColor(row: row, column: column)
                        let fontSize: CGFloat = value == 0 ? candidatesFontSize : valueFontSize
                        
                        Text(text)
                            .font(.system(size: fontSize))
                            .frame(width: cellSize, height: cellSize)
                            .background(backgroundColor.opacity(0.2))
                            .border(Color.black, width: borderWidth)
                            .multilineTextAlignment(.center)
                        
                        
                    }
                }
            }

        }
    }
}

func createBoard() -> Board {
    let board = Board()
    board.setValue(row: 0, column: 0, value: 1)
    board.setValue(row: 0, column: 1, value: 1)
    board.setValue(row: 0, column: 2, value: 1)
    board.setValue(row: 0, column: 3, value: 1)
    board.setValue(row: 0, column: 4, value: 1)
    board.setValue(row: 0, column: 5, value: 1)
    board.setValue(row: 0, column: 6, value: 1)
    board.setValue(row: 0, column: 7, value: 3)
    board.setValue(row: 0, column: 8, value: 1)

    board.setValue(row: 1, column: 0, value: 1)
    board.setValue(row: 1, column: 1, value: 1)
    board.setValue(row: 1, column: 2, value: 2)
    board.setValue(row: 1, column: 3, value: 1)
    board.setValue(row: 1, column: 4, value: 1)
    board.setValue(row: 1, column: 5, value: 1)
    board.setValue(row: 1, column: 6, value: 0)
    board.setValue(row: 1, column: 7, value: 1)
    board.setValue(row: 1, column: 8, value: 1)
    
    board.addCandidate(row: 2, column: 2, candidate: 2)
    board.addCandidate(row: 2, column: 2, candidate: 7)
    board.removeCandidate(row: 2, column: 2, candidate: 7)
    board.addCandidate(row: 2, column: 2, candidate: 9)
    board.addCandidate(row: 2, column: 2, candidate: 1)
    board.addCandidate(row: 2, column: 2, candidate: 4)
    
    return board
}

func determineBoxColor(row: Int, column: Int) -> Color {
    if (row <= 2) {
        if (column <= 2) {
            return BOX_COLOR_1
        }
        else if (column <= 5) {
            return BOX_COLOR_2
        }
        else {
            return BOX_COLOR_1
        }
    }
    else if (row <= 5) {
        if (column <= 2) {
            return BOX_COLOR_2
        }
        else if (column <= 5) {
            return BOX_COLOR_1
        }
        else {
            return BOX_COLOR_2
        }
    }
    else {
        if (column <= 2) {
            return BOX_COLOR_1
        }
        else if (column <= 5) {
            return BOX_COLOR_2
        }
        else {
            return BOX_COLOR_1
        }
    }
}

func candidatesToString(candidates: [Int]) -> String {
    var result = ""
    
    for i in 1..<10 {
        if (candidates.contains(i)) {
            result = result + "\(i)"
        }
        else {
            result = result + "_"
        }
        
        if (i % 3 == 0) {
            result = result + "\n"
        }
        else {
            result = result + " "
        }
    }
    
    return result
}

