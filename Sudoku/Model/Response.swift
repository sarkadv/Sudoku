/// Protokol, který musí splňovat sudoku získané z API / ze souboru.
protocol Response {
    /// Vrátí 2D pole řešitelného sudoku (hodnota prázdných buněk 0).
    func getValueGrid() -> [[Int]]
    
    /// Vrátí 2D pole vyřešeného sudoku.
    func getSolutionGrid() -> [[Int]]
    
    /// Vrátí obtížnost sudoku.
    func getDifficulty() -> Difficulty
}
