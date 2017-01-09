//
//  CoreDataHelper.swift
//  CoreDataSwift3
//


import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    static let coreDataSharedObj = CoreDataHelper()
    static let managedContext = CoreDataHelper.coreDataSharedObj.persistentContainer.viewContext
    var storeName: String = "CoreDataSwift3"
    
    //Var storeURL
   private var storeURL : URL {
        let storePath = self.applicationDocumentsDirectory
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(
                atPath: storePath as String,
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            print("Error creating storePath \(storePath): \(error)")
        }
        
        let sqliteFilePath = self.applicationDocumentsDirectory.appendingPathComponent(self.storeName + ".sqlite")
        
        return URL(fileURLWithPath: sqliteFilePath)
    }
    
    private lazy var applicationDocumentsDirectory: NSString = {
        let storePaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let storePath = storePaths[0] as NSString
        return storePath
    }()
    
    //Var storeDescription
    private lazy var storeDescription: NSPersistentStoreDescription = {
        let description = NSPersistentStoreDescription(url: self.storeURL)
        return description
    }()
    
    func fetchRequestEmployee()-> NSFetchRequest<Employee>{
        let fetchRequest: NSFetchRequest<Employee> = NSFetchRequest(entityName: "Employee")
        return fetchRequest
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataSwift3") // this name is same as CoreDataSwift3.xcdatamodeld
        container.persistentStoreDescriptions = [self.storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //-----------------------------------
/*
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CoreDataSwift3", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = URL(string: self.applicationDocumentsDirectory.appendingPathComponent(self.storeName + ".sqlite"))
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
*/
    //---------------------
    
    
    
}
