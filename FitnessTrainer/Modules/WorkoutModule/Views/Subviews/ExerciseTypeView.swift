//
//  ExerciseTypeView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/20/24.
//

import SwiftUI

struct ExerciseTypeView: View {
    @Binding var showExerciseTypeView: Bool
    @Binding var exerciseType: ExerciseType?
    @Binding var sessionDataItem: SessionDataItem
    var body: some View {
        ScrollView {
            VStack {
                ForEach(ExerciseType.allCases, id: \.self) { type in
                    HStack {
                        Text(type.rawValue)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                            .padding(.top, 5)
                            .font(.system(size: 16))
                        Spacer()
                        if exerciseType == type {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                                .fontWeight(.semibold)
                                .padding(.trailing, 10)
                        }
                    }
                    
                    .onTapGesture {
                        sessionDataItem.exercise.exerciseType = type
                        exerciseType = type
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showExerciseTypeView = false
                        }
                    }
                }
            }
            .padding(.bottom, 15)
            .padding(.top, 10)
        }
        .frame(width: 150, height: 180)
        .background(Color.black)
        .cornerRadius(15)
    }
}
