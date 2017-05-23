//
//  UIImageViewExtension.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func transition(duration: TimeInterval = 0.25, fromData imageData: Data) {
        
        DispatchQueue.global().async {
            
            let img = UIImage(data: imageData, scale: UIScreen.main.scale)
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.transition(duration: duration, toImage: img)
                
            }
            
        }
        
    }
    
    func transition(duration: TimeInterval = 0.25, toImage image: UIImage?) {
        
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            
            self.image = image
            
        }, completion: nil)
        
    }
    
    func loadImage(fromData imageData: Data) {
        
        DispatchQueue.global().async {
            
            let img = UIImage(data: imageData, scale: UIScreen.main.scale)
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.image = img
                
            }
            
        }
        
    }
    
}

