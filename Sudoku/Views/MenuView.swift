import SwiftUI

/// zobrazení hlavního menu
struct MenuView: View {
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
        let spacing: CGFloat = (sizeClass == .compact) ? 20.0 : 30.0    // velikost mezery mezi tlačítky
        let imageSize: CGFloat = (sizeClass == .compact) ? 200.0 : 500.0    // velikost úvodního obrázku
        let buttonWidth: CGFloat = (sizeClass == .compact) ? 150.0 : 300.0  // šířka tlačítka
        
        VStack (spacing: spacing) {
            Image("sudoku")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: imageSize, height: imageSize)
                .padding()
            
            Text("sudoku")
                .padding()
                .font(.largeTitle)
            
            // jednoduchá obtížnost
            Button(action: {
                self.difficulty = .easy
                self.state = .loading
            }) {
                Text("Easy")
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth)
                    .background(COLOR_EASY)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // střední obtížnost
            Button(action: {
                self.difficulty = .medium
                self.state = .loading
            }) {
                Text("Medium")
                    .font(.headline)
                    .padding()
                    .frame(width: buttonWidth)
                    .background(COLOR_MEDIUM)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // těžká obtížnost
            Button(action: {
                self.difficulty = .hard
                self.state = .loading
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

