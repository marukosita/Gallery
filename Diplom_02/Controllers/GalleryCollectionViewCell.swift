//
//  GalleryCollectionViewCell.swift
//  Diplom_02
//
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .red
        contentView.addSubview(photoImageView)
        
        
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with model: GalleryCollectionViewModel) {
        photoImageView.image = model.img
    }
}
