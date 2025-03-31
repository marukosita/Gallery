//
//  PickerViewController.swift
//  Diplom_02
//
//

import UIKit

class PickerViewController: UIViewController {
    
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
    
    private let photoImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Cnst.PickerVC.photoImgViewName)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Cnst.mainCornerRadius
        view.isUserInteractionEnabled = true
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
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    var dateOfLoadPhoto: String = "00.00.00 00:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        addTapGesture()
        addTapGestureForPicker()
        registerKeyboardNotifications()
    }
    
    // MARK: - GestureRecognizer
    private func addTapGestureForPicker() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(openPhotoPicker))
        photoImgView.addGestureRecognizer(recognizer)
    }
    @objc func openPhotoPicker() {
        print("openPhotoPicker")
        self.showPickerAlert()
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        conteinerViewForTxtField.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
        conteinerViewForTxtField.endEditing(true)
    }
    
    // MARK: - СonfigureUI
    private func configureUI() {
        view.backgroundColor = Cnst.mainBackgroundColor
        
        view.addSubview(conteinerViewForTxtField)
        
        conteinerViewForTxtField.addSubview(backBtn)
        conteinerViewForTxtField.addSubview(dateOfLoadLabel)
        conteinerViewForTxtField.addSubview(containerForHeartBtn)
        containerForHeartBtn.addSubview(heartBtn)
        
        conteinerViewForTxtField.addSubview(photoImgView)
        conteinerViewForTxtField.addSubview(descriptionPhotoTextField)
        
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
            make.bottom.equalTo(conteinerViewForTxtField.safeAreaLayoutGuide.snp.bottom).offset(-(Cnst.SwipeVC.UI.swipeBtnHeight + Cnst.SwipeVC.UI.mediumHorizontalOffset))
        }
    }
    
    // MARK: - Date
    private func getDateOfLoadPhoto() {
        dateFormatter.dateFormat = Cnst.PickerVC.dateFormat
        let formattedDate = dateFormatter.string(from: currentDate)
        dateOfLoadPhoto = formattedDate
    }
    
    private func updateDateLabel() {
        dateOfLoadLabel.text = dateOfLoadPhoto
    }
    
    // MARK: - Поднятие клавиатуры
    // Настройка триггера поднятия и опускания клавиатуры
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
    // Настройка механизма подъёма экрана
    @objc private func keyboardChangeFrame(_ notification: Notification) {
        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        var offset: CGFloat = 0
        if notification.name == UIResponder.keyboardWillHideNotification {
            offset = 0
        } else if notification.name == UIResponder.keyboardWillShowNotification {
            offset = -frame.height
        }
        conteinerViewForTxtField.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(offset)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Photo picker
    private func showPickerToSelectUserPhoto(with source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            print("Source is not available")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    private func showPickerAlert() {
        let alert = UIAlertController(title: Cnst.PickerVC.Alert.showPickerAlertTitle, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: Cnst.PickerVC.Alert.showPickerAlertCameraActionText, style: .default) { _ in
            self.showPickerToSelectUserPhoto(with: .camera)
        }
        alert.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: Cnst.PickerVC.Alert.showPickerAlertPhotoLibraryActionText, style: .default) { _ in
            self.showPickerToSelectUserPhoto(with: .photoLibrary)
        }
        alert.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: Cnst.PickerVC.Alert.showPickerAlertCancelActionText, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: Логика сохранения фото
    private func saveNewPhoto(newPhoto: UIImage) {
        // сохранение в file manager и получние инфы для объекта UserPhoto
        guard let newPhotoName = StorageManager.shared.saveImage(newPhoto) else {
            return print("error saveNewPhotoInFileManager")
        }
        
        guard let dateOfLoad = dateOfLoadLabel.text else {
            return print("error dateOfLoad")
        }
        
        let newUserPhoto = UserPhotoInfo(
            photoname: newPhotoName,
            dateOfLoad: dateOfLoad,
            description: descriptionPhotoTextField.text,
            isFavorite: heartBtn.isSelected
        )
        
        UserPhotoManager.shared.addPhoto(newPhoto: newUserPhoto)
        print("сохранено в UserDef")
    }
    
    
    private func showAlertForSavePhoto() {
        let alert = UIAlertController(title: Cnst.PickerVC.Alert.savePhotoAlertTitle, message: nil, preferredStyle: .alert)
        
        let trueAction = UIAlertAction(title: Cnst.PickerVC.Alert.savePhotoTrueActionText, style: .default) { _ in
            self.isNewPhotoSaved(is: true)
        }
        alert.addAction(trueAction)
        
        let falseAction = UIAlertAction(title: Cnst.PickerVC.Alert.savePhotoFalseActionText, style: .default) { _ in
            self.isNewPhotoSaved(is: false)
        }
        alert.addAction(falseAction)
        
        let cancelAction = UIAlertAction(title: Cnst.PickerVC.Alert.savePhotoCancelActionText, style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func isNewPhotoSaved(is saved: Bool) {
        if saved {
            print("переход в свайпалку")
            guard let newPhoto = photoImgView.image else {
                return print("error isNewPhotoSaved")
            }
            saveNewPhoto(newPhoto: newPhoto)
            
            moveSwipeVC()
        } else {
            print("возврат в галерею")
            moveBack()
        }
    }
    
    // MARK: - Navigation
    private func moveSwipeVC() {
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            
            viewControllers.removeLast() // Удаляем текущий контроллер
            let newViewController = SwipeViewController()
            newViewController.currentIndex = UserPhotoManager.shared.images.count - 1
            viewControllers.append(newViewController) // Добавляем новый контроллер
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
    
    private func moveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - ButtonTapped
    private func backBtnTapped() {
        if photoImgView.image != UIImage(named: Cnst.PickerVC.photoImgViewName) {
            self.showAlertForSavePhoto()
        } else {
            self.moveBack()
        }
    }
    private func heartBtnTapped() {
        heartBtn.isSelected.toggle()
    }
    
}

// MARK: - Extensions

extension PickerViewController: UITextFieldDelegate {
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

extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // вызывается, когда пользователь завершает выбор изображения в UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var choosenImage = UIImage()
        
        func compressImage(image: UIImage, quality: CGFloat) -> Data? {
            let compressionQuality = min(max(quality, 0.0), 1.0)
            return image.jpegData(compressionQuality: compressionQuality)
        }
        
        // выбираем какое фото будет выбрано - оригинал или редактировали
        if let image = info[.editedImage] as? UIImage {
            choosenImage = image
        } else if let image = info[.originalImage] as? UIImage {
            choosenImage = image
        }
        
//        // сжимаем и сохраняем фото
//        if let imageData = compressImage(image: choosenImage, quality: 0.5) {
//            PickerManager.shared.gameSettings.userPhoto = imageData
//        }
        
        // обновляем фото
        photoImgView.image = choosenImage
        print(choosenImage)
        
        // получение даты загрузки и обновление label
        getDateOfLoadPhoto()
        updateDateLabel()
        
        // закрытие пикера
        picker.dismiss(animated: true)
        
    }
}
