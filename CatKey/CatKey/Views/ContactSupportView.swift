import SwiftUI

struct ContactSupportView: View {
    @State private var selectedSubject = "General"
    @State private var customSubject = ""
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    private let subjects = ["General", "Feature Suggestion", "Bug Report", "Usage Question", "Performance Issue", "UI Improvement", "Other"]
    
    var body: some View {
        Form {
            Section("Subject") {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 8) {
                    ForEach(subjects, id: \.self) { subject in
                        Button(action: { selectedSubject = subject }) {
                            Text(subject)
                                .font(.subheadline.weight(selectedSubject == subject ? .semibold : .regular))
                                .foregroundStyle(selectedSubject == subject ? .white : Color(red: 0.18, green: 0.49, blue: 0.82))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(selectedSubject == subject ? Color(red: 0.18, green: 0.49, blue: 0.82) : Color(UIColor.tertiarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if selectedSubject == "Other" {
                    TextField("Specify subject...", text: $customSubject)
                }
            }
            
            Section {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }
            
            Section {
                Button(action: submitFeedback) {
                    Group {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Submit")
                                .font(.headline)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(isFormValid ? Color(red: 0.18, green: 0.49, blue: 0.82) : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!isFormValid || isSubmitting)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Contact Support")
        .alert("Thank You!", isPresented: $showSuccess) {
            Button("OK") {
                name = ""
                email = ""
                message = ""
                selectedSubject = "General"
                customSubject = ""
            }
        } message: {
            Text("Your feedback has been submitted successfully.")
        }
    }
    
    private var isFormValid: Bool {
        let subjectText = selectedSubject == "Other" ? customSubject : selectedSubject
        return !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !email.trimmingCharacters(in: .whitespaces).isEmpty
            && email.contains("@")
            && !subjectText.isEmpty
            && !message.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func submitFeedback() {
        guard isFormValid else { return }
        isSubmitting = true
        errorMessage = nil
        
        let subjectText = selectedSubject == "Other" ? customSubject : selectedSubject
        
        let requestBody: [String: String] = [
            "name": name.trimmingCharacters(in: .whitespaces),
            "email": email.trimmingCharacters(in: .whitespaces),
            "subject": subjectText,
            "message": message.trimmingCharacters(in: .whitespaces),
            "app_name": AppConstants.appName
        ]
        
        guard let url = URL(string: "\(AppConstants.feedbackBackendURL)/api/feedback") else {
            errorMessage = "Invalid server URL"
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            errorMessage = error.localizedDescription
            isSubmitting = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    showSuccess = true
                } else {
                    errorMessage = "Failed to submit. Please try again."
                }
            }
        }.resume()
    }
}
