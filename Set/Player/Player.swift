import Foundation

struct Player{
    let id = UUID()
    var name: String
    var score: Int = 0
    
    mutating func increaseScore(by value: Int) {
        self.score += value
    }
    
    mutating func decreaseScore(by value: Int) {
        self.score -= value
    }
}
