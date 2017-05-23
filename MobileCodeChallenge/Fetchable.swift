//
//  Fetchable.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import Foundation
protocol Fetchable {
    
    var urlString: String { get }
    var operationKey: OperationKey { get }
    func update(urlRequest: URLRequest) -> URLRequest
    func handle(data: Data, response: URLResponse?)
    func handle(error: Error?)
    
}

extension Fetchable where Self: ReachManagerProviding {
    
    func update(urlRequest: URLRequest) -> URLRequest { return urlRequest }
    
    var uploadData: Data? { return nil }
    
    func fetch() {
        
        var ur = URLRequest(url: URL(string: urlString)!)
        ur = update(urlRequest: ur)
        
        let op = NetworkOperation(request: ur, uploadData: uploadData) { (result: Result) in
            
            switch result {
                
            case .success(let data, let response):
                self.handle(data: data, response: response)
                
            case .failure(let error):
                self.handle(error: error)
                
            }
            
        }
        
        reachManager.add(operation: op, withKey: operationKey)
        
    }
    
    func cleanUp() {
        
        reachManager.removeOperation(withKey: self.operationKey)
        
    }
    
}

