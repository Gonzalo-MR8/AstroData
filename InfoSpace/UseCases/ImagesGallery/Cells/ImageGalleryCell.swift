//
//  ImageGalleryCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/6/22.
//

import UIKit

class ImageGalleryCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    private var kNumberOfTaps = 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        setupGestureRecognizers()
    }

    func configure(imageUrl: String) {
        imageView.downloadImage(from: imageUrl)
    }
    
    private func setupGestureRecognizers() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = kNumberOfTaps
        addGestureRecognizer(gestureRecognizer)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func handleDoubleTap(gesture: UIGestureRecognizer) {
        if let doubleTapGesture = gesture as? UITapGestureRecognizer {
            if scrollView.zoomScale == 1 {
                scrollView.zoom(to: zoomRectForScale(scrollView.maximumZoomScale / 2, center: doubleTapGesture.location(in: doubleTapGesture.view)), animated: true)
            } else {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer,
              case .down = swipeGesture.direction else { return }
        
        CustomNavigationController.instance.dismissVC(animated: true)
    }
    
    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func resetScroll() {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
}

extension ImageGalleryCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
