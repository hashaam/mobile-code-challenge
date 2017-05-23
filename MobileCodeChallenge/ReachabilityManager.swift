//
//  ReachabilityManager.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import ReachabilitySwift

enum OperationKey {
    case profileList
    case profile(Int64)
    case image(String)
    
    var keyString: String {
        switch self {
        case .profileList:
            return "profileList"
        case .profile(let pk):
            let pkStr = String(describing: pk)
            return "profile_\(pkStr)"
        case .image(let url):
            return "\(url)_image"
        }
    }
}

class ReachabilityManager {
    
    private var reachability = Reachability.init()
    
    private let oq = OperationQueue()
    
    // operation key
    private var ok = [String: Operation]()
    
    init() {
        
        reachability?.whenReachable = { [weak self] reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            // un-suspend operation queue on reachable
            if let strongSelf = self {
                strongSelf.oq.isSuspended = false
            }
            
            DispatchQueue.main.async {
                // hide alert view
                UIApplication.shared.keyWindow?.hideAlertView()
            }
        }
        reachability?.whenUnreachable = { [weak self] reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            
            // suspend operation queue on not reachable
            if let strongSelf = self {
                strongSelf.oq.isSuspended = true
            }
            
            DispatchQueue.main.async {
                // show alert view on child view controllers of UINavigationController of window's rootViewController
                if let window = UIApplication.shared.keyWindow, window.rootViewController is UINavigationController {
                    UIApplication.shared.keyWindow?.showAlertView()
                }
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            
        }
        
    }
    
    func isReachable() -> Bool {
        
        return reachability?.isReachable ?? false
        
    }
    
    func add(operation op: Operation, withKey key: OperationKey) {
        
        // check if operation already exists, return
        if let _ = ok[key.keyString] { return }
        
        
        if !isReachable() {
            oq.isSuspended = true
        }
        
        // keep handle of operation
        ok[key.keyString] = op
        
        // add operation to queue
        oq.addOperation(op)
        
    }
    
    func removeOperation(withKey key: OperationKey) {
        
        ok.removeValue(forKey: key.keyString)
        
    }
    
    func cancelOperation(withKey key: OperationKey) {
        
        if let op = ok[key.keyString] {
            
            op.cancel()
            
            removeOperation(withKey: key)
            
        }
        
    }
    
}
