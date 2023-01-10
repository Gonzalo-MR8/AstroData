//
//  OpenUrlCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class OpenUrlCell: UITableViewCell {

    @IBOutlet private weak var buttonOpenUrl: Button!
    
    private var url: URL!
    
    func configure(url: URL) {
        self.url = url
    }
    
    @IBAction func buttonOpenUrlPressed(_ sender: Any) {
        CustomNavigationController.instance.openUrl(url, animated: true)
    }
    
}
