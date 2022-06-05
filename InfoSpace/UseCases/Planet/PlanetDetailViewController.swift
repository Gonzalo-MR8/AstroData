//
//  PlanetDetailViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/6/22.
//

import UIKit

class PlanetDetailViewController: UIViewController {

    private var viewModel: PlanetDetailViewModel!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    static func initAndLoad(planet: Planet) -> PlanetDetailViewController {
        let planetDetailViewController = PlanetDetailViewController.initAndLoad()
        
        planetDetailViewController.viewModel = PlanetDetailViewModel(planet: planet)
        
        return planetDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = viewModel.getPlanet().title
    }

    @IBAction func buttonBackPressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
}
