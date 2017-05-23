//
//  AlertView.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            label.textColor = textColor
        }
    }
    
    private let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        
        addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        
    }
    
}
