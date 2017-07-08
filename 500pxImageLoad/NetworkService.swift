//
//  NetworkService.swift
//  500pxImageLoad
//
//  Created by Darren Leak on 2017/07/07.
//  Copyright © 2017 Darren Leak. All rights reserved.
//

import Foundation
import UIKit

protocol DataTaskRunnable
{
    func dataForApiEndpoint(_ endpoint: APIEndpoint, completion: @escaping (Data?, Error?) -> Void)
    func dataForImageURLString(_ urlString: String, order: Int, completion: @escaping (UIImage?, Error?) -> Void)
}

extension DataTaskRunnable {
    func dataForApiEndpoint(_ endpoint: APIEndpoint, completion: @escaping (Data?, Error?) -> Void)
    {
        if let url = URL(string: endpoint.stringValue())
        {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                completion(data, error)
                }.resume()
        }
    }
    
    func dataForImageURLString(_ urlString: String, order: Int, completion: @escaping (UIImage?, Error?) -> Void)
    {
        if let url = URL(string: urlString)
        {
            URLSession.shared.dataTask(with: url) { (responseData, response, error) in
                if error == nil
                {
                    if let data = responseData
                    {
                        let image = UIImage(data: data)
                        completion(image, nil)
                    }
                }
                else
                {
                    completion(nil, error)
                }
                }.resume()
        }
    }
}
