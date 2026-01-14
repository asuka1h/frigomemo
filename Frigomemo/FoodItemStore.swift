//
//  FoodItemStore.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FoodItemStore: ObservableObject {
    @Published var items: [FoodItem] = []
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        // Start listening when user is authenticated
        if userId != nil {
            startListening()
        }
    }
    
    func startListening() {
        guard let userId = userId else { return }
        
        // Stop existing listener if any
        listener?.remove()
        
        // Listen to real-time updates from Firestore
        listener = db.collection("users")
            .document(userId)
            .collection("foodItems")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching items: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.items = []
                    return
                }
                
                self.items = documents.compactMap { doc in
                    try? doc.data(as: FoodItem.self)
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
        items = []
    }
    
    func addItem(_ item: FoodItem) {
        guard let userId = userId else { return }
        
        do {
            let _ = try db.collection("users")
                .document(userId)
                .collection("foodItems")
                .document(item.id.uuidString)
                .setData(from: item)
        } catch {
            print("Error adding item: \(error.localizedDescription)")
        }
    }
    
    func deleteItem(_ item: FoodItem) {
        guard let userId = userId else { return }
        
        db.collection("users")
            .document(userId)
            .collection("foodItems")
            .document(item.id.uuidString)
            .delete { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                }
            }
    }
    
    func deleteItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { items[$0] }
        for item in itemsToDelete {
            deleteItem(item)
        }
    }
}
