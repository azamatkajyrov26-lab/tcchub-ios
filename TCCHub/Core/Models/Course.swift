import Foundation

struct Paginated<T: Decodable>: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [T]
}

struct Course: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let slug: String
    let summary: String?
    let description: String?
    let coverImageUrl: String?
    let durationHours: Int?
    let progressPercent: Double?

    static func == (l: Course, r: Course) -> Bool { l.id == r.id }
    func hash(into h: inout Hasher) { h.combine(id) }
}

struct CourseSection: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let details: String?
    let sequenceOrder: Int?
    let activities: [Activity]?
}

struct CourseDetail: Decodable {
    let id: Int
    let title: String
    let slug: String
    let summary: String?
    let description: String?
    let coverImageUrl: String?
    let durationHours: Int?
    let sections: [CourseSection]?
}

struct Activity: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let details: String?
    let activitySubtype: String?
    let sequenceOrder: Int?
    let deadline: Date?
    let completed: Bool?

    var kind: Kind { Kind(rawValue: activitySubtype ?? "") ?? .other }

    enum Kind: String {
        case lesson, video, document, folder, resource, url, quiz, assignment, forum, glossary, h5p, other
    }
}
