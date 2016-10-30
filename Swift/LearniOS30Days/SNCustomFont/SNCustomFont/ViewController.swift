//
//  ViewController.swift
//  SNCustomFont
//
//  Created by solon on 16/10/30.
//  Copyright © 2016年 solon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var texts = ["30days Learn Swift","自定义字体","你能成大事儿","人只能被摧毁不可以被打败","微博SolonPu同知乎Twitter","微信yingyuanzhen欢迎交流学习"];
    var fontNames = ["MFTongXin_Noncommercial-Regular", "MFJinHei_Noncommercial-Regular", "MFZhiHei_Noncommercial-Regular","Gaspar Regular"]
    
    var fontAtIndex = 0
    
    @IBOutlet weak var changeFontBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeFontBtn.layer.cornerRadius = 55
        changeFontBtn.layer.masksToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func changeFontAction(sender: AnyObject) {
        fontAtIndex = (fontAtIndex + 1) % 4
        print(fontNames[fontAtIndex])
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("fontCell", forIndexPath: indexPath)
        let text = texts[indexPath.row]
        
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.whiteColor()

        cell.textLabel?.font = UIFont(name: fontNames[fontAtIndex], size: 15)
        
        return cell
    }
}

