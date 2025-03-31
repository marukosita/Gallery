//
//  EntryViewController.swift
//  Diplom_02
//
//

import UIKit
import SnapKit
import SwiftyKeychainKit

class EntryViewController: UIViewController {
    
    private let keychain = Keychain(service: "com.yourapp.service")
    private let accessKey = KeychainKey<String>(key: "accessKey")
    
    private let enterTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = Cnst.EntryVC.Text.enterTextLabel
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.textColor = Cnst.mainTextColor
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let errorTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.textColor = Cnst.EntryVC.UI.errorTextColor
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self // lazy var SettingsViewController: UITextFieldDelegate
        textField.clearButtonMode = .always
        textField.placeholder = Cnst.EntryVC.Text.passwordTextFieldPlaceholder
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = Cnst.mainCornerRadius
        textField.textColor = Cnst.mainTextColor
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.clearButtonMode = .always
        textField.placeholder = Cnst.EntryVC.Text.confirmPasswordTextFieldPlaceholder
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = Cnst.mainCornerRadius
        textField.textColor = Cnst.mainTextColor
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let enterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(Cnst.EntryVC.Text.enterBtnTitle, for: .normal)
        btn.setTitleColor(Cnst.mainTextColor, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = Cnst.mainBtnColor
        btn.layer.cornerRadius = Cnst.mainCornerRadius
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //try? keychain.remove(accessKey)
        configureUI()
        addTapGesture()
    }
    // MARK: - GestureRecognizer
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - configureUI()
    private func configureUI() {
        checkIfPasswordExists()
        
        view.backgroundColor = Cnst.mainBackgroundColor
        
        view.addSubview(enterTextLabel)
        view.addSubview(errorTextLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(enterBtn)
        
        
        enterTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(errorTextLabel.snp.top)
            make.height.equalTo(Cnst.EntryVC.UI.mainHeight)
            make.left.equalToSuperview().offset(Cnst.EntryVC.UI.horizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.EntryVC.UI.horizontalOffset)
        }
        
        errorTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(passwordTextField.snp.top)
            make.height.equalTo(Cnst.EntryVC.UI.mainHeight / 3)
            make.left.equalToSuperview().offset(Cnst.EntryVC.UI.horizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.EntryVC.UI.horizontalOffset)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(confirmPasswordTextField.snp.top).offset(-Cnst.EntryVC.UI.verticalOffset)
            make.height.equalTo(Cnst.EntryVC.UI.mainHeight)
            make.left.equalToSuperview().offset(Cnst.EntryVC.UI.horizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.EntryVC.UI.horizontalOffset)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(enterBtn.snp.top).offset(-Cnst.EntryVC.UI.verticalOffset)
            make.height.equalTo(Cnst.EntryVC.UI.mainHeight)
            make.left.equalToSuperview().offset(Cnst.EntryVC.UI.horizontalOffset)
            make.right.equalToSuperview().offset(-Cnst.EntryVC.UI.horizontalOffset)
        }
        
        enterBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(Cnst.EntryVC.UI.mainHeight)
            make.width.equalTo(Cnst.EntryVC.UI.enterBtnWidth)
        }
        let enterBtnAction = UIAction { _ in
            self.enterBtnTapped()
            Cnst.animateClickBtn(for: self.enterBtn)
        }
        enterBtn.addAction(enterBtnAction, for: .touchUpInside)
    }
    
    private func checkIfPasswordExists() {
        if let _ = try? keychain.get(accessKey) {
            confirmPasswordTextField.isHidden = true
            confirmPasswordTextField.isEnabled = false
        } else {
            confirmPasswordTextField.isHidden = false
            confirmPasswordTextField.isEnabled = true
        }
    }
    
    // MARK: Password check
    private func enterBtnTapped() {
        guard let textFieldPassword = passwordTextField.text, !textFieldPassword.isEmpty else {
            return errorTextLabel.text = Cnst.EntryVC.Error.noPassword
        }
        
        if confirmPasswordTextField.isHidden {
            tryEnterPassword(textFieldPassword: textFieldPassword)
        } else {
            saveNewPassword(textFieldPassword: textFieldPassword)
        }
    }
    
    private func tryEnterPassword(textFieldPassword: String) {
        let savedPassword = try? keychain.get(accessKey)
        if savedPassword == textFieldPassword {
            moveGalleryScreen()
        } else {
            errorTextLabel.text = Cnst.EntryVC.Error.wrongPassword
        }
    }
    
    private func saveNewPassword(textFieldPassword: String) {
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            return errorTextLabel.text = Cnst.EntryVC.Error.confirmationPasswordNotEntered
        }
        if textFieldPassword == confirmPassword {
            try? keychain.set(textFieldPassword, for: accessKey)
            moveGalleryScreen()
        } else {
            errorTextLabel.text = Cnst.EntryVC.Error.passwordsDontMatch
        }
    }
    
    // MARK: - Save data
    private func loadPhotoInfo() {
        UserPhotoManager.shared.fetchPhotos()
    }
    
    // MARK: - Navigation
    private func moveGalleryScreen() {
        let controller = GalleryViewController()
        loadPhotoInfo()
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - extension
extension EntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // ограничение на количество символов
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        // Определение диапазона, который нужно заменить
        guard let stringRange = Range(range, in: currentText) else { return false }
        // Обновленный текст после замены
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= Cnst.EntryVC.Text.textFieldMaxLength
    }
}


