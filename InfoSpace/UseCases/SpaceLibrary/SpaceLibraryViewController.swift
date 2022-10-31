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
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: SpaceLibraryViewModel!
    
    static func initAndLoad(initInformation: String) -> SpaceLibraryViewController {
        let spaceLibraryViewController = SpaceLibraryViewController.initAndLoad()
        
        spaceLibraryViewController.viewModel = SpaceLibraryViewModel()
        
        return spaceLibraryViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.labelTitle.text = "Space Library"
        headerView.delegate = self
        filterView.isHidden = true
        configureTable()
    }
    
    private func configureTable() {
        tableView.register(APODDescriptionCell.nib, forCellReuseIdentifier: APODDescriptionCell.identifier)
    }
}

extension SpaceLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: APODDescriptionCell.identifier) as! APODDescriptionCell
        
        cell.configure(description: "SÑDLOVJISDBFILUVBIUSFABVIUBSFOUBNVDSFIUBVIUADFSBIVBISAFBIVUBJSIÑBVIUBISFJDBVIUSFDBVHBSFDIHBVJKSFDBVIJBSDFIHBVIBDSIYBVKJBDSHKJVBYISDBFVJKBSDIJVNBUIDFSBVJK BSDFIHJBNVUIGDSBJVBUYIDSBVUIBGSDKJVBIYDSBVJBDSWJKBVIYEWBSDUVIYBSDKJBVHIBSDIYUFBJUERWIHVJONDSFUIVBNUISBDVIJDSBNJVBJKSDBVKJSBDFHIVBIUSDBVIUDBIUVBIEBVIHBSDVLJSDBVLISHABVLSBFLIBUVBILUS")
        return cell
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
