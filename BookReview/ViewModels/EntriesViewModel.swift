import Foundation
import Combine
import SwiftUI

class EntriesViewModel: ObservableObject {
    @Published private(set) var entries: [Entry] = []
    private var fileURL: URL? = {
        let fm = FileManager.default
        guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return docs.appendingPathComponent("bookreview_entries.json")
    }()

    init() {
        load()
    }

    func create(entry: Entry) {
        entries.append(entry)
        save()
    }

    func update(entry: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    private func save() {
        guard let fileURL = fileURL else { return }
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save entries:", error)
        }
    }

    private func load() {
        guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("Failed to load entries:", error)
        }
    }
}
