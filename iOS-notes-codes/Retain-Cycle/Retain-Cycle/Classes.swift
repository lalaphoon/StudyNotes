//
//  Classes.swift
//  Retain-Cycle
//
//  Created by Mengyi LUO on 2020-05-15.
//  Copyright © 2020 lalaphoon. All rights reserved.
//

import Foundation

class Person {
    let name: String
    var macbook: MacBook?
    
    init(name: String, macbook: MacBook?) {
        self.name = name
        self.macbook = macbook
    }
    
    deinit {
        print("\(name) is being deinitialed")
    }
}

class MacBook {
    let name: String
    weak var owner: Person? //<-------- here is the fix
    
    init(name: String, owner: Person?) {
        self.name = name
        self.owner = owner
    }
    
    deinit {
        print("Macbook named \(name) is being deinitialized")
    }
}
