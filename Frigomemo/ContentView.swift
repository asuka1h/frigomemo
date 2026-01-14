//
//  ContentView.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: FoodItemStore
    @ObservedObject var authManager: AuthenticationManager
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                if store.items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "refrigerator")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No items yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Tap + to add your first item")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(store.items.sorted(by: { $0.expirationDate < $1.expirationDate })) { item in
                        FoodItemRow(item: item)
                    }
                    .onDelete(perform: store.deleteItems)
                }
            }
            .navigationTitle("Frigomemo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        do {
                            try authManager.signOut()
                            store.stopListening()
                        } catch {
                            print("Error signing out: \(error.localizedDescription)")
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.circle")
                            Text("Logout")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodItemView(store: store)
            }
        }
    }
}

struct FoodItemRow: View {
    let item: FoodItem
    
    var body: some View {
        HStack {
            Text(item.category.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatDate(item.expirationDate))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(item.expirationStatus.color)
                        .frame(width: 8, height: 8)
                    
                    Text(expirationText)
                        .font(.caption)
                        .foregroundColor(item.expirationStatus.color)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var expirationText: String {
        let days = item.daysUntilExpiration
        if days < 0 {
            return "Expired \(abs(days))d ago"
        } else if days == 0 {
            return "Expires today"
        } else if days == 1 {
            return "Expires tomorrow"
        } else {
            return "\(days) days left"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView(store: FoodItemStore(), authManager: AuthenticationManager())
}
