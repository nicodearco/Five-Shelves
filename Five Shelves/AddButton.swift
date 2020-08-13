//
//  AddButton.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/6/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit

class homeScreenButton: UIButton {

    // MARK: - Functions

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: self.bounds.origin.x - 5.0,
            y: self.bounds.origin.y - 5.0,
            width: self.bounds.size.width + 10.0,
            height: self.bounds.size.height + 20.0
        )
        return newArea.contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
