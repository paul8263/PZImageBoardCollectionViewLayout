//
//  PZImageBoardCollectionViewLayout.swift
//  PZImageBoardCollectionViewLayout
//
//  Created by Paul Zhang on 31/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

protocol PZImageBoardCollectionViewLayoutDelegate: class {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PZImageBoardCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: PZImageBoardCollectionViewLayoutDelegate? {
        return collectionView?.delegate as? PZImageBoardCollectionViewLayoutDelegate
    }
    
    var numberOfColumn = 2 {
        didSet {
            invalidateLayout()
        }
    }
    
    var contentWidth: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }
    
    var cellMargin: CGFloat = 10.0 {
        didSet {
            invalidateLayout()
        }
    }
    
    var columnWidth: CGFloat {
        return (contentWidth - CGFloat(numberOfColumn + 1) * cellMargin ) / CGFloat(numberOfColumn)
    }
    
    private var heightForColumn: [CGFloat] = []
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        layoutAttributes = []
        heightForColumn = [CGFloat](repeating: cellMargin, count: numberOfColumn)
        for index in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexForColumn = heightForColumn.index(of: heightForColumn.min()!)!
            
            let indexPath = IndexPath(row: index, section: 0)
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let offsetY = heightForColumn[indexForColumn]
            
            let offsetX = cellMargin + (columnWidth + cellMargin) * CGFloat(indexForColumn)
            
            if let cellHeight = delegate?.collectionView(collectionView!, layout: self, heightForCellAtIndexPath: indexPath) {
                let frame = CGRect(x: offsetX, y: offsetY, width: columnWidth, height: cellHeight)
                attr.frame = frame
                layoutAttributes.append(attr)
                heightForColumn[indexForColumn] += cellHeight + cellMargin
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array: [UICollectionViewLayoutAttributes] = []
        for attr in layoutAttributes {
            if attr.frame.intersects(rect) {
                array.append(attr)
            }
        }
        return array
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: heightForColumn.max()!)
    }
}
