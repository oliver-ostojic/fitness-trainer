//
//  CreateTemplateView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/10/24.
//

import SwiftUI

struct CreateTemplateView: View {
    @EnvironmentObject var userData: UserData
    @Binding var showTemplateView: Bool
    
    @State private var template: Template?
    @State private var inputTitle: String = ""
    @State private var selectedMuscles: [MuscleGroup] = []
    @State private var selectedDays: [DayOfWeek] = []
    
    @State private var isChoosingDays = false
    @State private var isAddingMuscleGroup = false
    
    // Body
    var body: some View {
        // GeometryReader is used to get device width and height
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            showTemplateView = false
                        }
                    }) {
                        Text("Cancel")
                            .padding(.top, 20)
                    }
                    // Add padding on left of button
                    .padding(.leading, 20)
                    Spacer()
                    // Create button
                    Button (action: {
                        withAnimation {
                            showTemplateView = false
                            let template = Template(id: UUID(), name: inputTitle, targetMuscleGroups: selectedMuscles, repeatDays: selectedDays)
                            userData.userTemplates.append(template)
                            _ = userData.saveData()
                        }
                    }) {
                        Text("Save")
                            .padding(.top, 20)
                    }
                    .padding(.trailing, 20)
                }
                // Editable Template name
                HStack{
                    TextField("Template Name", text: $inputTitle)
                        .multilineTextAlignment(.center)
                }
                // Buttons List
                VStack {
                    // Search button
                    Button (action: {
                        withAnimation {
                            isAddingMuscleGroup = true
                        }
                    }) {
                        HStack {
                            Text("Add Exercise Type")
                                .padding(.top, 10)
                                .padding(.leading, 20)
                                .font(.system(size: 16))
                            Spacer()
                        }
                    }
                    // Add divider
                    Divider()
                        .padding(.leading, 20)
                        .padding(.bottom, 4)
                    // Day Selection button
                    Button (action: {
                        withAnimation {
                            isChoosingDays = true
                        }
                    }) {
                        HStack {
                            Text("Repeat")
                                .padding(.bottom, 10)
                                .padding(.leading, 20)
                                .font(.system(size: 16))
                            Spacer()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                // List of selected muscles
                if !selectedMuscles.isEmpty {
                    // Create VStack of all selected muscles
                    List {
                        // List item
                        ForEach(selectedMuscles, id: \.self) { muscle in
                            HStack {
                                Text(muscle.rawValue)
                                // Push button to right
                                Spacer()
                                // Add Button to remove item
                                Button(action: {
                                    let muscleToRemove = muscle
                                    removeMuscle(muscleToRemove)
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                        .font(.system(size: 16))
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                // Push items up
                Spacer()
            }
            // Set VStack modifiers
            .frame(width: isAddingMuscleGroup || isChoosingDays ? geometry.size.width * 0.91 : geometry.size.width)
            .background(isAddingMuscleGroup || isChoosingDays ? Color(UIColor.systemGray4) : Color(UIColor.systemGray6))
            .cornerRadius(10)
            .offset(CGSize(width: 0, height: isAddingMuscleGroup || isChoosingDays ? 0: 10))
            .edgesIgnoringSafeArea(.all)
            .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            .padding(.top, 1)
            // Launch SearchView
            if isAddingMuscleGroup {
                MuscleGroupSearchView(selectedMuscles: $selectedMuscles, isAddingMuscleGroup: $isAddingMuscleGroup)
                    .transition(.move(edge: .bottom))
            }
            // Launch DaySelectionView
            if isChoosingDays {
                DaySelectionView(selectedDays: $selectedDays, isChoosingDay: $isChoosingDays)
                    .transition(.move(edge: .bottom))
            }
        }
        .zIndex(2)
    }
    // Function to remove the selected muscle from the list
       private func removeMuscle(_ muscle: MuscleGroup) {
           if let index = selectedMuscles.firstIndex(of: muscle) {
               selectedMuscles.remove(at: index)
           }
       }
}

struct CreateTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUserData = UserData()
        CreateTemplateView(showTemplateView: .constant(true))
            .environmentObject(sampleUserData)
    }
}
