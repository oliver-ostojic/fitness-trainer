//
//  WorkoutDataModel.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/10/24.
//

import Foundation
// The workout module is composed of three main enums:
enum MuscleGroup: String, CaseIterable, Codable {
    case bicep = "Bicep"
    case tricep = "Tricep"
    case chest = "Chest"
    case back = "Back"
    case abdominals = "Abs"
    case shoulder = "Shoulder"
    case glutes = "Glutes"
    case hamstrings = "Hamstrings"
    case quads = "Quads"
    case calf = "Calf"
    
}
enum ExerciseType: String, CaseIterable, Codable {
    case cableSingle = "Cable"
    case cableDouble = "Cables"
    case dumbellSingle = "Dumbell"
    case dumbellDouble = "Dumbbells"
    case bar = "Bar"
    case bodyWeight = "Body"
    case plateSingle = "Plate"
    case plateDouble = "Plates"
    case none = "None"
}
enum DayOfWeek: String, CaseIterable, Codable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
}
// The workout module is composed of three main structs:
struct Template: Identifiable, Codable {
    // Set important attributes
    let id: UUID
    var name: String
    var targetMuscleGroups: [MuscleGroup]
    var repeatDays: [DayOfWeek]
}
struct TemplateChecker {
    var templates: [Template]
    // Function to check if a specific day is assigned a template
    func is_day_assigned_to_template(_ dayChecking: DayOfWeek) -> Template? {
        for template in templates {
            for day in template.repeatDays {
                if day == dayChecking {
                    return template
                }
            }
        }
        return nil
    }
}
// Structs for a Workout Session
struct WorkoutSet: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var reps: Int
    // Allow for empty initialization
    init(id: UUID = UUID(), weight: Double = 0, reps: Int = 0) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
}
struct Exercise: Identifiable, Codable {
    let id: UUID
    let muscleGroup: MuscleGroup
    var exerciseType: ExerciseType
    // Initialize just with MuscleGroup awaiting exerciseType from user input
    init(muscleGroup: MuscleGroup) {
        self.muscleGroup = muscleGroup
        self.id = UUID()
        self.exerciseType = .none
    }
    init(muscleGroup: MuscleGroup, exerciseType: ExerciseType) {
        self.id = UUID()
        self.muscleGroup = muscleGroup
        self.exerciseType = exerciseType
    }
    // For comparisons
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
            return lhs.muscleGroup == rhs.muscleGroup && lhs.exerciseType == rhs.exerciseType
        }
    
}
struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    var sessionData: [SessionDataItem]
    var sessionTimeInterval = TimeInterval()
    var date = Date() 
    
    // Initialize a workout session skeleton
    init(setCount: Int, muscleGroups: [MuscleGroup]) {
        self.id = UUID()
        var sessionData: [SessionDataItem] = []

        for muscleGroup in muscleGroups {
            let exercise = Exercise(muscleGroup: muscleGroup)
            let sets = (0..<setCount).map { _ in WorkoutSet() }
            let item = SessionDataItem(exercise: exercise, sets: sets)
            sessionData.append(item)
        }
        self.sessionData = sessionData
        
    }
    init(sessionData: [SessionDataItem] = []) {
        self.sessionData = sessionData
        self.id = UUID()
    }
    
    // Function to remove unfilled sets (where set.reps == 0)
    mutating func delete_sets_with_no_reps() {
        for index in sessionData.indices {
            sessionData[index].sets.removeAll(where: { $0.reps == 0 })
        }
    }
}

struct SessionDataItem: Identifiable, Codable {
    let id: UUID
    var exercise: Exercise
    var sets: [WorkoutSet]
    
    init(id: UUID = UUID(), exercise: Exercise, sets: [WorkoutSet]) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
    }
    
}
