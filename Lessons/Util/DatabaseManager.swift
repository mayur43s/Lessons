//
//  DatabaseManager.swift
//  Lessons
//
//  Created by Mayur Shrivas on 10/01/23.
//

import CoreData

class DatabaseManager {
    
    static let shared = DatabaseManager(modelName: "VideoLessons")

    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext = storeContainer.viewContext

    func saveContext() {
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject> (_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try managedContext.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch let err {
            print(err)
            return [T]()
        }
    }

    func fetchWithPredicate<T: NSManagedObject> (_ objectType: T.Type, key: String, with filter: String) -> [T] {

        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(key) == %@", filter)

        do {
            let fetchedObjects = try managedContext.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch let err {
            print(err)
            return [T]()
        }
    }

    func delete(_ objectType: NSManagedObject) {
        managedContext.delete(objectType)
        saveContext()
    }

    func deleteAllRecords(_ entityName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error while trying to delete the entity: \(entityName)")
        }
    }
}
