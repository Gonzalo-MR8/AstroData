//
//  APODViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import UIKit

enum APODCellType {
    case title
    case date
    case image(UIImage)
    case buttonUrl(URL)
    case description
}

class APODViewController: UIViewController {

    private var viewModel: APODViewModel!
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    private var cellTypes: [APODCellType] = []
    
    static func initAndLoad(apod: APOD) -> APODViewController {
        let apodViewController = APODViewController.initAndLoad()
        
        apodViewController.viewModel = APODViewModel(apod: apod)
        
        return apodViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = "APOD"
        headerView.options = false
        headerView.delegate = self
        
        configureTable()
        
        showHudView()
        configureImageOrUrl()
    }
    
    private func configureImageOrUrl() {
        cellTypes.removeAll()
        
        cellTypes.append(.title)
        cellTypes.append(.date)
        
        let apod: APOD = viewModel.getApod()
        
        Utils.shared.downloadUIImage(with: apod.thumbUrl) { [self] result in
            if let image = result {
                cellTypes.append(.image(image))
            } else {
                guard let url = URL(string: apod.thumbUrl) else {
                    return
                }
                
                cellTypes.append(.buttonUrl(url))
            }
            
            cellTypes.append(.description)
            
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
                hideHudView()
            }
        }
    }
    
    private func configureTable() {
        tableView.register(APODDateCell.nib, forCellReuseIdentifier: APODDateCell.identifier)
        tableView.register(APODImageCell.nib, forCellReuseIdentifier: APODImageCell.identifier)
        tableView.register(APODUrlCell.nib, forCellReuseIdentifier: APODUrlCell.identifier)
        tableView.register(APODTitleCell.nib, forCellReuseIdentifier: APODTitleCell.identifier)
        tableView.register(APODDescriptionCell.nib, forCellReuseIdentifier: APODDescriptionCell.identifier)
    }
}

extension APODViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]
        let apod: APOD = viewModel.getApod()
        
        switch cellType {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: APODTitleCell.identifier) as! APODTitleCell
            
            cell.configure(title: apod.title)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: APODDateCell.identifier) as! APODDateCell
            
            cell.changeDatePicker = { [self] date in
                showHudView()
                viewModel.getNewAPOD(date: date, completion: { result in
                    switch result {
                    case .failure(let error):
                        print("Error \(error)")
                        cell.updateSelectedDate(state: false)
                        DispatchQueue.main.async {
                            self.hideHudView()
                            CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Fecha no valida intentelo de nuevo mas tarde")
                        }
                    case .success(_):
                        cell.updateSelectedDate(state: true)
                        self.configureImageOrUrl()
                    }
                })
            }
            
            return cell
        case .image(let image):
            let cell = tableView.dequeueReusableCell(withIdentifier: APODImageCell.identifier) as! APODImageCell
            
            cell.configure(image: image, apod: apod, frameWidth: self.view.frame.width)
            
            return cell
        case .buttonUrl(let url):
            let cell = tableView.dequeueReusableCell(withIdentifier: APODUrlCell.identifier) as! APODUrlCell
            
            cell.configure(url: url)
            
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: APODDescriptionCell.identifier) as! APODDescriptionCell
            
            cell.configure(description: apod.explanation)
            
            return cell
        }
    }
}

// MARK: - HeaderViewProtocol

extension APODViewController: HeaderViewProtocol {
    func didPressBack() {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    func didPressOptions() { }
}

// MARK: - HudViewProtocol

extension APODViewController: HudViewProtocol { }
