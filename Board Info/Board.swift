//
//  Board.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/18/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

protocol BoardDelegate {
    func addBallsToSuperview(fromCells cells:[BoardCollectionViewCell])
    func removeBallsFromSuperview(cells: [BoardCollectionViewCell])
}

class Board {
    private var boardCells = [BoardCollectionViewCell]()
    var delegate: BoardDelegate?
    
    subscript(row: Int, column: Int) -> BoardCollectionViewCell {
        get {
            return boardCells[(row * Int(cellsInLine)) + column]
        }
        set {
            boardCells[(row * Int(cellsInLine)) + column] = newValue
        }
    }
    
    func append(_ cell: BoardCollectionViewCell) {
        boardCells.append(cell)
    }
    
    func drawBallsOn(cells: [BoardCollectionViewCell], withColors colors: [String]) {
        var colorIndex = 0
        for cell in cells {
            let ballX = cell.frame.origin.x + (boardCellSize - ballSize) / 2
            let ballY = cell.frame.origin.y + (boardCellSize - ballSize) / 2
            
            cell.ball = Ball(x: ballX, y: ballY, color: colors[colorIndex])
            cell.isBusy = true
            
            colorIndex += 1
        }
        self.delegate?.addBallsToSuperview(fromCells: cells)
    }
    
    func moveBall(_ ballFromCell: BoardCollectionViewCell, to cell: BoardCollectionViewCell, withPath path: [BoardCollectionViewCell]) {
    
        
        var delay: Float = 0
        let tempBall = ballFromCell.ball!
        
        for i in 0..<path.count {
            tempBall.x = path[i].frame.origin.x + (boardCellSize - ballSize) / 2
            tempBall.y = path[i].frame.origin.y + (boardCellSize - ballSize) / 2
            
            UIView.animate(withDuration: 0.1,
                           delay: TimeInterval(delay),
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: {
                            tempBall.imageView.frame = CGRect(x: tempBall.x, y: tempBall.y, width: ballSize, height: ballSize)
            }, completion: { (true) in
                if i == path.count - 1 {
                    movePlayer?.play()
                }
            })
            delay += 0.1
        }
        ballFromCell.isBusy = false
        cell.isBusy = true
    }
    
    func remove(balls fromCells: [BoardCollectionViewCell]) {
        
        for cell in fromCells {
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            cell.ball?.imageView.frame = CGRect(x: (cell.ball?.x)! + ballSize / 2, y: (cell.ball?.y)! + ballSize / 2, width: 0, height: 0)
            }, completion: { (true) in
                if cell == fromCells.last {
                    popPlayer?.play()
                    self.delegate?.removeBallsFromSuperview(cells: fromCells)
                }
            })
        }
    }
}
