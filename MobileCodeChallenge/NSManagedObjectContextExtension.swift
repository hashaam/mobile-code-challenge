//
//  NSManagedObjectContextExtension.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveOrPrint() {
        do {
            try save()
        } catch let error as NSError {
            print("Couldn't save context. \(error.localizedDescription)")
        }
    }
}
