//
//  SpaceLibraryViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import UIKit

class SpaceLibraryViewController: UIViewController {

    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var filterView: FilterView!
    @IBOutlet private weak var spaceItemsCollectionView: UICollectionView!
    
    private var viewModel: SpaceLibraryViewModel!
    
    private let kCollectionViewCellInset:CGFloat = 10
    private let kCollectionViewNumberOfItemsPerRow:CGFloat = 2
    private let kReloadCellHeight: CGFloat = 130
    private let kNoItemsCellHeight: CGFloat = 400
    
    private let kAnimationDuration: TimeInterval = 0.6
    
    private var filtered: Bool = false
    private var reload: Bool = false
    
    static func initAndLoad(spaceLibraryData: SpaceLibraryData) -> SpaceLibraryViewController {
        let spaceLibraryViewController = SpaceLibraryViewController.initAndLoad()
        
        spaceLibraryViewController.viewModel = SpaceLibraryViewModel(spaceLibraryData: spaceLibraryData)
        
        return spaceLibraryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureCollectionView()
    }
    
    // MARK: - Private methods
    
    private func configureViews() {
        headerView.configure(title: "SPACE_LIBRARY_SHORT_TITLE".localized, options: true)
        headerView.delegate = self
        
        filterView.configure()
        filterView.isHidden = true
        filterView.delegate = self
    }
    
    private func configureCollectionView() {
        spaceItemsCollectionView.register(SpaceLibraryItemCell.nib, forCellWithReuseIdentifier: SpaceLibraryItemCell.identifier)
        spaceItemsCollectionView.register(ReloadCollectionViewCell.nib, forCellWithReuseIdentifier: ReloadCollectionViewCell.identifier)
        spaceItemsCollectionView.register(SpaceLibraryNoItemsCell.nib, forCellWithReuseIdentifier: SpaceLibraryNoItemsCell.identifier)
    }
    
    private func resetOfChangeFiltersSuccess() {
        DispatchQueue.main.async { [self] in
            spaceItemsCollectionView.reloadData()
            hideHudView()
            // Scroll to top
            guard self.viewModel.getNumberOfSpaceItems() != 0, spaceItemsCollectionView.contentOffset.y != 0 else {
                return
            }
            
            self.spaceItemsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SpaceLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reload {
            return viewModel.getNumberOfSpaceItems() + 1
        } else {
            if viewModel.getNumberOfSpaceItems() == 0 {
                return 1
            } else {
                return viewModel.getNumberOfSpaceItems()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard viewModel.getNumberOfSpaceItems() != 0 else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceLibraryNoItemsCell.identifier, for: indexPath) as! SpaceLibraryNoItemsCell
            
            return cell
        }
        
        if indexPath.row == viewModel.getNumberOfSpaceItems() && reload {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReloadCollectionViewCell.identifier, for: indexPath) as! ReloadCollectionViewCell
            
            reload = false
            
            return cell
        } else {
            let spaceItem = viewModel.getSpaceItem(position: indexPath.row)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceLibraryItemCell.identifier, for: indexPath) as! SpaceLibraryItemCell
            
            cell.configure(spaceItem: spaceItem)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SpaceLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spaceItem = viewModel.getSpaceItem(position: indexPath.row)
        let detailVC = SpaceItemDetailViewController.initAndLoad(spaceItem: spaceItem)
        CustomNavigationController.instance.navigate(to: detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpaceLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard viewModel.getNumberOfSpaceItems() != 0 else {
            return CGSize(width: collectionView.frame.width, height: kNoItemsCellHeight)
        }
        
        if indexPath.row == viewModel.getNumberOfSpaceItems() && reload {
            return CGSize(width: (collectionView.frame.width - kCollectionViewCellInset), height: kReloadCellHeight)
        } else {
            return CGSize(width: (collectionView.frame.width - kCollectionViewCellInset) / kCollectionViewNumberOfItemsPerRow, height: (collectionView.frame.width - kCollectionViewCellInset) / kCollectionViewNumberOfItemsPerRow)
        }
    }
}

// MARK: - HeaderViewProtocol

extension SpaceLibraryViewController: HeaderViewProtocol {
    func didPressBack() {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    func didPressOptions() {
        UIView.animate(withDuration: kAnimationDuration,
                       animations: {
            self.filterView.isHidden.toggle()
            self.filterView.layoutIfNeeded()
        })
    }
}

// MARK: - FilterViewProtocol

extension SpaceLibraryViewController: FilterViewProtocol {
    func changeFilters(filters: SpaceLibraryFilters) {
        if filters.mediaTypes == nil, filters.searchText == nil, filters.yearEnd == nil, filters.yearStart == Utils.shared.getCurrentYear().description {
            showHudView()
            
            viewModel.getSpaceLibraryItemsBegin(changeOrder: filters.order, completion: { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_FILTERS_ERROR".localized)
                        self.hideHudView()
                    }
                case .success(_):
                    self.resetOfChangeFiltersSuccess()
                }
            })
        } else {
            if filters.mediaTypes == nil, filters.searchText == nil, filters.yearEnd == nil, filters.yearStart == nil {
                CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_NO_FILTERS_ERROR".localized)
            } else {
                showHudView()
                
                filtered = true
                viewModel.getSpaceLibraryItemsFilters(filters: filters, completion: { result in
                    switch result {
                    case .failure(_):
                        DispatchQueue.main.async {
                            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_FILTERS_ERROR".localized)
                            self.hideHudView()
                        }
                    case .success(_):
                        self.resetOfChangeFiltersSuccess()
                    }
                })
            }
        }
    }
    
    func resetFilters() {
        showHudView()
        filtered = false
        viewModel.getSpaceLibraryItemsBegin(reset: true, completion: { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_RESET_ERROR".localized)
                    self.hideHudView()
                }
            case .success(_):
                self.resetOfChangeFiltersSuccess()
            }
        })
    }
}

// MARK: - UIScrollViewDelegate

extension SpaceLibraryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView is UICollectionView else { return }
        
        guard (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) else {
            return
        }
        
        guard viewModel.canLoadMoreData() else { return }
        
        UIView.animate(withDuration: kAnimationDuration,
                       animations: {
            self.reload = true
            self.spaceItemsCollectionView.reloadData()
        })
        
        if filtered {
            viewModel.getSpaceLibraryItemsFiltersNewPage(filters: filterView.filters, completion: { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_LOAD_ERROR".localized)
                        self.spaceItemsCollectionView.reloadData()
                    }
                case .success(_):
                    DispatchQueue.main.async {
                        self.spaceItemsCollectionView.reloadData()
                    }
                }
            })
        } else {
            viewModel.getSpaceLibraryItemsBeginNewPage(completion: { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPACE_LIBRARY_LOAD_ERROR".localized)
                        self.spaceItemsCollectionView.reloadData()
                    }
                case .success(_):
                    DispatchQueue.main.async {
                        self.spaceItemsCollectionView.reloadData()
                    }
                }
            })
        }
    }
}

// MARK: - HudViewProtocol

extension SpaceLibraryViewController: HudViewProtocol {}
