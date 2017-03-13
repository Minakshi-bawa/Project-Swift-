//
//  CoreDataHelper.swift
//
//  Copyright © 2017 All right preserved
//

import UIKit
import CoreData

let FieldId = "FieldId"
let Value = "Value"
let Results = "Data"
class CoreDataHelper: NSObject {

    //MARK:- Variables/Core Data stack
    static let sharedInstance = CoreDataHelper()

    fileprivate lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ios.Formidale" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    fileprivate lazy var applicationLibraryDirectory: URL = {
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "DJWorkforce", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        debugPrint(self.applicationDocumentsDirectory)
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    lazy var bgManagedObjectContext: NSManagedObjectContext = {
        var bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = CoreDataHelper.sharedInstance.managedObjectContext
        return bgContext
    }()
}

// MARK: - Core Data Saving support
extension CoreDataHelper{
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func saveBackgroundContext() {
        do{
            try bgManagedObjectContext.save()
            managedObjectContext.perform({
                do{
                    try self.managedObjectContext.save()
                }catch{
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            })
        }catch{
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}

//MARK:-  Data fetching methods via NSFetchRequest
extension CoreDataHelper{
    static func fetchObjectsOfClassWithName(className : String, predicate : NSPredicate?, sortingKeys : [(key:String, isAcending:Bool)]?, context:NSManagedObjectContext = CoreDataHelper.sharedInstance.managedObjectContext) -> Array<Any>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        fetchRequest.predicate = predicate

        //if there are sort keys
        if let sortingKeys = sortingKeys
        {
            fetchRequest.sortDescriptors = []
            for val in sortingKeys {
                let sortDescriptor = NSSortDescriptor(key: val.key, ascending: val.isAcending)
                fetchRequest.sortDescriptors?.append(sortDescriptor)
            }
        }

        do{
            let managedObjectContext = context
            return try managedObjectContext.fetch(fetchRequest)
        }
        catch
        {
            return []
        }
    }
}

//MARK:- NSFetchedResultsController setup method
extension CoreDataHelper{
    static func getFectechedResultsControllerWithEntityName(entityName : String, predicate : NSPredicate?, fetchLimit:Int?, sectionNameKeyPath : String?, sortingKeys : [(key:String, isAcending:Bool)]?) ->
        NSFetchedResultsController<NSFetchRequestResult>{

            let managedObjectContext = CoreDataHelper.sharedInstance.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
            fetchRequest.entity = entityDesc

            //If there is any fetch limit
            if let fetchLimit = fetchLimit{
                fetchRequest.fetchLimit = fetchLimit
            }

            fetchRequest.sortDescriptors = []
            //if there are sort keys
            if let sortingKeys = sortingKeys {
                for val in sortingKeys {
                    let sortDescriptor = NSSortDescriptor(key: val.key, ascending: val.isAcending)
                    fetchRequest.sortDescriptors?.append(sortDescriptor)
                }
            }
            // if predicate exists
            fetchRequest.predicate = predicate
            fetchRequest.fetchBatchSize = 50
            fetchRequest.returnsObjectsAsFaults = false
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)

            //perform fetch
            do{
                try fetchedResultsController.performFetch()
            }
            catch
            {
                debugPrint("Unable to fetch objects")
            }
            return fetchedResultsController;
            
    }
}
