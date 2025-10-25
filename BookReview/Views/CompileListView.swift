import SwiftUI

struct CompileListView: View {
    @EnvironmentObject var vm: EntriesViewModel

    var body: some View {
        Form {
            Section(header: Text("How would you like your list?")) {
                NavigationLink(destination: MakeMyOwnView()) {
                    Text("Make my own")
                }
                NavigationLink(destination: TimeframeView()) {
                    Text("By timeframe")
                }
                NavigationLink(destination: ByAuthorView()) {
                    Text("By Author / Actor")
                }
            }
        }
        .navigationTitle("Compile a list")
    }
}

private struct MakeMyOwnView: View {
    @State private var showBooks = true
    @State private var showAudiobooks = true
    @State private var showMiniSeries = true
    @State private var showMovies = true

    var body: some View {
        Form {
            Section(header: Text("Story Type")) {
                Toggle("Book", isOn: $showBooks)
                Toggle("Audiobook", isOn: $showAudiobooks)
                Toggle("Mini Series", isOn: $showMiniSeries)
                Toggle("Movie", isOn: $showMovies)
            }

            Section(header: Text("Recommendation")) {
                // Placeholder: In a fuller implementation you could build a multi-select
                Text("Select recommended star levels to include")
            }

            Section(header: Text("Genre")) {
                Text("Select genres to include (placeholder)")
            }

            Section(header: Text("Questions")) {
                Text("Include answers: What it's about, What I like, What I didn't like, What I want to remember")
            }
        }
        .navigationTitle("Make my own")
    }
}

private struct TimeframeView: View {
    @State private var from = Date()
    @State private var to = Date()

    var body: some View {
        Form {
            DatePicker("From", selection: $from, displayedComponents: .date)
            DatePicker("To", selection: $to, displayedComponents: .date)
            Section {
                Text("Results will show entries finished between the selected dates.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("By timeframe")
    }
}

private struct ByAuthorView: View {
    @State private var name = ""

    var body: some View {
        Form {
            TextField("Author / Actor name", text: $name)
            Section {
                Text("Results will show entries matching the given name.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("By Author / Actor")
    }
}

#Preview {
    NavigationStack {
        CompileListView()
            .environmentObject(EntriesViewModel())
    }
}
