import Foundation

struct GuessResponse: Codable {
    let black: Int
    let white: Int
}

struct Game: Codable {
    let gameID: String
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
    }
}
