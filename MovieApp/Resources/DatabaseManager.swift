//
//  Database Manager.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import Foundation
import FirebaseDatabase

struct MovieAppUser {
    
    let username:String
    let email:String
    var profilePictureFileName:String {
        //"ehab-1-com_profile_picture.png"
        return "\(email.SafeDB())_profile_picture.png"
    }
    
}


class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database(url: "https://movieapp-baf81-default-rtdb.firebaseio.com/").reference()
    
    public func deleteFavouriteMovie(email:String,id:String, completion : @escaping (Bool)-> Void) {
        
        database.child("users").child(email.SafeDB()).child("favourites").observeSingleEvent(of: .value) { (favouriteSnapshot) in
            if var favouriteCollection = favouriteSnapshot.value as? [[String:Any]] {
                var index:Int?
                for i in (0..<favouriteCollection.count) {
                    if favouriteCollection[i]["id"] as! String == id {
                        index = i
                        break
                    }
                }
                if let x = index {
                    favouriteCollection.remove(at: x)
                    self.database.child("users").child(email.SafeDB()).child("favourites").setValue(favouriteCollection) { (error, _) in
                        if error == nil {
                            print("favourite movie deleted ")
                            completion(true)
                            return
                        } else {
                            print("error in deleter movie in database manager\(String(describing: error))")
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                print("favourite collection msh mwgoda fl delete favourite movie fl database manager")
            }
        }
        
    }
    
    public func downloadFavouriteMovies(email:String,completion : @escaping (Result<[Movie],Error>) -> Void) {
        database.child("users").child(email.SafeDB()).child("favourites").observeSingleEvent(of: .value) { (favouriteSnapshot) in
            if let favouriteCollection = favouriteSnapshot.value as? [[String:Any]] {
                print("favouriteCollection ... \(favouriteCollection)")
                var moviesArray = [Movie]()
                for movie in favouriteCollection {
                    moviesArray.append(Movie(Title: movie["title"] as! String, Year: movie["year"] as! String, imdbID: movie["id"] as! String, _Type: "movie", Poster: movie["poster"] as! String))
                }
                completion(.success(moviesArray))
                return
            }
            else {
                print("el favourite collection msh mwgod")
                
                completion(.failure(DatabaseError.failedToFetch))
            }
        }
    }
    
    public func saveFavouriteMovies(email:String ,movieModel:Movie,completion : @escaping (Bool)->Void) {
        database.child("users").child(email.SafeDB()).child("favourites").observeSingleEvent(of: .value) { (favouriteSnapshot) in
            if var favouriteCollection = favouriteSnapshot.value as? [[String:Any]] {
                let array = [ "title" : movieModel.Title , "year":movieModel.Year,"id" : movieModel.imdbID , "poster" :movieModel.Poster ]
                favouriteCollection.append(array)
                self.database.child("users").child(email.SafeDB()).child("favourites").setValue(favouriteCollection) { (error, _) in
                    if error == nil {
                        print("favourite Movie Saved")
                        completion(true)
                        return
                    } else {
                        print("error in save favourite movie 1 .. \(String(describing: error))")
                        completion(false)
                        return
                    }
                }
            } else {
                // make array
                let array = [ "title" : movieModel.Title , "year":movieModel.Year,"id" : movieModel.imdbID , "poster" :movieModel.Poster ]
                let favouriteColletion = [array]
                self.database.child("users").child(email.SafeDB()).child("favourites").setValue(favouriteColletion) { (error, _) in
                    if error == nil {
                        print("favourite Movie Saved")
                        completion(true)
                        return
                    } else {
                        print("error in save favourite movie 2 .. \(String(describing: error))")
                        completion(false)
                        return
                    }
                }
            }
           
            
        }
    }
    
    public func downloadCurrentUsername (email:String , completion : @escaping (Result<String,Error>) -> Void ) {
        database.child("users").child(email.SafeDB()).observeSingleEvent(of: .value) { (UsersSnapshot) in
            if let userCollection = UsersSnapshot.value as? [String : Any] {
                print("userCollection .... \(userCollection)")
                print(userCollection["username"]!)
                completion(.success(userCollection["username"] as! String))
                        return
                    }
                    else {
                        print("mfesh user collection")
                    }
                }
            }
    
    public func SaveUser(user:MovieAppUser) {
        database.child("users").child(user.email.SafeDB()).observeSingleEvent(of: .value) { (snapshot) in
            
            if var userCollection = snapshot.value as? [String:Any] {
                // append to user dictionary
                userCollection["username"] = user.username
//                userCollection.append(["email" : user.email.SafeDB(),
//                                       "username" : user.username
//
//                ])
                
                self.database.child("users").child(user.email.SafeDB()).setValue(userCollection) { (error, _) in
                    if error == nil {
                        print("user saved successufully")
                        return
                    } else {
                        print("error in saving user \(String(describing: error))")
                        return
                    }
                }
            }
            else {
                //make array
                let userCollection = [ "username":user.username]
                self.database.child("users").child(user.email.SafeDB()).setValue(userCollection) { (error, _) in
                    if error == nil {
                        print("user saved successufully")
                        return
                    } else {
                        print("error in make array to save user \(String(describing: error))")
                        return
                    }
                }
                
            }
        }
        
    }
}
extension String {
    func SafeDB () -> String{
        var s:String
        s = self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return s
    }
}
