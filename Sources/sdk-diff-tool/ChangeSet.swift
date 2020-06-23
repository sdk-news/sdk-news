import Foundation

struct Change: Codable {
    var kind: String
    var name: String
}

struct ChangeSet: Codable {
    var root: String
    var platform: String
    var versions: [String]
    var timestamp: Date
    var changes: [String: Change]
    var links: [String: [String]]

    var title: String {
        return "\(platform) \(versions[0]) - \(platform) \(versions[1])"
    }

    init() {
        fatalError()
    }

    init(root: String, platform: String, versions: [String], timestamp: Date = Date(), changes: [String: Change] = [:], links: [String: [String]] = [:]) {
        self.root = root
        self.platform = platform
        self.versions = versions
        self.timestamp = timestamp
        self.changes = changes
        self.links = links
    }
}
