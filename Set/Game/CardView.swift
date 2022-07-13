import SwiftUI

struct CardView: View {
    var cardContent: CardContentModel
    let countAdapter = CountAdapter()
    let colorAdapter = ColorAdapter()

    var body: some View {
        GeometryReader { _ in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 20)
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                VStack {
                    // I get "Non-constant range: argument must be an integer literal" warning on the 16th line, but don't know how to avoid it
                    ForEach(0 ..< countAdapter.convertCount(count: cardContent.numOfShapes)) { _ in
                        Text("Hello")
                            .foregroundColor(colorAdapter.convertColor(color: cardContent.color))
                    }
                }
            }
            .padding()
        }
    }
}

// struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
// }
