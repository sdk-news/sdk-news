import Foundation

extension ChangeSet {
    func renderHtml(allChangesets: [ChangeSet]) throws -> String {
        return try ###"""
            <!doctype html>
            <html lang="en">
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>\###(title)</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
                <style type="text/css">
                  body { padding-top: 5rem; }
                  [data-toggle="collapse"] .fa:before { content: "\f139"; }
                  [data-toggle="collapse"].collapsed .fa:before { content: "\f13a"; }
                  ul.changes { list-style-type: none; padding: 0 0 0 2rem; }
                  ul.changes li::before { font-size: 50%; vertical-align: middle; margin: 0 0 0 -2rem; display: inline-block; width: 1.5rem; text-align: right; }
                  ul.changes li.added::before { content: "🟢"; }
                  ul.changes li.modified::before { content: "🟣"; }
                  ul.changes li.deprecated::before { content: "🔴"; }
                </style>
              </head>
              <body>
                <nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark">
                  <a class="navbar-brand" href="index.html">SDK News</a>
                  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                  </button>

                  <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav mr-auto">
                      <li class="nav-item dropdown active">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                          \###(title)
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                          \###(allChangesets.sorted(by: { $0.timestamp > $1.timestamp }).map(\.title).map({
                            return "<a class=\"dropdown-item\" href=\"\($0.sanitizeForFilename()).html\">\($0)</a>"
                          }).joined(separator: "\n"))
                        </div>
                      </li>
                    </ul>
                    <ul class="navbar-nav ml-auto">
                      <li class="nav-item dropdown active">
                        <a class="nav-link" href="https://github.com/victor-pavlychko/sdk-news/" role="button">
                          GitHub
                        </a>
                      </li>
                    </ul>
                  </div>
                </nav>

                <main role="main" class="container">
                    \###(links[root].unwrapped().flatMap({ try renderHtmlSection(link: $0) }).joined(separator: "\n"))
                </main>

                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
              </body>
            </html>
            """###
    }

    private func renderHtmlSection(link: String) throws -> [String] {
        guard let change = changes[link] else {
            return []
        }

        var lines: [String] = []

        let collapseId = "collapse\(getNextId())"

        lines.append(###"""
            <h2>
              <button class="btn" data-toggle="collapse" data-target="#\###(collapseId)" aria-controls="\###(collapseId)" aria-expanded="false" aria-label="Toggle section">
                <i class="fa"></i>
              </button>
              <a href="\###(link)">\###(change.name)</a>
            </h2>
            """###)

//        lines.append(###"<h2><a href="\###(link)">\###(change.name)</a></h2>"###)

        if let links = links[link] {
            lines.append(###"<ul class="changes collapse show" id="\###(collapseId)">"###)
            try lines.append(contentsOf: links.flatMap({ try renderHtmlEntry(link: $0, parents: [link]) }))
            lines.append("</ul>")
        }

        return lines
    }

    private func renderHtmlEntry(link: String, parents: Set<String>) throws -> [String] {
        var nestedParents = parents

        guard nestedParents.insert(link).inserted else {
            return []
        }

        guard let change = changes[link] else {
            return []
        }

        var lines: [String] = []

        lines.append(###"<li class="\###(change.kind)">"###)
        lines.append(###"<a href="\###(link)">\###(change.name)</a>"###)

        if let links = links[link] {
            lines.append(###"<ul class="changes">"###)
            try lines.append(contentsOf: links.flatMap({ try renderHtmlEntry(link: $0, parents: nestedParents) }))
            lines.append("</ul>")
        }

        lines.append("</li>")

        return lines
    }

    private func getNextId() -> Int {
        Self.nextId += 1
        return Self.nextId
    }

    private static var nextId = 0
}
