//
//  UserPhotoManager.swift
//  Diplom_02
//
//

import Foundation
private extension String {
    static let userPhotosKey = "userPhotos"
}

final class UserPhotoManager {
    
    static let shared = UserPhotoManager()
    private init() {}
    
    var photosInfo: [UserPhotoInfo] = []
    var images: [GalleryCollectionViewModel] = []
    
    
    func addPhoto(newPhoto: UserPhotoInfo) {
        var photosInfo = self.photosInfo
        photosInfo.append(newPhoto)
        
        self.save(userPhotos: photosInfo)
        self.fetchPhotos()
    }

    func updatePhotoInfo(updatedPhotoInfo: UserPhotoInfo, index: Int) {
        var photosInfo = self.photosInfo
        photosInfo[index] = updatedPhotoInfo
        
        self.save(userPhotos: photosInfo)
        self.fetchPhotos()
    }
    
    func fetchPhotos() {
        guard let photosInfo = self.load() else {
            return print("failed to load user photos")
        }
        self.photosInfo = photosInfo
        self.getUserPhotoImages()
    }
    
    private func save(userPhotos: [UserPhotoInfo]) {
        UserDefaults.standard.set(encodable: userPhotos, forKey: .userPhotosKey)
    }
    
    private func load() -> [UserPhotoInfo]? {
        let userPhotos = UserDefaults.standard.value(Array<UserPhotoInfo>.self, forKey: .userPhotosKey)
        return userPhotos
    }
    
    private func getUserPhotoImages() {
        self.images = self.photosInfo.map { photo in
            return GalleryCollectionViewModel(img: StorageManager.shared.loadImage(fileName: photo.photoname)!)
        }
    }
}
