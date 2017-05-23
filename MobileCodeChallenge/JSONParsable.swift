//
//  JSONParsable.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation

enum JSONParseResult {
    case success
    case failure(Error?)
}

protocol JSONParsable {
    associatedtype ResultType
}

enum ParseResult<T> {
    case success(T)
    case failure(Error?)
}

extension JSONParsable {
    func parse(data: Data) -> ResultType? {
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: []) as? ResultType else { return nil }
            return result
        } catch {
            
        }
        return nil
    }
}
