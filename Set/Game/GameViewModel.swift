import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private var gameModel: GameModel
    private var countdown: Int = 10
    @Published var timerTitle = ""
    private var timer: Timer?
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timerTitle = "Time: \(self.countdown)"
            if self.countdown >= 1 {
                self.countdown -= 1
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
    
    var firstPlayerButtonColor: Color {
        if firstPlayer.id == whoseTurn?.id {
            return .green
        } else if secondPlayer.id == whoseTurn?.id {
            return .gray
        } else {
            return .black
        }
    }
    
    var secondPlayerButtonColor: Color {
        if secondPlayer.id == whoseTurn?.id {
            return .green
        } else if firstPlayer.id == whoseTurn?.id {
            return .gray
        } else {
            return .black
        }
    }
    
    var firstPlayer: Player {
        gameModel.firstPlayer
    }
    
    var secondPlayer: Player {
        gameModel.secondPlayer
    }
    
    var isFirstPlayerActive: Bool {
        firstPlayer.id == whoseTurn?.id
    }
    
    var isSecondPlayerActive: Bool {
        secondPlayer.id == whoseTurn?.id
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
        countdown = 10
    }
    
    func didSelect(player: Player) {
        whoseTurn = player
        startTimer()
    }
    
    func didSelect(card: CardModel) {
        guard let player = whoseTurn else {
            return
        }
        
        select(card, player)
    }
}
