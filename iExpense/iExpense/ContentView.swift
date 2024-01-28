//
//  ContentView.swift
//  iExpense
//
//  This app keeps track of user's expenses.
//  The user can specify whether the expense is personal or business.
//  User can also filter between personal or business expenses.
//
//  Created by Evan Law on 2024-01-21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddView = false
    
    @State private var selectedFilter = 0
    
    var filteredExpenses: [ExpenseItem] {
        switch selectedFilter {
        case 0: // All
            return expenses.items
        case 1: // Personal
            return expenses.items.filter { $0.type == "Personal" }
        case 2: // Business
            return expenses.items.filter { $0.type == "Business" }
        default:
            return expenses.items
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(0)
                    Text("Personal").tag(1)
                    Text("Business").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                        .listRowBackground(
                            Group {
                                if item.amount <= 10.0 {
                                    Color.green
                                }
                                else if item.amount <= 100.0 {
                                    Color.yellow
                                }
                                else {
                                    Color.red
                                }
                            }
                        )
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add expense", systemImage: "plus") {
                        showingAddView = true
                    }
                    .sheet(isPresented: $showingAddView) {
                        AddView(expenses: expenses)
                    }
                }
            }
        }
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
        
}

#Preview {
    ContentView()
}
