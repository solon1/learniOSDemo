//
//  ViewController.swift
//  SNStopWatch
//
//  Created by solon on 16/10/29.
//  Copyright © 2016年 solon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var counter = 0.0
    var timer = NSTimer()
    var isPlaying = false
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!

    
    @IBAction func resetAction(sender: AnyObject) {
        timer.invalidate()
        isPlaying = false;
        counter = 0.0
        timeLabel.text = String(counter)
        playBtn.enabled = true;
        pauseBtn.enabled = true;
    }
    
    @IBAction func playAction(sender: AnyObject) {
        if(isPlaying == true) {
            return;
        }
        playBtn.enabled = false;
        pauseBtn.enabled = true;
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        isPlaying = true;
    }
    
    @IBAction func pauseAction(sender: AnyObject) {
        playBtn.enabled = true;
        pauseBtn.enabled = false;
        timer.invalidate()
        isPlaying = false;
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String(counter)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTimer(){
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
    }
}

