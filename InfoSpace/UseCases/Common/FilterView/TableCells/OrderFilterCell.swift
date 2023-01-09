//
//  OrderFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 29/11/22.
//

import UIKit

protocol OrderFilterCellProtocol: AnyObject {
    func changeSelectedSegment(selectedOrder: Order)
}

class OrderFilterCell: UITableViewCell {
    
    @IBOutlet weak var segmentedControlOrder: UISegmentedControl!
    
    weak var delegate: OrderFilterCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentedControlOrder.setTitleTextAttributes([.foregroundColor: Colors.white.value], for: .normal)
        segmentedControlOrder.setTitleTextAttributes([.foregroundColor: Colors.secondaryColor.value], for: .selected)
        segmentedControlOrder.setTitle("FILTER_VIEW_HIGHEST".localized, forSegmentAt: 0)
        segmentedControlOrder.setTitle("FILTER_VIEW_LOWEST".localized, forSegmentAt: 1)
    }
    
    func reset() {
        segmentedControlOrder.selectedSegmentIndex = 0
    }
    
    @IBAction func changeSelectedSegment(_ sender: Any) {
        if segmentedControlOrder.selectedSegmentIndex == 0 {
            delegate?.changeSelectedSegment(selectedOrder: .highestToLowest)
        } else {
            delegate?.changeSelectedSegment(selectedOrder: .lowestToHighest)
        }
    }
}
