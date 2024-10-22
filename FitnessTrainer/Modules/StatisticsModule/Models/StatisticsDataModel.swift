//
//  StatisticsDataModel.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/20/24.
//

import Foundation
// Structure to hold a week of workout statistics and achievements
struct WeeklyStatistic: Identifiable, Codable {
    // This struct holds statistic data for displaying to user in explicitly and in charts
    // Data is modified for Tricep, Bicep, Shoulder, Calf to be measured by single muscle vs the rest of muscles being
    // measured through combined muscle effort
    let id: UUID
    let date: Date
    var totalTimeExercising = TimeInterval()
    
    var muscleWeeklyStatistics: [MuscleWeeklyStatistic] = []
    var sortedMuscleData: [SortedMuscleData] = []
    
    init(workoutSessions: [WorkoutSession]) {
        self.date = Date()
        self.id = UUID()
        for workoutSession in workoutSessions {
            // Increment total time exercising with session time
            self.totalTimeExercising += workoutSession.sessionTimeInterval
            // For every set in a workout session,
            sessionDataLoop: for sessionDataItem in workoutSession.sessionData {
                
                // Add the data item to its appropriate sortedData
                for i in 0..<sortedMuscleData.count {
                    // Check if the muscleGroup is a match
                    if sessionDataItem.exercise.muscleGroup == sortedMuscleData[i].muscleGroup {
                        // If so, add the data to the sorted data
                        self.sortedMuscleData[i].exercises.append(sessionDataItem)
                        // Skip to next item
                        continue sessionDataLoop
                    }
                }
                
                // If no match found, create a new SortedMuscleData and add it to self.sortedMuscleData
                let data = SortedMuscleData(muscleGroup: sessionDataItem.exercise.muscleGroup, exerciseData: sessionDataItem)
                self.sortedMuscleData.append(data)
            }
        }
        // Now, create a new MuscleWeeklyStatistic for each SortedMuscleData
        sortedMuscleData.forEach { dataItem in
            let newStatistic = MuscleWeeklyStatistic(sortedData: dataItem)
            // Add the new item to self.muscleWeeklyStatistic
            self.muscleWeeklyStatistics.append(newStatistic)
        }
    }
    // Struct for sorting all SessionDataItems (an exercise, and its sets) by their muscle group
    struct SortedMuscleData: Identifiable, Codable {
        let id: UUID
        let muscleGroup: MuscleGroup
        var exercises: [SessionDataItem] = []
        
        init(muscleGroup: MuscleGroup, exerciseData: SessionDataItem) {
            self.id = UUID()
            self.muscleGroup = muscleGroup
            self.exercises.append(exerciseData)
        }
    }
    // init with WorkoutSessions query to grab all WorkoutSessions from the last week
    struct MuscleWeeklyStatistic: Identifiable, Codable {
        // Struct attributes
        let id: UUID
        var muscleGroup: MuscleGroup
        var totalReps: Int = 0
        var avgReps: Int = 0
        var totalWeight: Double = 0
        var avgWeight: Double = 0
        var setCount: Int = 0

        // PICK UP HERE with list of same muscles data
        init(sortedData: SortedMuscleData) {
            // Set first variables
            self.id = UUID()
            self.muscleGroup = sortedData.muscleGroup
            
            // Categories for exercise and muscle types
            let isolatedMuscles: [MuscleGroup] = [.bicep, .tricep, .shoulder, .calf]
            let halfExerciseTypes: [ExerciseType] = [.plateSingle, .cableSingle, .bar, .dumbellSingle]
            let doubleExerciseTypes: [ExerciseType] = [.dumbellDouble, .plateDouble, .cableDouble]
            var isIsolated = false
            
            // Check if the MUSCLE of the SortedMuscleData should be analyzed in isolation
            if isolatedMuscles.contains(self.muscleGroup) {
                isIsolated = true
            }

            // Iterate through each item in sortedData and update statistic values (totalreps, avgreps, totalweight, avgweight)
            sortedData.exercises.forEach { sessionDataItem in
                // Set state variables for current data item
                var halfWeight = false
                var doubleWeight = false
                
                // Check if the exercise type is one in which the weight is HALFED (for isolated muscles)
                if isIsolated {
                    if halfExerciseTypes.contains(sessionDataItem.exercise.exerciseType) {
                        halfWeight = true
                    }
                }
                // If its a non-isolated muscle
                else {
                    // Check if the weight needs to be doubled
                    if doubleExerciseTypes.contains(sessionDataItem.exercise.exerciseType) {
                        doubleWeight = true
                    }
                }
            
                // Iterate through each set in sessionDataItem
                sessionDataItem.sets.forEach { set in
                    // Update set count
                    self.setCount += 1
                    
                    // Update total weight
                    // If weight needs to be halfed
                    if halfWeight {
                        self.totalWeight += (set.weight/2)
                    }
                    // If weight needs to be doubled
                    else if doubleWeight {
                        self.totalWeight += (set.weight*2)
                    }
                    // If normal base case
                    else {
                        self.totalWeight += set.weight
                    }
                    
                    // Update the total reps
                    self.totalReps += set.reps
                }
            }
            // Calculate the weighted average of weight
            sortedData.exercises.forEach { sessionDataItem in
                sessionDataItem.sets.forEach { set in
                    // Calculate the weighted average
                    let currAvg = (Double(set.reps)/Double(totalReps)) * set.weight
                    // Add the weighted average for each set weight
                    self.avgWeight += currAvg
                }
            }
            // Calculate the average reps done in a set
            self.avgReps = (self.totalReps/self.setCount)
        }
    }
}
enum GraphType: String, CaseIterable, Codable {
    case arm = "Arm"
    case upperBody = "Upper Body"
    case lowerBody = "Lower Body"
    case none = "None"
    
    static func which_graph_type(muscleGroup: MuscleGroup) -> GraphType {
        let armMuscles: [MuscleGroup] = [.bicep, .tricep,]
        let upperMuscles: [MuscleGroup] = [.chest, .abdominals, .back, .shoulder]
        let lowerMuscles: [MuscleGroup] = [.quads, .hamstrings, .calf, .glutes]
        if armMuscles.contains(muscleGroup) {
            return .arm
        }
        else if upperMuscles.contains(muscleGroup) {
            return .upperBody
        }
        else if lowerMuscles.contains(muscleGroup) {
            return .lowerBody
        }
        else {
            return .none
        }
    }
}
// Struct for StatisticsGraph item
struct GraphWithDateXAxis: Identifiable, Codable {
    let id: UUID
    let graphType: GraphType
    var lines: [LineOnAGraph] = []
    
    init(line: LineOnAGraph, type: GraphType) {
        self.id = UUID()
        self.lines.append(line)
        self.graphType = type
    }
}
// Struct for pie chart comparing rep percenetages by muscle group
struct PieChart: Identifiable, Codable {
    let id: UUID
    var pairs: [Pair] = []
    
    init() {
        self.id = UUID()
    }
    init(weeklyStatistic: WeeklyStatistic) {
        self.id = UUID()
        for statistic in weeklyStatistic.muscleWeeklyStatistics {
            let pair = Pair(totalReps: statistic.totalReps, muscleGroup: statistic.muscleGroup)
            self.pairs.append(pair)
        }
    }
    struct Pair : Identifiable, Codable {
        let id: UUID
        let totalReps: Int
        let muscleGroup: MuscleGroup
        
        init(totalReps: Int, muscleGroup: MuscleGroup) {
            self.id = UUID()
            self.totalReps = totalReps
            self.muscleGroup = muscleGroup
        }
        
    }
    
}
// Struct for a point on a graph
struct WeightPoint: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var date: Date
    var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    init(weight: Double, date: Date) {
        self.id = UUID()
        self.weight = weight
        self.date = date
    }
}
// Struct for a line on a graph
struct LineOnAGraph: Identifiable, Codable {
    let id: UUID
    var points: [WeightPoint] = []
    var label: MuscleGroup
    
    init(point: WeightPoint, label: MuscleGroup) {
        self.id = UUID()
        self.points.append(point)
        self.label = label
    }
}
// Struct for StatisticsView
struct StatisticData: Identifiable, Codable {
    let id: UUID
    var graphs: [GraphWithDateXAxis] = []
    var pieChartData = PieChart()
    var weeklyStatistics: [WeeklyStatistic] = []
    
    init() {
        self.id = UUID()
    }
    mutating func update(workoutSessions: [WorkoutSession]) {
        // Get the current weekday
        // let weekday = Calendar.current.component(.weekday, from: Date())
        // If so, create new Statistic
        create_new_weekly_statistic(workoutSessions: workoutSessions)
        // Update Graphs
        if let latestWeekStat = weeklyStatistics.last {
            update_graphs(weeklyStatistic: latestWeekStat)
            // Update Pie Chart with current week's data
            let newPieChart = PieChart(weeklyStatistic: latestWeekStat)
            pieChartData = newPieChart
        }
        // ABOVE GOES INSIDE IF LOOK BELOW (EXCLUDED FOR TESTING
        // If the current weekday is sunday:
        //if weekday == 1 {}
        // Add a new statistic to weeklyStatistics
    }
    mutating func create_new_weekly_statistic(workoutSessions: [WorkoutSession]) {
        // Get the current weekday
        if let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
            let pastWeekSessions = workoutSessions.filter { session in
                return session.date >= oneWeekAgo && session.date <= Date()
            }
            // Make sure that there is at least one workout session to generate statistics
            if !pastWeekSessions.isEmpty {
                let newStatistic = WeeklyStatistic(workoutSessions: pastWeekSessions)
                // Append the new statistic
                weeklyStatistics.append(newStatistic)
            }
        }
    }
    // Function to update all graphs
    mutating func update_graphs(weeklyStatistic: WeeklyStatistic) {
        // PURPOSE is to add new points to graphs. Each point is a (Date, avgWeight) for each muscle in a week's statistics
        
        // For every muscle group in the WeeklyStatistic item
        loop: for statisticItem in weeklyStatistic.muscleWeeklyStatistics {
            // First, create the point to be added to a graph (date, avgWeight for muscle for the week)
            let newPoint = WeightPoint(weight: statisticItem.avgWeight, date: weeklyStatistic.date)
            // Check what graph this point should go on
            let graphType = GraphType.which_graph_type(muscleGroup: statisticItem.muscleGroup)
            
            // Make sure that graphType is not .none
            if graphType != .none {
                // Now, add the data point to a graph
                // Look through all graphs to find the one to add new data point to
                for i in 0..<graphs.count {
                    // If we find the graph
                    if graphs[i].graphType == graphType {
                        // Check if a line exists for the intended muscleGroup
                        for j in 0..<graphs[i].lines.count {
                            if graphs[i].lines[j].label == statisticItem.muscleGroup {
                                // If so, add point to line
                                graphs[i].lines[j].points.append(newPoint)
                                // All done, jump to start of loop
                                continue loop
                            }
                        }
                        // Else, create a new line with new point
                        let newLine = LineOnAGraph(point: newPoint, label: statisticItem.muscleGroup)
                        // Add the line to the graph
                        graphs[i].lines.append(newLine)
                        // All done! jump to start
                        continue loop
                    }
                }
                // If the needed graph doesn't exist, make it
                // But first, make a line and add the point
                let newLine = LineOnAGraph(point: newPoint, label: statisticItem.muscleGroup)
                let newGraph = GraphWithDateXAxis(line: newLine, type: graphType)
                // Add the graph to graphs
                self.graphs.append(newGraph)
            }
        }
    }
}
