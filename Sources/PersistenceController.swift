import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    private init() {
        // create model programmatically
        let model = NSManagedObjectModel()
        let noteEntity = NSEntityDescription()
        noteEntity.name = "Note"
        noteEntity.managedObjectClassName = "Note"

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

        // iCloud optional: only configure CloudKit when user enables in settings
        let useCloud = UserDefaults.standard.bool(forKey: "enableCloudSync")
        if useCloud {
            if let description = container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            }
        } else {
            let desc = NSPersistentStoreDescription()
            desc.type = NSSQLiteStoreType
            desc.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("TodayInspiration.sqlite")
            container.persistentStoreDescriptions = [desc]
        }

        container.loadPersistentStores { storeDesc, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
