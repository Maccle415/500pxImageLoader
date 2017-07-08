//
//  APIEndpoint.swift
//  500pxImageLoad
//
//  Created by Darren Leak on 2017/07/07.
//  Copyright © 2017 Darren Leak. All rights reserved.
//

import Foundation

enum APIEndpoint
{
    case photos
    case page(pageNumber: Int, endpoint: String)
    
    func stringValue() -> String
    {
        switch self
        {
        case .photos:
            return "https://api.500px.com/v1/photos?consumer_key=\(self.consumerKey())&exclude=nude&image_size=2"
        case .page(let pageNumber, let endpoint):
            return "\(endpoint)&page=\(pageNumber)"
        }
    }
    
    private func consumerKey() -> String
    {
        return "ltsZ9szdG9G3usj4E4UhomCykVqTGpfjX61y7I7r"
    }
}
