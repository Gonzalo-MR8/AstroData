//
//  FilterView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 24/10/22.
//

import UIKit

enum FilterCellType {
    case header
    case separator
    case search
    case contentType
    case years
}
class FilterView: View {

    @IBOutlet weak var filtersTableView: UITableView!
    
    private var cellTypes: [FilterCellType] = [.header, .separator, .search, .separator, .contentType, .separator, .years, .separator]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func configure(with title: String) {
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupNib()
        configureTable()
    }
    
    private func configureTable() {
        filtersTableView.register(HeaderFilterCell.nib, forCellReuseIdentifier: HeaderFilterCell.identifier)
        filtersTableView.register(SeparatorCell.nib, forCellReuseIdentifier: SeparatorCell.identifier)
        filtersTableView.register(SearchFilterCell.nib, forCellReuseIdentifier: SearchFilterCell.identifier)
        filtersTableView.register(ContentTypeFilterCell.nib, forCellReuseIdentifier: ContentTypeFilterCell.identifier)
        filtersTableView.register(YearsFilterCell.nib, forCellReuseIdentifier: YearsFilterCell.identifier)
    }
}

extension FilterView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellTypes[indexPath.row]

        switch cellType {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderFilterCell.identifier) as! HeaderFilterCell
            
            return cell
        case .separator:
            let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorCell.identifier) as! SeparatorCell
            
            return cell
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchFilterCell.identifier) as! SearchFilterCell
            
            return cell
        case .contentType:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTypeFilterCell.identifier) as! ContentTypeFilterCell
            
            cell.configure()
            
            return cell
        case .years:
            let cell = tableView.dequeueReusableCell(withIdentifier: YearsFilterCell.identifier) as! YearsFilterCell
            
            cell.configure()
            
            return cell
        }
    }
}
