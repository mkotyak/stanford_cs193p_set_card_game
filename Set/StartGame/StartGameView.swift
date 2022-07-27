import SwiftUI

struct StartGameView: View {
    let gameViewBuilder: GameViewBuilder
    @ObservedObject var startGameViewModel: StartGameViewModel

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: gameViewBuilder.build(startGameViewModel.isColorBlindModeEnabled)) {
                    Text("Start the game")
                        .font(.largeTitle)
                        .frame(width: 280, height: 55)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                Toggle(isOn: $startGameViewModel.isColorBlindModeEnabled) {
                    Text("Enable color-blind mode")
                }
                .padding(.horizontal, 25)
            }
        }
    }
}
