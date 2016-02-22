//
//  StretchyCollectionViewLayout.swift
//  StretchyCollection
//
//  Created by Ryan Poolos on 1/19/16.
//  Copyright © 2016 Frozen Fire Studios, Inc. All rights reserved.
//

import UIKit

let StretchyCollectionHeaderKind = "StretchyCollectionHeaderKind"

class StretchyCollectionViewLayout: UICollectionViewLayout {
    
    let startingHeaderHeight: CGFloat = 128.0
    
    var sectionInset = UIEdgeInsetsZero
    var itemSize = CGSize.zero
    var itemSpacing: CGFloat = 0.0
    
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepareLayout() {
        super.prepareLayout()
        
        // Start with a fresh array of attributes
        attributes = []
        
        // Can't do much without a collectionView.
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfSections = collectionView.numberOfSections()
        
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItemsInSection(section)
            
            for item in 0..<numberOfItems {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                if let attribute = layoutAttributesForItemAtIndexPath(indexPath) {
                    attributes.append(attribute)
                }
            }
        }
        
        let headerIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        if let headerAttribute = layoutAttributesForSupplementaryViewOfKind(StretchyCollectionHeaderKind, atIndexPath: headerIndexPath) {
            attributes.append(headerAttribute)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleAttributes = attributes.filter { attribute -> Bool in
            return rect.contains(attribute.frame) || rect.intersects(attribute.frame)
        }
        
        return visibleAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }

        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var sectionOriginY = startingHeaderHeight + sectionInset.top
        
        if indexPath.section > 0 {
            let previousSection = indexPath.section - 1
            let lastItem = collectionView.numberOfItemsInSection(previousSection) - 1
            let previousCell = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: lastItem, inSection: previousSection))
            sectionOriginY = (previousCell?.frame.maxY ?? 0) + sectionInset.bottom
        }
        
        let itemOriginY = sectionOriginY + CGFloat(indexPath.item) * (itemSize.height + itemSpacing)
        
        attribute.frame = CGRect(x: sectionInset.left, y: itemOriginY, width: itemSize.width, height: itemSize.height)
        
        return attribute
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: StretchyCollectionHeaderKind, withIndexPath: indexPath)
        attribute.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: startingHeaderHeight)
        return attribute
    }
    
    override func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        
        let numberOfSections = collectionView.numberOfSections()
        let lastSection = numberOfSections - 1
        let numberOfItems = collectionView.numberOfItemsInSection(lastSection)
        let lastItem = numberOfItems - 1
        
        guard let lastCell = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: lastItem, inSection: lastSection)) else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.width, height: lastCell.frame.maxY + sectionInset.bottom)
    }
}
