//
//  FilterView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 24/10/22.
//

import UIKit

protocol FilterViewProtocol: AnyObject {
    func changeFilters(filters: SpaceLibraryFilters)
    func resetFilters()
}

enum FilterCellType {
    case header
    case separator
    case search
    case contentType
    case years
    case order
    case buttons
}

class FilterView: View {

    @IBOutlet weak var filtersTableView: UITableView!
    
    private var cellTypes: [FilterCellType] = [.header, .separator, .search, .separator, .contentType, .separator, .years, .separator, .order, .separator, .buttons]
    private var reset: Bool = false
    
    public var filters: SpaceLibraryFilters!
    
    weak var delegate: FilterViewProtocol?
    
    func configure() {
        setupNib()
        configureTable()
        filters = SpaceLibraryFilters()
    }
    
    // MARK: - Private methods
    
    private func configureTable() {
        filtersTableView.register(HeaderFilterCell.nib, forCellReuseIdentifier: HeaderFilterCell.identifier)
        filtersTableView.register(SeparatorCell.nib, forCellReuseIdentifier: SeparatorCell.identifier)
        filtersTableView.register(SearchFilterCell.nib, forCellReuseIdentifier: SearchFilterCell.identifier)
        filtersTableView.register(ContentTypeFilterCell.nib, forCellReuseIdentifier: ContentTypeFilterCell.identifier)
        filtersTableView.register(YearsFilterCell.nib, forCellReuseIdentifier: YearsFilterCell.identifier)
        filtersTableView.register(OrderFilterCell.nib, forCellReuseIdentifier: OrderFilterCell.identifier)
        filtersTableView.register(ButtonsFilterCell.nib, forCellReuseIdentifier: ButtonsFilterCell.identifier)
    }
}

// MARK: - UITableViewDataSource

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
            
            cell.delegate = self
            
            if reset {
                cell.reset()
            }

            return cell
        case .contentType:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContentTypeFilterCell.identifier) as! ContentTypeFilterCell
            
            cell.delegate = self
            
            if reset {
                cell.reset()
            }
            
            return cell
        case .years:
            let cell = tableView.dequeueReusableCell(withIdentifier: YearsFilterCell.identifier) as! YearsFilterCell
            
            cell.delegate = self
            
            if reset {
                cell.reset()
                reset = false
            }
            
            return cell
        case .order:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderFilterCell.identifier) as! OrderFilterCell
            
            cell.delegate = self
            
            return cell
        case .buttons:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonsFilterCell.identifier) as! ButtonsFilterCell
            
            cell.delegate = self
            
            return cell
        }
    }
}

// MARK: - SearchFilterCellProtocol

extension FilterView: SearchFilterCellProtocol {
    func searchTextChanged(text: String?) {
        filters.searchText = text
    }
}

// MARK: - ContentTypeFilterCellProtocol

extension FilterView: ContentTypeFilterCellProtocol {
    func changeSelectedTypes(mediaTypes: [MediaType]?) {
        filters.mediaTypes = mediaTypes
    }
}

// MARK: - YearsFilterCellProtocol

extension FilterView: YearsFilterCellProtocol {
    func changeYearsSelected(yearStart: String?, yearEnd: String?) {
        filters.yearStart = yearStart
        filters.yearEnd = yearEnd
    }
}

// MARK: - OrderFilterCellProtocol

extension FilterView: OrderFilterCellProtocol {
    func changeSelectedSegment(selectedOrder: Order) {
        filters.order = selectedOrder
    }
}

// MARK: - ButtonsFilterCellProtocol

extension FilterView: ButtonsFilterCellProtocol {
    func applyButtonPressed() {
        delegate?.changeFilters(filters: filters)
    }
    
    func resetButtonPressed() {
        reset = true
        filtersTableView.reloadData()
        filters = SpaceLibraryFilters()
        delegate?.resetFilters()
    }
}
