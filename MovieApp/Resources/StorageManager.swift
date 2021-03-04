//
//  StorageManager.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import Foundation
import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    
    public func deleteProfilePicture (fileName:String , completion: @escaping (Bool) -> Void) {
        storage.child("images/\(fileName)").delete { error in
            if (error == nil) {
                completion(true)
                return
                
            }
            else {
                print("deleted error ...... \(String(describing: error))")
                completion(false)
                return
                
            }
        }
    }
    //return completion with url string to download
    public func uploadProfilePicture ( data : Data , fileName : String , completion : @escaping (Result<String,Error>) -> Void) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                //failed
                print("failed to upload data to storage")
                completion(.failure(error!))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(error!))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned : \(urlString)")
                completion(.success(urlString))
            }
            
        }
        
    }
    
    func downlaodURL (path:String , completion: @escaping (Result<URL,Error>)->Void) {
        storage.child(path).downloadURL { (url, error) in
            guard let url = url , error == nil else{
                completion(.failure(error!))
                return
            }
            completion(.success(url))
        }
    }
    
    
    
}
