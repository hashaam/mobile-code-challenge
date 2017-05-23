//
//  CoreDataStack.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var container: NSPersistentContainer!
    
    var readyHandler: () -> Void
    
    init(readyHandler: @escaping ()->Void) {
        
        self.readyHandler = readyHandler
        
    }
    
    func initializeCoreDataStack() {
        
        container = NSPersistentContainer(name: "MobileCodeChallenge")
        container.loadPersistentStores { [weak self] (storeDescription: NSPersistentStoreDescription, error: Error?) in
            
            if let error = error {
                print("Failed to load store")
                print("Unresolved error \(error.localizedDescription)\nAttempted to create store")
                abort()
            }
            
            DispatchQueue.main.async {
                self?.readyHandler()
            }
            
        }
        
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        let vc = self.container.viewContext
        vc.automaticallyMergesChangesFromParent = true
        return vc
    }()
    
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    func saveContext() {
        
        if !container.viewContext.hasChanges { return }
        
        container.viewContext.perform { [weak self] in
            
            guard let strongSelf = self else { return }
            
            do {
                
                try strongSelf.container.viewContext.save()
                
            } catch let error {
                
                print("Error saving context: \(error.localizedDescription)")
                abort()
                
            }
            
        }
        
    }
    
}
