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
    
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var imageViewOptions: UIImageView!
    @IBOutlet private weak var buttonOptions: UIButton!
    
    weak var delegate: HeaderViewProtocol?
    
    var percentShown: CGFloat = 0.0 {
        didSet {
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
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self else { return }

            imageViewOptions.transform = imageViewOptions.transform.rotated(by: .pi)
        })
        delegate?.didPressOptions()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupNib()
        
        backgroundColor = .clear
        
        percentShown = 100.0
    }
    
    // MARK: - Public methods
    
    public func configure(title: String, options: Bool) {
        labelTitle.text = title
        self.options = options
    }
}
