//
//  FruitCollectionViewCell.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class FruitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(name: String, 
               colour: UIColor) {
        self.background.layer.cornerRadius = 5
        self.background.backgroundColor = colour
        self.nameLabel.text = name.uppercased()
        self.nameLabel.textColor = .white
    }
}
