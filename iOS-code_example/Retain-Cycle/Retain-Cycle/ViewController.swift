//
//  ViewController.swift
//  Retain-Cycle
//
//  Created by Mengyi LUO on 2020-05-15.
//  Copyright © 2020 lalaphoon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sean: Person?
    var matilda: MacBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObjects()
        assignProperties()
        print("code is been finished")
    }
    
    func createObjects() {
        sean = Person(name: "Sean", macbook:nil)
        matilda = MacBook(name: "Matilada", owner: nil)
        
        //SUCCEED
        //sean = nil
        //matilada = nil
    }
    
    func assignProperties() {
        sean?.macbook = matilda
        matilda?.owner = sean
        
        //SUCCEED - matilda is not holding anymore
        sean = nil
        //matilda's owner is nil
        matilda = nil
        
        //failed for deinit matilda alone
        //matilda = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

