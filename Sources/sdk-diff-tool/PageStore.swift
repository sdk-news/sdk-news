import Foundation

class PageStore {
    private let rootURL: URL

    init(url: URL) throws {
        self.rootURL = url

        try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
    }

    func update(_ changeSets: [ChangeSet]) throws {
        let indexURL = rootURL
            .appendingPathComponent("index")
            .appendingPathExtension("html")

        try changeSets
            .renderIndex()
            .write(to: indexURL, atomically: true, encoding: .utf8)

        for changeSet in changeSets {
            let fileURL = rootURL
                .appendingPathComponent(changeSet.title.sanitizeForFilename())
                .appendingPathExtension("html")

            try changeSet
                .renderHtml(allChangesets: changeSets)
                .write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }
}
