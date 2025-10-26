import SwiftUI

struct EntryFormView: View {
    @EnvironmentObject var vm: EntriesViewModel
    @Environment(\.dismiss) var dismiss

    @State private var step: Int = 0
    @State private var entry: Entry
    // optional callback for embedded usage so parent can react (e.g. hide the form)
    private let onSave: (() -> Void)?

    private let genres = ["", "Crime/Thriller/Mystery", "Fantasy", "Horror", "Romance", "Science Fiction"]

    init(existingEntry: Entry? = nil, initialMedia: MediaType = .book, onSave: (() -> Void)? = nil) {
        if let existing = existingEntry {
            _entry = State(initialValue: existing)
        } else {
            _entry = State(initialValue: Entry(mediaType: initialMedia))
        }
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 12) {
            // Top selection row: Watch or Read
            VStack(spacing: 8) {
                Text("Which one did you do?")
                    .font(.title2)
                    .bold()

                HStack(spacing: 28) {
                    // Watch option
                    Button(action: { toggleToWatch() }) {
                        VStack(spacing: 8) {
                            Image(systemName: "eye")
                                .font(.system(size: 36))
                                .foregroundColor(isWatch ? Color.white : Color.primary)
                                .padding(18)
                                .background(isWatch ? Color.accentColor : Color.primary.opacity(0.06))
                                .clipShape(Circle())
                            Text("Watch")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Watch")
                    }

                    // Read option
                    Button(action: { toggleToRead() }) {
                        VStack(spacing: 8) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 34))
                                .foregroundColor(isRead ? Color.white : Color.primary)
                                .padding(18)
                                .background(isRead ? Color.accentColor : Color.primary.opacity(0.06))
                                .clipShape(Circle())
                            Text("Read")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .accessibilityLabel("Read")
                    }
                }
            }

            // Progress + existing content below
            ProgressView(value: Double(step), total: 7)
                .padding()

            Form {
                switch step {
                case 0:
                    Section(header: Text("Type")) {
                        // keep the ability to choose sub-type (book vs audiobook, movie vs miniseries)
                        if entry.mediaType == .book || entry.mediaType == .audiobook {
                            Picker("Was it a...", selection: $entry.mediaType) {
                                Text("Book").tag(MediaType.book)
                                Text("Audiobook").tag(MediaType.audiobook)
                            }
                            .pickerStyle(.segmented)
                        } else {
                            Picker("Was it a...", selection: $entry.mediaType) {
                                Text("Mini Series").tag(MediaType.miniseries)
                                Text("Movie").tag(MediaType.movie)
                            }
                            .pickerStyle(.segmented)
                        }

                        // Side-by-side: Date on the left, Recommendation on the right
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("When did you finish it?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: Binding(get: { entry.dateFinished ?? Date() }, set: { entry.dateFinished = $0 }), displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(alignment: .trailing) {
                                Text("Your recommendation")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                RecommendationPicker(selection: $entry.recommendation)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                case 1:
                    Section(header: Text("Title & Creator")) {
                        TextField("Title", text: $entry.title)
                        TextField(entry.mediaType == .book || entry.mediaType == .audiobook ? "Author(s)" : "Actor(s)", text: Binding(get: { entry.authorsOrActors ?? "" }, set: { entry.authorsOrActors = $0.isEmpty ? nil : $0 }))
                    }
                case 2:
                    Section(header: Text("Genre")) {
                        Picker("Genre", selection: Binding(get: { entry.genre ?? "" }, set: { entry.genre = $0.isEmpty ? nil : $0 })) {
                            ForEach(genres, id: \.self) { g in
                                Text(g.isEmpty ? "Leave Blank" : g).tag(g)
                            }
                        }
                        Picker("Subgenre", selection: Binding(get: { entry.subgenre ?? "" }, set: { entry.subgenre = $0.isEmpty ? nil : $0 })) {
                            ForEach(genres, id: \.self) { g in
                                Text(g.isEmpty ? "Leave Blank" : g).tag(g)
                            }
                        }
                    }
                case 3:
                    Section(header: Text("What was it about?")) {
                        TextEditor(text: Binding(get: { entry.plot30 ?? "" }, set: { entry.plot30 = $0.isEmpty ? nil : $0 }))
                            .frame(minHeight: 80)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.25)))
                    }
                case 4:
                    Section(header: Text("What did you like about it?")) {
                        TextEditor(text: Binding(get: { entry.liked ?? "" }, set: { entry.liked = $0.isEmpty ? nil : $0 }))
                            .frame(minHeight: 80)
                    }
                case 5:
                    Section(header: Text("What did you not like about it?")) {
                        TextEditor(text: Binding(get: { entry.disliked ?? "" }, set: { entry.disliked = $0.isEmpty ? nil : $0 }))
                            .frame(minHeight: 80)
                    }
                case 6:
                    Section(header: Text("What would you like to remember?")) {
                        TextEditor(text: Binding(get: { entry.remember ?? "" }, set: { entry.remember = $0.isEmpty ? nil : $0 }))
                            .frame(minHeight: 80)
                    }
                default:
                    EmptyView()
                }
            }

            HStack {
                if step > 0 {
                    Button("Back") { step -= 1 }
                        .padding()
                }
                Spacer()
                if step < 6 {
                    Button("Next") { step += 1 }
                        .padding()
                } else {
                    Button(action: saveAndClose) {
                        Text(existingLabel)
                            .bold()
                    }
                    .padding()
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(stepTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // ensure date has a default if nil
            if entry.dateFinished == nil { entry.dateFinished = Date() }
        }
    }

    // MARK: - Helpers for top toggle
    private var isWatch: Bool {
        switch entry.mediaType {
        case .movie, .miniseries: return true
        default: return false
        }
    }

    private var isRead: Bool {
        switch entry.mediaType {
        case .book, .audiobook: return true
        default: return false
        }
    }

    private func toggleToWatch() {
        // default to .movie but keep previous sub-type if it was a miniseries
        if entry.mediaType == .miniseries {
            entry.mediaType = .miniseries
        } else {
            entry.mediaType = .movie
        }
    }

    private func toggleToRead() {
        // default to .book unless it was previously an audiobook
        if entry.mediaType == .audiobook {
            entry.mediaType = .audiobook
        } else {
            entry.mediaType = .book
        }
    }

    // MARK: - Save / Labels / Titles
    private var isExisting: Bool {
        return vm.entries.contains(where: { $0.id == entry.id })
    }

    private var existingLabel: String {
        return isExisting ? "Save" : "Add Entry"
    }

    private var stepTitle: String {
        switch step {
        case 0: return "Type"
        case 1: return "Title & Creator"
        case 2: return "Genre"
        case 3: return "What was it about?"
        case 4: return "What did you like?"
        case 5: return "What did you not like?"
        case 6: return "What would you like to remember?"
        default: return "Entry"
        }
    }

    private func saveAndClose() {
        if isExisting {
            vm.update(entry: entry)
        } else {
            vm.create(entry: entry)
        }
        // notify parent if embedded
        onSave?()
        // only dismiss the view if we're not embedded (parent will handle closing)
        if onSave == nil {
            dismiss()
        }
    }
}

// Simple recommendation picker view
private struct RecommendationPicker: View {
    @Binding var selection: Recommendation

    var body: some View {
        HStack(spacing: 12) {
            Button(action: { selection = .bronze }) {
                Image(systemName: selection == .bronze ? "star.fill" : "star")
                    .foregroundColor(.brown)
            }
            Button(action: { selection = .silver }) {
                Image(systemName: selection == .silver ? "star.fill" : "star")
                    .foregroundColor(.gray)
            }
            Button(action: { selection = .gold }) {
                Image(systemName: selection == .gold ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EntryFormView(existingEntry: nil, initialMedia: .book)
            .environmentObject(EntriesViewModel())
    }
}
