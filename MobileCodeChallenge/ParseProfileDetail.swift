//
//  ParseProfileDetail.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import CoreData

class ParseProfileDetail: Fetchable, CoreDataStackProviding, ReachManagerProviding, JSONParsable {
    
    typealias ResultType = [String: Any]
    
    let pk: Int64
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!
    let completionHandler: (JSONParseResult) -> Void
    
    var urlString: String {
        let pkStr = String(describing: pk)
        return "https://fierce-harbor-90458.herokuapp.com/profiles/\(pkStr)"
    }
    var operationKey: OperationKey { return .profile(pk) }
    
    init(pk: Int64, coreDataStack: CoreDataStack, reachManager: ReachabilityManager, completionHandler: @escaping (JSONParseResult) -> Void) {
        self.pk = pk
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
            
            let firstName = result["first_name"] as? String ?? ""
            let lastName = result["last_name"] as? String ?? ""
            
            // update
            Profile.update(pk: strongSelf.pk, firstName: firstName, lastName: lastName, context: context)
            
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
