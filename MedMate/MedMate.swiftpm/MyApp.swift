import SwiftUI
import UserNotifications

@main
struct MedMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    // Medication data
    var medicationName: String = "Example Pill"
    @State var medicationCount: Int = 0
    
    var body: some View {
        VStack {
            Text("It's time to take your \(medicationName).")
                .padding()
            
            Text("Pills remaining: \(medicationCount)")
            
            Button("Take Pill") {
                takePill()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
        }
        .onAppear {
            setupNotifications()
            medicationCount = 3
            takePill() // Output: You took a pill. Pills remaining: 2
        }
    }
    
    func setupNotifications() {
        // Request user permission for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                // Schedule reminder notifications for medication intake
                let content = UNMutableNotificationContent()
                content.title = "MedMate Reminder"
                content.body = "It's time to take your \(self.medicationName)."
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: true)
                let request = UNNotificationRequest(identifier: "MedicationReminder", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully.")
                    }
                }
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func takePill() {
        // Handle pill intake
        if medicationCount > 0 {
            medicationCount -= 1
            print("You took a pill. Pills remaining: \(medicationCount)")
        } else {
            print("No pills remaining.")
        }
    }
}
