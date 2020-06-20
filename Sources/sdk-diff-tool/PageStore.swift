import Foundation

class PageStore {
    private let rootURL: URL

    init(url: URL) throws {
        self.rootURL = url

        try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
    }

    func update(_ changeSets: [ChangeSet]) throws {
        let allTitles = changeSets.map(\.title).sorted()

        for changeSet in changeSets {
            let fileURL = rootURL
                .appendingPathComponent(changeSet.title.sanitizeForFilename())
                .appendingPathExtension("html")

            try changeSet
                .renderHtml(allTitles: allTitles)
                .write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
