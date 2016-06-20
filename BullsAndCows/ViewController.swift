//
//  ViewController.swift
//  BullsAndCows
//
//  Created by Brian Hu on 5/19/16.
//  Copyright © 2016 Brian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answearLabel: UILabel!
    
    var a = UInt16(0)
    var b = UInt16(0)
    var c = UInt16(0)
    var d = UInt16(0)
    var remainingTime: UInt8! {
        didSet {
            remainingTimeLabel.text = "remaining time: \(remainingTime)"
            if remainingTime == 0 {
                guessButton.enabled = false
            } else {
                guessButton.enabled = true
            }
        }
    }
    
    var hintArray = [(guess: String, hint: String)]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // TODO: 1. decide the data type you want to use to store the answear
    var answear: UInt16!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame()
    }

    func setGame() {
        generateAnswear()
        remainingTime = 9
        hintArray.removeAll()
        answearLabel.text = nil
        guessTextField.text = nil
    }
    
    func generateAnswear() {
        a = UInt16(arc4random() % 10)
        b = UInt16(arc4random() % 10)
        c = UInt16(arc4random() % 10)
        d = UInt16(arc4random() % 10)
        if (a == b || a == c || a == d || b == d || b == c || c == d) {
            generateAnswear()
        }
        else {
            answear = 1000*a + 100*b + 10*c + d
        }
    }
    
    @IBAction func guess(sender: AnyObject) {
        let guessString = guessTextField.text
        guard guessString?.characters.count == 4 else {
            let alert = UIAlertController(title: "you should input 4 digits to guess!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        // TODO: 3. convert guessString to the data type you want to use and judge the guess
        let guessInt = UInt16(guessString!)
        let x = (guessString! as NSString).substringWithRange(NSMakeRange(0, 1))
        let y = (guessString! as NSString).substringWithRange(NSMakeRange(1, 1))
        let z = (guessString! as NSString).substringWithRange(NSMakeRange(2, 1))
        let w = (guessString! as NSString).substringWithRange(NSMakeRange(3, 1))
        
        var goodAns = 0
        var notBadAns = 0
        if UInt16(x) == a {
            goodAns += 1
        }
        if UInt16(y) == b {
            goodAns += 1
        }
        if UInt16(z) == c {
            goodAns += 1
        }
        if UInt16(w) == d {
            goodAns += 1
        }
        
        
        if UInt16(x) == a || UInt16(x) == b || UInt16(x) == c || UInt16(x) == d{
            notBadAns += 1
        }
        if UInt16(y) == a || UInt16(y) == b || UInt16(y) == c || UInt16(y) == d{
            notBadAns += 1
        }
        if UInt16(z) == a || UInt16(z) == b || UInt16(z) == c || UInt16(z) == d{
            notBadAns += 1
        }
        if UInt16(w) == a || UInt16(w) == b || UInt16(w) == c || UInt16(w) == d{
            notBadAns += 1
        }
        notBadAns = notBadAns - goodAns
        
        print(goodAns)
        // TODO: 4. update the hint
        let hint = "\(goodAns)A\(notBadAns)B"
        
        hintArray.append((guessString!, hint))
        
        // TODO: 5. update the constant "correct" if the guess is correct
        var correct = false
        if guessInt == answear {
            correct = true
        }
        if correct {
            let alert = UIAlertController(title: "Wow! You are awesome!", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            guessButton.enabled = false
        } else {
            remainingTime! -= 1
        }
    }
    @IBAction func showAnswear(sender: AnyObject) {
        // TODO: 6. convert your answear to string(if it's necessary) and display it
        answearLabel.text = "\(answear)"
    }
    
    @IBAction func playAgain(sender: AnyObject) {
        setGame()
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hintArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Hint Cell", forIndexPath: indexPath)
        let (guess, hint) = hintArray[indexPath.row]
        cell.textLabel?.text = "\(guess) => \(hint)"
        return cell
    }
}

