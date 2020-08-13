//
//  ItemListCell.swift
//  Five Shelves
//
//  Created by Kevin Ryan Nava on 6/6/20.
//  Copyright © 2020 Kevin Ryan Nava. All rights reserved.
//

import UIKit


extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}


class ItemListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    func configureView() {
        // add and configure subviews here
        
        let bodyFont = UIFont.preferredFont(forTextStyle: .title2)
        let detailFont = UIFont.preferredFont(forTextStyle: .callout)
        
        textLabel?.font = bodyFont
        textLabel?.adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        
        guard detailTextLabel != nil else {
            return
        }
        
        detailTextLabel?.adjustsFontForContentSizeCategory = true
        detailTextLabel?.font = detailFont.bold()
        detailTextLabel?.adjustsFontForContentSizeCategory = true
        detailTextLabel?.textAlignment = .center
    }
    
}
