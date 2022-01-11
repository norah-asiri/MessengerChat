//
//  StorageManager.swift
//  MessengerChat
//
//  Created by administrator on 09/01/2022.
//
//import FirebaseStorage
//final class StorageManager {
//
//    static let shared = StorageManager() // static property so we can get an instance of this storage manager
//
//    private let storage = Storage.storage().reference()
//
//    // function takes in bytes and add a filename where it should be written to
//    // once this has been uploaded, we want to hand back the download URL for the image
//    /*
//     /images/jmh3434-gmail-com_profile_picture.png - using this storage object
//     */
//
//    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void // type alias makes things cleaner
//
//    /// Uploads picture to firebase storage and returns completion with url string to download
//    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
//        // return a string of the download URL
//        // if we succeed, return a string, otherwise return error
//
//        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
//            guard error == nil else {
//                // failed
//                print("failed to upload data to firebase for picture")
//                completion(.failure(StorageErrors.failedToUpload))
//                return
//            }
//
//            self.storage.child("images/\(fileName)").downloadURL { url, error in
//                guard let url = url else {
//                    print("Failed to get download url")
//                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                    return
//                }
//
//                let urlString = url.absoluteString
//
//                print("download url returned: \(urlString)")
//
//                completion(.success(urlString))
//            }
//        }
//
//    }
//
//    public func downloadURL(for path: String,completion: @escaping (Result<URL, Error>) -> Void) {
//        let reference = storage.child(path)
//
//        // whole closure is escaping
//        // when you call the completion down below, it can escape the asynchronous execution block that firebase provides
//
//        reference.downloadURL { url, error in
//            guard let url = url, error == nil else {
//                completion(.failure(StorageErrors.failedToGetDownloadUrl))
//                return
//            }
//            completion(.success(url))
//        }
//    }
//
//    public enum StorageErrors: Error {
//        case failedToUpload
//        case failedToGetDownloadUrl
//    }
//}
//
import Foundation
import FirebaseStorage

/// Allows you to get, fetch, and upload files to firebase  storage
final class StorageManager {

    static let shared = StorageManager()

    private init() {}

    private let storage = Storage.storage().reference()

    /*
     /images/afraz9-gmail-com_profile_picture.png
     */

    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void

    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    /// Upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload video file to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }

    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
}

