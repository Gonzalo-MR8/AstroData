//
//  ImagesGalleryViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/6/22.
//

import UIKit

class ImagesGalleryViewController: UIViewController {
    
    private var viewModel: ImagesGalleryViewModel!
    
    @IBOutlet private weak var collectionViewGallery: UICollectionView!
    @IBOutlet private weak var viewTitle: View!
    @IBOutlet private weak var labelTitle: UILabel!
    
    private var position: Int!
    
    var isScrolled = false
    
    static func initAndLoad(imagesUrl: [String], highDefinitionUrlImages: [String], titles: [String]? = nil, position: Int) -> ImagesGalleryViewController {
        let imagesViewController = ImagesGalleryViewController.initAndLoad()
        
        imagesViewController.viewModel = ImagesGalleryViewModel(imagesUrl: imagesUrl, highDefinitionUrlImages: highDefinitionUrlImages, titles: titles)
        imagesViewController.position = position
        
        return imagesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewGallery.register(ImageGalleryCell.nib, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        configureTitle()
    }
    
    @IBAction func buttonClosePressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    @IBAction func buttonDownloadPressed(_ sender: Any) {
        AnalyticsManager.shared.send(name: AnalyticsConstantsEvents.kAnalyticsImagesGalleryDownloadPressed)

        CustomNavigationController.instance.presentAcceptOrCancelAlert(title: "IMAGES_GALLERY_DOWNLOAD".localized, message: "IMAGES_GALLERY_DOWNLOAD_QUESTION".localized, acceptCompletion: { [weak self] _ in
            guard let self else { return }

            AnalyticsManager.shared.send(name: AnalyticsConstantsEvents.kAnalyticsImagesGalleryDownloadAccept)

            //let imageSaver = ImageSaver()
            Utils.writeToPhotoAlbum(urlString: viewModel.getHighDefinitionUrlImage(position: position))
        }, cancelCompletion: { _ in
            AnalyticsManager.shared.send(name: AnalyticsConstantsEvents.kAnalyticsImagesGalleryDownloadCancel)
        })
    }
    
    private func configureTitle() {
        let collectionViewCenterPoint = view.convert(collectionViewGallery.center, to: collectionViewGallery)
        
        guard let centerIndexPath = collectionViewGallery.indexPathForItem(at: collectionViewCenterPoint) else { return }
        
        if let title = viewModel.getTitle(position: centerIndexPath.row) {
            viewTitle.isHidden = false
            labelTitle.text = title
        } else {
            viewTitle.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ImagesGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = viewModel.getImage(position: indexPath.row)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.identifier, for: indexPath) as? ImageGalleryCell else { return UICollectionViewCell() }

        cell.configure(imageUrl: imageUrl)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImagesGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isScrolled {
            let indexToScrollTo = IndexPath(item: position, section: indexPath.section)
            self.collectionViewGallery.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            isScrolled = true
            configureTitle()
        }
        
        guard let imageCell = cell as? ImageGalleryCell else { return }
        
        imageCell.resetScroll()
    }
}

// MARK: - UIScrollViewDelegate

extension ImagesGalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        configureTitle()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
