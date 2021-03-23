//
//  Player.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/25/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import Foundation


class Player {
    var name: String
    var score: Int = 0
    
    init() {
        self.name = ""
    }
    
    init(withName name: String) {
        self.name = name
    }
}
