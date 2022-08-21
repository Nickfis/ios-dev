//
//  ContentView.swift
//  WorldScramble
//
//  Created by Niklas Fischer on 20/8/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var avgWordLength: Double {
        usedWords.count > 0 ? Double(usedWords.map({$0.count}).reduce(0, +)) / Double(usedWords.count) : 0
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord).autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Text(word)
                        }
                    }
                }
                
                Section {
                    Text("Overall found words: \(usedWords.count)")
                    Text("Overall score: \(usedWords.map({$0.count}).reduce(0, +))")
                    Text("Average length of found words \(avgWordLength.formatted())")
                } header: {
                    Text("User score")
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart game") {
                    startGame()
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {return}
        
        guard isLongEnough(answer) else {
            wordError(title: "Word is not long enough", message: "Word has to have at least 4 chracters")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word is not possible", message: "Can't create your word from \(rootWord)")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word is not a real word", message: "You might have misspelled it")
            return
        }
        
        
        withAnimation {
            usedWords.insert(answer, at: 0)
            newWord = ""
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            // is the first position of this letter in our rootWord
            if let pos = tempWord.firstIndex(of: letter) {
                // remove the occurence of the letter
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

    func isLongEnough(_ word: String) -> Bool {
        return word.count > 3
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
