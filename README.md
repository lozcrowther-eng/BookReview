# BookReview

A small SwiftUI app for recording brief book reviews and metadata.

Overview
- SwiftUI app targeting iOS Simulator (development build configuration).
- Simple entry model and a few views for creating and listing book entries.

Requirements
- macOS with Xcode 15+ (command line tools installed)
- Swift toolchain bundled with Xcode

Quick build & run (command line)
1. Build for the iPhone Simulator (example used iPhone 17 Pro):

```bash
xcodebuild -project BookReview.xcodeproj -scheme BookReview -configuration Debug -destination 'id=4C991D84-935C-4284-9ECE-2C31337905B8' -derivedDataPath build/derivedData clean build
```

2. Install to the booted simulator:

```bash
xcrun simctl install booted build/derivedData/Build/Products/Debug-iphonesimulator/BookReview.app
```

3. Launch the app in the simulator:

```bash
xcrun simctl launch booted amy.BookReview
```

Open in Xcode
- To run with the debugger or edit the project, open the project file:

```bash
open BookReview.xcodeproj
# or if you use the workspace:
# open BookReview.xcworkspace
```

Add the remote repository you mentioned
- To add the remote URL you provided as a new remote named `origin` (or `upstream`) run:

```bash
# add as origin (only if there's not already an origin you want to replace)
git remote add origin https://github.com/lozcrowther-eng/BookReview.git

# or add as upstream to avoid overwriting existing origin
git remote add upstream https://github.com/lozcrowther-eng/BookReview.git
```

Project structure (top-level)
- BookReview/ (Swift package targets / app sources)
  - BookReviewApp.swift
  - ContentView.swift
  - Views/
    - WelcomeView.swift
    - ActionSelectionView.swift
    - EntriesListView.swift
    - EntryFormView.swift
    - MediaSelectionView.swift
    - CompileListView.swift
  - Models/
    - Entry.swift
  - ViewModels/
    - EntriesViewModel.swift
- BookReview.xcodeproj
- README.md (this file)

Development notes / tips
- The app uses a fake team ID in simulated entitlements for running in simulator; no real provisioning is required for simulator builds.
- Use `xcrun simctl list devices available` to find simulator UDIDs if you want to target another device.
- If you want me to add the remote for you (and optionally push a README commit), I can run those git commands—tell me which remote name you prefer (`origin` or `upstream`) and whether to commit the new README automatically.

License
- This README is provided under an MIT-style notice. Add a proper LICENSE file if you need a formal license for the code.

Contact / Next steps
- Tell me if you want me to:
  - add the remote to the repository now,
  - commit & push the README,
  - or open the project in Xcode and start a debug session.
