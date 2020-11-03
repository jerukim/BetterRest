//
//  ContentView.swift
//  BetterRest
//
//  Created by Jeru Kim on 11/2/20.
//  Copyright © 2020 Jeru Kim. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        let components = DateComponents(hour: 7, minute: 0)
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    @State private var wakeupTime = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    func calculateBedtime() -> String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeupTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        do {
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeupTime - prediction.actualSleep
            
            return formatter.string(from: sleepTime)
            
        } catch {
            let sleepTime = wakeupTime - sleepAmount
            
            return formatter.string(from: sleepTime)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeupTime,
                        displayedComponents: .hourAndMinute
                    )
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...14, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section {
                    Picker("How much coffee do you drink?", selection: $coffeeAmount) {
                        ForEach(1..<21) { num in
                            Text("\(num)")
                        }
                    }
                }
                
                Section {
                    HStack{
                        Text("Your ideal bedtime is...")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(calculateBedtime())
                            .font(.largeTitle)
                    }
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
