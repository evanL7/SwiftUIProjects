//
//  ContentView.swift
//  WeSplit
//
//  Created by Evan Law on 2023-12-21.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2 // Index value
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalAmountPerPerson: Double {
        // Calcuates how much each individual should pay after tip
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipAmount = checkAmount * (tipSelection / 100)
        let grandTotal = checkAmount + tipAmount
        
        return grandTotal / peopleCount;
    }
    
    var totalAmount: Double {
        totalAmountPerPerson * Double(numberOfPeople + 2)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused) // Sets amountIsFocused to true
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
//                Previous version
//                Section("How much would you like to tip?") {
//                    Picker("Tip percentage", selection: $tipPercentage) {
//                        ForEach(0..<101) {
//                            Text($0, format: .percent)
//                        }
//                    }
//                }
//                .pickerStyle(.navigationLink)
                
                Section("How much would you like to tip?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                 
                Section("Amount after tip and before split") {
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }
                
                Section("Amount per person") {
                    Text(totalAmountPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
