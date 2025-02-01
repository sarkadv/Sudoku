import SwiftUI

var selectedDifficulty: Difficulty = .easy

func createBoard() -> Board {
    let board = Board()
    board.set(row: 0, column: 0, value: 1)
    board.set(row: 0, column: 1, value: 1)
    board.set(row: 0, column: 2, value: 1)
    board.set(row: 0, column: 3, value: 1)
    board.set(row: 0, column: 4, value: 1)
    board.set(row: 0, column: 5, value: 1)
    board.set(row: 0, column: 6, value: 1)
    board.set(row: 0, column: 7, value: 3)
    board.set(row: 0, column: 8, value: 1)

    board.set(row: 1, column: 0, value: 1)
    board.set(row: 1, column: 1, value: 1)
    board.set(row: 1, column: 2, value: 2)
    board.set(row: 1, column: 3, value: 1)
    board.set(row: 1, column: 4, value: 1)
    board.set(row: 1, column: 5, value: 1)
    board.set(row: 1, column: 6, value: 0)
    board.set(row: 1, column: 7, value: 1)
    board.set(row: 1, column: 8, value: 1)

    board.printBoard()
    
    return board
}

struct ContentView: View {
    @State private var state: ViewState = .menu
    
    var body: some View {
        VStack {
            if (state == .menu) {
                MenuView()
            }
        }
    }
}

#Preview {
    ContentView()
}
