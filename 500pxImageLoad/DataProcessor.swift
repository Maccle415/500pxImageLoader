//
//  DataProcessor.swift
//  500pxImageLoad
//
//  Created by Darren Leak on 2017/07/07.
//  Copyright © 2017 Darren Leak. All rights reserved.
//

import Foundation

struct DataProcessor {
    static func imageUrlsFromData(_ data: Data) -> (imageUrlStrings: [String], error: Error?)
    {
        var imagesUrlStrings = [String]()
        do
        {
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                if let photos = jsonData["photos"] as? [[String: Any]]
                {
                    for photo in photos
                    {
                        if let imageUrl = photo["image_url"]
                        {
                            if let imageUrlString = imageUrl as? String
                            {
                                imagesUrlStrings.append(imageUrlString)
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            return (imagesUrlStrings, error)
        }
        
        return (imagesUrlStrings, nil)
    }
    
    static func pageInformationFromData(_ data: Data) -> (currentPage: Int, totalPages: Int)
    {
        do
        {
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            {
                if let currentPage = jsonData["current_page"] as? Int, let totalPages = jsonData["total_pages"] as? Int
                {
                    return (currentPage, totalPages)
                }
            }
        }
        catch {}
        
        return (1, 1)
    }
}
