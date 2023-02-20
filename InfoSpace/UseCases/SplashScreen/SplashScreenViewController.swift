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
    
    @IBOutlet private weak var viewAnimation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAnimation.loopMode = .loop
        viewAnimation.contentMode = .scaleAspectFill
        viewAnimation.play()
        getInitialData()
    }
    
    private func getInitialData() {
        Task {
            let initialData = await viewModel.getInitialData()
            
            switch initialData {
            case .success(let dashboardData):
                DispatchQueue.main.async {
                    let dashboardVC = DashboardViewController.initAndLoad(dashboardData: dashboardData)
                    CustomNavigationController.instance.navigate(to: dashboardVC, animated: true)
                }
            case .failure:
                DispatchQueue.main.async {
                    CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPLASH_SCREEN_LOAD_ERROR".localized, completion: { _ in
                        self.getInitialData()
                    })
                }
            }
        }
    }
}
