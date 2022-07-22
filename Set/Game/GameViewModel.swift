import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var gameModel: GameModel
    @Published var countDownTimer = 10
    var timerIsRunning = false
    var timerTitle = ""
    var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    func startTimer() {
        timerTitle = "Time: \(countDownTimer)"
        if timerIsRunning, countDownTimer >= 1 {
            countDownTimer -= 1
        } else {
            cleanUp()
        }
    }
    
    var cardsOnScreen: [CardModel] {
        gameModel.cardsOnTheScreen
    }
    
    var deck: [CardModel] {
        gameModel.deck
    }
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    var isMoreCardAvailable: Bool {
        return deck.isEmpty
    }
    
    var moreCardsButtonColor: Color {
        isMoreCardAvailable ? .gray : .black
    }
    
    var player1ButtonColor: Color {
        if player1.isPlaying {
            return .green
        } else if player2.isPlaying {
            return .gray
        } else {
            return .black
        }
    }
    
    var player2ButtonColor: Color {
        if player2.isPlaying {
            return .green
        } else if player1.isPlaying {
            return .gray
        } else {
            return .black
        }
    }
    
    var player1: Player {
        gameModel.player1
    }
    
    var player2: Player {
        gameModel.player2
    }
    
    var whoseTurn: Player?
        
    // MARK: - Inents
    
    func dealThreeMoreCards() {
        gameModel.dealThreeMoreCards()
    }
    
    func startNewGame() {
        cleanUp()
        gameModel.startNewGame()
    }
    
    func markAsPlaying(_ player: Player) {
        if player.name == player1.name {
            gameModel.player1.isPlaying = true
        } else {
            gameModel.player2.isPlaying = true
        }
    }
        
    func select(_ card: CardModel, _ player: Player) {
        print("Select method: \(player.name)")
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
            return
        }
        
        guard timerIsRunning else {
            return
        }
        
        let matchStatus = gameModel.toggleCard(by: chousenCard.id)
        if matchStatus == .successfulMatch || matchStatus == .unsuccessfulMatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.gameModel.finishTurn(for: matchStatus, player: player)
                self?.cleanUp()
            }
        }
    }
    
    private func cleanUp() {
        whoseTurn = nil
        timerTitle = ""
        countDownTimer = 10
        timerIsRunning = false
        gameModel.player1.isPlaying = false
        gameModel.player2.isPlaying = false
    }
}
