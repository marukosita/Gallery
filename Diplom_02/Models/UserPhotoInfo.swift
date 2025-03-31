//
//  UserPhoto.swift
//  Diplom_02
//
//

import Foundation

final class UserPhotoInfo: Codable {
    
    let photoname: String
    let dateOfLoad: String
    let description: String?
    let isFavorite: Bool
    
    init(photoname: String, dateOfLoad: String, description: String?, isFavorite: Bool) {
        self.photoname = photoname
        self.dateOfLoad = dateOfLoad
        self.description = description
        self.isFavorite = isFavorite
    }
}
