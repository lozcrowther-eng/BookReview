import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let left = CGPoint(x: rect.minX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.maxY)
        path.move(to: top)
        path.addLine(to: left)
        path.addLine(to: right)
        path.addLine(to: top)
        return path
    }
}

struct WatercolorCircle: View {
    var colors: [Color]
    var body: some View {
        Circle()
            .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .blur(radius: 10)
            .opacity(0.45)
            .scaleEffect(1.1)
    }
}

struct IconWithWatercolor: View {
    var systemName: String
    var size: CGFloat = 70
    var colors: [Color] = [Color.mint.opacity(0.35), Color.blue.opacity(0.22)]

    var body: some View {
        // compute drawing params outside the ViewBuilder
        let blurRadius: Double = size > 70 ? 10.0 : (size > 50 ? 6.0 : 4.0)
        let scale: CGFloat = size > 70 ? 1.1 : (size > 50 ? 1.05 : 0.95)

        return ZStack {
            WatercolorCircle(colors: colors)
                .frame(width: size * (1.15 * scale), height: size * (1.15 * scale))
                .blur(radius: blurRadius)
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(.primary)
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // background watercolor gradient
                LinearGradient(colors: [.mint.opacity(0.15), .blue.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                // Make the main content scrollable if vertical space is tight
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        Spacer().frame(height: max(12, geo.size.height * 0.04))

                        // Top heading
                        VStack(spacing: 6) {
                            Text("Welcome")
                                .font(.largeTitle)
                                .bold()
                            Text("to")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }

                        // Center binoculars image (scale with width)
                        IconWithWatercolor(systemName: "binoculars", size: min(90, geo.size.width * 0.22), colors: [Color.mint.opacity(0.35), Color.blue.opacity(0.2)])
                            .padding(.top, 6)

                        // Watch / Read side-by-side above the description
                        // Responsive layout: side-by-side on wide screens, stacked on narrow screens
                        // columns share a fixed height so icons can be vertically centered and the 'and' sits between them
                        let columnHeight = min(220, max(140, geo.size.height * 0.22))
                        HStack(alignment: .center, spacing: 12) {
                            // Watch column: title above, icon centered, caption below
                            VStack {
                                Text("Watch")
                                    .font(.title)
                                    .bold()
                                Spacer(minLength: 6)
                                IconWithWatercolor(systemName: "eye", size: min(58, geo.size.width * 0.12), colors: [Color.yellow.opacity(0.28), Color.orange.opacity(0.18)])
                                    .frame(width: min(80, geo.size.width * 0.24), height: min(80, geo.size.width * 0.24))
                                Spacer(minLength: 6)
                            }
                            .frame(maxWidth: geo.size.width * 0.4, minHeight: columnHeight)

                            // 'and' centered vertically between icons
                            Text("and")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(minHeight: columnHeight)
                                .frame(width: 48)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)

                            // Read column
                            VStack {
                                Text("Read")
                                    .font(.title)
                                    .bold()
                                Spacer(minLength: 6)
                                IconWithWatercolor(systemName: "book", size: min(58, geo.size.width * 0.12), colors: [Color.pink.opacity(0.28), Color.purple.opacity(0.18)])
                                    .frame(width: min(80, geo.size.width * 0.24), height: min(80, geo.size.width * 0.24))
                                Spacer(minLength: 6)
                            }
                            .frame(maxWidth: geo.size.width * 0.4, minHeight: columnHeight)
                        }
                        .padding(.horizontal, 28)
                        .padding(.top, 10)
                        .padding(.bottom, 18)

                        // Description + button grouped to prevent overlap
                        VStack(spacing: 12) {
                            NavigationLink(destination: ActionSelectionView()) {
                                Text("Click to Start")
                                    .font(.headline)
                                    .frame(maxWidth: 260)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Hey there — making an entry is as quick as answering 12 questions. Taking 5 minutes to log an entry after finishing a story helps you remember favourites and enables recommendations.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 24)
                                .padding(.top, 6)
                                 .layoutPriority(1) // keep description from being compressed

                            
                            .padding(.top, 6)
                        }
                        .padding(.bottom, max(20, geo.safeAreaInsets.bottom + 12))
                    }
                 }
             }
         }
     }
 }

 struct WelcomeView_Previews: PreviewProvider {
     static var previews: some View {
         Group {
             NavigationStack { WelcomeView() }
                 .previewDevice("iPhone 14 Pro")
                 .previewDisplayName("iPhone 14 Pro")

             NavigationStack { WelcomeView() }
                 .previewDevice("iPhone SE (2nd generation)")
                 .previewDisplayName("iPhone SE (compact)")
         }
     }
 }
