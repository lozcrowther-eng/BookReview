import SwiftUI

struct ActionSelectionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("What would you like to do?")
                .font(.title2)
                .bold()

            NavigationLink(destination: MediaSelectionView()) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Make an entry")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }

            NavigationLink(destination: EntriesListView()) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Amend an Entry")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }

            NavigationLink(destination: CompileListView()) {
                HStack {
                    Image(systemName: "list.bullet")
                    Text("Compile a list")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).strokeBorder())
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Choose")
    }
}

#Preview {
    NavigationStack {
        ActionSelectionView()
    }
}
