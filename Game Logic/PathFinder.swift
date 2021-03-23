//
//  PathFinder.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/20/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import Foundation

class PathFinder {
    
    let POSFREE = 0
    let POSOCCUPIED = -1
    let POSSTART = -2
    let POSEND = 1
    
    var board: Board!
    
    private var matrix = Array<Array<Int>>()
    
    init(withBoard board: Board){
        self.board = board
        for _ in 0...Int(cellsInLine - 1) {
            let arr = Array(repeatElement(0, count: Int(cellsInLine)))
            matrix.append(arr)
        }
    }
    
    
    func findPathFrom(_ fromCell: BoardCollectionViewCell, to destinationcell: BoardCollectionViewCell) -> [BoardCollectionViewCell]? {
        fillTheMatrix()
        matrix[fromCell.row!][fromCell.colomn!] = POSSTART
        matrix[destinationcell.row!][destinationcell.colomn!] = POSEND
        
        var found = false
        var current = POSEND
        let maxPathLength = Int(cellsInLine) * 4
        
        while current < (maxPathLength + POSEND) && !found {
            for i in 0..<Int(cellsInLine) {
                for j in 0..<Int(cellsInLine) {
                    if matrix[i][j] == current {
                        if i > 0 && checkNeighbourOf((i - 1), j, andAssign: (current + 1)) {
                            found = true
                        }
                        if i < Int(cellsInLine) - 1 && checkNeighbourOf((i + 1), j, andAssign: (current + 1)) {
                            found = true
                        }
                        if j > 0 && checkNeighbourOf(i, (j - 1), andAssign: (current + 1)) {
                            found = true
                        }
                        if j < Int(cellsInLine) - 1  && checkNeighbourOf(i, (j + 1), andAssign: (current + 1)) {
                            found = true
                        }
                    }
                }
            }
            current += 1
        }
        
        if found {
            var result = [BoardCollectionViewCell]()
            
            var pos = fromCell
            while pos != destinationcell {
                pos = getNearestCell(of: pos)
                result.append(pos)
            }
            
            return result
        } else {
            return nil
        }
    }
    
    private func fillTheMatrix() {
        
        for i in 0..<Int(cellsInLine) {
            for j in 0..<Int(cellsInLine) {
                if board[i, j].isBusy {
                    matrix[i][j] = POSOCCUPIED
                } else {
                    matrix[i][j] = POSFREE
                }
                
            }
        }
    }
    
    private func checkNeighbourOf(_ i: Int, _ j: Int, andAssign value: Int) -> Bool{
        if matrix[i][j] == POSSTART {
            return true
        }
        if matrix[i][j] == POSFREE {
            matrix[i][j] = value
        }
        return false
    }
    
    private func getNearestCell(of cell: BoardCollectionViewCell) -> BoardCollectionViewCell {
        var min = matrix[cell.row!][cell.colomn!]
        var result: BoardCollectionViewCell?
        
        var i = cell.row! - 1
        var j = cell.colomn!
        
        if i >= 0 && matrix[i][j] > 0 {
            if (min < 0) || (matrix[i][j] < min) {
                min = matrix[i][j]
                result = board[i, j]
            }
        }
        
        i = cell.row! + 1
        
        if i < Int(cellsInLine) && matrix[i][j] > 0 {
            if (min < 0) || (matrix[i][j] < min) {
                min = matrix[i][j]
                result = board[i, j]
            }
        }
        
        i = cell.row!
        j = cell.colomn! - 1
        
        if j >= 0 && matrix[i][j] > 0 {
            if (min < 0) || (matrix[i][j] < min) {
                min = matrix[i][j]
                result = board[i, j]
            }
        }
        
        j = cell.colomn! + 1
        
        if j < Int(cellsInLine) && matrix[i][j] > 0 {
            if (min < 0) || (matrix[i][j] < min) {
                min = matrix[i][j]
                result = board[i, j]
            }
        }
        
        return result!
    }
}
