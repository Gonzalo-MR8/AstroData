//
//  SpaceLibraryViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import UIKit

class SpaceLibraryViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var spaceItemsCollectionView: UICollectionView!
    
    private var viewModel: SpaceLibraryViewModel!
    
    private let kCollectionViewCellInset:CGFloat = 10
    private let kCollectionViewNumberOfItemsPerRow:CGFloat = 2
    
    static func initAndLoad(spaceLibraryItems: SpaceLibraryItems) -> SpaceLibraryViewController {
        let spaceLibraryViewController = SpaceLibraryViewController.initAndLoad()
        
        spaceLibraryViewController.viewModel = SpaceLibraryViewModel(spaceLibraryItems: spaceLibraryItems)
        
        return spaceLibraryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = "Space Library"
        headerView.delegate = self
        filterView.isHidden = true
        filterView.delegate = self
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        spaceItemsCollectionView.register(SpaceLibraryItemCell.nib, forCellWithReuseIdentifier: SpaceLibraryItemCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension SpaceLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfSpaceItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let spaceItem = viewModel.getSpaceItem(position: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceLibraryItemCell.identifier, for: indexPath) as! SpaceLibraryItemCell
        
        cell.configure(spaceItem: spaceItem)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpaceLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - kCollectionViewCellInset) / kCollectionViewNumberOfItemsPerRow, height: (collectionView.frame.width - kCollectionViewCellInset) / kCollectionViewNumberOfItemsPerRow)
    }
}

// MARK: - HeaderViewProtocol

extension SpaceLibraryViewController: HeaderViewProtocol {
    func didPressBack() {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    func didPressOptions() {
        UIView.animate(withDuration: 0.6,
                       animations: {
            self.filterView.isHidden.toggle()
            self.filterView.layoutIfNeeded()
        })
    }
}

extension SpaceLibraryViewController: FilterViewProtocol {
    func changeFilters(filters: SpaceLibraryFilters) {
        viewModel.getSpaceLibraryItemsFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let failure):
                print("Change spaceLibrary filters error: \(failure)")
            case .success(_):
                DispatchQueue.main.async {
                    self.spaceItemsCollectionView.reloadData()
                }
            }
        })
    }
    
    func resetFilters() {
        viewModel.getSpaceLibraryItemsBegin(page: 1, completion: { result in
            switch result {
            case .failure(let failure):
                print("Reset spaceLibrary filters error: \(failure)")
            case .success(_):
                DispatchQueue.main.async {
                    self.spaceItemsCollectionView.reloadData()
                }
            }
        })
    }
}
// MARK: - HudViewProtocol

extension SpaceLibraryViewController: HudViewProtocol {}
