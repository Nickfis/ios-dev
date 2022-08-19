//
//  ContentView.swift
//  WeSplit2
//
//  Created by Niklas Fischer on 16/8/22.
//

import SwiftUI

struct ContentView: View {
    @State private var amount = 0
    @State private var selectedPeople = 4
    @State private var tipPercentage = 20
    @State private var tipOptions = [0, 5, 10, 15, 20, 25]
    @FocusState private var textIsFocused: Bool

    var totalPerPerson: Double {
        let overallPeople = Double(selectedPeople)
        let totalAmount = (1 + Double(tipPercentage) / 100) * Double(amount)
        let totalPerPerson = totalAmount / overallPeople
        return totalPerPerson
    }
    
    var totalCheque: Double {
        return (1 + Double(tipPercentage) / 100) * Double(amount)
    }
    
    @State private var selectedStudent = "Harry"
    @FocusState private var amountIsFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)

                    Picker("People eating", selection: $selectedPeople) {
                        ForEach(2..<100, id: \.self) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipOptions, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                Section {
                    Text(totalCheque, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total check including tip")
                }
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total per person")
                }
            }.navigationTitle("WeSplit")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            amountIsFocused = false
                        }
                    }
                }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
