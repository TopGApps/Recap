import Foundation

struct Option: Codable {
    let text: String
    let correct: Bool
}

struct Question: Codable {
    let type: String
    let question: String
    let options: [Option]?
    let answer: String?
}
