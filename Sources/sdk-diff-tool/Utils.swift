import Foundation

extension String: LocalizedError {
    var localizedDescription: String {
        return self
    }
}

extension Optional {
    func unwrapped() throws -> Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            throw "Unexpected nil."
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case let .some(value):
            return value.isEmpty
        case .none:
            return true
        }
    }
}

extension Optional where Wrapped: RangeReplaceableCollection {
    func valueOrEmpty() -> Wrapped {
        switch self {
        case let .some(value):
            return value
        case .none:
            return Wrapped()
        }
    }
}

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        return character.unicodeScalars.count == 1 && contains(character.unicodeScalars.first!)
    }
}

extension String {
    func sanitizeForFilename() -> String {
        return Self.filenameCleanupRegex.stringByReplacingMatches(in: String(lowercased().map({ Self.filenameAllowed.contains($0) ? $0 : "-" })), withTemplate: "-")
    }

    private static let filenameCleanupRegex = try! NSRegularExpression(
        pattern: "-+",
        options: []
    )

    private static let filenameAllowed = CharacterSet()
        .union(CharacterSet(charactersIn: "a" ... "z"))
        .union(CharacterSet(charactersIn: "A" ... "Z"))
        .union(CharacterSet(charactersIn: "0" ... "9"))
}

extension NSRegularExpression {
    func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
        return firstMatch(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
    }

    func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
        return matches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
    }

    func stringByReplacingMatches(in string: String, options: NSRegularExpression.MatchingOptions = [], withTemplate templ: String) -> String {
        return stringByReplacingMatches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count), withTemplate: templ)
    }
}

extension NSTextCheckingResult {
    func range(in string: String) -> Range<String.Index>? {
        return Range(range, in: string)
    }

    func range(at index: Int, in string: String) -> Range<String.Index>? {
        return Range(range(at: index), in: string)
    }

    func substring(in string: String) -> Substring? {
        return range(in: string).map { string[$0] }
    }

    func substring(at index: Int, in string: String) -> Substring? {
        return range(at: index, in: string).map { string[$0] }
    }
}
