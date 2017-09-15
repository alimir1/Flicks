//
//  GirdViewLayout.swift
//  Flicks
//
//  Created by Ali Mir on 9/15/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        get {
            
            guard let collectionView = collectionView else {
                // Default fallback
                return CGSize(width: 100, height: 180)
            }
            
            let itemWidth: CGFloat = (collectionView.bounds.width/CGFloat(2)) - self.minimumLineSpacing
            
            let itemHeight = itemWidth*1.5
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        }
        
        set {
            super.itemSize = newValue
        }
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }

    
}
