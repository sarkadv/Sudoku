import SwiftUI

struct MenuView: View {
    @Binding var state: ViewState
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        let spacing: CGFloat = (sizeClass == .compact) ? 20.0 : 30.0
        let imageSize: CGFloat = (sizeClass == .compact) ? 200.0 : 500.0
        let buttonWidth: CGFloat = (sizeClass == .compact) ? 150.0 : 300.0
        
        VStack (spacing: spacing) {
            Image("sudoku")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize, height: imageSize)
                .padding()
            
            Text("sudoku")
                .padding()
                .font(.largeTitle)
            
            // Easy Button
            Button(action: {
                selectedDifficulty = .easy
                self.state = .game
            }) {
                Text("Easy")
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth)
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
                    .frame(width: buttonWidth)
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
                    .frame(width: buttonWidth)
                    .background(COLOR_HARD)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
        }
    }
}

