//
//  ContentView.swift
//  BetterRest
//
//  Created by Niklas Fischer on 20/8/22.
//


// get from user: desired wakeup time
// desired amount of sleep in hours
// coffe cups drunk today
// -> inputs done

// connect to ML Core and display alert with wake up time!

// add button that calculates sleep time on click


import SwiftUI
import CoreML

struct drawText: ViewModifier {
    let font = Font.system(size: 16, weight: .regular, design: .default)
    
    func body(content: Content) -> some View {
        content
        .font(font)
    }
}

struct DrawHorizontalText: View {
    var text: String
    var textResult: String
    var body: some View {
        HStack {
            Text(text).modifier(drawText())
            
            Text(textResult).modifier(drawText())
        }
    }
}

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var desiredHours = 8.0
    @State private var cupsOfCoffee = 1
    @State private var wakeupTime = defaultWakeTime
    var recommendedSleepTime: String {
        calculateBedTime()
    }
    
    var body: some View {
        NavigationView  {
            Form {
                Section {
                    Text("When do you want to get up?").font(.headline)
                    DatePicker("Please enter time for getting up", selection: $wakeupTime, displayedComponents: .hourAndMinute).labelsHidden()
                }
                
                Section {
                    Text("How much sleep do you want to get?")
                    Stepper("\(desiredHours.formatted()) hours of sleep", value: $desiredHours, in: 4...12, step: 0.25)
                }
                
                Section {
                    Text("Coffee intake")
                    Stepper(cupsOfCoffee == 1 ? "1 cup" : "\(cupsOfCoffee) cups", value: $cupsOfCoffee, in: 1...12)
                }
                DrawHorizontalText(text: "Your ideal bedtime is:", textResult: "\(recommendedSleepTime)")
            }
        .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeupTime)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: desiredHours, coffee: Double(cupsOfCoffee))
            
            let bedTime = wakeupTime - prediction.actualSleep
            
            return bedTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Problem calculating bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
