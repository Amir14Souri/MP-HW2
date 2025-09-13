import Foundation
import FoundationNetworking

enum API {
    static let base = "https://mastermind.darkube.app"
}

final class APIClient {
    static func startGame(completion: @escaping (Game?) -> Void) {
        guard let url = URL(string: "\(API.base)/game") else { completion(nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error { completion(nil); return }
            guard let data = data else { completion(nil); return }
            let game = try? JSONDecoder().decode(Game.self, from: data)
            completion(game)
        }.resume()
    }

    static func makeGuess(gameId: String, guess: String, completion: @escaping (GuessResponse?) -> Void) {
        guard let url = URL(string: "\(API.base)/guess") else { completion(nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["game_id": gameId, "guess": guess]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error { completion(nil); return }
            guard let data = data else { completion(nil); return }
            let guessResponse = try? JSONDecoder().decode(GuessResponse.self, from: data)
            completion(guessResponse)
        }.resume()
    }

    static func startGameSync(timeout: DispatchTime = .now() + 10) -> Game? {
        let sem = DispatchSemaphore(value: 0)
        var result: Game?
        startGame { g in result = g; sem.signal() }
        _ = sem.wait(timeout: timeout)
        return result
    }

    static func makeGuessSync(gameId: String, guess: String, timeout: DispatchTime = .now() + 10) -> GuessResponse? {
        let sem = DispatchSemaphore(value: 0)
        var result: GuessResponse?
        makeGuess(gameId: gameId, guess: guess) { r in result = r; sem.signal() }
        _ = sem.wait(timeout: timeout)
        return result
    }
}
