//
//  DashboardViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

class DashboardViewController: UIViewController {

    private let viewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showHudView()
    }

}

// MARK: - HudViewProtocol

extension DashboardViewController: HudViewProtocol { }
