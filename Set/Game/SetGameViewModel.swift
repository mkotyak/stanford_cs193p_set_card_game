import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var gameModel: SetGameModel

    init() {
        gameModel = SetGameModel()
        createDeckOfCards()
    }

    func createDeckOfCards() {
        for shape in Shape.allCases {
            for color in ContentColor.allCases {
                for numOfShapes in NumOfShapes.allCases {
                    for shading in Shading.allCases {
                        gameModel.cards.append(SetGameModel.Card(content: CardContentModel(
                            shape: shape,
                            numOfShapes: numOfShapes,
                            shading: shading,
                            color: color)
                        ))
                    }
                }
            }
        }
        print(gameModel.cards.count)
    }
}
