//
//  UICollectionView+Ext.swift
//  WordSearch
//
//  Created by Santos on 2019-05-14.
//  Copyright © 2019 Santos.swift. All rights reserved.
//

import UIKit

extension UICollectionView {
    func rightNeighbour(cell : UICollectionViewCell) -> UICollectionViewCell? {
        guard let indexPath = self.indexPath(for: cell) else{
            return nil
        }
        if (indexPath.row + 1 <= self.numberOfItems(inSection: indexPath.section)-1 && indexPath.row + 1 >= 0) {
            let neighbourIndexPath = IndexPath(row: indexPath.row+1, section: indexPath.section)
            guard let neighbour = self.cellForItem(at: neighbourIndexPath) else{
                return nil
            }
            return neighbour
        }
        return nil
    }
    
    func leftNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        guard let indexPath = self.indexPath(for: cell) else{
            return nil
        }
        if (indexPath.row - 1 <= self.numberOfItems(inSection: indexPath.section)-1 && indexPath.row - 1 >= 0) {
            let neighbourIndexPath = IndexPath(row: indexPath.row-1, section: indexPath.section)
            guard let neighbour = self.cellForItem(at: neighbourIndexPath) else{
                return nil
            }
            return neighbour
        }
        return nil
    }
    
    func topNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        guard let indexPath = self.indexPath(for: cell) else{
            return nil
        }
        
        if(indexPath.section - 1 <= self.numberOfSections || indexPath.section >= 0) {
            let neighbourIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            guard let neighbour = self.cellForItem(at: neighbourIndexPath) else{
                return nil
            }
            return neighbour
        }
        return nil
    }
    
    func bottomNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        guard let indexPath = self.indexPath(for: cell) else {
            return nil
        }
        if (indexPath.section + 1 <= self.numberOfSections-1  && indexPath.section + 1 >= 0){
            let neighbourIndexPath = IndexPath(row: indexPath.row, section: indexPath.section+1)
            guard let neighbour = self.cellForItem(at: neighbourIndexPath) else{
                return nil
            }
            return neighbour
        }
        return nil
    }
    
    func topRightNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        if let topNeighbour = topNeighbour(cell: cell) {
            return rightNeighbour(cell: topNeighbour)
        }
        return nil
    }
    
    func topLeftNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        if let topNeighbour = topNeighbour(cell: cell) {
            return leftNeighbour(cell: topNeighbour)
        }
        return nil
    }
    
    func bottomRightNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        if let bottomNeighbour = bottomNeighbour(cell: cell) {
            return rightNeighbour(cell: bottomNeighbour)
        }
        return nil
    }
    
    func bottomLeftNeighbour(cell: UICollectionViewCell) -> UICollectionViewCell? {
        if let bottomNeighbour = bottomNeighbour(cell: cell) {
            return leftNeighbour(cell: bottomNeighbour)
        }
        return nil
    }
}
