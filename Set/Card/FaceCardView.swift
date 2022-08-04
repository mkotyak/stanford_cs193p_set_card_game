import SwiftUI

struct FaceCardView: View {
    enum Constants {
        static let cornerRadius: CGFloat = 15
        static let shapeImageScale: CGFloat = 0.55
        static let colorTextFontSize: CGFloat = 11
        static let colorTextTopPadding: CGFloat = 8
        static let borderWidth: CGFloat = 2
    }

    let backgroundColor: Color
    let strokeColor: Color
    let contentColor: Color
    let isColorBlindModeEnabled: Bool
    let numOfShapes: Int
    let shapeImage: Image
    let contentColorDefinition: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                shape.fill(backgroundColor)
                shape.strokeBorder(lineWidth: Constants.borderWidth)
                    .foregroundColor(strokeColor)

                if isColorBlindModeEnabled {
                    colorBlindView
                }

                VStack {
                    ForEach(0 ..< numOfShapes, id: \.self) { _ in
                        shapeImage
                            .resizable()
                            .scaledToFit()
                            .frame(width:
                                min(geometry.size.height, geometry.size.width) * Constants.shapeImageScale
                            )
                    }
                    .foregroundColor(contentColor)
                }
            }
            .rotation3DEffect(Angle(degrees: strokeColor == .green ? 360 : 0),
                                axis: (x: 1, y: 1, z: 1))
            .animation(Animation.linear(duration: 1), value: strokeColor)
        }
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
