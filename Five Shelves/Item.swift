//
//  Item.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/3/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import Foundation

struct Item {
    var name = String()
    var shelf = String()

    func getName() -> String {
        return self.name
    }
    
    func getShelf() -> String {
        return self.shelf
    }

}
