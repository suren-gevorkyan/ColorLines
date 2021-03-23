//
//  BoardCollectionViewCell.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/20/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    var row: Int?
    var colomn: Int?
    var isBusy: Bool = false
    
    var ball: Ball?
    
    func printDescription() {
        print("Row:  \(String(describing: row))\nColomn:  \(String(describing: colomn))\nIs busy:  \(isBusy)")
    }
}
