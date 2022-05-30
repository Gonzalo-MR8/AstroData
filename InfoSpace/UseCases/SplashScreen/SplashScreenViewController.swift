//
//  SplashScreenViewController.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 25/5/22.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    private let viewModel = SplashScreenViewModel()
    
    @IBOutlet weak var viewAnimation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAnimation.loopMode = .loop
        viewAnimation.contentMode  = .scaleAspectFill
        viewAnimation.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            let dashboardVC = DashboardViewController.initAndLoad()
            CustomNavigationController.instance.navigate(to: dashboardVC, animated: true)
        }
    }
}
