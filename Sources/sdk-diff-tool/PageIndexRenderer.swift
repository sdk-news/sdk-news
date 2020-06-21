import Foundation

extension Array where Element == ChangeSet {
    func renderIndex() throws -> String {
        return ###"""
            <!doctype html>
            <html lang="en">
              <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>SDK News</title>
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
                  <a class="navbar-brand" href="#">SDK News</a>
                  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                  </button>

                  <div class="collapse navbar-collapse" id="navbarSupportedContent">
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
                  <h1>SDK News</h1>
                  <p>What’s new in Xcode: a structured list of API changes from the developer documentation.</p>
                  <ul>
                    \###(sorted(by: { $0.timestamp > $1.timestamp }).map(\.title).map({
                        return "<li><a href=\"\($0.sanitizeForFilename()).html\">\($0)</a></li>"
                    }).joined(separator: "\n"))
                  </ul>
                </main>

                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
              </body>
            </html>
            """###
    }
}
