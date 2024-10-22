//
//  SingleSetRowView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/17/24.
//

import SwiftUI

struct SingleSetRowView: View {
    @Binding var inputReps: Int
    @Binding var inputWeight: Double
    let setNumber: Int
    // For holding parsed number when validating inputs
    @State private var number: Int? = nil
    @State private var showCheckmark: Bool = false
    // Body
    var body: some View {
        HStack {
            // Display setNumber
            HStack {
                Text("\(setNumber)")
                    .padding(.leading, 10)
                Spacer()
            }
            .frame(width: 100)
            // Display TextField for inputWeight
            HStack {
                // Binding() to update inputWeight value
                TextField("0.0", text: Binding(
                    get: { inputWeight == 0 ? "" : String(inputWeight) },
                    set: { newValue in
                        if let value = Double(newValue) {
                            inputWeight = value
                        }
                        else if newValue.isEmpty {
                            inputWeight = 0
                        }
                    }
                ))
                    .padding(.leading, 10)
                    .keyboardType(.decimalPad)
                Spacer()
            }
            .frame(width: 100)
            // Display TextField for inputReps
            HStack {
                // Binding() to update inputWeight value
                TextField("0", text: Binding(
                    get: { inputReps == 0 ? "" : String(inputReps) },
                    set: { newValue in
                        if let value = Int(newValue) {
                            inputReps = value
                        }
                        else if newValue.isEmpty {
                            inputReps = 0
                        }
                    }
                ))
                    .padding(.leading, 10)
                    .keyboardType(.numberPad)
                Spacer()
            }
            .frame(width: 50)
            Spacer()
            // Place a Checkmark if both Reps and Weight are entered
            if inputReps > 0 && inputWeight > 0 {
                Image(systemName: "checkmark")
                    .frame(width: 20)
                    .padding(.trailing, 10)
                    .foregroundColor(.green)
                    .scaleEffect(showCheckmark ? 1.0 : 0.5)
                    .animation(.interpolatingSpring(stiffness: 400, damping: 8), value: showCheckmark)
                    .onAppear {
                        showCheckmark = true
                    }
            }
        }
    }
}

#Preview {
    SingleSetRowView(inputReps: .constant(0), inputWeight: .constant(0.0), setNumber: 1)
}
