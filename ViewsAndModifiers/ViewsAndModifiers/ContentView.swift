//
//  ContentView.swift
//  ViewsAndModifiers
//
//  This app displays the technique to toggle multiple
//  switches at one time.
//
//  Created by Evan Law on 2024-01-06.
//

import SwiftUI

struct ContentView: View {
        
    @State private var agreedToTerms = false
    @State private var agreedToPrivacyPolicy = false
    @State private var agreedToEmails = false

    var body: some View {
        let agreedToAll = Binding<Bool>(
            get: {
                agreedToTerms && agreedToPrivacyPolicy && agreedToEmails
            },
            set: {
                agreedToTerms = $0
                agreedToPrivacyPolicy = $0
                agreedToEmails = $0
            }
        )
        return VStack {
            Toggle("Agree to terms", isOn: $agreedToTerms)
            Toggle("Agree to privacy policy", isOn: $agreedToPrivacyPolicy)
            Toggle("Agree to receive shipping emails", isOn: $agreedToEmails)
            Toggle("Agree to all", isOn: agreedToAll)
        }
    }
}


// To create a custom modifier, the struct must conform to ViewModifier
// and must have a body function that returns some View
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.bold())
            .foregroundColor(.blue)
    }
}


// Extension for Title struct to make calling the modifier easier
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}


#Preview {
    ContentView()
}
