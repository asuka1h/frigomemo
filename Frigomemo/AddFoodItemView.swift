//
//  AddFoodItemView.swift
//  Frigomemo
//
//  Created by Yihan Wang on 11/8/23.
//

import SwiftUI

struct AddFoodItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: FoodItemStore
    
    @State private var name: String = ""
    @State private var selectedCategory: FoodCategory = .vegetable
    @State private var expirationDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Item Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(FoodCategory.allCases, id: \.self) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Expiration Date")) {
                    DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                Section {
                    Button(action: saveItem) {
                        HStack {
                            Spacer()
                            Text("Save")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add Food Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        let newItem = FoodItem(
            name: name,
            category: selectedCategory,
            expirationDate: expirationDate
        )
        store.addItem(newItem)
        dismiss()
    }
}

#Preview {
    AddFoodItemView(store: FoodItemStore())
}
