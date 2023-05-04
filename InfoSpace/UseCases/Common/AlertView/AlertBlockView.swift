//
//  AlertBlockView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 4/5/23.
//

import Foundation

enum AletBlockType {
    case internet
    case update
}

class AlertBlockView: View {

    private var blockType: AletBlockType = .internet

    func configure(blockType: AletBlockType) {
        setupNib()
        self.blockType = blockType
    }

    @IBAction func tryAgainPressed(_ sender: Any) {
        switch blockType {
        case .internet:
            if NetworkManager.shared.isConnected == true {
                CustomNavigationController.instance.closeAlertBlockView()
            }
        case .update:
            print("update")
        }
    }

}
