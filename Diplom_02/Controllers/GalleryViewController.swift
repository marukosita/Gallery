//
//  GalleryViewController.swift
//  Diplom_02
//
//

import UIKit

class GalleryViewController: UIViewController {
    
    private let addNewPhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(Cnst.GalleryVC.Text.addNewPhotoBtn, for: .normal)
        btn.backgroundColor = Cnst.mainBtnColor
        btn.layer.cornerRadius = Cnst.mainCornerRadius
        return btn
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let info = UserPhotoManager.shared.load()
//        print(info?.count)
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainCollectionView.reloadData()
    }
    
    // MARK: - configureUI
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(addNewPhotoBtn)
        view.addSubview(mainCollectionView)
        
        addNewPhotoBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview().offset(Cnst.GalleryVC.UI.horizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.GalleryVC.UI.horizontalOffset)
            make.height.equalTo(Cnst.GalleryVC.UI.addNewPhotoBtnHeight)
        }
        let addNewPhotoBtnAction = UIAction { _ in
            self.addNewPhotoBtnTapped()
            Cnst.animateClickBtn(for: self.addNewPhotoBtn)
        }
        addNewPhotoBtn.addAction(addNewPhotoBtnAction, for: .touchUpInside)
        
        mainCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(addNewPhotoBtn.snp.top).offset(-Cnst.GalleryVC.UI.verticalOffset)
            make.left.right.top.equalToSuperview()
        }
    }
    // MARK: - ButtonTapped
    private func addNewPhotoBtnTapped() {
        movePickerScreen()
    }
    
    // MARK: - Navigation
    private func movePickerScreen() {
        let controller = PickerViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


// MARK: - extensions
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserPhotoManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        item.configure(with: UserPhotoManager.shared.images[indexPath.item])
        return item
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (Int(mainCollectionView.frame.size.width) - (10 * 3)) / 4
        return CGSize(width: side, height: side)
    }
    // обработка нажатия на фото и переход в SwipeVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = SwipeViewController()
        controller.currentIndex = indexPath.item
        navigationController?.pushViewController(controller, animated: true)
    }
}
