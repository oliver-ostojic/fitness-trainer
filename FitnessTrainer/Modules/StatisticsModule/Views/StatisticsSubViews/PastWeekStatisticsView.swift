//
//  PastWeekStatisticsView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/27/24.
//

import SwiftUI
import Charts

struct PastWeekStatisticsView: View {
    // Pass in graph data for viewing
    let weeklyStat: WeeklyStatistic
    var body: some View {
        VStack {
            // Need to use ForEach in SwiftUI View
            ForEach(weeklyStat.muscleWeeklyStatistics) { item in
                Text("Muscle: \(item.muscleGroup.rawValue), TotalReps: \(item.totalReps), AvgReps: \(item.avgReps), TotalWeight: \(item.totalWeight.clean), AvgWeight: \(item.avgWeight.clean)")
                    .padding(.bottom, 10)
            }
        }
    }
}
// For formatting
extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
// For preview
struct PastWeekStatistics_Preview: PreviewProvider {
    
    static var testDataItems: [SessionDataItem] {
        var items: [SessionDataItem] = []
        
        let testDataItem1 = SessionDataItem(exercise: Exercise(muscleGroup: .bicep, exerciseType: .cableSingle), sets: [WorkoutSet(weight: 40, reps: 10), WorkoutSet(weight: 45, reps: 8), WorkoutSet(weight: 40, reps: 9)])
        items.append(testDataItem1)
        let testDataItem2 = SessionDataItem(exercise: Exercise(muscleGroup: .bicep, exerciseType: .dumbellDouble), sets: [WorkoutSet(weight: 22.5, reps: 11), WorkoutSet(weight: 22.5, reps: 10), WorkoutSet(weight: 25, reps: 6)])
        items.append(testDataItem2)
        
        let testDataItem3 = SessionDataItem(exercise: Exercise(muscleGroup: .tricep, exerciseType: .dumbellDouble), sets: [WorkoutSet(weight: 15, reps: 10), WorkoutSet(weight: 15, reps: 8), WorkoutSet(weight: 15, reps: 6)])
        items.append(testDataItem3)
        let testDataItem4 = SessionDataItem(exercise: Exercise(muscleGroup: .tricep, exerciseType: .bodyWeight), sets: [WorkoutSet(weight: 0, reps: 4), WorkoutSet(weight: 0, reps: 5), WorkoutSet(weight: 10, reps: 8)])
        items.append(testDataItem4)
        
        let testDataItem5 = SessionDataItem(exercise: Exercise(muscleGroup: .back, exerciseType: .cableSingle), sets: [WorkoutSet(weight: 70, reps: 11), WorkoutSet(weight: 80, reps: 6), WorkoutSet(weight: 80, reps: 7)])
        items.append(testDataItem5)
        let testDataItem6 = SessionDataItem(exercise: Exercise(muscleGroup: .back, exerciseType: .cableSingle), sets: [WorkoutSet(weight: 50, reps: 11), WorkoutSet(weight: 60, reps: 9), WorkoutSet(weight: 65, reps: 9)])
        items.append(testDataItem6)
        
        return items
    }
    static var previews: some View {
        let workoutSession = WorkoutSession(sessionData: testDataItems)
        let weeklyStatistic = WeeklyStatistic(workoutSessions: [workoutSession])
        PastWeekStatisticsView(weeklyStat: weeklyStatistic)
    }
}
