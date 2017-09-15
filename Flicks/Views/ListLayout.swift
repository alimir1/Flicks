//
//  ListLayout.swift
//  Flicks
//
//  Created by Ali Mir on 9/15/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

class ListLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.minimumLineSpacing = 1
    }
    
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else {
                // Default fallback
                return CGSize(width: 100, height: 100)
            }
            
            let itemWidth = collectionView.frame.width
            let itemHeight = CGFloat(250)
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        set {
            super.itemSize = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
}
