//
//  APODUrlCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODUrlCell: UITableViewCell {

    @IBOutlet weak var buttonOpenUrl: Button!
    
    private var url: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(url: URL) {
        self.url = url
    }
    
    @IBAction func buttonOpenUrlPressed(_ sender: Any) {
        CustomNavigationController.instance.openUrl(url)
    }
}
