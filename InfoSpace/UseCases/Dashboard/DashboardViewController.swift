//
//  DashboardViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

class DashboardViewController: UIViewController {

    private var viewModel: DashboardViewModel!
    
    private let kNumberOfStars: ClosedRange = 180...200
    private let kSateliteAngle: CGFloat = 2.5
    private let kSmallElipseSize: CGSize = CGSize(width: 240, height: 240)
    private let kMidElipseSize: CGSize = CGSize(width: 410, height: 410)
    private let kBigElipseSize: CGSize = CGSize(width: 590, height: 590)
    private let kLayoutMargin: CGFloat = 10
    // Margin used to leave a gap when resizing the cell
    private let kCollectionViewPlanetsHeightMargin: CGFloat = 35
    
    @IBOutlet private weak var containerView: CIView!
    @IBOutlet private weak var imageViewSatelite: UIImageView!
    @IBOutlet private weak var imageViewComet: UIImageView!
    @IBOutlet private weak var imageViewMoon: UIImageView!
    @IBOutlet private weak var collectionViewDashboard: UICollectionView!
    @IBOutlet private weak var collectionViewPlanets: UICollectionView!
    
    private var centerPlanetCell: PlanetCell?

    private let analyticsScreen: AnalyticsScreen = .dashboard

    static func initAndLoad(dashboardData: DashboardData) -> DashboardViewController {
        let dashboardViewController = DashboardViewController.initAndLoad()
        
        dashboardViewController.viewModel = DashboardViewModel(dashboardData: dashboardData)
        
        return dashboardViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionViewPlanets()
        configureCollectionViewDashboard()
        createBackgroundElements()
        
        DispatchQueue.main.async {
            self.collectionViewPlanets.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - Private methods
    
    private func createBackgroundElements() {
        containerView.createStars(numberOfStarsRange: kNumberOfStars)
        
        imageViewSatelite.transform = CGAffineTransform(rotationAngle: CGFloat(kSateliteAngle))
        
        imageViewSatelite.createElipseToImage(containerView: containerView, size: kSmallElipseSize, borderColor: Colors.white20.value.cgColor)
        imageViewSatelite.createElipseToImage(containerView: containerView, size: kMidElipseSize, borderColor: Colors.white15.value.cgColor)
        imageViewSatelite.createElipseToImage(containerView: containerView, size: kBigElipseSize, borderColor: Colors.white10.value.cgColor)
    }
    
    private func configureCollectionViewPlanets() {
        collectionViewPlanets.showsHorizontalScrollIndicator = false
        collectionViewPlanets.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let layoutMargins: CGFloat = collectionViewPlanets.layoutMargins.left + collectionViewPlanets.layoutMargins.right
        let sideInset = (collectionViewPlanets.frame.width / 2) - (layoutMargins + kLayoutMargin)
        collectionViewPlanets.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: kLayoutMargin, right: sideInset)
        
        collectionViewPlanets.register(PlanetCell.nib, forCellWithReuseIdentifier: PlanetCell.identifier)
    }
    
    private func snapToCenter() {
        // This is used like this because on small devices when scrolling is enabled the center of the collectionView doesn't work to center the cell and vice versa
        let containerCenterPoint = view.convert(containerView.center, to: collectionViewPlanets)
        let collectionViewCenterPoint = view.convert(collectionViewPlanets.center, to: collectionViewPlanets)
        
        if let centerIndexPath = collectionViewPlanets.indexPathForItem(at: containerCenterPoint) {
            collectionViewPlanets.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        } else if let centerIndexPath = collectionViewPlanets.indexPathForItem(at: collectionViewCenterPoint) {
            collectionViewPlanets.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func configureCollectionViewDashboard() {
        collectionViewDashboard.register(DashboardItemCell.nib, forCellWithReuseIdentifier: DashboardItemCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPlanets {
            return viewModel.numberOfPlanets()
        } else {
            return viewModel.numberOfDashboardItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewPlanets {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanetCell.identifier, for: indexPath) as? PlanetCell else { return UICollectionViewCell() }

            let planet = viewModel.getPlanet(position: indexPath.row)
            cell.configure(planet: planet)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardItemCell.identifier, for: indexPath) as? DashboardItemCell else { return UICollectionViewCell() }

            let dashboardItem = viewModel.getDashboardItem(position: indexPath.row)
            cell.configure(dashboardItem: dashboardItem)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // CollectionViewPlanets
        guard collectionView == collectionViewDashboard else {
            AnalyticsManager.shared.send(event: analyticsScreen.planetDetailEnterAnalyticsEvent)

            collectionViewPlanets.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            let detailVC = PlanetDetailViewController.initAndLoad(planet: viewModel.getPlanet(position: indexPath.row))
            CustomNavigationController.instance.navigate(to: detailVC, animated: true)
            return
        }
        
        // CollectionViewDashboard
        switch indexPath.row {
        case 0:
            // Astronomy picture of the day
            AnalyticsManager.shared.send(event: analyticsScreen.apodEnterAnalyticsEvent)

            let apodVC = APODViewController.initAndLoad(apod: viewModel.getApod())
            CustomNavigationController.instance.navigate(to: apodVC, animated: true)
        default:
            // Space library
            AnalyticsManager.shared.send(event: analyticsScreen.spaceLibraryEnterAnalyticsEvent)

            let spaceLibraryVC = SpaceLibraryViewController.initAndLoad(spaceLibraryData: viewModel.getSpaceLibraryData())
            CustomNavigationController.instance.navigate(to: spaceLibraryVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewPlanets {
            return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height - kCollectionViewPlanetsHeightMargin)
        } else {
            return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.height)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension DashboardViewController: UIScrollViewDelegate {
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
        guard scrollView is UICollectionView else { return }
        
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView is UICollectionView else { return }
        
        if !decelerate {
            snapToCenter()
        }
    }
}
