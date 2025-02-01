import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack (spacing: 20) {
            Image("sudoku")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()
            
            Text("sudoku")
                .padding()
                .font(.largeTitle)
        }
        
        // Easy Button
        Button(action: {
            selectedDifficulty = .easy

        }) {
            Text("Easy")
                .font(.headline)
                .padding()
                .frame(width: 100)
                .background(COLOR_EASY)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        
        // Medium Button
        Button(action: {
            selectedDifficulty = .medium
        }) {
            Text("Medium")
                .font(.headline)
                .padding()
                .frame(width: 100)
                .background(COLOR_MEDIUM)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        
        // Hard Button
        Button(action: {
            selectedDifficulty = .hard
        }) {
            Text("Hard")
                .font(.headline)
                .padding()
                .frame(width: 100)
                .background(COLOR_HARD)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
    }
}

