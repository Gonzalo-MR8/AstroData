//
//  NoInternetView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/4/23.
//

import UIKit

class NoInternetView: View {

    func configure() {
        setupNib()
    }

    @IBAction func tryAgainPressed(_ sender: Any) {
        CustomNavigationController.instance.closeNoInternetView()
    }
}
