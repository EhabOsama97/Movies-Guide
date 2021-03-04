//
//  AuthManager.swift
//  MovieApp
//
//  Created by Ehab Osama on 2/7/21.
//

import Foundation
import FirebaseAuth
public class AuthManager {
    
    static let shared = AuthManager()
    
    
    
    func signUp (email:String , password:String , completion : @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("sign up successfully")
                completion(true)
            }
            else {
                print("error in sign up")
                completion(false)
            }
        }
    }
    
    
    func login (email:String , password:String , completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("loged in succeffuly")
                completion(true)
            }
            else {
                print("error in log in")
                completion(false)
            }
        }
    }
    
    public func logOut( completion : @escaping (Bool)->Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print("Error on log out")
            completion(false)
        }
    }
    
    
    
}
