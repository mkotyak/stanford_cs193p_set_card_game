import SwiftUI

struct SetGameView: View {
    @ObservedObject var gameViewModel: SetGameViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(gameViewModel: SetGameViewModel())
    }
}
