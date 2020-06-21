import Foundation

struct Change: Codable {
    var kind: String
    var name: String
}

struct ChangeSet: Codable {
    var root: String
    var title: String
    var timestamp: Date
    var changes: [String: Change]
    var links: [String: [String]]
}
