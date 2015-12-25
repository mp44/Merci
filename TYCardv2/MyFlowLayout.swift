//
//  MyFlowLayout.swift
//  TYCardv2
//
//  Created by Andy Wei on 7/21/15.
//  Copyright (c) 2015 Andy Wei. All rights reserved.
//

import UIKit

class MyFlowLayout: UICollectionViewFlowLayout {
   
    var currentCellPath: NSIndexPath?
    var currentCellCenter: CGPoint?
    var currentCellScale: CGFloat?
    
    func setCurrentCellScale(scale: CGFloat)
    {
        currentCellScale = scale
        self.invalidateLayout()
    }
    
    func setCurrentCellCenter(origin: CGPoint)
    {
        currentCellCenter = origin
        self.invalidateLayout()
    }
    override func layoutAttributesForItemAtIndexPath(indexPath:
        NSIndexPath) -> UICollectionViewLayoutAttributes {
            
            let attributes =
            super.layoutAttributesForItemAtIndexPath(indexPath)
            
            self.modifyLayoutAttributes(attributes)
            return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) ->
        [AnyObject] {
            
            let allAttributesInRect =
            super.layoutAttributesForElementsInRect(rect)
            
            for cellAttributes in allAttributesInRect! {
                self.modifyLayoutAttributes(cellAttributes as!
                    UICollectionViewLayoutAttributes)
            }
            return allAttributesInRect!
    }
    func modifyLayoutAttributes(layoutattributes:
        UICollectionViewLayoutAttributes) {
            
            if layoutattributes.indexPath == currentCellPath {
                layoutattributes.transform3D =
                    CATransform3DMakeScale(currentCellScale!,
                        currentCellScale!, 1.0)
                layoutattributes.center = currentCellCenter!
                layoutattributes.zIndex = 1
            }
    }
}
