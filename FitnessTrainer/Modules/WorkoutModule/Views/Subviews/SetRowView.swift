//
//  SetRowView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/17/24.
//

import SwiftUI

struct SetRowView: View {
    @Binding var sets: [WorkoutSet]
    
    var body: some View {
        VStack(spacing: 0) {
            // for a workoutsession, repeat 3 times. DEPENDS ON SETCOUNT ONLY
            // Create SingleSetRowView for each set
            ForEach(Array($sets.enumerated()), id: \.element.id) { index, $set in
                // Call SingleSetRow
                SingleSetRowView(inputReps: $set.reps, inputWeight: $set.weight, setNumber: index + 1)
                // Put divider between items as long as not last item
                if index < sets.count - 1 {
                    Divider()
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                }
            }
        }
        .padding(.bottom, 10)
    }
}

#Preview(body: {
    SetRowView(sets: .constant((0..<3).map { _ in WorkoutSet() }))
})
