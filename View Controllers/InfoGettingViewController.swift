//
//  InfoGettingViewController.swift
//  Lines
//
//  Created by Suren Gevorkyan on 11/25/17.
//  Copyright © 2017 Suren Gevorkyan. All rights reserved.
//

import UIKit

protocol InfoViewControllerDelegate {
    func didCancelProvidingInfo()
    func didProvideName(_ name: String)
}

class InfoGettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    var delegate: InfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.didCancelProvidingInfo()
       
    }
    
    
    @IBAction func continueAction(_ sender: Any) {
        if self.nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Enter valid name", message: "Your name must contain some characters", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        } else {
            var temp = self.nameTextField.text!
            for char in temp {
                if char == " " {
                    temp.remove(at: temp.index(of: char)!)
                }
            }
            
            if temp.isEmpty {
                let alert = UIAlertController(title: "Enter valid name", message: "Your name must contain some characters", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            } else {
                self.delegate?.didProvideName(nameTextField.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField!.endEditing(true)
        return true
    }

}
