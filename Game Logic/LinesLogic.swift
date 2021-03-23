//
//  LinesLogic.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/18/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

protocol LinesManagerDelegate {
    func changeComingBalls(withBalls balls: [String])
    func updateScoreInfo(withNewScore score: Int)
    func showGameEndedAlert()
}

class LinesManager {
    
    let player: Player?
    
    let board: Board!
    var selectedCell: BoardCollectionViewCell?
    var emptyCellArray =  [EmptyCell]()
    
    let destroyManager: DestroyManager
    let pathFinder: PathFinder
    
    var delegate: LinesManagerDelegate?
    
    private let paths: NSArray
    private let documentsDirectory: NSString
    private let scoresPath: String
    private let namesPath: String
    
    var ballColors = ["red", "green", "orange", "yellow", "blue"]
    var comingBallColors = [String]()
    
    var score: Int = 0
    
    init() {
        self.player = Player()
        
        paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        documentsDirectory = paths.object(at: 0) as! NSString
        scoresPath = documentsDirectory.appendingPathComponent("Scores.plist")
        namesPath = documentsDirectory.appendingPathComponent("Players.plist")
        
        board = Board()
        destroyManager = DestroyManager(withBoard: self.board)
        pathFinder = PathFinder(withBoard: self.board)
        changeComingBalls()
    }
    
    func changeComingBalls() {
        comingBallColors.removeAll()
        
        for _ in 0..<comingBallCount {
            let index = Int(arc4random_uniform(UInt32(ballColors.count)))
            comingBallColors.append(ballColors[index])
        }
    }
    
    func findCellFrom(_ x: CGFloat, _ y: CGFloat) -> BoardCollectionViewCell? {
        if boardViewX - x > 0 || boardViewY - y > 0 || boardViewX + boardViewLength - x <= 0 || boardViewY + boardViewLength - y <= 0 {
            return nil
        } else {
            let deltaI = Int((y - boardViewY) / boardCellSize)
            let deltaJ = Int((x - boardViewX) / boardCellSize)
            
            return board[deltaI, deltaJ]
        }
    }
    
    func selectCellsToDraw() {
        
        if emptyCellArray.count <= comingBallCount {
            self.delegate?.showGameEndedAlert()
            return
        }
        
        var cells = [BoardCollectionViewCell]()
        
        for _ in 0..<comingBallCount {
            let index = Int(arc4random_uniform(UInt32(emptyCellArray.count)))
            let emptyCell = board[emptyCellArray[index].i, emptyCellArray[index].j]
            cells.append(emptyCell)
            emptyCellArray.remove(at: index)
        }
        board.drawBallsOn(cells: cells, withColors: comingBallColors)
        for cell in cells {
            if let destroyPath = self.destroyManager.findDestroyingCombinations(near: cell) {
                self.board.remove(balls: destroyPath)
                self.calculateScore(fromBallCount: destroyPath.count)
            }
        }
        
        changeComingBalls()
        self.delegate?.changeComingBalls(withBalls: comingBallColors)
    }
    
    func findPathFromSelectedCell(to cell: BoardCollectionViewCell) {
        
        if let path = pathFinder.findPathFrom(selectedCell!, to: cell) {
            
            board.moveBall(selectedCell!, to: cell, withPath: path)

            let additionalTime: DispatchTimeInterval = .milliseconds(path.count * 120)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + additionalTime) {
                self.removeFromEmptyCells(cell: cell)
                cell.ball = self.selectedCell?.ball
                self.selectedCell!.ball = nil
                self.emptyCellArray.append(EmptyCell(withCoordinatesOf: self.selectedCell!))
                
                if let destroyPath = self.destroyManager.findDestroyingCombinations(near: cell) {
                    self.board.remove(balls: destroyPath)
                    self.calculateScore(fromBallCount: destroyPath.count)
                } else {
                    self.selectCellsToDraw()
                }
                
                self.selectedCell = nil
            }
            selectedCell?.isBusy = false
            cell.isBusy = true
        } else {
            cantmovePlayer?.play()
        }
    }
    
    func removeFromEmptyCells(cell: BoardCollectionViewCell) {
        let newEmptyCell = EmptyCell(withCoordinatesOf: cell)
        
        for i in 0..<emptyCellArray.count {
            if emptyCellArray[i] == newEmptyCell {
                emptyCellArray.remove(at: i)
                return 
            }
        }
    }
    
    private func calculateScore(fromBallCount count: Int) {
        if count == ballsToDestroy {
            player?.score += 4
        } else {
            player?.score += 4
            player?.score += (count - ballsToDestroy) * 2
        }
        
        self.delegate?.updateScoreInfo(withNewScore: (player?.score)!)
    }
    
    func saveScores() {
        
        var scores = [Int]()
        var players = [String]()
        self.loadScores(scores: &scores, andPlayerNames: &players)
        
        appendScoreSorted(toScores: &scores, andNames: &players)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let scoresPath = documentsDirectory.appendingPathComponent("Scores.plist")
        let namesPath = documentsDirectory.appendingPathComponent("Players.plist")
        
        let scoresToWrite = NSMutableArray(array: scores as NSArray)
        let namesToWrite = NSMutableArray(array: players as NSArray)
        
        scoresToWrite.write(toFile: scoresPath, atomically: true)
        namesToWrite.write(toFile: namesPath, atomically: true)

        
    }
    
    func loadScores(scores: inout [Int], andPlayerNames playerNames: inout [String]) {
        if NSMutableArray(contentsOfFile: scoresPath) != nil {
            scores = NSMutableArray(contentsOfFile: scoresPath)! as NSArray as! [Int]
            playerNames = NSMutableArray(contentsOfFile: namesPath)! as NSArray as! [String]
        }
    }
    
    func saveChangedInfo(scores: [Int], names: [String]) {
        
        let scoresToWrite = NSMutableArray(array: scores as NSArray)
        let namesToWrite = NSMutableArray(array: names as NSArray)
        
        scoresToWrite.write(toFile: scoresPath, atomically: true)
        namesToWrite.write(toFile: namesPath, atomically: true)
    }
    
    private func appendScoreSorted(toScores scores: inout [Int], andNames names: inout [String]) {
        if scores.count == 0 {
            scores.append(player!.score)
            names.append(player!.name)
            return
        }
        for i in 0..<scores.count {
            if player!.score >= scores[i] {
                scores.insert(player!.score, at: i)
                names.insert(player!.name, at: i)
                break
            } else if i == scores.count - 1 {
                scores.append(player!.score)
                names.append(player!.name)
            }
        }
    }

}
