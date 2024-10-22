//
//  UserData.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/20/24.
//

import Foundation
// Define class for UserData (Consists of a userId, [Session], and [Template]
class UserData: ObservableObject {
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var userTemplates: [Template] = []
    @Published var statisticData = StatisticData()
    
    // Function to save user data
    func saveData() -> Bool {
        return true
    }
    // Function to check if today has a workout template
    func query_if_workout_today(day: DayOfWeek) -> Template? {
        for template in userTemplates {
            for aDay in template.repeatDays {
                if aDay == day {
                    return template
                }
            }
        }
        return nil
    }
}
