//
//  GameViewController.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/16/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit
import AVFoundation

var cellsInLine:CGFloat = 7
let ballsToDestroy: Int = 5
let comingBallCount: Int = 3

var boardViewX: CGFloat = 0
var boardViewY: CGFloat = 0
var boardViewLength: CGFloat = 0

var boardCellSize: CGFloat = 0
var ballSize: CGFloat = boardCellSize - 10

var movePlayer: AVAudioPlayer?
var cantmovePlayer: AVAudioPlayer?
var destroyPlayer: AVAudioPlayer?
var selectedPlayer: AVAudioPlayer?
var popPlayer: AVAudioPlayer?

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BoardDelegate, InfoViewControllerDelegate, LinesManagerDelegate {
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var comingBallsView: UIStackView!
    @IBOutlet weak var comingBall1: UIImageView!
    @IBOutlet weak var comingBall2: UIImageView!
    @IBOutlet weak var comingBall3: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var colViewHeight: NSLayoutConstraint!
    
    
    
    let linesManager = LinesManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InfoGettingVC") as! InfoGettingViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.view.backgroundColor = UIColor.clear
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
        linesManager.board.delegate = self
        linesManager.delegate = self
        
        boardViewLength = self.view.frame.width - 32
        boardViewX = self.view.center.x - boardViewLength / 2
        boardViewY = self.view.center.y - boardViewLength / 2
        colView.frame = CGRect(x: boardViewX, y: boardViewY, width: boardViewLength, height: boardViewLength)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        boardCellSize = (self.view.frame.width - 32) / cellsInLine - 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: boardCellSize , height: boardCellSize )
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        colView!.collectionViewLayout = layout
        
        colViewHeight.constant = boardViewLength
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selectedUrl = Bundle.main.url(forResource: "selected", withExtension: "wav")!
        let cantmoveUrl = Bundle.main.url(forResource: "cantmove", withExtension: "wav")!
        let destroyUrl = Bundle.main.url(forResource: "destroy", withExtension: "wav")!
        let movPlayer = Bundle.main.url(forResource: "move", withExtension: "wav")!
        let popPlayr = Bundle.main.url(forResource: "pop", withExtension: "wav")!

        
        do {
            selectedPlayer = try AVAudioPlayer(contentsOf: selectedUrl)
            cantmovePlayer = try AVAudioPlayer(contentsOf: cantmoveUrl)
            destroyPlayer = try AVAudioPlayer(contentsOf: destroyUrl)
            movePlayer = try AVAudioPlayer(contentsOf: movPlayer)
            popPlayer = try AVAudioPlayer(contentsOf: popPlayr)
            guard let _ = selectedPlayer, let _ = cantmovePlayer, let _ = destroyPlayer else { return }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func endGameAction(_ sender: Any) {
        linesManager.saveScores()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer) {
        let point: CGPoint = recognizer.location(in: view)
        
        if let cell = linesManager.findCellFrom(point.x, point.y) {
            
            if cell.isBusy {
                selectedPlayer?.play()
                
                if linesManager.selectedCell != nil {
                    linesManager.selectedCell?.ball?.stopBouncing()
                    cell.ball?.bounce()
                    linesManager.selectedCell = cell
                } else {
                    linesManager.selectedCell = cell
                    cell.ball?.bounce()
                }
                return
            } else if linesManager.selectedCell != nil {
                linesManager.selectedCell?.ball!.stopBouncing()
                linesManager.findPathFromSelectedCell(to: cell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int {
            return Int(cellsInLine * cellsInLine)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BoardCollectionViewCell
        cell.isBusy = false
        cell.colomn = indexPath.row % Int(cellsInLine)
        cell.row = indexPath.row / Int(cellsInLine)
        linesManager.board.append(cell)
        linesManager.emptyCellArray.append(EmptyCell(withCoordinatesOf: cell))
        if indexPath.row == Int(cellsInLine * cellsInLine - 1) {
            linesManager.selectCellsToDraw()
        }
        return cell
    }

    func addBallsToSuperview(fromCells cells: [BoardCollectionViewCell]) {
        for cell in cells {
            self.colView.addSubview(cell.ball!.imageView)
        }
    }
    
    func removeBallsFromSuperview(cells: [BoardCollectionViewCell]) {
        for cell in cells {
            cell.ball?.imageView.removeFromSuperview()
            cell.ball = nil
            cell.isBusy = false
            self.linesManager.emptyCellArray.append(EmptyCell(withCoordinatesOf: cell))
        }
    }
    
    func didCancelProvidingInfo() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didProvideName(_ name: String) {
        linesManager.player?.name = name
    }
    
    func changeComingBalls(withBalls balls: [String]) {
        comingBall1.image = UIImage(named: balls[0])
        comingBall2.image = UIImage(named: balls[1])
        comingBall3.image = UIImage(named: balls[2])
    }
    
    func updateScoreInfo(withNewScore score: Int) {
        scoreLabel.text = String(score)
    }
    
    func showGameEndedAlert() {
        let alert = UIAlertController(title: "The game is over", message: "Don't worry, your result will be stroed in the scores manu", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
            alert.dismiss(animated: true, completion: nil)
            self.linesManager.saveScores()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}
