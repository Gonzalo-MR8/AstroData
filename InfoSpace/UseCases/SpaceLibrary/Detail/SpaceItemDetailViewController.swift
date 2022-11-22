//
//  SpaceItemDetailViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import UIKit

enum SpaceItemDetailCellType {
    case title
    case image
}

class SpaceItemDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SpaceItemDetailViewModel!
    private var cellTypes: [SpaceItemDetailCellType] = [.title, .image]
    
    static func initAndLoad(spaceItem: SpaceItem) -> SpaceItemDetailViewController {
        let spaceItemDetailViewController = SpaceItemDetailViewController.initAndLoad()
        
        spaceItemDetailViewController.viewModel = SpaceItemDetailViewModel(spaceItem: spaceItem)
        
        return spaceItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = viewModel.getSpaceItem().spaceItemdata.first?.nasaID
        headerView.options = false
        headerView.delegate = self
        
        configureTable()
    }

    private func configureTable() {
        tableView.register(SIDetailTitleCell.nib, forCellReuseIdentifier: SIDetailTitleCell.identifier)
        tableView.register(SIDetailImageCell.nib, forCellReuseIdentifier: SIDetailImageCell.identifier)
    }
}

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
            
            cell.configure(title: spaceItem.spaceItemdata.first?.title ?? "No titulo")
            
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailImageCell.identifier) as! SIDetailImageCell
            
            cell.configure(spaceItem: spaceItem, frameWidth: self.view.frame.width)
            
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
