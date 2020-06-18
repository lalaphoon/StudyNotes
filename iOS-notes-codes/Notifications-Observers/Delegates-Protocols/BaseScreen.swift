//
//  BaseScreen.swift
//  Delegates-Protocols
//
//  Created by Sean Allen on 5/20/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit

let lightNotificationKey = "co.seanallen.lightSide"
let darkNotificationKey = "co.seanallen.darkSide"

class BaseScreen: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    let light = Notification.Name(rawValue: lightNotificationKey)
    let dark = Notification.Name(rawValue: darkNotificationKey)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseButton.layer.cornerRadius = chooseButton.frame.size.height/2
        createObservers()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createObservers() {
        
        //Light
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: light, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateNameLabel(notification:)), name: light, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateBackground(notification:)), name: light, object: nil)
        
        //Dark
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateCharacterImage(notification:)), name: dark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateNameLabel(notification:)), name: dark, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseScreen.updateBackground(notification:)), name: dark, object: nil)
    }
    
    @objc func updateCharacterImage(notification: NSNotification) {
        
        let isLight = notification.name == light
        let image = isLight ? UIImage(named: "luke")! : UIImage(named: "vader")!
        mainImageView.image = image
    }
    
    @objc func updateNameLabel(notification: NSNotification) {
        
        let isLight = notification.name == light
        let name = isLight ? "Luke Skywalker" : "Darth Vader"
        nameLabel.text = name
        
    }
    
    @objc func updateBackground(notification: NSNotification) {
        
        let isLight = notification.name == light
        let color = isLight ? UIColor.cyan : UIColor.red
        view.backgroundColor = color
    }
    
    
    @IBAction func chooseButtonTapped(_ sender: UIButton) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "SelectionScreen") as! SelectionScreen
        present(selectionVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
