//
//  MyCollectionViewCell.swift
//  TYCardv2
//
//  Created by Andy Wei on 7/23/15.
//  Copyright (c) 2015 Andy Wei. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var chooseButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        chooseButton = UIButton(type: UIButtonType.System)
    }
}
