import Foundation

extension String {
    func levenshteinDistance(to target: String) -> Int {
        let s = Array(self.lowercased())
        let t = Array(target.lowercased())
        
        if s.isEmpty { return t.count }
        if t.isEmpty { return s.count }
        
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: t.count + 1), count: s.count + 1)
        
        for i in 0...s.count { matrix[i][0] = i }
        for j in 0...t.count { matrix[0][j] = j }
        
        for i in 1...s.count {
            for j in 1...t.count {
                let cost = s[i - 1] == t[j - 1] ? 0 : 1
                matrix[i][j] = Swift.min(
                    matrix[i - 1][j] + 1,
                    matrix[i][j - 1] + 1,
                    matrix[i - 1][j - 1] + cost
                )
            }
        }
        
        return matrix[s.count][t.count]
    }
    
    var isCatalanMarker: Bool {
        let catalanMarkers: Set<Character> = ["à", "è", "é", "í", "ï", "ó", "ò", "ú", "ü", "ç", "·"]
        return self.lowercased().contains { catalanMarkers.contains($0) }
    }
    
    var isSpanishMarker: Bool {
        let spanishMarkers: Set<Character> = ["ñ", "á"]
        return self.lowercased().contains { spanishMarkers.contains($0) }
    }
    
    var isWordBoundary: Bool {
        return self == " " || self == "." || self == "," || self == "!" || self == "?" || self == ";" || self == ":" || self == "\n"
    }
}
