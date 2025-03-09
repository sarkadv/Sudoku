class MatrixHelper {
    
    /// Provede rotaci 2D pole čísel o 90 stupňů po směru hodinových ručiček.
    /// - Parameter matrix: 2D pole čísel
    /// - Returns: rotované 2D pole
    public static func rotate90DegreesClockwise(matrix: [[Int]]) -> [[Int]] {
        let rowCount = matrix.count
        let columnCount = matrix[0].count
        
        // nová matice stejné velikosti, samé 0
        var rotatedMatrix = Array(repeating: Array(repeating: 0, count: rowCount), count: columnCount)

        for i in 0..<rowCount {
            for j in 0..<columnCount {
                rotatedMatrix[j][rowCount - 1 - i] = matrix[i][j]
            }
        }
        
        return rotatedMatrix
    }
    
    /// Vertikální překlopení 2D pole čísel.
    /// - Parameter matrix: 2D pole čísel
    /// - Returns: překlopené 2D pole
    public static func verticalFlip(matrix: [[Int]]) -> [[Int]] {
        // obrácení pořadí řádků
        return matrix.reversed()
    }
    
    /// Horizontální překlopení 2D pole čísel.
    /// - Parameter matrix: 2D pole čísel
    /// - Returns: překlopené 2D pole
    public static func horizontalFlip(matrix: [[Int]]) -> [[Int]] {
        // řádky stejné pořadí, obrácení elementů v řádcích
        return matrix.map { $0.reversed() }
    }
}

