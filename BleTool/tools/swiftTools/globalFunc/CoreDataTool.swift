//
//  CoreDataTool.swift
//  MobileHealth
//
//  Created by boeDev on 2018/12/26.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//

import UIKit
import CoreData
class CoreDataTool: NSObject {
    static let `default` = CoreDataTool.init()
    lazy var clingModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "ClingModel", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        return managedObjectModel!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: self.clingModel)
        let sqliteURL = self.documentDir.appendingPathComponent("ClingModel")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return persistentStoreCoordinator
    }()
    
    lazy var documentDir: URL = {
        let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return documentDir!
    }()
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    // 更新数据
    func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // 增加数据
//    func savePersonWith(name: String, age: Int16) {
//        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! MinuteData
//        person.name = name
//        person.age = age
//        saveContext()
//    }
    
//    // 获取所有数据
//    func getAllPerson() -> [Person] {
//        let fetchRequest: NSFetchRequest = Person.fetchRequest()
//        do {
//            let result = try context.fetch(fetchRequest)
//            return result
//        } catch {
//            fatalError();
//        }
//    }
    
//    // 根据姓名获取数据
//    func getPersonWith(name: String) -> [Person] {
//        let fetchRequest: NSFetchRequest = Person.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        do {
//            let result: [Person] = try context.fetch(fetchRequest)
//            return result
//        } catch {
//            fatalError();
//        }
//    }
//    // 根据姓名修改数据
//    func changePersonWith(name: String, newName: String, newAge: Int16) {
//        let fetchRequest: NSFetchRequest = Person.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        do {
//            // 拿到符合条件的所有数据
//            let result = try context.fetch(fetchRequest)
//            for person in result {
//                // 循环修改
//                person.name = newName
//                person.age = newAge
//            }
//        } catch {
//            fatalError();
//        }
//        saveContext()
//    }
    
//    // 根据姓名删除数据
//    func deleteWith(name: String) {
//        let fetchRequest: NSFetchRequest = Person.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//        do {
//            let result = try context.fetch(fetchRequest)
//            for person in result {
//                context.delete(person)
//            }
//        } catch {
//            fatalError();
//        }
//        saveContext()
//    }
    
//    // 删除所有数据
//    func deleteAllPerson() {
//        // 这里直接调用上面获取所有数据的方法
//        let result = getAllPerson()
//        // 循环删除所有数据
//        for person in result {
//            context.delete(person)
//        }
//        saveContext()
//    }
    

    
}
