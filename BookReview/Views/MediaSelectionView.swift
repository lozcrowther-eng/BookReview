import SwiftUI

struct MediaSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Which one did you do?")
                .font(.title2)
                .bold()

            NavigationLink(destination: EntryFormView(existingEntry: nil, initialMedia: .miniseries)) {
                HStack {
                    Image(systemName: "eye")
                    Text("Watch")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }

            NavigationLink(destination: EntryFormView(existingEntry: nil, initialMedia: .book)) {
                HStack {
                    Image(systemName: "book")
                    Text("Read")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Pick media")
    }
}

#Preview {
    NavigationStack {
        MediaSelectionView()
    }
}
