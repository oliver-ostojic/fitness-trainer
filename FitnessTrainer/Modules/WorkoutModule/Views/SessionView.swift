//
//  SessionView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/16/24.
//

import SwiftUI

struct SessionView: View {
    @EnvironmentObject var userData: UserData
    @State private var expanded = true
    @State private var offset: CGFloat = 0
    @State var timeElapsed: Int = 0
    @State var workoutSession: WorkoutSession
    @Binding var isSessionRunning: Bool
    // To be changed to setCount set in User Module
    let setCount: Int = 3
    // Pass in read only template
    let template: Template
    // Initialize input_arrays dynamically according to setCount (dependant on user intensity)
    init(isSessionRunning: Binding<Bool>, template: Template) {
        self._isSessionRunning = isSessionRunning
        self.template = template
        // Initialize a workoutSession skeleton that will be validated later
        _workoutSession = State(initialValue: WorkoutSession(setCount: setCount, muscleGroups: template.targetMuscleGroups))
    }
    // Create timer
    let timer =  Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // Body
    var body: some View {
        GeometryReader { geometry in
            // Expanded view
            if expanded {
                VStack {
                    // Little bar on top to swipe down
                    HandleBar()
                        // Minimize the view with a DragGesture()
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Handle dragging
                                    if value.translation.height > 0 {
                                        offset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    withAnimation {
                                        if offset > 0 {
                                            expanded = false
                                        } else {
                                            offset = 0
                                        }
                                    }
                                }
                        )
                    // Finish button
                    ZStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isSessionRunning = false
                                
                                // Stop Timer and set value in workoutSession
                                workoutSession.sessionTimeInterval = TimeInterval(timeElapsed)
                                
                                // Delete unused or empty sets
                                workoutSession.delete_sets_with_no_reps()
                                
                                // Add session to user data
                                userData.workoutSessions.append(workoutSession)
                                
                                // Save data (TO BE IMPLEMENTED)
                                _ = userData.saveData()
            
                            }) {
                                Text("Finish")
                            }
                            .padding(.trailing, 20)
                        }
                        HStack {
                            Button(action: {
                                isSessionRunning = false
                            }) {
                                Text("Cancel")
                            }
                            .padding(.leading, 20)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 10)
                    // View Title
                    HStack {
                        Text("Workout Session")
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.leading, 20)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    // Template Name SubTitle
                    Text(template.name)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading, 20)
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Timer
                    HStack {
                        Text(timeString(from: timeElapsed))
                            .onReceive(timer) {firedDate in
                                timeElapsed = Int(firedDate.timeIntervalSince(workoutSession.date))
                        }
                            .padding(.leading, 20)
                            .foregroundColor(Color(UIColor.systemGray))
                        Spacer()
                    }
                    // Exercise Forms
                    ScrollView {
                        ForEach($workoutSession.sessionData) { $sessionDataItem in
                            TemplateExerciseView(sessionDataItem: $sessionDataItem)
                        }
                    }
                }
                .offset(y:offset)
                .background(Color.white)
                .cornerRadius(10)
                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .bottom).combined(with: .opacity)))
            }
            // Minimized view
            else {
                // Create Frame that when clicked, opens back to expanded
                VStack {
                    ZStack {
                        HStack {
                            Text(template.name)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(timeString(from: timeElapsed))
                                .onReceive(timer) {firedDate in
                                    timeElapsed = Int(firedDate.timeIntervalSince(workoutSession.date))
                            }
                                .padding(.trailing, 20)
                                .foregroundColor(Color(UIColor.systemGray))
                        }
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y:2)
                .offset(CGSize(width: 0, height: 650))
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .onTapGesture {
                    withAnimation {
                        expanded.toggle()
                        offset = 0
                    }
                }
            }
        }
        .zIndex(2)
    }
    // Function to display timer
    private func timeString(from interval: Int) -> String {
            let minutes = interval / 60
            let seconds = interval % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    // Struct for pulldown bar
    struct HandleBar: View {
        var body: some View {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 100, height: 5)
                .cornerRadius(2.5)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        // Define a sample template
        let sampleTemplate = Template(id: UUID(), name: "Leg Day", targetMuscleGroups: [.quads, .hamstrings], repeatDays: [.monday])
        let sampleUserData = UserData()
        // Use the preview provider to display the view
        SessionView(isSessionRunning: .constant(true), template: sampleTemplate)
            .environmentObject(sampleUserData)
    }
}
