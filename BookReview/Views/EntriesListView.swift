import SwiftUI

struct EntriesListView: View {
    @EnvironmentObject var vm: EntriesViewModel

    var body: some View {
        List {
            ForEach(vm.entries) { e in
                NavigationLink(destination: EntryFormView(existingEntry: e, initialMedia: e.mediaType).environmentObject(vm)) {
                    VStack(alignment: .leading) {
                        Text(e.title.isEmpty ? "(Untitled)" : e.title)
                            .font(.headline)
                        HStack {
                            Text(e.mediaType.rawValue.capitalized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if let a = e.authorsOrActors, !a.isEmpty {
                                Text("•")
                                Text(a)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .onDelete(perform: vm.delete)
        }
        .navigationTitle("Entries")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EntryFormView(existingEntry: nil, initialMedia: .book).environmentObject(vm)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EntriesListView()
            .environmentObject(EntriesViewModel())
    }
}
