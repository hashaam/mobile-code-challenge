//
//  ViewController.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, CoreDataStackProviding, ReachManagerProviding {
    
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadMainViewController() {
        
        guard let nvc = storyboard?.instantiateViewController(withIdentifier: "Navigation Controller") as? UINavigationController else { return }
        guard let vc = nvc.topViewController as? MainViewController else { return }
        
        guard let delegate = UIApplication.shared.delegate else { return }
        guard let window = delegate.window else { return }
        
        vc.coreDataStack = coreDataStack
        vc.reachManager = reachManager
        
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        
    }

}

