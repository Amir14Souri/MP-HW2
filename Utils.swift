import Foundation

func isValidGuess(_ s: String) -> Bool {
    guard s.count == 4 else { return false }
    for ch in s {
        guard let v = ch.wholeNumberValue, (1...6).contains(v) else { return false }
    }
    return true
}

func readLineOrExit() -> String {
    if let input = readLine() {
        if input.lowercased() == "exit" {
            print("Exiting game...")
            exit(0)
        }
        return input
    }
    return ""
}
