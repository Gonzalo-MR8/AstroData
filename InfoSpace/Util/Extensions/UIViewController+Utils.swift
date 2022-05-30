//
//  UIViewController+Utils.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 24/5/22.
//

import UIKit

extension UIViewController {
    /// Inits and loads the view controller
    /// - Returns: The view controller
    static func initAndLoad() -> Self {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T {
            let vc = T.init(nibName: String(describing: T.self), bundle: nil)
            
            vc.modalPresentationStyle = .fullScreen
            
            return vc
        }
        
        return instantiateFromNib(self)
    }
    
    /// Determines if a view controller is modal
    /// - Returns: <code>True</code> if it is modal or <code>false</code> in other case
    func isModal() -> Bool {
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
