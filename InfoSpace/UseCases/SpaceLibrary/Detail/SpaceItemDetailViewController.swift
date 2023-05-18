//
//  SpaceItemDetailViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 19/11/22.
//

import UIKit
import AVFoundation

enum SpaceItemDetailCellType: Equatable {
    case title
    case image(UIImage, String?)
    case video(URL)
    case audio(URL)
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

    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: SpaceItemDetailViewModel!
    private var cellTypes: [SpaceItemDetailCellType] = []
    
    private let baseDetailUrl: String = Bundle.string(for: InfoConstants.kNasaDetailBaseUrl)!
    
    private var player: AVPlayer?
    
    static func initAndLoad(spaceItem: SpaceItem) -> SpaceItemDetailViewController {
        let spaceItemDetailViewController = SpaceItemDetailViewController.initAndLoad()
        
        spaceItemDetailViewController.viewModel = SpaceItemDetailViewModel(spaceItem: spaceItem)
        
        return spaceItemDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.configure(title: viewModel.getSpaceItemData().nasaID, options: false)
        headerView.delegate = self
        
        configureTable()
        
        CustomNavigationController.instance.showHudView()
        
        Task {
            _ = await viewModel.getMediaURLs()
            
            switch viewModel.getSpaceItemData().mediaType {
            case .image:
                configureImageCells()
            case .video:
                configureVideoCells()
            case .audio:
                configureAudioCells()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cellTypes.enumerated().forEach({ position, item in
            if let url = URL(completedString: viewModel.getVideoUrl()), item == .video(url) {
                guard let videoCell = tableView.cellForRow(at: IndexPath(row: position, section: 0)) as? SIDetailVideoCell else {
                    return
                }
                videoCell.player.pause()
                videoCell.player = nil
                return
            }
            
            if let url = URL(completedString: viewModel.getAudioUrl()), item == .audio(url) {
                guard let audioCell = tableView.cellForRow(at: IndexPath(row: position, section: 0)) as? SIDetailAudioCell else {
                    return
                }
                audioCell.player.pause()
                audioCell.player = nil
                return
            }
        })
    }
    
    private func configureTable() {
        tableView.register(OpenUrlCell.nib, forCellReuseIdentifier: OpenUrlCell.identifier)
        tableView.register(TitleCell.nib, forCellReuseIdentifier: TitleCell.identifier)
        tableView.register(DescriptionCell.nib, forCellReuseIdentifier: DescriptionCell.identifier)
        tableView.register(SIDetailImageCell.nib, forCellReuseIdentifier: SIDetailImageCell.identifier)
        tableView.register(SIDetailVideoCell.nib, forCellReuseIdentifier: SIDetailVideoCell.identifier)
        tableView.register(SIDetailAudioCell.nib, forCellReuseIdentifier: SIDetailAudioCell.identifier)
        tableView.register(SIDetailMultipurposeTextCell.nib, forCellReuseIdentifier: SIDetailMultipurposeTextCell.identifier)
        tableView.register(SeparatorCell.nib, forCellReuseIdentifier: SeparatorCell.identifier)
    }
    
    private func configureCommonCells(spaceItemData: SpaceItemData) {
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
        
        if let url = URL(completedString: baseDetailUrl + spaceItemData.nasaID) {
            cellTypes.append(.openWeb(url))
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            tableView.reloadData()
            CustomNavigationController.instance.closeHudView()
        }
    }
    
    private func configureImageCells() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        
        let spaceItemData: SpaceItemData = viewModel.getSpaceItemData()
        
        Utils.downloadUIImage(with: viewModel.getSpaceItemLinks()?.href) { [weak self] result in
            guard let self else { return }
            if let image = result {
                cellTypes.append(.image(image, viewModel.getHighDefinitionImage()))
            }
            
            configureCommonCells(spaceItemData: spaceItemData)
        }
    }
    
    private func configureVideoCells() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        
        let spaceItemData: SpaceItemData = viewModel.getSpaceItemData()
        
        if let url = URL(completedString: viewModel.getVideoUrl()) {
            cellTypes.append(.video(url))
        } else {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
                CustomNavigationController.instance.dismissVC(animated: true)
            }
        }
        
        configureCommonCells(spaceItemData: spaceItemData)
    }
    
    private func configureAudioCells() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        
        let spaceItemData: SpaceItemData = viewModel.getSpaceItemData()
        
        if let url = URL(completedString: viewModel.getAudioUrl()) {
            cellTypes.append(.audio(url))
            cellTypes.append(.separator)
        } else {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "TRY_IT_LATER".localized) { _ in
                CustomNavigationController.instance.dismissVC(animated: true)
            }
        }
        
        configureCommonCells(spaceItemData: spaceItemData)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleCell.identifier) as? TitleCell else { return UITableViewCell() }
            
            cell.configure(title: spaceItemData.title)
            
            return cell
        case .image(let image, let highDefinitionUrlImage):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailImageCell.identifier) as? SIDetailImageCell else { return UITableViewCell() }
            
            cell.configure(image: image, link: viewModel.getSpaceItemLinks(), highDefinitionUrlImage: highDefinitionUrlImage, frameWidth: self.view.frame.width)
            
            return cell
        case .video(let url):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailVideoCell.identifier) as? SIDetailVideoCell else { return UITableViewCell() }
            
            if let player = player {
                cell.configure(player: player, frameWidth: self.view.frame.width, viewController: self)
            } else {
                let newPlayer = AVPlayer(url: url)
                cell.configure(player: newPlayer, frameWidth: self.view.frame.width, viewController: self)
            }
            
            return cell
        case .audio(let url):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailAudioCell.identifier) as? SIDetailAudioCell else { return UITableViewCell() }
            
            if let player = player {
                cell.configure(player: player)
            } else {
                let newPlayer = AVPlayer(url: url)
                cell.configure(player: newPlayer)
            }
            
            return cell
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifier) as? DescriptionCell else { return UITableViewCell() }
            
            cell.configure(description: spaceItemData.description ?? "")
            
            return cell
        case .date(let date):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as? SIDetailMultipurposeTextCell else { return UITableViewCell() }
            
            cell.configure(title: "SPACE_ITEM_DETAIL_DATE_TITLE".localized, text: date)
            
            return cell
        case .center(let center):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as? SIDetailMultipurposeTextCell else { return UITableViewCell() }
            
            cell.configure(title: "SPACE_ITEM_DETAIL_CENTER_TITLE".localized, text: center)
            
            return cell
        case .secondaryCreator(let secondaryCreator):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as? SIDetailMultipurposeTextCell else { return UITableViewCell() }
            
            cell.configure(title: "SPACE_ITEM_DETAIL_SECONDARY_CREATOR_TITLE".localized, text: secondaryCreator)
            
            return cell
        case .photographer(let photographer):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as? SIDetailMultipurposeTextCell else { return UITableViewCell() }
            
            cell.configure(title: "SPACE_ITEM_DETAIL_PHOTOGRAPHER_TITLE".localized, text: photographer)
            
            return cell
        case .location(let location):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SIDetailMultipurposeTextCell.identifier) as? SIDetailMultipurposeTextCell else { return UITableViewCell() }
            
            cell.configure(title: "SPACE_ITEM_DETAIL_LOCATION_TITLE".localized, text: location)
            
            return cell
        case .openWeb(let url):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OpenUrlCell.identifier) as? OpenUrlCell else { return UITableViewCell() }
            
            cell.configure(url: url, analyticsScreen: .spaceLibraryDetail)
            
            return cell
        case .separator:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorCell.identifier) as? SeparatorCell else { return UITableViewCell() }
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SpaceItemDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // This code save the player to save the progrees of the audio or the video when you scroll down the cell
        if let audioCell = cell as? SIDetailAudioCell {
            player = audioCell.player
        } else if let videoCell = cell as? SIDetailVideoCell {
            player = videoCell.player
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

// MARK: - HudViewProtocol

extension SpaceItemDetailViewController: HudViewProtocol {}
