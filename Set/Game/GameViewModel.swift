import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    private enum Constants {
        static let playerTurnDuration: Int = 10
        static let timerFireInterval: TimeInterval = 1.0
        static let matchAnimationDuration: Double = 0.5
    }
    
    @Published private var gameModel: GameModel
    private var countdown = Constants.playerTurnDuration
    private var timer: Timer?
    @Published var timerTitle = ""
    
    var cardsOnScreen: [CardModel] {
        gameModel.cardsOnTheScreen
    }
    
    var deck: [CardModel] {
        gameModel.deck
    }
    
    var isMoreCardAvailable: Bool {
        return deck.isEmpty
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
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerFireInterval, repeats: true) { _ in
            self.timerTitle = "Time: \(self.countdown)"
            if self.countdown >= 1 {
                self.countdown -= 1
            } else {
                self.cleanUp()
            }
        }
    }
    
    private func cleanUp() {
        whoseTurn = nil
        timer?.invalidate()
        timerTitle = ""
        countdown = Constants.playerTurnDuration
    }
        
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
        
        guard let chousenCard = cardsOnScreen.first(where: { $0.id == card.id }) else {
            print("Card is out of scope")
            return
        }
        
        let matchStatus = gameModel.toggleCard(by: chousenCard.id)
        if matchStatus == .successfulMatch || matchStatus == .unsuccessfulMatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.matchAnimationDuration) { [weak self] in
                self?.gameModel.finishTurn(for: matchStatus, player: player)
                self?.cleanUp()
            }
        }
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
