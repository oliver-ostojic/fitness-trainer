//
//  LiftingProgressChartView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/24/24.
//

import SwiftUI
import Charts

struct LiftingProgressChartView: View {
    // Pass in graph data for viewing
    let graphData: GraphWithDateXAxis
    
    var body: some View {
        VStack {
            Chart(graphData.lines) { line in
                ForEach(line.points) { point in
                    LineMark(x: .value("Date", point.date), y: .value("Weight", point.weight))
                    PointMark(x: .value("Date", point.date), y: .value("Weight", point.weight))
                }
            }
            .padding()
            .frame(height: 300)
            .chartScrollableAxes(.horizontal)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) {
                    value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(format: .dateTime.month(.abbreviated))
                    }
                }
            }
            
            // Specify the X-axis being scrollable
            // And to show two months of data
            // With the current month in the middle of the x-axis
            // Make weekly vertical dotted axis lines
            // Make horizontal weight full axis lines 
        }
    }
}
// Extension for Date to help create test data
extension Date {
    init?(month: Int, day: Int, year: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            self = date
        }
        else {
            return nil
        }
    }
}
// For preview
struct LiftingChart_Previews: PreviewProvider {
    // Create days for points
    static let dateA: Date = Date(month: 9, day: 22, year: 2024) ?? Date()
    static let dateB: Date = Date(month: 9, day: 29, year: 2024) ?? Date()
    static let dateC: Date = Date(month: 9, day: 15, year: 2024) ?? Date()
    // Create points
    static let pointA: WeightPoint = WeightPoint(weight: 20, date: dateC)
    static let pointB: WeightPoint = WeightPoint(weight: 18, date: dateA)
    static let pointC: WeightPoint = WeightPoint(weight: 17.5, date: dateB)
    
    // Then add those points to a line
    static var line: LineOnAGraph {
        var newLine = LineOnAGraph(point: pointA, label: .bicep)
        newLine.points.append(pointB)
        newLine.points.append(pointC)
        return newLine
    }
    static var graph: GraphWithDateXAxis = GraphWithDateXAxis(line: line, type: .upperBody)
    
    static var previews: some View {
        LiftingProgressChartView(graphData: graph)
    }
}

