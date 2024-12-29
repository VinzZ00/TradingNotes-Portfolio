//
//  FireStoreManager.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 16/09/24.
//

import Foundation
import FirebaseFirestore

class FireStoreManager : setupStorage {
    static public let shared : FireStoreManager = FireStoreManager()
    var db : Firestore?
    
    private init() {
        loadStorage()
    }
    
    func loadStorage() {
        db = Firestore.firestore()
    }
    
    func addData(collection : String, data : [String : Any], didSuccessAdd : @escaping () -> Void) {
        guard let db else {
            print("var db in FireStoreManager.swift is nil")
            return
        }
        db.collection(collection).addDocument(data: data) {
            if $0 != nil {
                print("Error when adding the document : \($0?.localizedDescription)")
            }
            
            didSuccessAdd()
        }
    }
    
    func removeData(collection : String, documentId : String, completion : @escaping (Error?) -> Void) {
        guard let db else {
            print("var db in FireStoreManager.swift is nil")
            return
        }
        
        db.collection(collection).document(documentId).delete {
            if $0 != nil {
                print("Error deleting the Document : \($0!.localizedDescription)")
            }
        }
    }
    
    func updateData(collection: String, documentId: String, data : [String : Any], completion: ( () -> Void)? = nil) {
        db?.collection(collection).document(documentId).updateData(data) {
            if $0 != nil {
                print("Error updating the Document : \($0!.localizedDescription)")
            } else {
                completion?()
            }
        }
    }
    
    func getSnapShotCollectionOf(collection : String, completion : @escaping ([QueryDocumentSnapshot]?) -> Void) {
        guard let db else {
            print("var db in FireStoreManager.swift is nil")
            return
        }
        
        db.collection(collection).getDocuments {
            if $1 != nil {
                print("Error getting the Document : \($1!.localizedDescription)")
                return
            }
            
            completion($0?.documents)
        }
    }
    
}
