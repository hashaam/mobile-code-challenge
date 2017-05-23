//
//  UIWindowExtension.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
import UIKit

private var xoAlertViewAssociationKey: UInt8 = 0
private var xoAlertViewBottomConstraintAssociationKey: UInt8 = 0

extension UIWindow {
    
    var alertView: UIView? {
        get {
            return objc_getAssociatedObject(self, &xoAlertViewAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAlertViewAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var alertViewBottomConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &xoAlertViewBottomConstraintAssociationKey) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAlertViewBottomConstraintAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setAlertView() {
        
        guard alertView == nil else { return }
        
        let height = CGFloat(40.0)
        
        let av = AlertView()
        av.translatesAutoresizingMaskIntoConstraints = false
        av.backgroundColor = UIColor(colorLiteralRed: 254.0/255.0, green: 232.0/255.0, blue: 234.0/255.0, alpha: 1.0)
        av.textColor = UIColor(colorLiteralRed: 194.0/255.0, green: 35.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        av.text = "Could not connect to server"
        
        addSubview(av)
        
        av.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        av.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        av.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let bottomConstraint = av.bottomAnchor.constraint(equalTo: bottomAnchor, constant: height)
        bottomConstraint.isActive = true
        
        alertView = av
        alertViewBottomConstraint = bottomConstraint
        
        layoutIfNeeded()
        
    }
    
    func showAlertView() {
        
        if alertView == nil {
            setAlertView()
        }
        
        guard let bottomConstraint = alertViewBottomConstraint else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            bottomConstraint.constant = 0.0
            self.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func hideAlertView() {
        
        guard let bottomConstraint = alertViewBottomConstraint else { return }
        
        let height = CGFloat(40.0)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            
            bottomConstraint.constant = height
            self.layoutIfNeeded()
            
        }) { (completed: Bool) in
            
            self.alertView?.removeFromSuperview()
            self.alertView = nil
            
            self.alertViewBottomConstraint = nil
            
        }
        
    }
    
}
