//
//  Cnst.swift
//  Diplom_02
//
//

import Foundation
import UIKit

final class Cnst {
    static let mainCornerRadius: CGFloat = 20
    static let mainTextColor: UIColor = .black
    static let mainBtnColor: UIColor = .lightGray
    static let mainBtnTappedColor: UIColor = .gray
    static let mainBackgroundColor: UIColor = .white
    
    static func animateClickBtn(for btn: UIButton) {
        UIView.animate(withDuration: 0.1) {
            btn.backgroundColor = Cnst.mainBtnTappedColor
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                btn.backgroundColor = Cnst.mainBtnColor
            }
        }
    }
    
    enum EntryVC {
        
        enum Text {
            static let textFieldMaxLength: Int = 10
            static let passwordTextFieldPlaceholder = "enter password"
            static let confirmPasswordTextFieldPlaceholder = "repeat the password"
            static let enterTextLabel = "Enter your password to login"
            static let enterBtnTitle = "ENTER"
        }
        enum Error {
            static let noPassword = "*enter password"
            static let wrongPassword = "*wrong password"
            static let confirmationPasswordNotEntered = "*enter the confirmation password"
            static let passwordsDontMatch = "*passwords don't match, repeat entry"
        }
        
        enum UI {
            static let mainHeight: CGFloat = 50
            static let enterBtnWidth: CGFloat = 150
            static let horizontalOffset: CGFloat = 20
            static let verticalOffset: CGFloat = 10
            
            static let errorTextColor: UIColor = .red
        }
        
    }
    
    enum GalleryVC {
        
        enum Text {
            static let addNewPhotoBtn = "ADD NEW PHOTO"
        }
        
        enum UI {
            static let addNewPhotoBtnHeight: CGFloat = 50
            static let horizontalOffset: CGFloat = 20
            static let verticalOffset: CGFloat = 10
        }
        
    }
    
    enum PickerVC {
        static let photoImgViewName = "addNewPhotoIcon"
        static let dateFormat = "dd.MM.yy HH:mm"
        
        enum Alert {
            static let savePhotoAlertTitle = "You want to save new photo?"
            static let savePhotoTrueActionText = "Yes"
            static let savePhotoFalseActionText = "No"
            static let savePhotoCancelActionText = "Cancel"
            
            static let showPickerAlertTitle = "Choose source to add user photo"
            static let showPickerAlertCameraActionText = "Camera"
            static let showPickerAlertPhotoLibraryActionText = "Photo library"
            static let showPickerAlertCancelActionText = "Cancel"
        }
    }
    
    enum SwipeVC {
        enum Color {
            static let backbtnTextColor: UIColor = .gray
            
        }
        enum Text {
            static let backBtnTitle: String = "< BACK"
            static let descriptionPhotoTextFieldPlaceholder = "enter description"
            static let textFieldMaxLength = 20
        }
        enum Image {
            static let addToFavorites = "heart"
            static let deleteFromFavorites = "heartFull"
            static let nextPhotoBtn = "nextPhoto"
            static let previousPhotoBtn = "previousPhoto"
        }
        
        enum UI {
            static let mainHeight: CGFloat = 50
            static let swipeBtnHeight: CGFloat = 60
            static let dateOfLoadLabelWidth: CGFloat = 0.5
            
            static let mediumHorizontalOffset: CGFloat = 20
            
            static let smallVerticalOffset: CGFloat = 10
            static let bigVerticalOffset: CGFloat = 45
        }
    }
}
