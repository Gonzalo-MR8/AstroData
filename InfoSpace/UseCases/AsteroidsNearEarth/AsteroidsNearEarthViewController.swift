//
//  AsteroidsNearEarthViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import UIKit

class AsteroidsNearEarthViewController: UIViewController {

    private var viewModel: AsteroidsNearEarthViewModel!
    
    static func initAndLoad(initInformation: String) -> AsteroidsNearEarthViewController {
        let asteroidsNearEarthViewController = AsteroidsNearEarthViewController.initAndLoad()
        
        asteroidsNearEarthViewController.viewModel = AsteroidsNearEarthViewModel()
        
        return asteroidsNearEarthViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
}
