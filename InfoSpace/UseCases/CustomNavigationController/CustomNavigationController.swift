//
//  CustomNavigationController.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 25/5/22.
//

import UIKit
import SafariServices

typealias EmptyBlock = () -> ()

class CustomNavigationController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewHud: HudView!
    
    static let instance = CustomNavigationController()
    var navigation: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitialViewController(initialViewController: SplashScreenViewController.initAndLoad())
        viewHud.isHidden = true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func configure() -> UIWindow {
        //Create a window that is the same size as the screen
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = CustomNavigationController.instance
        // Show the window
        window.makeKeyAndVisible()
        
        return window
    }
    
    func setInitialViewController(initialViewController: UIViewController) {
        navigation = UINavigationController(rootViewController: initialViewController)
        navigation.view.translatesAutoresizingMaskIntoConstraints = false
        navigation.setNavigationBarHidden(true, animated: false)
        
        self.addChild(navigation)
        self.viewContainer.addSubview(navigation.view)
        navigation.didMove(toParent: self)
        
        let activeConstraints = [
            navigation.view.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            navigation.view.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            navigation.view.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            navigation.view.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
    func navigate(to destination: UIViewController, animated: Bool, closePreviousVCs: Bool = false) {
        if let topViewController = UIApplication.topViewController(controller: navigation), let nav = topViewController.navigationController
        {
            nav.pushViewController(destination, animated: animated)
            if (closePreviousVCs)
            {
                if let index = nav.viewControllers.firstIndex(of: destination), index > 0
                {
                    nav.viewControllers.removeSubrange(0..<index)
                }
            }
            
        }else
        {
            navigation.pushViewController(destination, animated: animated)
            if(closePreviousVCs)
            {
                if let index = navigation.viewControllers.firstIndex(of: destination), index > 0
                {
                    navigation.viewControllers.removeSubrange(0..<index)
                }
            }
        }
    }
    
    func navigateClosingLast(to destination: UIViewController, animated: Bool) {
        if let topViewController = UIApplication.topViewController(controller: navigation), let nav = topViewController.navigationController {
            nav.pushViewController(destination, animated: animated)
            if let index = nav.viewControllers.firstIndex(of: destination), index > 0 {
                nav.viewControllers.remove(at: index - 1)
            }
            
        } else {
            navigation.pushViewController(destination, animated: animated)
            if let index = navigation.viewControllers.firstIndex(of: destination), index > 0 {
                navigation.viewControllers.remove(at: index - 1)
            }
        }
    }
    
    func navigateClosingRangeOfViewControllers(to destination: UIViewController, sincePositionVCToClose: Int, animated: Bool) {
        if let topViewController = UIApplication.topViewController(controller: navigation), let nav = topViewController.navigationController {
            nav.pushViewController(destination, animated: animated)
            if let index = nav.viewControllers.firstIndex(of: destination), index > 0 {
                nav.viewControllers.removeSubrange(sincePositionVCToClose...index - 1)
            }
            
        } else {
            navigation.pushViewController(destination, animated: animated)
            if let index = navigation.viewControllers.firstIndex(of: destination), index > 0 {
                navigation.viewControllers.removeSubrange(sincePositionVCToClose...index - 1)
            }
        }
    }
    
    func present(to destination: UIViewController, animated: Bool, completion: (() -> Void)? = nil, presentationStyle: UIModalPresentationStyle = .overCurrentContext) {
        if let topViewController = UIApplication.topViewController(controller: navigation) {
            destination.modalPresentationStyle = presentationStyle
            topViewController.present(destination, animated: animated, completion: completion)
        }
    }
    
    func presentOverAll(to destination: UIViewController, animated: Bool, closeLast: Bool, completion: (() -> Void)? = nil) {
        if (closeLast) {
            if let topViewController = UIApplication.topViewController(controller: self), topViewController !== self {
                topViewController.dismiss(animated: false) {
                    self.present(destination, animated: animated, completion: completion)
                }
            } else {
                self.present(destination, animated: animated, completion: completion)
            }
        } else {
            if let topViewController = UIApplication.topViewController(controller: self) {
                topViewController.present(destination, animated: animated, completion: completion)
            }
        }
    }
    
    func dismissController(animated: Bool, completion: (() -> Void)? = nil) {
        if let topViewController = UIApplication.topViewController(controller: navigation) {
            if(topViewController.isModal()) {
                topViewController.dismiss(animated: animated, completion: completion)
            } else {
                topViewController.navigationController?.popViewController(animated: animated)
                completion?()
            }
        } else {
            navigation.popViewController(animated: animated)
            completion?()
        }
    }
    
    func popToViewController(classVC: AnyClass, animated: Bool) {
        if let viewController = self.getViewControllerInStack(classVC: classVC) {
            self.navigation.popToViewController(viewController, animated: animated)
        }
    }
    
    func getViewControllerInStack(classVC: AnyClass) -> UIViewController? {
        return self.navigation.viewControllers.first(where: { type(of:$0) == classVC })
    }
    
    func openUrl(_ url: URL) {
        let safariController = SFSafariViewController(url: url)
        
        safariController.modalPresentationStyle = .overFullScreen
        
        present(safariController, animated: true, completion: nil)
    }
}

// MARK: - Hud View

extension CustomNavigationController {
    func showHud(applyBlur: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            guard !strongSelf.isHudShowing() else { return }
            
            strongSelf.viewHud.startAnimating()
            strongSelf.viewHud.isHidden = false
            strongSelf.viewHud.viewBlur.isHidden = !applyBlur
            strongSelf.view.bringSubviewToFront(strongSelf.viewHud)
        }
    }
    
    func hideHud() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            guard strongSelf.isHudShowing() else { return }
            
            strongSelf.viewHud.stopAnimating()
            strongSelf.viewHud.isHidden = true
        }
    }
    
    func isHudShowing() -> Bool {
        return !viewHud.isHidden
    }
}
