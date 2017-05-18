//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Admin on 5/16/17.
//  Copyright © 2017 Illum. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValString = ""
    var rightValString = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOf: soundURL as URL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        playSound()
        
        runningNumber = ""
        leftValString = ""
        rightValString = ""
        currentOperation = Operation.Empty
        result = ""
        outputLbl.text = "0"
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(op: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(op: Operation.Add)
    }
    
    @IBAction func onEqualsPressed(_ sender: AnyObject) {
        processOperation(op: currentOperation)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Evaluate expression
            
            // User selected an operator then selected another operator without first entering a number
            if runningNumber != "" {
                rightValString = runningNumber
                runningNumber = ""
            
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValString)! * Double(rightValString)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValString)! / Double(rightValString)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValString)! + Double(rightValString)!)"
                }  else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValString)! - Double(rightValString)!)"
                }
            
                leftValString = result
                outputLbl.text = result
            }
            currentOperation = op
            
        } else {
            // This is the first time an operator has been pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
   
}

