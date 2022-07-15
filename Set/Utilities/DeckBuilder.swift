import Foundation

class DeckBuilder {
    func createDeck() -> [CardModel] {
        var deck: [CardModel] = []
        for shape in ContentShape.allCases {
            for color in ContentColor.allCases {
                for numOfShapes in NumOfShapes.allCases {
                    for shading in Shading.allCases {
                        deck.append(CardModel(content: CardContentModel(
                            shape: shape,
                            numOfShapes: numOfShapes,
                            shading: shading,
                            color: color)
                        ))
                    }
                }
            }
        }
        return deck.shuffled()
    }
}
