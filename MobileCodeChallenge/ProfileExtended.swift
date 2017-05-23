//
//  ProfileExtended.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

extension Profile {
    
    static func save(pk: Int64, image: String, context: NSManagedObjectContext) {
        
        let p = Profile(context: context)
        p.pk = pk
        p.image = image
        p.imageData = NSData()
        
    }
    
    static func update(pk: Int64, firstName: String, lastName: String, context: NSManagedObjectContext) {
        
        let p = Profile.predicate(forPk: pk)
        guard let profile = Profile.get(predicate: p, context: context)?.first else { return }
        
        profile.firstName = firstName
        profile.lastName = lastName
        
    }
    
    static func get(predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [Profile]? {
        
        let fr: NSFetchRequest<Profile> = Profile.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: "pk", ascending: true)]
        
        if let predicate = predicate {
            fr.predicate = predicate
        }
        
        if let results = try? context.fetch(fr) {
            return results
        }
        
        return nil
        
    }
    
    static func predicate(forPk pk: Int64) -> NSPredicate {
        return NSPredicate(format: "pk = %d", pk)
    }
    
    static func setProfileAsFavorite(pk: Int64, context: NSManagedObjectContext) {
        
        let p = Profile.predicate(forPk: pk)
        guard let profile = Profile.get(predicate: p, context: context)?.first else { return }
        
        profile.isFavorite = true
        
    }
    
}
