//
//  FruitsViewController.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class FruitsViewController: UIViewController {
    
    private let viewModel: FruitsViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: self.createLayout())
        return collectionView
    }()
    
    init(viewModel: FruitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.update = self.updateState
        self.viewModel.setup()
        self.setupCollectionView()
        self.view.backgroundColor = .white
    }
    
    private func updateState(new: FruitsViewModel.FruitsState) {
        switch new {
        case .loaded:
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case .error(let message):
            break
        }
    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "FruitCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "Fruit")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension FruitsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.fruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fruit", for: indexPath)
        if let cell = cell as? FruitCollectionViewCell {
            cell.setup(name: self.viewModel.fruits[indexPath.row].type,
                       colour: .red)
        }
        return cell
    }
}

extension FruitsViewController: UICollectionViewDelegate {
    // TODO: did select
}
