//
//  ContentView.swift
//  GuessTheFlag
//
//  This app has the user tap the correct flag.
//  The app keeps track of scores and the game resets after 8 questions.
//
//  Created by Evan Law on 2023-12-24.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userChoice = ""
    @State private var score = 0
    
    @State private var userFlag = ""
    
    @State private var gameFinish = false
    @State private var questionNumber = 1
    
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop.init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                
                Text("Question: \(questionNumber)/8")
                    .foregroundStyle(.white)
                    .font(.headline.bold())
                
                Spacer()
                
                Text("Guess the flag")
                    .font(Font.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(Color.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(Color.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number) // flag was tapped
                        } label: {
                            FlagImage(countries: countries, number: number)
                                .rotation3DEffect(.degrees(countries[number] == userFlag ? animationAmount : 0),axis: (x: 0.0, y: 1.0, z: 0.0))
                                .opacity(countries[number] != userFlag ? opacityAmount : 1)
                                .scaleEffect(countries[number] != userFlag ? CGSize(width: scaleAmount, height: scaleAmount) : CGSize(width: 1.0, height: 1.0))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $gameFinish) {
            Button("Reset", action: reset)
        } message: {
            Text("Final score: \(score)")
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("\(userChoice)Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            animationAmount += 360
            opacityAmount -= 0.75
            scaleAmount -= 0.75
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userChoice = ""
            score += 1
        } else {
            scoreTitle = "Wrong!"
            userChoice = "You chose: \(countries[number])\n"
        }
        userFlag = countries[number]
        
        if questionNumber == 8 {
            gameFinish = true
        }
        else {
            showingScore = true // Turns on the alert
        }
    }
        
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNumber += 1
        userFlag = "" // Resets chosen flag to prevent double spins
        animationAmount = 0
        opacityAmount = 1.0
        scaleAmount = 1.0
    }
    
    func reset() {
        score = 0
        questionNumber = 0
        askQuestion()
    }
}

struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
