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
        getPlanets()
    }
    
    private func getPlanets() {
        viewModel.getPlanets(completion: { result in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let planets):
                DispatchQueue.main.async {
                    let dashboardVC = DashboardViewController.initAndLoad(planets: planets)
                    CustomNavigationController.instance.navigate(to: dashboardVC, animated: true)
                }
            }
        })
    }
}
