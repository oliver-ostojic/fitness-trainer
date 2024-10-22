//  TemplateExerciseView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/16/24.
//

import SwiftUI

// Create Anchor Preference Key for Type button
struct TypeButtonPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect? = nil
    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue() ?? value
    }
}

struct TemplateExerciseView: View {
    @Binding var sessionDataItem: SessionDataItem
    @State private var exerciseType: ExerciseType?
    @State private var showExerciseTypeView = false
    @State private var typeButtonFrame: CGRect = .zero
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                // Display Muscle Name
                ZStack {
                    HStack {
                        Text(sessionDataItem.exercise.muscleGroup.rawValue)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    // MuscleType Button
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showExerciseTypeView = true
                            }
                        }) {
                            if let type = exerciseType {
                                Text(type.rawValue)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.vertical, 5)
                            }
                            else {
                                Text("Type")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .padding(.vertical, 5)
                            }
                        }
                        .frame(width: 100)
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(key: TypeButtonPreferenceKey.self, value: proxy.frame(in: .named("container")))
                            }
                        )
                    }
                    Spacer()
                    
                }
                // Display Column Headers (Set, Lbs, Reps)
                VStack {
                    HStack {
                        HStack {
                            Text("Set")
                                .padding(.leading, 10)
                                .foregroundColor(Color(UIColor.systemGray))
                            Spacer()
                        }
                        .frame(width: 100)
                        HStack {
                            Text("lbs")
                                .padding(.leading, 10)
                                .foregroundColor(Color(UIColor.systemGray))
                            Spacer()
                            
                        }
                        .frame(width: 100)
                        HStack {
                            Text("Reps")
                                .padding(.leading, 10)
                                .foregroundColor(Color(UIColor.systemGray))
                            Spacer()
                        }
                        .frame(width: 100)
                        Spacer()
                    }
                    .padding(.top, 10)
                    // Call SetRowView
                    SetRowView(sets: $sessionDataItem.sets)
                }
                .frame(width: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
            .frame(width: .infinity)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 15)
            .zIndex(1)
            .overlay(
                Group {
                    if showExerciseTypeView {
                        ExerciseTypeView(showExerciseTypeView: $showExerciseTypeView, exerciseType: $exerciseType, sessionDataItem: $sessionDataItem)
                            .frame(width: 150)
                            .background(Color.black)
                            .cornerRadius(15)
                            .position(x: typeButtonFrame.maxX - 95, y: typeButtonFrame.maxY + 60)
                            .zIndex(1)
                            .padding(.trailing, 20)
                    }
                }
            )
        }
        .coordinateSpace(name: "container")
        .onPreferenceChange(TypeButtonPreferenceKey.self) { frame in
            if let frame = frame {
                typeButtonFrame = frame
            }
        }
    }
}
// For preview
struct TemplateExerciseView_Previews: View {
    @State private var sessionDataItem: SessionDataItem = SessionDataItem(exercise: Exercise(muscleGroup: .bicep), sets: (0..<3).map { _ in WorkoutSet() })
    var body: some View {
        TemplateExerciseView(sessionDataItem: $sessionDataItem)
    }
}
