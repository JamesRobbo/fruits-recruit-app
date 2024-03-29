//
//  FruitsViewController.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class FruitsViewController: BaseViewController {
    
    private let viewModel: FruitsViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: self.createLayout())
        return collectionView
    }()
    
    init(viewModel: FruitsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.viewModel.update = self.updateState
        self.viewModel.setup()
        self.setupCollectionView()
        self.view.backgroundColor = .mainView
        super.viewDidLoad()
    }
    
    private func updateState(new: FruitsViewModel.FruitsState) {
        switch new {
        case .loaded:
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case .layoutChange:
            self.collectionView.collectionViewLayout = self.createLayout()
            self.updateState(new: .loaded)
        case .changeMode:
            let window = self.view.window
            if window?.overrideUserInterfaceStyle == .dark {
                window?.overrideUserInterfaceStyle = .light
            } else {
                window?.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    private func setupCollectionView() {
        // Adds collection view and fills superview with it
        self.view.addSubview(self.collectionView)
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        
        self.collectionView.register(UINib(nibName: "FruitCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "Fruit")
        self.collectionView.register(UINib(nibName: "ButtonCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "Button")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            let section = self.viewModel.sections[section]
            switch section {
            case .button:
                return self.buttonLayout()
            case .fruits:
                return self.fruitsLayout()
            }
        }
        
        return layout
    }
    
    // Button layout
    private func buttonLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(64))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(64))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func fruitsLayout() -> NSCollectionLayoutSection {
        switch self.viewModel.layout {
        case .grid:
            return self.defaultLayout()
        case .list:
            return self.defaultLayout(isGrid: false)
        case .carousel:
            return self.carouselLayout()
        }
    }
    
    // Default layout aka list or grid, use isGrid = true to make it a grid
    private func defaultLayout(isGrid: Bool = true) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(isGrid ? 0.5 : 1),
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
        return section
    }
    
    // Carousel layout, swipe between fruits
    private func carouselLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
}

extension FruitsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.viewModel.sections[section] {
        case .button:
            return 1
        case .fruits:
            return self.viewModel.fruits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewModel.sections[indexPath.section] {
        case .button(let title, let method):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Button", for: indexPath)
            if let cell = cell as? ButtonCollectionViewCell {
                cell.setup(title: title, method: method)
            }
            return cell
        case .fruits:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fruit", for: indexPath)
            if let cell = cell as? FruitCollectionViewCell {
                cell.setup(name: self.viewModel.fruits[indexPath.row].type,
                           colour: .secondary)
            }
            return cell
        }
    }
}

extension FruitsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.viewModel.sections[indexPath.section] {
        case .fruits:
            let fruit = self.viewModel.fruits[indexPath.row]
            DispatchQueue.main.async {
                let viewController = FruitDetailViewController(fruit: fruit)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}
