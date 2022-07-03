//
//  MarsRoverViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/7/22.
//

import UIKit

class MarsRoverViewController: UIViewController {

    private var viewModel: MarsRoverViewModel!
    
    static func initAndLoad(initInformation: String) -> MarsRoverViewController {
        let marsRoverViewController = MarsRoverViewController.initAndLoad()
        
        marsRoverViewController.viewModel = MarsRoverViewModel()
        
        return marsRoverViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
}
