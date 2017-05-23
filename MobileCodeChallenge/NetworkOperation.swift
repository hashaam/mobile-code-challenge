//
//  NetworkOperation.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

enum Result {
    case success(Data, URLResponse?)
    case failure(Error?)
}

class NetworkOperation: CustomOperation, URLSessionDataDelegate {
    
    private weak var task: URLSessionTask?
    var incomingData = Data()
    var response: URLResponse?
    
    private let completionHandler: (Result) -> Void
    
    init(request: URLRequest, uploadData: Data? = nil, completionHandler: @escaping (Result) -> Void) {
        
        self.completionHandler = completionHandler
        
        super.init()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: nil)
        if let ud = uploadData {
            task = session.uploadTask(with: request, from: ud)
        } else {
            task = session.dataTask(with: request)
        }
        
    }
    
    final override func execute() {
        
        task?.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        self.response = response
        
        if isCancelled {
            isFinished = true
            task?.cancel()
            return
        }
        
        // check the response code and react appropriately
        completionHandler(.allow)
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if isCancelled {
            isFinished = true
            task?.cancel()
            return
        }
        
        incomingData.append(data)
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if isCancelled {
            isFinished = true
            task.cancel()
            return
        }
        
        if error != nil {
            self.error = error
            completionHandler(.failure(error))
            isFinished = true
            return
        }
        
        
        completionHandler(.success(incomingData, response))
        
        isFinished = true
        
    }
    
}

