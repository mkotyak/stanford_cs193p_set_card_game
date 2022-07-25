import Foundation

struct Player{
    var name: String
    var score: Int
    let id = UUID()
    
    mutating func increaseScore(by value: Int) {
        self.score += value
    }
    
    mutating func decreaseScore(by value: Int) {
        self.score -= value
    }
}
