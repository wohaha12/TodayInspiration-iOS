import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    private init(inMemory: Bool = false) {
        // Programmatically create the model to avoid .xcdatamodeld in this demo
        let model = NSManagedObjectModel()
        let noteEntity = NSEntityDescription()
        noteEntity.name = "Note"
        noteEntity.managedObjectClassName = "Note"

        // attributes
        var properties: [NSAttributeDescription] = []

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        properties.append(idAttr)

        let titleAttr = NSAttributeDescription()
        titleAttr.name = "title"
        titleAttr.attributeType = .stringAttributeType
        titleAttr.isOptional = true
        properties.append(titleAttr)

        let bodyAttr = NSAttributeDescription()
        bodyAttr.name = "body"
        bodyAttr.attributeType = .stringAttributeType
        bodyAttr.isOptional = true
        properties.append(bodyAttr)

        let tagsAttr = NSAttributeDescription()
        tagsAttr.name = "tagsCSV"
        tagsAttr.attributeType = .stringAttributeType
        tagsAttr.isOptional = true
        properties.append(tagsAttr)

        let createdAttr = NSAttributeDescription()
        createdAttr.name = "createdAt"
        createdAttr.attributeType = .dateAttributeType
        createdAttr.isOptional = false
        properties.append(createdAttr)

        let imageAttr = NSAttributeDescription()
        imageAttr.name = "imageData"
        imageAttr.attributeType = .binaryDataAttributeType
        imageAttr.isOptional = true
        properties.append(imageAttr)

        noteEntity.properties = properties
        model.entities = [noteEntity]

        container = NSPersistentCloudKitContainer(name: "TodayInspiration", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        } else {
            // Default description uses CloudKit if capabilities enabled in Xcode
            let description = container.persistentStoreDescriptions.first
            description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        }

        container.loadPersistentStores { storeDesc, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
