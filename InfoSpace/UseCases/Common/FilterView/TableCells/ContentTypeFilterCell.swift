//
//  ContentTypeFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/10/22.
//

import UIKit

protocol ContentTypeFilterCellProtocol: AnyObject {
    func changeSelectedTypes(mediaTypes: [MediaType]?)
}

typealias ContentTypeItem = (MediaType, String)

class ContentTypeFilterCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let kTypes: [ContentTypeItem] = [(.image, "FILTER_VIEW_IMAGES".localized), (.video, "FILTER_VIEW_VIDEOS".localized), (.audio, "FILTER_VIEW_AUDIOS".localized)]
    private var selectedTypes: [MediaType] = [.image, .video, .audio]
    
    weak var delegate: ContentTypeFilterCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContentTypeItemCell.nib, forCellWithReuseIdentifier: ContentTypeItemCell.identifier)
    }
    
    func reset() {
        selectedTypes = [.image, .video, .audio]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ContentTypeFilterCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentTypeItemCell.identifier, for: indexPath) as? ContentTypeItemCell else { return UICollectionViewCell() }
        
        if selectedTypes.contains(where: { $0 == kTypes[indexPath.row].0 }) {
            cell.configure(text: kTypes[indexPath.row].1, isSelected: true)
        } else {
            cell.configure(text: kTypes[indexPath.row].1, isSelected: false)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ContentTypeFilterCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedTypes.contains(where: { $0 == kTypes[indexPath.row].0 }) {
            if selectedTypes.count == 1 {
                CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "FILTER_VIEW_MINIMUN_CONTENT".localized)
            } else {
                selectedTypes.removeAll { $0 == kTypes[indexPath.row].0 }
            }
        } else {
            selectedTypes.append(kTypes[indexPath.row].0)
        }
    
        collectionView.reloadData()
            
        delegate?.changeSelectedTypes(mediaTypes: selectedTypes)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ContentTypeFilterCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
}
