//
//  SplashScreenViewController.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 25/5/22.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var viewAnimation: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewAnimation.loopMode = .loop
        viewAnimation.contentMode  = .scaleAspectFill
        viewAnimation.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //sleep(1)
        
        //let destinationVC: = MainViewController.initAndLoad()
        
        //CustomNavigationController.instance.navigate(to: destinationVC, animated: true)
    }
}
