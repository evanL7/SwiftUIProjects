//
//  ContentView.swift
//  BetterRest
//
//  This app uses CoreML to predict a user's ideal sleep time.
//  Requires the user to enter the time they want to wake up,
//  the amount of sleep the user wants, and the number of
//  cups of coffee they drank.
//
//  Created by Evan Law on 2024-01-09.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var idealBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
                        
        } catch { // In case above doesn't work
            return "Error"
        }

    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake") {
                    // or use ternary operator coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
//                    Stepper("^[\(coffeeAmount) cup](inflect:true)", value: $coffeeAmount, in: 1...20)
                    Picker("Number of cups", selection: $coffeeAmount, content: {
                        ForEach(1..<21) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    })
                }
                
                Section("Ideal bedtime") {
                    Text("\(idealBedtime)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
        }
//        .alert(alertTitle, isPresented: $showingAlert) {
//            Button("OK") {}
//        } message: {
//            Text(alertMessage)
//        }
        
    }
    
    func calculateBedtime () {
        
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
                        
        } catch { // In case above doesn't work
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error calculating your bedtime"
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}



//Form {
//    VStack(alignment: .leading, spacing: 0) {
//        Text("When do you want to wake up?")
//            .font(.headline)
//        
//        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//            .labelsHidden()
//    }
//    
//    VStack(alignment: .leading, spacing: 0) {
//        Text("Desired amount of sleep")
//            .font(.headline)
//        
//        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//    }
//    
//    VStack(alignment: .leading, spacing: 0) {
//        Text("Daily coffee intake")
//            .font(.headline)
//        
//        // or use ternary operator coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups"
//        Stepper("^[\(coffeeAmount) cup](inflect:true)", value: $coffeeAmount, in: 1...20)
//    }
//}
//.navigationTitle("BetterRest")
//.toolbar {
//    Button("Calculate", action: calculateBedtime)
//}
