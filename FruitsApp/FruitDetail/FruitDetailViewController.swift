//
//  FruitDetailViewController.swift
//  FruitsApp
//
//  Created by James Robinson on 16/01/2024.
//

import UIKit

class FruitDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private let fruit: Fruit
    
    init(fruit: Fruit) {
        self.fruit = fruit
        super.init(nibName: "FruitDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.fruit.type
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "GBP"
        let price = numberFormatter.string(from: NSNumber(integerLiteral: self.fruit.price))
        let weightGrams = Measurement(value: self.fruit.weight, unit: UnitMass.grams)
        let weightKg = weightGrams.converted(to: .kilograms)
        self.priceLabel.text = price
        self.weightLabel.text = "\(weightKg)"
    }
}
