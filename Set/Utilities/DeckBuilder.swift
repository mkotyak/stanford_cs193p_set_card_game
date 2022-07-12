import Foundation

class DeckBuilder {
    func createDeckOfCards() -> [SetGameModel.Card] {
        var deckOfCards: [SetGameModel.Card] = []
        for shape in Shape.allCases {
            for color in ContentColor.allCases {
                for numOfShapes in NumOfShapes.allCases {
                    for shading in Shading.allCases {
                        deckOfCards.append(SetGameModel.Card(content: CardContentModel(
                            shape: shape,
                            numOfShapes: numOfShapes,
                            shading: shading,
                            color: color)
                        ))
                    }
                }
            }
        }
        return deckOfCards
    }
}
