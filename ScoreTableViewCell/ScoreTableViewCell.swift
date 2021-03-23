//
//  ScoreTableViewCell.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/26/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    
    func configureWith(name: String, andScore score: Int, atIndex index: Int) {
        self.nameTextField.text = name
        self.scoreTextField.text = String(score)
        switch index {
        case 0:
            numberLabel.text = "🥇"
            break
        case 1:
            numberLabel.text = "🥈"
            break
        case 2:
            numberLabel.text = "🥉"
            break
        default:
            numberLabel.text = String(index + 1)
        }
        
        self.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
