//
//  UIView+Utils.swift
//  InfoSpace
//
//  Created by Gonzalo MR on 25/5/22.
//

import UIKit

extension UIView {
    func setupNib() {
        let contentView = loadViewFromNib()!
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    fileprivate func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func generateAleatoriePositionInView() -> (CGFloat, CGFloat) {
        var xPosition = CGFloat.random(in: 0...self.frame.width / 2)
        var yPosition = CGFloat.random(in: 0...self.frame.height / 2)
        
        let xNegate = Int.random(in: 0...1)
        let yNegate = Int.random(in: 0...1)
        
        if xNegate == 0 {
            xPosition.negate()
        }
        
        if yNegate == 0 {
            yPosition.negate()
        }
        
        return (xPosition, yPosition)
    }
    
    func createStars(numberOfStarsRange: ClosedRange<Int>) {
        let numberOfStars = Int.random(in: numberOfStarsRange)
        
        for star in 0...numberOfStars {
            
            let (xPosition, yPosition) = self.generateAleatoriePositionInView()
            
            if star <= numberOfStars / 20 {
                let starView = BigStarView()
                starView.setup()
                self.insertSubview(starView, at: 0)
                
                starView.translatesAutoresizingMaskIntoConstraints = false
                starView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xPosition).isActive = true
                starView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yPosition).isActive = true
            } else if star <= numberOfStars / 10 {
                let starView = NormalStarView()
                starView.setup()
                self.insertSubview(starView, at: 0)
                
                starView.translatesAutoresizingMaskIntoConstraints = false
                starView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xPosition).isActive = true
                starView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yPosition).isActive = true
            } else if star <= numberOfStars / 6 {
                let starView = NormalWhiteStarView()
                starView.setup()
                self.insertSubview(starView, at: 0)
                
                starView.translatesAutoresizingMaskIntoConstraints = false
                starView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xPosition).isActive = true
                starView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yPosition).isActive = true
            } else {
                let starView = SmallStarView()
                starView.setup()
                self.insertSubview(starView, at: 0)
                
                starView.translatesAutoresizingMaskIntoConstraints = false
                starView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: xPosition).isActive = true
                starView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yPosition).isActive = true
            }
        }
    }
}
