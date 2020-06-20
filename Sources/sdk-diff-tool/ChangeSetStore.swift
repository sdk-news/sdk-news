import Foundation

class ChangeSetStore {
    private let rootURL: URL

    init(url: URL) throws {
        self.rootURL = url

        try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
    }

    func add(_ changeSet: ChangeSet) throws {
        let fileURL = rootURL
            .appendingPathComponent(changeSet.title.sanitizeForFilename())
            .appendingPathExtension("json")

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(changeSet).write(to: fileURL)
    }

    func loadAll() throws -> [ChangeSet] {
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: nil,
            options: [.skipsPackageDescendants, .skipsSubdirectoryDescendants]
        )

        return fileURLs
            .filter { $0.pathExtension == "json" }
            .compactMap { try? JSONDecoder().decode(ChangeSet.self, from: Data(contentsOf: $0)) }
    }
}
