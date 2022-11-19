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
    private let kReloadCellHeight: CGFloat = 130
    
    private let kAnimationDuration: TimeInterval = 0.6
    
    private var page: Int = 1
    private var filtered: Bool = false
    private var reload: Bool = false
    
    static func initAndLoad(spaceLibraryItems: SpaceLibraryItems) -> SpaceLibraryViewController {
        let spaceLibraryViewController = SpaceLibraryViewController.initAndLoad()
        
        spaceLibraryViewController.viewModel = SpaceLibraryViewModel(spaceLibraryItems: spaceLibraryItems)
        
        return spaceLibraryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureCollectionView()
    }
    
    // MARK: - Private methods
    
    private func configureViews() {
        headerView.labelTitle.text = "Space Library"
        headerView.delegate = self
        
        filterView.configure(page: page)
        filterView.isHidden = true
        filterView.delegate = self
    }
    
    private func configureCollectionView() {
        spaceItemsCollectionView.register(SpaceLibraryItemCell.nib, forCellWithReuseIdentifier: SpaceLibraryItemCell.identifier)
        spaceItemsCollectionView.register(ReloadCollectionViewCell.nib, forCellWithReuseIdentifier: ReloadCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension SpaceLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reload {
            return viewModel.getNumberOfSpaceItems() + 1
        } else {
            if viewModel.getNumberOfSpaceItems() == 0 {
                reload = true
                return 1
            } else {
                return viewModel.getNumberOfSpaceItems()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == viewModel.getNumberOfSpaceItems() && reload {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReloadCollectionViewCell.identifier, for: indexPath) as! ReloadCollectionViewCell
            
            return cell
        } else {
            let spaceItem = viewModel.getSpaceItem(position: indexPath.row)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpaceLibraryItemCell.identifier, for: indexPath) as! SpaceLibraryItemCell
            
            cell.configure(spaceItem: spaceItem)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SpaceLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        showHudView()
        page = 1
        filtered = true
        viewModel.getSpaceLibraryItemsFilters(filters: filters, completion: { result in
            switch result {
            case .failure(let failure):
                print("Change spaceLibrary filters error: \(failure)")
                DispatchQueue.main.async {
                    CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Algo a ido mal al aplicar los filtros, intentelo de nuevo")
                    self.hideHudView()
                }
            case .success(_):
                DispatchQueue.main.async {
                    self.spaceItemsCollectionView.reloadData()
                    self.spaceItemsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    self.hideHudView()
                }
            }
        })
    }
    
    func resetFilters() {
        showHudView()
        page = 1
        filtered = false
        viewModel.getSpaceLibraryItemsBegin(page: page, completion: { result in
            switch result {
            case .failure(let failure):
                print("Reset spaceLibrary filters error: \(failure)")
                DispatchQueue.main.async {
                    CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Algo a ido mal al pulsar el boton reset, intentelo de nuevo")
                    self.hideHudView()
                }
            case .success(_):
                DispatchQueue.main.async {
                    self.spaceItemsCollectionView.reloadData()
                    self.hideHudView()
                }
            }
        })
    }
}

// MARK: - UIScrollViewDelegate

extension SpaceLibraryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView is UICollectionView else { return }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            UIView.animate(withDuration: kAnimationDuration,
                           animations: {
                self.reload = true
                self.spaceItemsCollectionView.reloadData()
            })
            
            page = page + 1
            
            if filtered {
                filterView.filters.page = page
                viewModel.getSpaceLibraryItemsFiltersNewPage(filters: filterView.filters, completion: { result in
                    switch result {
                    case .failure(let failure):
                        print("Get newPage spaceLibrary filters error: \(failure)")
                        DispatchQueue.main.async {
                            CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Algo a ido mal")
                        }
                    case .success(_):
                        DispatchQueue.main.async {
                            self.reload = false
                            self.spaceItemsCollectionView.reloadData()
                        }
                    }
                })
            } else {
                viewModel.getSpaceLibraryItemsBeginNewPage(page: page, completion: { result in
                    switch result {
                    case .failure(let failure):
                        print("Get newPage spaceLibrary error: \(failure)")
                        DispatchQueue.main.async {
                            CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Algo a ido mal")
                        }
                    case .success(_):
                        DispatchQueue.main.async {
                            self.reload = false
                            self.spaceItemsCollectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
}

// MARK: - HudViewProtocol

extension SpaceLibraryViewController: HudViewProtocol {}
