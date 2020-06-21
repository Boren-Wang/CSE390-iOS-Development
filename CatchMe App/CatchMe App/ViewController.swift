//
//  ViewController.swift
//  CatchMe App
//
//  Created by Boren Wang on 2020/6/17.
//  Copyright © 2020 Boren Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnCatch: UIButton!
    @IBOutlet weak var endingRegion: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCatchClicked(_ sender: UIButton) {
        score+=1
        scoreLabel.text = "Score: \(score)"
        
        let halfWidth = sender.bounds.width/2.0
        let halfHeight = sender.bounds.height/2.0
        
        let minX = view.safeAreaInsets.left
        let maxX = view.bounds.width - view.safeAreaInsets.right

        let minY = view.safeAreaInsets.top
        let maxY = view.bounds.height - view.safeAreaInsets.bottom
        
        let randomX = CGFloat.random(in: minX+halfWidth...maxX-halfWidth)
        let randomY = CGFloat.random(in: minY+halfHeight...maxY-halfHeight)
        
        sender.center = .init(x: randomX, y: randomY)

        // minX, minX+250
        // maxY-250, maxY
        
        if(minX<=randomX && randomX<=minX+250 && maxY-250<=randomY && randomY<=maxY) {

            btnCatch.isEnabled = false
            playAgain.isHidden = false
            
            let alert = UIAlertController(title: "GAME OVER", message: "You have entered the ending region.\nYour score is \(score).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func playAgainClicked(_ sender: UIButton) {
        score = 0
        scoreLabel.text = "Score: 0"
        
        let minX = view.safeAreaInsets.left
        let maxX = view.bounds.width - view.safeAreaInsets.right

        let minY = view.safeAreaInsets.top
        let maxY = view.bounds.height - view.safeAreaInsets.bottom

        btnCatch.center = .init(x: (maxX-minX)/2, y: (maxY-minY)/2)
        
        btnCatch.isEnabled = true
        playAgain.isHidden = true
    }
}

