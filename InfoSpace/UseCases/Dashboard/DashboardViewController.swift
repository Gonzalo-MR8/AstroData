//
//  DashboardViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

class DashboardViewController: UIViewController {

    private let viewModel = DashboardViewModel()
    
    @IBOutlet weak var containerView: View!
    @IBOutlet weak var collectionViewDashboard: UICollectionView!
    @IBOutlet weak var collectionViewPlanets: UICollectionView!
    
    private var centerPlanetCell: PlanetCell?
    
    static func initAndLoad(planets: Planets) -> DashboardViewController {
        let dashboardViewController = DashboardViewController.initAndLoad()
        
        dashboardViewController.viewModel.setPlanets(planets: planets)
        
        return dashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionViewPlanets()
        configureCollectionViewDashboard()
        containerView.createStars(numberOfStarsRange: 180...200)
    }
    
    // MARK: - Private methods
    
    private func configureCollectionViewPlanets() {
        collectionViewPlanets.showsHorizontalScrollIndicator = false
        collectionViewPlanets.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let layoutMargins: CGFloat = collectionViewPlanets.layoutMargins.left + collectionViewPlanets.layoutMargins.right
        let sideInset = (collectionViewPlanets.frame.width / 2) - (layoutMargins + 10)
        collectionViewPlanets.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 10, right: sideInset)
        
        collectionViewPlanets.register(PlanetCell.nib, forCellWithReuseIdentifier: PlanetCell.identifier)
    }
    
    private func snapToCenter() {
        let centerPoint = view.convert(collectionViewPlanets.center, to: collectionViewPlanets)
        guard let centerIndexPath = collectionViewPlanets.indexPathForItem(at: centerPoint) else { return }
        collectionViewPlanets.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func configureCollectionViewDashboard() {
        collectionViewDashboard.register(DashboardItemCell.nib, forCellWithReuseIdentifier: DashboardItemCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPlanets {
            return viewModel.numberOfPlanets()
        } else {
            return viewModel.numberOfDashboardItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewPlanets {
            let planet = viewModel.getPlanet(position: indexPath.row)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanetCell.identifier, for: indexPath) as! PlanetCell
            
            cell.configure(planet: planet)
            
            return cell
        } else {
            let dashboardItem = viewModel.getDashboardItem(position: indexPath.row)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardItemCell.identifier, for: indexPath) as! DashboardItemCell
            
            cell.configure(dashboardItem: dashboardItem)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewPlanets {
            return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height - 35)
        } else {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(x: collectionViewPlanets.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: collectionViewPlanets.frame.size.height / 2 + scrollView.contentOffset.y)
        
        if let indexPath = collectionViewPlanets.indexPathForItem(at: centerPoint) {
            self.centerPlanetCell = collectionViewPlanets.cellForItem(at: indexPath) as? PlanetCell
            
            self.centerPlanetCell?.transformToLarge()
        }
        
        if let cell = self.centerPlanetCell {
            let offSetX = centerPoint.x - cell.center.x
            
            if offSetX < -15 || offSetX > 15 {
                cell.transformToStandard()
                self.centerPlanetCell = nil
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }
    
}


// MARK: - HudViewProtocol

extension DashboardViewController: HudViewProtocol { }
