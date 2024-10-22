//
//  HomeView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/12/24.
//

import SwiftUI
// Divider used in WeekView
struct DottedLine: Shape {
        
    func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            return path
        }
}
// Home Content
struct HomeView: View {
    // User data
    @EnvironmentObject var userData: UserData
    
    @State private var showTemplateView = false
    @State private var showSessionView = false
    @State private var isUserViewOpen = false
    @State private var selectedTemplate: Template? = nil
    
    var body: some View {
        ZStack {
            // Create black overlay for card effect
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            GeometryReader { geometry in
                // Home content
                VStack {
                    // Home page title
                    ZStack {
                        HStack {
                            Text("Home")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.top, 80)
                                .padding(.leading, 20)
                                .padding(.bottom, 5)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            VStack {
                                // Circle shape with an emoji inside, and onTapGesture for interaction
                                ZStack {
                                    Circle()
                                        .fill(Color(.blue))
                                        .frame(width: 30, height: 30)
                                        .padding(.top, 80)
                                        .padding(.trailing, 20)
                                        .padding(.bottom, 5)
                                    
                                    Image(systemName: "person.fill")
                                        .frame(width: 40, height: 40)
                                        .padding(.top, 80)
                                        .padding(.trailing, 20)
                                        .padding(.bottom, 5)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                }
                                .onTapGesture {
                                    isUserViewOpen = true
                                }
                            }
                        }
                    }
                    // Week Title
                    Text("Weekly Schedule")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Week View
                    HStack(spacing: 0) {
                        // Create the 7 days of the week using ForEach and VStack
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            VStack {
                                Spacer()
                                // Check if this day has a template to include
                                if userData.query_if_workout_today(day: day) != nil {
                                    // If so, create a colorful card to include the template
                                    VStack {
                                        Image(systemName: "figure.run.square.stack.fill")
                                            .font(.system(size: 30))
                                            .padding(.bottom, 5)
                                            .foregroundColor(Color(UIColor.systemGray2))
                                    }
                                }
                                Text(day.rawValue)
                                    .foregroundStyle(Color(UIColor.systemGray4))
                                    .padding(.bottom, 5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            // Dotted divider between days
                            if day != .sunday {
                                DottedLine()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                    .frame(width: 0.5, height: 200)
                                    .foregroundColor(Color(UIColor.systemGray5))
                            }
                        }
                    }
                    .frame(width: geometry.size.width*0.9, height: 200)
                    .overlay(
                        Rectangle()
                            .stroke(Color(UIColor.systemGray5), lineWidth: 0.5)
                    )
                    // Button to launch 'CreateTemplateView'
                    Button(action: {
                        withAnimation {
                            showTemplateView = true
                        }
                    }) {
                        ZStack {
                            HStack {
                                Text("New Template")
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .padding(.leading, 15)
                                    .foregroundColor(.blue)
                                    .font(.system(size: 16))
                                Spacer()
                            }
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 38)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                    .foregroundColor(Color(UIColor.systemGray3))
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(.top, 10)
                    // Title for Today's Workout
                    Text("Today's Workout")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    // Section to display today's workout template
                    VStack {
                        if let today = getCurrentDayOfWeek() {
                            if let template = userData.query_if_workout_today(day: today) {
                                Text(template.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 10)
                                    .padding(.leading, 20)
                                Divider()
                                    .padding(.leading, 20)
                                Button(action: {
                                    withAnimation{
                                        showSessionView = true
                                        selectedTemplate = template
                                    }
                                }) {
                                    ZStack {
                                        HStack {
                                            Text("Start Workout Session")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.bottom, 10)
                                                .padding(.top, 2)
                                            .padding(.leading, 20)
                                            Spacer()
                                        }
                                        HStack {
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .padding(.trailing, 20)
                                                .padding(.bottom, 10)
                                                .padding(.top, 2)
                                                .foregroundColor(Color(UIColor.systemGray3))
                                                .font(.system(size: 14))
                                        }
                                    }
                                }
                            }
                            else {
                                Text("No workout today")
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                            }
                        }
                        else {
                            Text("Unable to determine today's date")
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(maxWidth: geometry.size.width*0.9)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    // Spacer to push items up
                    Spacer()
                }
                .frame(width: showTemplateView ? geometry.size.width * 0.91 : geometry.size.width)
                .background(showTemplateView ? Color(UIColor.systemGray4) : .white)
                .cornerRadius(showTemplateView ? 10 : 0)
                .offset(CGSize(width: 0, height: showTemplateView ? 60: 0))
                .zIndex(1)
                .edgesIgnoringSafeArea(.all)
                // Center home page content 'card'
                .position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
                // Launch CreateTemplateView
                if showTemplateView {
                    // Create the card view
                    CreateTemplateView(showTemplateView: $showTemplateView)
                        .environmentObject(userData)
                        .transition(.move(edge: .bottom))
                }
                if showSessionView {
                    if let template = selectedTemplate {
                        SessionView(isSessionRunning: $showSessionView, template: template)
                            .environmentObject(userData)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
    }
    // Function to get the current day and match it to the DayOfWeek enum
    func getCurrentDayOfWeek() -> DayOfWeek? {
        let today = Calendar.current.component(.weekday, from: Date())

        // Swift’s Calendar weekday starts with 1 for Sunday, so map accordingly
        switch today {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
}

#Preview {
    let userData = UserData()
    HomeView()
        .environmentObject(userData)
}
