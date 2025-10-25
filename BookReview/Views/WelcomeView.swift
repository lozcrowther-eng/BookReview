import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // light watercolor background placeholder
            LinearGradient(colors: [.mint.opacity(0.15), .blue.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()
                VStack(spacing: 6) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                    Text("to")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("BookReview")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                Image(systemName: "binoculars")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 80)
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)

                Text("Making an entry is as quick as answering 12 questions. Taking 5 minutes to log an entry after finishing a story helps you remember favourites and enables recommendations.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.secondary)

                Spacer()

                NavigationLink(destination: ActionSelectionView()) {
                    Text("Click to Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
