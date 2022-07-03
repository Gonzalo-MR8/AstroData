//
//  HeaderView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 17/6/22.
//

import UIKit

protocol HeaderViewProtocol: AnyObject {
    func didPressBack()
    func didPressOptions()
}

class HeaderView: View {
    
    @IBOutlet weak var viewBackground: View!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewOptions: UIImageView!
    @IBOutlet weak var buttonOptions: UIButton!
    
    weak var delegate: HeaderViewProtocol?
    
    var percentShown: CGFloat = 0.0 {
        didSet {
            viewBackground.alpha = percentShown
            
            labelTitle.alpha = percentShown
        }
    }
    
    var title: String = "" {
        didSet {
            if title.count > 0 {
                labelTitle.text = title
                labelTitle.isHidden = false
            } else {
                labelTitle.text = title
                labelTitle.isHidden = true
            }
        }
    }
    
    var options: Bool = false {
        didSet {
            if options {
                imageViewOptions.isHidden   = false
                buttonOptions.isHidden      = false
            } else {
                imageViewOptions.isHidden   = true
                buttonOptions.isHidden      = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func configure(with title: String) {
        labelTitle.text = title
    }
    
    // MARK: - IBActions

    @IBAction func buttonBackPressed(_ sender: Any) {
        delegate?.didPressBack()
    }
    
    @IBAction func buttonOptionsPressed(_ sender: Any) {
        delegate?.didPressOptions()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupNib()
        
        backgroundColor = .clear
        
        //let window = UIApplication.shared.keyWindow
        //let topPadding = window?.safeAreaInsets.top ?? Values.kDefaultSafeAreaInsetsTop
        
        //constraintTop.constant = topPadding
        
        percentShown = 100.0
    }
    
}
