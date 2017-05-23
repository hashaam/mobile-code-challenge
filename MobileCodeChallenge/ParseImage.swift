//
//  ParseImage.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit
import CoreData

class ParseImage: Fetchable, CoreDataStackProviding, ReachManagerProviding, ImageParsable {
    
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!
    let imageAssignedHandler: (() -> Void)?
    let completionHandler: ((ImageParseResult) -> Void)?
    
    var urlString: String = ""
    var operationKey: OperationKey { return .image(urlString) }
    
    let imageView: UIImageView
    let object: Profile
    
    init(coreDataStack: CoreDataStack, reachManager: ReachabilityManager, imageView: UIImageView, object: Profile, imageAssignedHandler: (() -> Void)? = nil, completionHandler: ( (ImageParseResult) -> Void)?) {
        self.coreDataStack = coreDataStack
        self.reachManager = reachManager
        self.imageView = imageView
        self.object = object
        self.imageAssignedHandler = imageAssignedHandler
        self.completionHandler = completionHandler
    }
    
    func process() {
        
        if let imageData = object.imageData as Data?, imageData.count > 0 {
            
            imageView.loadImage(fromData: imageData)
            imageAssignedHandler?()
            return
            
        }
        
        guard let urlString = object.image, urlString.characters.count > 0 else { return }
        
        self.urlString = urlString
        
        fetch()
        
    }
    
    func handle(data: Data, response: URLResponse?) {
        
        guard let image = parse(data: data) else {
            handle(error: nil)
            return
        }
        
        coreDataStack.performBackgroundTask(block: { [weak self] (context: NSManagedObjectContext) in
            
            guard let strongSelf = self else { return }
            
            guard let tmpObject = context.object(with: strongSelf.object.objectID) as? Profile else { return }
            
            tmpObject.imageData = data as NSData
            
            context.saveOrPrint()
            
            DispatchQueue.main.async {
                strongSelf.imageView.transition(toImage: image)
                strongSelf.imageAssignedHandler?()
                strongSelf.completionHandler?(.success(image))
            }
            
            // clean up
            strongSelf.cleanUp()
            
        })
        
    }
    
    func handle(error: Error?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.completionHandler?(.failure(error))
        }
        
        // clean up
        cleanUp()
        
    }
    
}

