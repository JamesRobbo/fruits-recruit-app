//
//  FruitsViewController.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class FruitsViewController: UIViewController {
    
    private let viewModel: FruitsViewModel
    
    init(viewModel: FruitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    private func setupCollectionView() {
        
    }
}
