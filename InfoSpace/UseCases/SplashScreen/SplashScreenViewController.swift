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

        DispatchQueue.global().async {
            do {
                if try Bundle.isUpdateAvailable() {
                    DispatchQueue.main.async {
                        CustomNavigationController.instance.showAlertBlockView(alertType: .update)
                    }
                }
            } catch {
                print("Update Available Error")
            }
        }
        
        getInitialData()
    }

    private func getInitialData() {
        Task {
          do {
            let dashboardData = try await viewModel.getInitialData()
            DispatchQueue.main.async {
                let dashboardVC = DashboardViewController.initAndLoad(dashboardData: dashboardData)
                CustomNavigationController.instance.navigate(to: dashboardVC, animated: true)
            }
          } catch {
            DispatchQueue.main.async {
                guard !CustomNavigationController.instance.isAlertViewPresented() else { return }

                CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "SPLASH_SCREEN_LOAD_ERROR".localized, completion: { [weak self] _ in
                    guard let self else { return }
                    getInitialData()
                })
            }
          }
        }
    }
}
