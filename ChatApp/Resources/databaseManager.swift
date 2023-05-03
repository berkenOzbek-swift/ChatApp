//
//  databaseManager.swift
//  ChatApp
//
//  Created by Berken Özbek on 2.05.2023.
//

import Foundation
import FirebaseDatabase


final class databaseManager{
     
    static let share = databaseManager()
    private let database = Database.database().reference()
   
}
extension databaseManager{
    
    public func userExists(with email : String, completion : @escaping((Bool) -> Void)){
        
        database.child(email).observeSingleEvent(of: .value) { DataSnapshot in
            guard DataSnapshot.value as? String != nil 
            else{
                completion(false)
                return
            }
            completion(true)

        }
    }
    
    public func insertUser(with user : ShareAppUser){
        database.child(user.emailAdress).setValue(["emailAdress" : user.emailAdress])
    }
    
    struct ShareAppUser{
            
            let emailAdress : String
           // let profilePictureURL : String
        }
}



