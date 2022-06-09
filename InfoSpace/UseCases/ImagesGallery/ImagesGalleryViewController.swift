//
//  ImagesGalleryViewController.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/6/22.
//

import UIKit

class ImagesGalleryViewController: UIViewController {

    private var viewModel: ImagesGalleryViewModel!
    
    @IBOutlet weak var collectionViewGallery: UICollectionView!
    @IBOutlet weak var viewTitle: View!
    @IBOutlet weak var labelTitle: UILabel!
    
    private var position: Int!
    
    var isScrolled = false
    
    static func initAndLoad(imagesUrl: [String], titles: [String]? = nil, position: Int) -> ImagesGalleryViewController {
        let imagesViewController = ImagesGalleryViewController.initAndLoad()
        
        imagesViewController.viewModel = ImagesGalleryViewModel(imagesUrl: imagesUrl, titles: titles)
        imagesViewController.position = position
        
        return imagesViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewGallery.register(ImageGalleryCell.nib, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
    }
    
    @IBAction func buttonClosePressed(_ sender: Any) {
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ImagesGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrl = viewModel.getImage(position: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.identifier, for: indexPath) as! ImageGalleryCell
        
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
        }
        
        if let title = viewModel.getTitle(position: indexPath.row) {
            viewTitle.isHidden = false
            labelTitle.text = title
        } else {
            viewTitle.isHidden = true
        }
        
        guard let imageCell = cell as? ImageGalleryCell else { return }
        
        imageCell.resetScroll()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
