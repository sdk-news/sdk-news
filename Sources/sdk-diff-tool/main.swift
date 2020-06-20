import Foundation

let rootURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let changeSetStore = try ChangeSetStore(url: rootURL.appendingPathComponent("json"))
try changeSetStore.update()

let pageStore = try PageStore(url: rootURL.appendingPathComponent("docs"))
try pageStore.update(changeSetStore.loadAll())
