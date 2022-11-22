//
//  SpaceItemDetailViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import UIKit

enum SpaceItemDetailCellType {
    case title
    case image(UIImage)
}

class SpaceItemDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SpaceItemDetailViewModel!
    private var cellTypes: [SpaceItemDetailCellType] = []
    
    static func initAndLoad(spaceItem: SpaceItem) -> SpaceItemDetailViewController {
        let spaceItemDetailViewController = SpaceItemDetailViewController.initAndLoad()
        
        spaceItemDetailViewController.viewModel = SpaceItemDetailViewModel(spaceItem: spaceItem)
        
        return spaceItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = viewModel.getSpaceItem().spaceItemdata.nasaID
        headerView.options = false
        headerView.delegate = self
        
        configureTable()
        configureCells()
    }

    private func configureTable() {
        tableView.register(SIDetailTitleCell.nib, forCellReuseIdentifier: SIDetailTitleCell.identifier)
        tableView.register(SIDetailImageCell.nib, forCellReuseIdentifier: SIDetailImageCell.identifier)
    }
    
    private func configureCells() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        
        let spaceItem: SpaceItem = viewModel.getSpaceItem()
        
        Utils.shared.downloadUIImage(with: spaceItem.links.first?.href) { [self] result in
            if let image = result {
                cellTypes.append(.image(image))
            }
            
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SpaceItemDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]
        let spaceItem: SpaceItem = viewModel.getSpaceItem()
        
        switch cellType {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailTitleCell.identifier) as! SIDetailTitleCell
            
            cell.configure(title: spaceItem.spaceItemdata.title)
            
            return cell
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailImageCell.identifier) as! SIDetailImageCell
            
            cell.configure(image: image, spaceItem: spaceItem, frameWidth: self.view.frame.width)
            
            return cell
        }
    }
}

// MARK: - HeaderViewProtocol

extension SpaceItemDetailViewController: HeaderViewProtocol {
    func didPressBack() {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    func didPressOptions() { }
}
