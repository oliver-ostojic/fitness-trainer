//
//  MuscleGroupSearchView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/10/24.
//

import SwiftUI

struct MuscleGroupSearchView: View {
    // Create private states to track
    @State private var muscleSearch: String = ""
    @State private var isSearching = false
    // Bound variables
    @Binding var selectedMuscles: [MuscleGroup]
    @Binding var isAddingMuscleGroup: Bool
    // Body code
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .font(.system(size: 16))
                        TextField("Type Muscle Name", text: $muscleSearch)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    // Cancel Button
                    Button(action: {
                        withAnimation {
                            isAddingMuscleGroup = false
                        }
                    }) {
                        Text("Cancel")
                    }
                }
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                // List of results of search bar
                // Filter and display suggestions based on search input
                List {
                    // ForEach('collection', 'id') { for item in, do something}
                    ForEach(MuscleGroup.allCases.filter {
                        muscleSearch.isEmpty ? true : $0.rawValue.lowercased().contains(muscleSearch.lowercased())
                    }, id: \.self) {muscle in
                        Text(muscle.rawValue)
                            .onTapGesture {
                                // Set the muscle and search text
                                selectedMuscles.append(muscle)
                                muscleSearch = muscle.rawValue
                                // Exit out of the search by clearing the search text
                                withAnimation {
                                    isAddingMuscleGroup = false
                                }
                                muscleSearch = ""
                            }
                    }
                    .listRowBackground(Color(UIColor.systemGray5))
                }
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 10)
        }
        .zIndex(3)
        
    }
}

struct MuscleGroupSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MuscleGroupSearchView(selectedMuscles: .constant([]), isAddingMuscleGroup: .constant(true))
    }
}
