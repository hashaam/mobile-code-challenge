//
//  ParseProfile.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

class ParseProfile: Fetchable, CoreDataStackProviding, ReachManagerProviding, JSONParsable {
    
    typealias ResultType = [[String: Any]]
    
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!
    let completionHandler: (JSONParseResult) -> Void
    
    var urlString = "https://fierce-harbor-90458.herokuapp.com/profiles"
    var operationKey: OperationKey { return .profileList }
    
    init(coreDataStack: CoreDataStack, reachManager: ReachabilityManager, completionHandler: @escaping (JSONParseResult) -> Void) {
        self.coreDataStack = coreDataStack
        self.reachManager = reachManager
        self.completionHandler = completionHandler
    }
    
    func handle(data: Data, response: URLResponse?) {
        
        guard let result = parse(data: data) else {
            handle(error: nil)
            return
        }
        
        coreDataStack.performBackgroundTask(block: { [weak self] (context: NSManagedObjectContext) in
            
            guard let strongSelf = self else { return }
            
            result
                .forEach { obj in
                    
                    let pk = obj["id"] as? Int64 ?? 0
                    let image = obj["profile_picture"] as? String ?? ""
                    
                    // save
                    Profile.save(pk: pk, image: image, context: context)
                    
            }
            
            // save or print
            context.saveOrPrint()
            
            DispatchQueue.main.async {
                strongSelf.completionHandler(.success)
            }
            
            // clean up
            strongSelf.cleanUp()
            
        })
        
    }
    
    func handle(error: Error?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.completionHandler(.failure(error))
        }
        
        // clean up
        cleanUp()
        
    }
    
}
