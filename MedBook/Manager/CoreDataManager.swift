import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    
    private init(inMemory:Bool = false) {
        // pass the data model filename to NSPersistentContainer initializer
        container = NSPersistentContainer(name: "MedBookContainer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // load any persistent stores
        container.loadPersistentStores { (description, error) in
            if let error = error  {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    // save the changes on your context to the persistent store
    func saveContext()->Bool {
        do {
            try viewContext.save()
            return true
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
            return false
        }
    }
    
    
     func resetDatabase() {
        do {
            try container.persistentStoreCoordinator.managedObjectModel.entities.forEach { (entity) in
                if let name = entity.name {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    try viewContext.execute(request)
                }
            }
            try viewContext.save()
        } catch {
            print("error resenting the database: \(error.localizedDescription)")
        }
    }

}



