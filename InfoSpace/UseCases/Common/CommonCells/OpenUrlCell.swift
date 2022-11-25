//
//  OpenUrlCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class OpenUrlCell: UITableViewCell {

    @IBOutlet weak var buttonOpenUrl: Button!
    
    private var url: URL!
    
    func configure(url: URL, buttonText: String? = nil) {
        self.url = url
        
        if let buttonText = buttonText {
            buttonOpenUrl.setTitle(buttonText, for: .normal)
        }
    }
    
    @IBAction func buttonOpenUrlPressed(_ sender: Any) {
        CustomNavigationController.instance.openUrl(url, animated: true)
    }
    
}
