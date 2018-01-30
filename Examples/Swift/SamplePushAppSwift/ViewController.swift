//
//  ViewController.swift
//  SamplePushAppSwift
//
//  Created by Daniel Sykes-Turner on 17/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startPush() {
        SpotzPush.shared().start()
    }
    
    @IBAction func startLocation() {
        SpotzPush.shared().enableLocationServices()
    }
}

