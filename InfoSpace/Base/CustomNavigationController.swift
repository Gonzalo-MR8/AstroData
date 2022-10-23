//
//  CustomNavigationController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 28/5/22.
//

import UIKit
import SafariServices

typealias EmptyBlock = () -> ()

class CustomNavigationController: UINavigationController {

    // Here we have to create and instantiate the rootViewController
    static let instance = CustomNavigationController(rootViewController: SplashScreenViewController.initAndLoad())

    func configure() -> UIWindow {
        // Configure Navigation Controller appearance
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.setNavigationBarHidden(true, animated: false)
        
        // Create a window that is the same size as the screen
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.rootViewController = self
        // Show the window
        window.makeKeyAndVisible()
        
        return window
    }
    
    func navigate(to destination: UIViewController, animated: Bool, closePreviousVC: Bool = false) {
        if let topViewController = UIApplication.topViewController(controller: self), let nav = topViewController.navigationController {
            nav.pushViewController(destination, animated: animated)
            if closePreviousVC {
                if let index = nav.viewControllers.firstIndex(of: destination), index > 0 {
                    nav.viewControllers.removeSubrange(0..<index)
                }
            }
            
        } else {
            self.pushViewController(destination, animated: animated)
            if closePreviousVC {
                if let index = self.viewControllers.firstIndex(of: destination), index > 0 {
                    self.viewControllers.removeSubrange(0..<index)
                }
            }
        }
    }
    
    func present(to destination: UIViewController, animated: Bool, presentationStyle: UIModalPresentationStyle = .overCurrentContext, completion: (() -> Void)? = nil) {
        if let topViewController = UIApplication.topViewController(controller: self) {
            destination.modalPresentationStyle = presentationStyle
            topViewController.present(destination, animated: animated, completion: completion)
        } else {
            destination.modalPresentationStyle = presentationStyle
            self.present(destination, animated: animated, completion: completion)
        }
    }
    
    func dismissVC(animated: Bool, completion: (() -> Void)? = nil) {
        if let topViewController = UIApplication.topViewController(controller: self) {
            if topViewController.isModal() {
                topViewController.dismiss(animated: animated, completion: completion)
            } else {
                topViewController.navigationController?.popViewController(animated: animated)
                completion?()
            }
        } else {
            self.popViewController(animated: animated)
            completion?()
        }
    }
    
    func presentDefaultAlert(title: String, message: String, actionTitle: String = "Vale", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { action in
            completion?()
            alert.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popToViewController(classVC: AnyClass, animated: Bool) {
        if let viewController = self.getViewControllerInStack(classVC: classVC) {
            self.popToViewController(viewController, animated: animated)
        }
    }
    
    func getViewControllerInStack(classVC: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: { type(of:$0) == classVC })
    }
    
    func openUrl(_ url: URL) {
        let safariController = SFSafariViewController(url: url)
        
        safariController.modalPresentationStyle = .overFullScreen
        
        self.present(safariController, animated: true, completion: nil)
    }
}
