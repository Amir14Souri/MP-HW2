import Foundation

func runCLI() {
    guard let game = APIClient.startGameSync() else {
        print("Failed to create game. Exiting.")
        exit(1)
    }
    print("Game created! Game ID: \(game.gameID)")

    while true {
        print("Enter your guess (4 digits from 1 to 6 or exit): ", terminator: "")
        let guess = readLineOrExit()

        if !isValidGuess(guess) {
            print("Invalid guess. Must be 4 digits, each between 1 and 6.")
            continue
        }

        if let response = APIClient.makeGuessSync(gameId: game.gameID, guess: guess) {
            let blackPegs = String(repeating: "B", count: response.black)
            let whitePegs = String(repeating: "W", count: response.white)
            print("Result: \(blackPegs)\(whitePegs)")

            if response.black == 4 {
                print("Congrats! You found the hidden code.")
                exit(0)
            }
        } else {
            print("error connecting to server or request timed out")
        }
    }
}
