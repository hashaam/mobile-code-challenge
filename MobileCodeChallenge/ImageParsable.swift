//
//  ImageParsable.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

enum ImageParseResult {
    case success(UIImage?)
    case failure(Error?)
}

protocol ImageParsable { }

extension ImageParsable {
    func parse(data: Data) -> UIImage? {
        return UIImage(data: data, scale: UIScreen.main.scale)
    }
}
