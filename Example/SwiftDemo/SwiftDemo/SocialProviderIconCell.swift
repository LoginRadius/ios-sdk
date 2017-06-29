//
//  SocialProviderIconCell.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import UIKit

class SocialProviderIconCell: UICollectionViewCell {
    var imageView : UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
