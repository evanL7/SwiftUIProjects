//
//  ContentView.swift
//  WordScramble
//
//  This app has users spell words from a given word.
//  Score is reset after a new word is generated.
//
//  Created by Evan Law on 2024-01-12.

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = "" // word user spells from
    @State private var newWord = "" // user's entered word
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            Text("Score: \(score)")
                .font(.headline)

            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text("\(word)")
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar(content: {
                Button("New Word", action: startGame)
            })
        }
    }
    
    func addNewWord() {
        // lowercase and trim unnecessary spaces
        let result = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard result.count > 0 else { return }
        
        guard isOriginal(word: result) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: result) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: result) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isSame(word: result) else {
            wordError(title: "Same word", message: "Don't use the same word")
            return
        }
        
        guard isTwoCharOrLess(word: result) else {
            wordError(title: "Word too short", message: "Write a longer word!")
            return
        }
                
        withAnimation {
            usedWords.insert(result, at: 0)
        }
        newWord = "" // clear the field
        
        score += result.count + 1 // add to score: length of word plus adding a new word
    }
    
    func startGame() {
        // find the url
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // convert contents to a single string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // separate the single string into an array
                let allWords = startWords.components(separatedBy: .newlines)
                
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = [String]() // clear user's entered words
                score = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle") // didn't load start.txt
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        // matches letters of user input to word to see if word uses available letters
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isSame(word: String) -> Bool {
        !(word == rootWord)
    }
    
    func isTwoCharOrLess(word: String) -> Bool {
        !(word.count < 3)
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
