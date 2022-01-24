//
//  APIFetcher.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/10/21.
//

import Foundation

class APIFetcher {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    func postHeartRateToServer(url: String, completion: @escaping (String?) -> ()) {
        
        let url: URL = URL(string: url)!
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion("Sucess get data from server")
                } else {
                    print("\(httpResponse.statusCode)")
                    completion(nil)
                }
            }
        }
        
        dataTask?.resume()
    }
}

