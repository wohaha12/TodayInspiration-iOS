import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject { }

extension Note {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var tagsCSV: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var imageData: Data?
}

extension Note {
    var tags: [String] {
        (tagsCSV ?? "").split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
    }

    func setTags(_ arr: [String]) {
        tagsCSV = arr.joined(separator: ",")
    }

    var uiImage: UIImage? {
        guard let d = imageData else { return nil }
        return UIImage(data: d)
    }
}
