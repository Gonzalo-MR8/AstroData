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
    case description
    case separator
    case date(String)
    case center(String)
    case secondaryCreator(String)
    case photographer(String)
    case location(String)
    case openWeb(URL)
}

class SpaceItemDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SpaceItemDetailViewModel!
    private var cellTypes: [SpaceItemDetailCellType] = []
    
    private let baseDetailUrl: String = Bundle.string(for: InfoConstants.kNasaDetailBaseUrl)!
    
    static func initAndLoad(spaceItem: SpaceItem) -> SpaceItemDetailViewController {
        let spaceItemDetailViewController = SpaceItemDetailViewController.initAndLoad()
        
        spaceItemDetailViewController.viewModel = SpaceItemDetailViewModel(spaceItem: spaceItem)
        
        return spaceItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = viewModel.getSpaceItemData().nasaID
        headerView.options = false
        headerView.delegate = self
        
        configureTable()
        configureCells()
    }

    private func configureTable() {
        tableView.register(OpenUrlCell.nib, forCellReuseIdentifier: OpenUrlCell.identifier)
        tableView.register(TitleCell.nib, forCellReuseIdentifier: TitleCell.identifier)
        tableView.register(DescriptionCell.nib, forCellReuseIdentifier: DescriptionCell.identifier)
        tableView.register(SIDetailImageCell.nib, forCellReuseIdentifier: SIDetailImageCell.identifier)
        tableView.register(SIDetailMultipurposeTextCell.nib, forCellReuseIdentifier: SIDetailMultipurposeTextCell.identifier)
        tableView.register(SeparatorCell.nib, forCellReuseIdentifier: SeparatorCell.identifier)
    }
    
    private func configureCells() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        
        let spaceItemData: SpaceItemData = viewModel.getSpaceItemData()
        
        Utils.shared.downloadUIImage(with: viewModel.getSpaceItemLinks().first?.href) { [self] result in
            if let image = result {
                cellTypes.append(.image(image))
            }
            
            let formatter = DateFormatter.dateFormatterLocale
            formatter.dateFormat = Constants.kShortDateFormat
            
            cellTypes.append(.date(formatter.string(from: spaceItemData.dateCreated)))
            
            if let center = spaceItemData.center {
                cellTypes.append(.center(center))
            }
            
            if let secondaryCreator = spaceItemData.secondaryCreator {
                cellTypes.append(.secondaryCreator(secondaryCreator))
            }
            
            if let photographer = spaceItemData.photographer {
                cellTypes.append(.photographer(photographer))
            }
            
            if let location = spaceItemData.location {
                cellTypes.append(.location(location))
            }
            
            cellTypes.append(.separator)
            
            if spaceItemData.description != nil {
                cellTypes.append(.description)
            }
            
            if let url = URL(string: baseDetailUrl + spaceItemData.nasaID) {
                cellTypes.append(.openWeb(url))
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
        let spaceItemData: SpaceItemData = viewModel.getSpaceItemData()
        
        switch cellType {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleCell.identifier) as! TitleCell
            
            cell.configure(title: spaceItemData.title)
            
            return cell
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailImageCell.identifier) as! SIDetailImageCell
            
            cell.configure(image: image, links: viewModel.getSpaceItemLinks(), frameWidth: self.view.frame.width)
            
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier) as! DescriptionCell
            
            cell.configure(description: spaceItemData.description!)
            
            return cell
        case .date(let date):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as! SIDetailMultipurposeTextCell
            
            cell.configure(title: "Date created: ", text: date)
            
            return cell
        case .center(let center):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as! SIDetailMultipurposeTextCell
            
            cell.configure(title: "Center: ", text: center)
            
            return cell
        case .secondaryCreator(let secondaryCreator):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as! SIDetailMultipurposeTextCell
            
            cell.configure(title: "Secondary Creator: ", text: secondaryCreator)
            
            return cell
        case .photographer(let photographer):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as! SIDetailMultipurposeTextCell
            
            cell.configure(title: "Photographer: ", text: photographer)
            
            return cell
        case .location(let location):
            let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as! SIDetailMultipurposeTextCell
            
            cell.configure(title: "Location: ", text: location)
            
            return cell
        case .openWeb(let url):
            let cell = tableView.dequeueReusableCell(withIdentifier: OpenUrlCell.identifier) as! OpenUrlCell
            
            cell.configure(url: url, buttonText: "OPEN IN WEB")
            
            return cell
        case .separator:
            let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorCell.identifier) as! SeparatorCell
            
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
