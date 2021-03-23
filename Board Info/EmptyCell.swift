//
//  EmptyCell.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/22/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import Foundation

class EmptyCell: Equatable {
    static func ==(lhs: EmptyCell, rhs: EmptyCell) -> Bool {
        if lhs.i == rhs.i && lhs.j == rhs.j {
            return true
        } else {
            return false
        }
    }
    
    var i: Int!
    var j: Int!
    
    init(withCoordinatesOf cell: BoardCollectionViewCell) {
        self.i = cell.row!
        self.j = cell.colomn!
    }
    
    func description() {
        print("Row:  \(i)\nColomn:   \(j)")
    }
}
