//
//  ButtonCollectionViewCell.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    
    private var method: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.method = nil
        self.button.setTitle(nil, for: .normal)
    }
    
    func setup(title: String, method: @escaping () -> Void) {
        self.button.setTitle(title, for: .normal)
        self.method = method
    }
    
    @IBAction func buttonPressed() {
        self.method?()
    }
}
