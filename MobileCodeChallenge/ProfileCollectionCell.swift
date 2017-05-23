//
//  ProfileCollectionCell.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

protocol CellViewModelDelegate: class {
    func cancelOperation(forKey: OperationKey)
}

class ProfileCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var imageOperationKey: OperationKey?
    weak var delegate: CellViewModelDelegate?
    
    override func awakeFromNib() {
        
        favoriteImageView.tintColor = UIColor.yellow
        
    }
    
    override func prepareForReuse() {
        
        cellImageView.image = nil
        
        guard let iok = imageOperationKey else { return }
        delegate?.cancelOperation(forKey: iok)
        
    }
    
}
