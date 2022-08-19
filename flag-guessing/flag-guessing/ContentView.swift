//
//  ContentView.swift
//  flag-guessing
//
//  Created by Niklas Fischer on 19/8/22.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var score = 0
    @State private var correctAnswer = 0
    @State private var guessedFlags = 0
    @State private var lastAnswer = ""
    @State private var lastAnswerColor = Color(red: 1, green: 1, blue: 1)
    
// Text(content: lastAnswer != "" && "Last answer was \()")
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cyan, .black]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            VStack(spacing: 30) {
                HStack {
                    Text("Last answer: \(lastAnswer)").foregroundColor(lastAnswerColor)
                }
                VStack(spacing:30) {
                    Text("Correctly guessed flags: \(score)")
                    Text("Overall flags seen: \(guessedFlags)")
                }
                VStack {
                    Text("Guess the flag of")
                    Text(countries[correctAnswer])
                }
                
                VStack(spacing: 20) {
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number]).renderingMode(.original)
                        }
                    }
                }
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            lastAnswer = "correct"
            lastAnswerColor = Color.green
        } else {
            lastAnswer = "false"
            lastAnswerColor = Color.red
        }
        guessedFlags += 1
        countries.shuffle()
        correctAnswer = Int.random(in:0...2)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
