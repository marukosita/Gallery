
//  SwipeViewController.swift
//  Diplom_02
//


import UIKit

class SwipeViewController: UIViewController {
    
    var currentIndex = 0
    
    private enum Direction {
        case back
        case next
    }
    
    private let conteinerViewForTxtField: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle(Cnst.SwipeVC.Text.backBtnTitle, for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.layer.cornerRadius = Cnst.mainCornerRadius
        return btn
    }()
    
    private let dateOfLoadLabel: UILabel = {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.textColor = Cnst.mainTextColor
        return lbl
    }()
    
    private let containerForHeartBtn: UIView = {
        let view = UIView()
        return view
    }()
    private let heartBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("like", for: .normal)
        btn.titleLabel?.textColor = Cnst.mainTextColor
        btn.setImage(UIImage(named: Cnst.SwipeVC.Image.addToFavorites), for: .normal)
        btn.setImage(UIImage(named: Cnst.SwipeVC.Image.deleteFromFavorites), for: .selected)
        return btn
    }()
    
    private lazy var photoImgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Cnst.mainCornerRadius
        view.image = UserPhotoManager.shared.images[currentIndex].img
        return view
    }()
    
    private lazy var descriptionPhotoTextField: UITextField = {
        let txt = UITextField()
        txt.delegate = self // lazy var Delegate
        txt.clearButtonMode = .always
        txt.placeholder = Cnst.SwipeVC.Text.descriptionPhotoTextFieldPlaceholder
        txt.layer.cornerRadius = Cnst.mainCornerRadius
        txt.borderStyle = .roundedRect
        txt.textColor = Cnst.mainTextColor
        txt.textAlignment = .center
        return txt
    }()
    
    private let nextPhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("->", for: .normal)
        btn.titleLabel?.textColor = Cnst.mainTextColor
        btn.setImage(UIImage(named: Cnst.SwipeVC.Image.nextPhotoBtn), for: .normal)
        return btn
    }()
    
    private let previousPhotoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("<-", for: .normal)
        btn.titleLabel?.textColor = Cnst.mainTextColor
        btn.setImage(UIImage(named: Cnst.SwipeVC.Image.previousPhotoBtn), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTapGesture()
        registerKeyboardNotifications()
    }
    
// MARK: - GestureRecognizer
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        conteinerViewForTxtField.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
        conteinerViewForTxtField.endEditing(true)
    }
    
// MARK: - configureUI
    private func configureUI() {
        view.backgroundColor = Cnst.mainBackgroundColor
        
        view.addSubview(conteinerViewForTxtField)
        
        conteinerViewForTxtField.addSubview(backBtn)
        conteinerViewForTxtField.addSubview(dateOfLoadLabel)
        conteinerViewForTxtField.addSubview(containerForHeartBtn)
        containerForHeartBtn.addSubview(heartBtn)
        
        conteinerViewForTxtField.addSubview(photoImgView)
        conteinerViewForTxtField.addSubview(descriptionPhotoTextField)
        conteinerViewForTxtField.addSubview(nextPhotoBtn)
        conteinerViewForTxtField.addSubview(previousPhotoBtn)
        
        conteinerViewForTxtField.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(Cnst.SwipeVC.UI.smallVerticalOffset)
            make.right.equalTo(dateOfLoadLabel.snp.left).offset(-Cnst.SwipeVC.UI.smallVerticalOffset)
            make.height.equalTo(Cnst.SwipeVC.UI.mainHeight)
        }
        let backBtnAction = UIAction { _ in
            self.backBtnTapped()
            print("backBtnTapped")
        }
        backBtn.addAction(backBtnAction, for: .touchUpInside)
        
        dateOfLoadLabel.snp.makeConstraints { make in
            make.top.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(Cnst.SwipeVC.UI.mainHeight)
            make.width.equalTo(view.frame.width * Cnst.SwipeVC.UI.dateOfLoadLabelWidth)
        }
        
        containerForHeartBtn.snp.makeConstraints { make in
            make.top.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview().offset(-Cnst.SwipeVC.UI.smallVerticalOffset)
            make.left.equalTo(dateOfLoadLabel.snp.right).offset(Cnst.SwipeVC.UI.smallVerticalOffset)
            make.height.equalTo(Cnst.SwipeVC.UI.mainHeight)
        }
        heartBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.width.equalTo(containerForHeartBtn.snp.height)
            make.centerX.equalToSuperview()
        }
        let heartBtnAction = UIAction { _ in
            self.heartBtnTapped()
        }
        heartBtn.addAction(heartBtnAction, for: .touchUpInside)
        
        photoImgView.snp.makeConstraints { make in
            make.top.equalTo(dateOfLoadLabel.snp.bottom).offset(Cnst.SwipeVC.UI.mediumHorizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.SwipeVC.UI.smallVerticalOffset)
            make.left.equalToSuperview().offset(Cnst.SwipeVC.UI.smallVerticalOffset)
        }
        
        
        descriptionPhotoTextField.snp.makeConstraints { make in
            make.top.equalTo(photoImgView.snp.bottom).offset(Cnst.SwipeVC.UI.mediumHorizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.SwipeVC.UI.smallVerticalOffset)
            make.left.equalToSuperview().offset(Cnst.SwipeVC.UI.smallVerticalOffset)
            make.height.equalTo(Cnst.SwipeVC.UI.mainHeight)
        }
        previousPhotoBtn.snp.makeConstraints { make in
            make.top.equalTo(descriptionPhotoTextField.snp.bottom).offset(Cnst.SwipeVC.UI.mediumHorizontalOffset)
            make.left.equalToSuperview().offset(Cnst.SwipeVC.UI.bigVerticalOffset)
            make.bottom.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(Cnst.SwipeVC.UI.swipeBtnHeight)
            make.width.equalTo(previousPhotoBtn.snp.height)
        }
        let previousPhotoBtnAction = UIAction { _ in
            self.previousPhotoBtnTapped()
        }
        previousPhotoBtn.addAction(previousPhotoBtnAction, for: .touchUpInside)
        
        nextPhotoBtn.snp.makeConstraints { make in
            make.top.equalTo(descriptionPhotoTextField.snp.bottom).offset(Cnst.SwipeVC.UI.mediumHorizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.SwipeVC.UI.bigVerticalOffset)
            make.bottom.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(previousPhotoBtn.snp.height)
            make.width.equalTo(previousPhotoBtn.snp.width)
        }
        let nextPhotoBtnAction = UIAction { _ in
            self.nextPhotoBtnTapped()
        }
        nextPhotoBtn.addAction(nextPhotoBtnAction, for: .touchUpInside)

        configureImageInfo(index: currentIndex)
    }
    
    private func configureImageInfo(index: Int) {
        dateOfLoadLabel.text = UserPhotoManager.shared.photosInfo[index].dateOfLoad
        heartBtn.isSelected = UserPhotoManager.shared.photosInfo[index].isFavorite
        descriptionPhotoTextField.text = UserPhotoManager.shared.photosInfo[index].description
    }
    
// MARK: - Механизм подъёма экрана
    private func registerKeyboardNotifications() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardChangeFrame(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardChangeFrame(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
    @objc private func keyboardChangeFrame(_ notification: Notification) {
            guard let info = notification.userInfo,
                  let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                  let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
            
            var offset: CGFloat = 0
            if notification.name == UIResponder.keyboardWillHideNotification {
                offset = 0
                updateDescriptionPhotoInfo()
                nextPhotoBtn.isEnabled = true
                previousPhotoBtn.isEnabled = true
            } else if notification.name == UIResponder.keyboardWillShowNotification {
                offset = -frame.height
                nextPhotoBtn.isEnabled = false
                previousPhotoBtn.isEnabled = false
            }
            conteinerViewForTxtField.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(offset)
            }
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    
// MARK: - Механика свайпов
    private func swipePhotoBtnCounter(move: Direction) {
        
        switch move {
        case .next:
            currentIndex = (currentIndex + 1) % UserPhotoManager.shared.images.count
            print("next \(currentIndex)")
            showNextImage(direction: .next, index: currentIndex)
        case .back:
            currentIndex = (currentIndex - 1 + UserPhotoManager.shared.images.count) % UserPhotoManager.shared.images.count
            print("back \(currentIndex)")
            showNextImage(direction: .back, index: currentIndex)
        }
        configureImageInfo(index: currentIndex)
    }
    
    private func showNextImage(direction: Direction, index: Int) {
        let newImg = UserPhotoManager.shared.images[index]
        let newImgView = UIImageView(image: newImg.img)
        
        
        view.addSubview(newImgView)
        newImgView.frame = photoImgView.frame
        newImgView.contentMode = .scaleAspectFit
        newImgView.clipsToBounds = true
        newImgView.center = photoImgView.center
        newImgView.layer.cornerRadius = Cnst.mainCornerRadius
        
        switch direction {
        case .next:
            newImgView.center.x += view.frame.width
            UIView.animate(withDuration: 0.3) {
                newImgView.center.x -= self.view.frame.width
            } completion: { _ in
                self.photoImgView.image = newImg.img
                newImgView.removeFromSuperview()
            }
            
        case .back:
            newImgView.image = photoImgView.image
            UIView.animate(withDuration: 0.3) {
                self.photoImgView.image = newImg.img
                newImgView.center.x -= self.view.frame.width
            } completion: { _ in
                newImgView.removeFromSuperview()
            }
        }
    }
    
// MARK: - ButtonTapped
    private func backBtnTapped() {
        self.moveGalleryScreen()
    }
    
    private func heartBtnTapped() {
        heartBtn.isSelected.toggle()
        updateFavoritePhotoInfo()
    }

    private func previousPhotoBtnTapped() {
        self.swipePhotoBtnCounter(move: .back)
    }
    private func nextPhotoBtnTapped() {
        self.swipePhotoBtnCounter(move: .next)
    }
    
// MARK: - Сохранение изменений в информации о фото
    private func updateFavoritePhotoInfo() {
        let currentPhotoInfo = UserPhotoManager.shared.photosInfo[currentIndex]
        let updatedPhotoInfo = UserPhotoInfo(
            photoname: currentPhotoInfo.photoname,
            dateOfLoad: currentPhotoInfo.dateOfLoad,
            description: currentPhotoInfo.description,
            isFavorite: heartBtn.isSelected
        )
        UserPhotoManager.shared.updatePhotoInfo(updatedPhotoInfo: updatedPhotoInfo, index: currentIndex)
    }
    
    private func updateDescriptionPhotoInfo() {
        let currentPhotoInfo = UserPhotoManager.shared.photosInfo[currentIndex]
        let updatedPhotoInfo = UserPhotoInfo(
            photoname: currentPhotoInfo.photoname,
            dateOfLoad: currentPhotoInfo.dateOfLoad,
            description: descriptionPhotoTextField.text,
            isFavorite: currentPhotoInfo.isFavorite
        )
        UserPhotoManager.shared.updatePhotoInfo(updatedPhotoInfo: updatedPhotoInfo, index: currentIndex)
    }
    
// MARK: - Navigation
    private func moveGalleryScreen() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions
extension SwipeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= Cnst.SwipeVC.Text.textFieldMaxLength
    }
}


