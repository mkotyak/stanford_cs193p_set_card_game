import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var gameModel: GameModel
    @Published var countDownTimer: Int = 10
    @Published var timerTitle = ""
    var timer: Timer?
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timerTitle = "Time: \(self.countDownTimer)"
            if self.countDownTimer >= 1 {
                self.countDownTimer -= 1
            } else {
                self.cleanUp()
            }
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
        if player1.id == whoseTurn?.id {
            return .green
        } else if player2.id == whoseTurn?.id {
            return .gray
        } else {
            return .black
        }
    }
    
    var player2ButtonColor: Color {
        if player2.id == whoseTurn?.id {
            return .green
        } else if player1.id == whoseTurn?.id {
            return .gray
        } else {
            return .black
        }
    }
    
    var player1: Player {
        gameModel.firstPlayer
    }
    
    var player2: Player {
        gameModel.secondPlayer
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
        
    func select(_ card: CardModel, _ player: Player) {
        guard let timer = timer else {
            return
        }
        
        guard timer.isValid else {
            return
        }
        
        // test comment
        print("Select method: \(player.name)")
        // END: test comment
        
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
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
        timer?.invalidate()
        timerTitle = ""
        countDownTimer = 10
    }
    
    func didSelect(player: Player) {
        whoseTurn = player
    }
}
