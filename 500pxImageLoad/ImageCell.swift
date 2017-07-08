//
//  ImageCell.swift
//  500pxImageLoad
//
//  Created by Darren Leak on 2017/07/07.
//  Copyright © 2017 Darren Leak. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .center
        }
    }
}
