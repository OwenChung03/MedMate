import SwiftUI
import UserNotifications

struct MedMateApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

struct ContentView: View {
    // Medication data
    @State private var selectedMedicine: String = "Example Pill"
    @State private var medicationCount: Int = 0
    @State private var intervalHours: Double = 1.0 // Default interval of 1 hour
    @State private var timer: Timer? = nil
    @State private var medicines: [String] = ["Example Pill"]
    @State private var newMedicine: String = ""

    var body: some View {
        VStack {
            Picker("Medicine", selection: $selectedMedicine) {
                ForEach(medicines, id: \.self) { medicine in
                    Text(medicine)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Text("It's time to take your \(selectedMedicine).")
                .padding()

            Text("Pills remaining: \(medicationCount)")

            Button("Take Pill") {
                takePill()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)

            Stepper("Interval (hours): \(intervalHours, specifier: "%.1f")", value: $intervalHours, in: 0.5...12, step: 0.5)
                .padding()
                .onChange(of: intervalHours) { _ in
                    resetTimer()
                }

            TextField("New Medicine", text: $newMedicine)
                .padding()

            Button("Add Medicine") {
                addMedicine()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
        }
        .onAppear {
            setupNotifications()
            medicationCount = 3
            resetTimer()
        }
        .onDisappear {
            cancelTimer()
        }
    }
    func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "MedMate Reminder"
                content.body = "It's time to take your \(self.medicines[0])."
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalHours * 3600, repeats: true)
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
        if medicationCount > 0 {
            medicationCount -= 1
            print("You took a pill. Pills remaining: \(medicationCount)")
        } else {
            print("No pills remaining.")
        }
    }

    func resetTimer() {
            cancelTimer()
            
            let selectedMedicineCopy = selectedMedicine // Capture selectedMedicine value
            
            timer = Timer.scheduledTimer(withTimeInterval: intervalHours * 3600, repeats: true) { _ in
                print("It's time to take your \(selectedMedicineCopy).") // Use selectedMedicineCopy
                // Trigger a notification here if needed
            }
        }
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    func addMedicine() {
            if !newMedicine.isEmpty && !medicines.contains(newMedicine) {
                medicines.append(newMedicine)
                newMedicine = ""
            }
        }
}
