//
//  DetailViewController.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, CoreDataStackProviding, ReachManagerProviding {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!
    
    var profile: Profile?
    
    var dataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        title = "Loading..."

        // load image
        loadImage()
        
        // get data
        getData()
        
    }
    
    @IBAction func buttonHandler(_ sender: Any) {
        
        guard let profile = profile else { return }
        
        coreDataStack.performBackgroundTask { (context: NSManagedObjectContext) in
            
            // set profile as favorite
            Profile.setProfileAsFavorite(pk: profile.pk, context: context)
            
            // save
            context.saveOrPrint()
            
        }
        
    }
    
    func loadImage() {
        
        guard let profile = profile else { return }
        
        let pi = ParseImage(coreDataStack: coreDataStack, reachManager: reachManager, imageView: mainImageView, object: profile, completionHandler: nil)
        pi.process()
        
    }
    
    func getData() {
        
        guard let profile = profile else { return }
        
        // load data
        loadData()
        
        // continue downloading details only if data not loaded
        if dataLoaded { return; }
        
        let pk = profile.pk
        let ppd = ParseProfileDetail(pk: pk, coreDataStack: coreDataStack, reachManager: reachManager) { [weak self] (result: JSONParseResult) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success:
                strongSelf.loadData()
                
            case .failure(let error):
                strongSelf.handleError(error: error)
                
            }
            
        }
        ppd.fetch()
        
    }
    
    func loadData() {
        
        guard let profile = profile else { return }
        
        let firstName = profile.firstName ?? ""
        let lastName = profile.lastName ?? ""
        
        guard firstName.characters.count > 0 else { return }
        guard lastName.characters.count > 0 else { return }
        
        let fullName = "\(firstName) \(lastName)"
        
        title = fullName
        
        dataLoaded = true
        
    }
    
    func handleError(error: Error?) {
        
        // TODO: Show alert view here to retry
        
    }
    
}
