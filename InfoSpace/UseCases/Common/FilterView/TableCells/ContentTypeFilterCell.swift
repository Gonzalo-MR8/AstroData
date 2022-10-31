//
//  ContentTypeFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/10/22.
//

import UIKit

typealias ContentTypeItem = (MediaType, String)

class ContentTypeFilterCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kTypes: [ContentTypeItem] = [(.image,"IMAGENES"), (.video, "VIDEOS"), (.audio, "AUDIOS")]
    var selectedTypes: [MediaType] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContentTypeItemCell.nib, forCellWithReuseIdentifier: ContentTypeItemCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension ContentTypeFilterCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentTypeItemCell.identifier, for: indexPath) as! ContentTypeItemCell
        
        if selectedTypes.contains(where: { $0 == kTypes[indexPath.row].0 }) {
            cell.configure(text: kTypes[indexPath.row].1, isSelected: false)
        } else {
            cell.configure(text: kTypes[indexPath.row].1, isSelected: true)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ContentTypeFilterCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedTypes.contains(where: { $0 == kTypes[indexPath.row].0 }) {
            selectedTypes.removeAll { $0 == kTypes[indexPath.row].0 }
        } else {
            selectedTypes.append(kTypes[indexPath.row].0)
        }
    
        //selectedTypes?(selectedTypes)
        collectionView.reloadData()
    }
}
