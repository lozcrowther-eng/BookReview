import Foundation

enum MediaType: String, Codable {
    case book, audiobook, miniseries, movie
}

enum Recommendation: String, Codable {
    case none, bronze, silver, gold
}

struct Entry: Identifiable, Codable {
    let id: UUID
    var mediaType: MediaType
    var title: String
    var authorsOrActors: String?
    var dateFinished: Date?
    var recommendation: Recommendation
    var genre: String?
    var subgenre: String?
    var plot30: String?
    var liked: String?
    var disliked: String?
    var remember: String?
    var createdAt: Date

    init(id: UUID = UUID(), mediaType: MediaType, title: String = "", authorsOrActors: String? = nil) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.authorsOrActors = authorsOrActors
        self.dateFinished = nil
        self.recommendation = .none
        self.genre = nil
        self.subgenre = nil
        self.plot30 = nil
        self.liked = nil
        self.disliked = nil
        self.remember = nil
        self.createdAt = Date()
    }
}
