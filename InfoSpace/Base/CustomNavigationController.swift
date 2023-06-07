//
//  CustomNavigationController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 28/5/22.
//

import UIKit

final class CustomNavigationController: UINavigationController {

    // Here we have to create and instantiate the rootViewController
    static let instance = CustomNavigationController(rootViewController: SplashScreenViewController.initAndLoad())

    private override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        // Configure Navigation Controller appearance
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.setNavigationBarHidden(true, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureWindow() -> UIWindow {
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
    
    func presentDefaultAlert(title: String, message: String, actionTitle: String = "OKEY".localized, completion: ((UIAlertAction) -> Void)? = nil) {
        closeAlertView()

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: completion))
        self.present(to: alert, animated: true)
    }
    
    func presentAcceptOrCancelAlert(title: String, message: String, acceptActionTitle: String = "ACCEPT".localized, cancelActionTitle: String = "CANCEL".localized, acceptCompletion: ((UIAlertAction) -> Void)? = nil, cancelCompletion: ((UIAlertAction) -> Void)? = nil) {
        closeAlertView()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: acceptActionTitle, style: .default, handler: acceptCompletion)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .default, handler: cancelCompletion)
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        self.present(to: alert, animated: true)
    }

    func popToViewController(classVC: AnyClass, animated: Bool) {
        if let viewController = self.getViewControllerInStack(classVC: classVC) {
            self.popToViewController(viewController, animated: animated)
        }
    }
    
    func getViewControllerInStack(classVC: AnyClass) -> UIViewController? {
        return self.viewControllers.first(where: { type(of: $0) == classVC })
    }
    
    func getPresentedViewController(classVC: AnyClass) -> UIViewController? {
        guard let presentedViewController = self.presentedViewController,
              type(of: presentedViewController) == classVC else { return nil }
        
        return presentedViewController
    }
    
    func openUrl(_ url: URL, animated: Bool) {
        UIApplication.shared.open(url)
    }
}

// MARK: - Hud View
extension CustomNavigationController {
    func showHudView() {
        closeHudView()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let hudView = HudView(frame: view.frame)
            hudView.startAnimating()
            view.addSubview(hudView)
        }
    }

    func closeHudView() {
        self.view.subviews.first(where: { type(of: $0) == HudView.self })?.removeFromSuperview()
    }
}

// MARK: - Show Custom Alerts
extension CustomNavigationController {
    func presentDefaultInfoAlert(title: String, message: String) {
        closeAlertView()

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        self.present(to: alert, animated: true, completion: {
            if let superview = alert.view.superview {
                let view = UIView()
                view.backgroundColor = .clear

                superview.addSubview(view)

                view.translatesAutoresizingMaskIntoConstraints = false
                view.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true

                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            alert.dismiss(animated: true)
        })
    }

    @objc private func dismissOnTapOutside() {
        self.dismiss(animated: true, completion: nil)
    }

    func closeAlertView() {
        self.view.subviews.first(where: { type(of: $0) == UIAlertController.self })?.removeFromSuperview()
    }

    func showAlertBlockView(alertType: AlertBlockType) {
        closeAlertBlockView()
        closeAlertView()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let blockView = AlertBlockView(frame: view.frame)
            blockView.configure(alertType: alertType)
            view.addSubview(blockView)
        }
    }

    func closeAlertBlockView() {
        self.view.subviews.first(where: { type(of: $0) == AlertBlockView.self })?.removeFromSuperview()
    }

    func showAlertSimpleView(alertType: AlertSimpleType) {
        closeAlertSimpleView()
        closeAlertView()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let alertView = AlertSimpleView(frame: view.frame)
            alertView.configure(alertType: alertType)
            view.addSubview(alertView)
        }
    }

    func closeAlertSimpleView() {
        self.view.subviews.first(where: { type(of: $0) == AlertSimpleView.self })?.removeFromSuperview()
    }

    func isAlertViewPresented() -> Bool {
        return self.view.subviews.first(where: { type(of: $0) == AlertSimpleView.self || type(of: $0) == UIAlertController.self || type(of: $0) == AlertBlockView.self }) != nil
    }
}
