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
    
    /// Calculates the cells inbewteen (inclusive) the shortest path of the two cells give.
    ///
    /// - Parameters:
    ///   - startCell: cell to begin at
    ///   - endCell: cell to stop at
    /// - Returns: the cells inbetween the startCell and endCell
    func cellsBetween(start startCell: UICollectionViewCell, end endCell: UICollectionViewCell) -> [UICollectionViewCell] {
        var cells = [UICollectionViewCell]()
        cells.append(startCell)
        
        guard let firstIndexPath = self.indexPath(for: startCell),
            let lastIndexPath = self.indexPath(for: endCell) else {
                return cells
        }
        //Right check
        var currentIndexPath = firstIndexPath
        
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let rightNeighbour = self.rightNeighbour(cell: currentCell),
                let rightIndexPath = self.indexPath(for: rightNeighbour) {
                currentIndexPath = rightIndexPath
                cells.append(rightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        //Left check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let leftNeighbour = self.leftNeighbour(cell: currentCell),
                let leftIndexPath = self.indexPath(for: leftNeighbour) {
                currentIndexPath = leftIndexPath
                cells.append(leftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        //Top check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topNeighbour = self.topNeighbour(cell: currentCell),
                let topIndexPath = self.indexPath(for: topNeighbour) {
                currentIndexPath = topIndexPath
                cells.append(topNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomNeighbour = self.bottomNeighbour(cell: currentCell),
                let bottomIndexPath = self.indexPath(for: bottomNeighbour) {
                currentIndexPath = bottomIndexPath
                cells.append(bottomNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Top right check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topRightNeighbour = self.topRightNeighbour(cell: currentCell),
                let topRightIndexPath = self.indexPath(for: topRightNeighbour) {
                currentIndexPath = topRightIndexPath
                cells.append(topRightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Top left Check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let topLeftNeighbour = self.topLeftNeighbour(cell: currentCell),
                let topLeftIndexPath = self.indexPath(for: topLeftNeighbour) {
                currentIndexPath = topLeftIndexPath
                cells.append(topLeftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom Right check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomRightNeighbour = self.bottomRightNeighbour(cell: currentCell),
                let bottomRightIndexPath = self.indexPath(for: bottomRightNeighbour) {
                currentIndexPath = bottomRightIndexPath
                cells.append(bottomRightNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        //Bottom Left check
        currentIndexPath = firstIndexPath
        cells.append(startCell)
        while(true){
            if let currentCell = self.cellForItem(at: currentIndexPath),
                let bottomLeftNeighbour = self.bottomLeftNeighbour(cell: currentCell),
                let bottomLeftIndexPath = self.indexPath(for: bottomLeftNeighbour) {
                currentIndexPath = bottomLeftIndexPath
                cells.append(bottomLeftNeighbour)
                if(lastIndexPath == currentIndexPath){
                    return cells
                }
            }
            else{
                cells = []
                break
            }
        }
        
        return cells
    }
}
