//
//  CoreDataManager.swift
//  PocketRocket
//
//  Created by Tim Isenman on 8/9/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, errorString) in
            guard errorString == nil else {
                fatalError(errorString!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension DataController {
    
    func autoSaveViewContext(interval: TimeInterval = 10) {
//        print("Autosaving")
        guard interval > 0 else {
            print("Cannot save on negative intervals")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
        
    }
    
}
