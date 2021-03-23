//
//  DestroyManager.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/20/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import Foundation

class DestroyManager {
    
    var board: Board!
    
    init() {
        board = Board()
    }
    
    init(withBoard board: Board) {
        self.board = board
    }
    
    func findDestroyingCombinations(near cell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        var result = [BoardCollectionViewCell]()
        
        if let vertical = findVertical(forCEll: cell) {
            result.addElements(of: vertical)
        }
        if let horizontal = findHorizontal(forCEll: cell) {
            result.addElements(of: horizontal)
        }
        if let diagonal = findDiagonal(forCEll: cell) {
            result.addElements(of: diagonal)
        }
        if let secDiagonal = findSecondaryDiagonal(forCEll: cell) {
            result.addElements(of: secDiagonal)
        }
        
        if result.count > 0 && !result.contains(cell) {
            result.append(cell)
            return result
        }
        return nil
    }
    
    private func findVertical(forCEll cell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        let j = cell.colomn!
        var result = [BoardCollectionViewCell]()
        
        if cell.row! > 0 {
            var i = cell.row! - 1
            for _ in 0..<(cell.row!) {
                if i < 0 || !compare(cell: board[i,j], toCell: cell, andAddTo: &result) {
                    break
                }
                i -= 1
            }
        }
        
        if cell.row! < Int(cellsInLine) {
            for i in (cell.row! + 1)..<Int(cellsInLine) {
                if i == Int(cellsInLine) || !compare(cell: board[i, j], toCell: cell, andAddTo: &result) {
                    break
                }
            }
        }
        if result.count >= ballsToDestroy - 1 {
            return result
        } else {
            return nil
        }
    }
    
    private func findHorizontal(forCEll cell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        let i = cell.row!
        var result = [BoardCollectionViewCell]()
        
        if cell.colomn! < Int(cellsInLine) {
            for j in (cell.colomn! + 1)..<Int(cellsInLine) {
                if j == Int(cellsInLine) || !compare(cell: board[i, j], toCell: cell, andAddTo: &result){
                    break
                }
            }
        }
        
        if cell.row! < Int(cellsInLine) {
            var j = cell.colomn! - 1
            for _ in 0..<cell.colomn! {
                if j < 0 || j == Int(cellsInLine) || !compare(cell: board[i, j], toCell: cell, andAddTo: &result){
                    break
                }
                j -= 1
            }
        }
        if result.count >= ballsToDestroy - 1 {
            return result
        } else {
            return nil
        }
    }
    
    private func findDiagonal(forCEll cell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        var result = [BoardCollectionViewCell]()
        var i = cell.row! - 1
        var j = cell.colomn! - 1
        
        for _ in 0..<(cell.row!) {
            if  j < 0 || i < 0  || !compare(cell: board[i, j], toCell: cell, andAddTo: &result){
                break
            }
            i -= 1
            j -= 1
        }
        
        i = cell.row! + 1
        j = cell.colomn! + 1
        for _ in 0...(Int(cellsInLine) - cell.row!) {
            if i == Int(cellsInLine) || j == Int(cellsInLine) || !compare(cell: board[i ,j], toCell: cell, andAddTo: &result) {
                break
            }
            i += 1
            j += 1
        }
        
        if result.count >= ballsToDestroy - 1 {
            return result
        } else {
            return nil
        }
    }
    
    //needs testing
    private func findSecondaryDiagonal(forCEll cell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        var result = [BoardCollectionViewCell]()
        var i = cell.row! - 1
        var j = cell.colomn! + 1
        
        for _ in 0..<(cell.row!) {
            if j == Int(cellsInLine) || i < 0 || !compare(cell: board[i, j], toCell: cell, andAddTo: &result) {
                break
            }
            i -= 1
            j += 1
        }
        
        i = cell.row! + 1
        j = cell.colomn! - 1
        for _ in 0...(Int(cellsInLine) - cell.row!) {
            if i == Int(cellsInLine) || j < 0 || !compare(cell: board[i ,j], toCell: cell, andAddTo: &result) {
                break
            }
            i += 1
            j -= 1
        }
        
        if result.count >= ballsToDestroy - 1 {
            return result
        } else {
            return nil
        }
    }
}


private func compare(cell: BoardCollectionViewCell, toCell: BoardCollectionViewCell, andAddTo array: inout [BoardCollectionViewCell]) -> Bool {
    if cell.isBusy && cell.ball?.ballColor == toCell.ball?.ballColor && cell.ball?.ballColor != nil {
        array.append(cell)
        return true
    }
    return false
}



extension Array where Element: Equatable{
    func containsElement(item: Element) -> Bool {
        for i in self {
            if i == item {
                return true
            }
        }
        return false
    }
    
}

extension Array {
    mutating func addElements(of array: [Element]) {
        for item in array {
            self.append(item)
        }
    }
}
