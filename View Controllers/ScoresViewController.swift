//
//  ScoresViewController.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/16/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scoresTableView: UITableView!
    let linesManager = LinesManager()
    var scoreArray = [Int]()
    var playerNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linesManager.loadScores(scores: &scoreArray, andPlayerNames: &playerNameArray)
        scoresTableView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreTableViewCell
        
        cell.configureWith(name: playerNameArray[indexPath.row], andScore: scoreArray[indexPath.row], atIndex: indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete {
            scoreArray.remove(at: indexPath.row)
            playerNameArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            linesManager.saveChangedInfo(scores: scoreArray, names: playerNameArray)
            scoresTableView.reloadData()
        }
    }
}
