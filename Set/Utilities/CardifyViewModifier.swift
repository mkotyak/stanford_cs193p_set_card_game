import SwiftUI

struct Cardify: ViewModifier {
    enum Constants {
        static let cornerRadius: CGFloat = 15
        static let colorTextFontSize: CGFloat = 11
        static let colorTextTopPadding: CGFloat = 8
        static let borderWidth: CGFloat = 2
        static let animationDuration: Double = 0.7
    }

    var isFaceUp: Bool
    var backgroundColor: Color
    var strokeColor: Color
    var isHinted: Bool
    var isColorBlindModeEnabled: Bool
    var contentColorDefinition: String

    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                shape.fill(backgroundColor)
                shape.strokeBorder(lineWidth: Constants.borderWidth * (isHinted ? 3 : 1))
                    .foregroundColor(strokeColor)
                if isColorBlindModeEnabled {
                    colorBlindView
                }
                content
            } else {
                ZStack {
                    let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    shape.fill(.white)
                    shape.strokeBorder(lineWidth: Constants.borderWidth)
                        .foregroundColor(.black)
                    Text("Set").foregroundColor(.green)
                }
            }
        }
        .rotation3DEffect(
            Angle(degrees: strokeColor == .green ? 360 : 0),
            axis: (x: 1, y: 1, z: 1)
        )
        .animation(Animation.linear(duration: Constants.animationDuration), value: strokeColor)
    }

    private var colorBlindView: some View {
        VStack(alignment: .leading) {
            Text("\(contentColorDefinition)")
                .font(.system(size: Constants.colorTextFontSize))
            Spacer()
        }
        .padding(.top, Constants.colorTextTopPadding)
    }
}

extension View {
    func cardify(
        isFaceUp: Bool,
        backgroundColor: Color,
        strokeColor: Color,
        isHinted: Bool,
        isColorBlindModeEnabled: Bool,
        contentColorDefinition: String
    ) -> some View {
        modifier(Cardify(
            isFaceUp: isFaceUp,
            backgroundColor: backgroundColor,
            strokeColor: strokeColor,
            isHinted: isHinted,
            isColorBlindModeEnabled: isColorBlindModeEnabled,
            contentColorDefinition: contentColorDefinition)
        )
    }
}
