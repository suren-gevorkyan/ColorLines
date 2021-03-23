//
//  Ball.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/18/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import Foundation
import UIKit

class Ball {
    var x: CGFloat
    var y: CGFloat
    var ballColor: String?
    var imageView = UIImageView()
    
    var timer = Timer()
    
    init(x: CGFloat, y: CGFloat, color: String) {
        self.x = x
        self.y = y
        self.ballColor = color
        self.imageView.frame = CGRect(x: x, y: y, width: ballSize, height: ballSize)
        imageView.image = UIImage(named: color)
    }
    
    func bounce() {
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.bounceAnimations), userInfo: nil, repeats: true)
    
    }
    
    func stopBouncing() {
        timer.invalidate()
        imageView.frame = CGRect(x: self.x, y: self.y, width: ballSize, height: ballSize)
    }
    
    @objc private func bounceAnimations() {
        let ballHighY = self.y - 6
        
        UIView.animate(withDuration: 0.15) {
            if self.imageView.frame.origin.y == self.y {
                self.imageView.frame = CGRect(x: self.x, y: ballHighY, width: ballSize, height: ballSize)
            } else {
                self.imageView.frame = CGRect(x: self.x, y: self.y, width: ballSize, height: ballSize)
            }
        }
    }
}
