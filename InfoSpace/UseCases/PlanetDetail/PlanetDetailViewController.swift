//
//  PlanetDetailViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/6/22.
//

import UIKit

class PlanetDetailViewController: UIViewController {

    private var viewModel: PlanetDetailViewModel!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageViewHeader: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var labelSatelites: UILabel!
    @IBOutlet private weak var viewDecorativeTag: UIView!
    @IBOutlet private weak var viewDrag: CIView!
    @IBOutlet private weak var viewDragHeight: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewImages: UICollectionView!
    
    private let kCollectionViewTopBottomInsets = 40
    private let kAnimationDuration: TimeInterval = 0.3
    private let kCollectionViewItemsPerRow: CGFloat = 3
    private let kCollectionViewCellInsets: CGFloat = 3
    
    private var isDragged: Bool = false

    private let analyticsScreen: AnalyticsScreen = .planetDetail

    static func initAndLoad(planet: Planet) -> PlanetDetailViewController {
        let planetDetailViewController = PlanetDetailViewController.initAndLoad()
        
        planetDetailViewController.viewModel = PlanetDetailViewModel(planet: planet)
        
        return planetDetailViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionImages()
        configure()
        createGestureRecognizers()
    }

    private func configureCollectionImages() {
        collectionViewImages.register(PlanetImageCell.nib, forCellWithReuseIdentifier: PlanetImageCell.identifier)
        viewDragHeight.constant = CGFloat(kCollectionViewTopBottomInsets + Int(collectionViewImages.frame.width / kCollectionViewItemsPerRow) * 1)
    }
    
    private func configure() {
        let planet = viewModel.getPlanet()
        imageViewHeader.setImage(with: planet.headerImageUrl)
        labelTitle.text = planet.title
        labelDescription.text = planet.description
        labelSatelites.text = String(planet.satellites ?? 0)
    }
    
    private func createGestureRecognizers() {
        let panGestureRecognizerViewDecorativeTag = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        
        viewDecorativeTag.addGestureRecognizer(panGestureRecognizerViewDecorativeTag)
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func changeCollectionViewScrollDirection(scrollDirection: UICollectionView.ScrollDirection) {
        if let layout = collectionViewImages.collectionViewLayout as? UICollectionViewFlowLayout {
            switch scrollDirection {
            case .vertical:
                collectionViewImages.isScrollEnabled = false
            case .horizontal:
                collectionViewImages.isScrollEnabled = true
            @unknown default:
                collectionViewImages.isScrollEnabled = true
            }
            
            layout.scrollDirection = scrollDirection
        }
    }
    
    @IBAction func buttonBackPressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }

    @objc func didPan(sender: UIPanGestureRecognizer) {
       let velocity = sender.velocity(in: view)
        
       if sender.state == .ended {
           if velocity.y > 0 {
               UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
                   guard let self else { return }

                   if isDragged {
                       AnalyticsManager.shared.send(name: AnalyticsConstantsEvents.kAnalyticsPlanetDetailDeexpandImages)

                       viewDragHeight.constant = CGFloat(kCollectionViewTopBottomInsets + Int(collectionViewImages.frame.width / kCollectionViewItemsPerRow) * 1)
                       changeCollectionViewScrollDirection(scrollDirection: .horizontal)
                   }
                   
                   isDragged = false
                   view.layoutIfNeeded()
               })
           } else {
               UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] in
                   guard let self else { return }

                   if !isDragged {
                       AnalyticsManager.shared.send(name: AnalyticsConstantsEvents.kAnalyticsPlanetDetailExpandImages)

                       viewDragHeight.constant = CGFloat(kCollectionViewTopBottomInsets + Int(collectionViewImages.frame.width / kCollectionViewItemsPerRow) * viewModel.getNumberOfSectionsOfGalleryImages())
                       changeCollectionViewScrollDirection(scrollDirection: .vertical)
                   }
                   
                   isDragged = true
                   view.layoutIfNeeded()
               })
           }
           
           scrollToBottom()
       }
    }
}

// MARK: - UICollectionViewDataSource

extension PlanetDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfGalleryImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanetImageCell.identifier, for: indexPath) as? PlanetImageCell else { return UICollectionViewCell() }

        let image = viewModel.getGalleryImage(position: indexPath.row)
        cell.configure(stringUrl: image.imageUrl)
        
        return cell
    }
}

extension PlanetDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let images = viewModel.getAllPlanetImages()

        AnalyticsManager.shared.send(event: analyticsScreen.imagesGalleryEnterAnalyticsEvent)

        let imagesGalleryViewController = ImagesGalleryViewController.initAndLoad(imagesUrl: images.0, highDefinitionUrlImages: images.2, titles: images.1, position: indexPath.row)
        CustomNavigationController.instance.present(to: imagesGalleryViewController, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension PlanetDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - kCollectionViewCellInsets) / kCollectionViewItemsPerRow, height: (collectionView.frame.width - kCollectionViewCellInsets) / kCollectionViewItemsPerRow)
    }
}
