import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var currentPage = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("paintpalette.fill", "Color by Numbers", "Relax and create beautiful artwork by filling in numbered cells with vibrant colors."),
        ("hand.tap.fill", "Tap to Color", "Select a color from the palette, then tap cells with the matching number to fill them in."),
        ("sparkles", "Discover New Art", "Explore hundreds of designs across categories like animals, nature, fantasy, and more."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    onboardingPage(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.appPrimary : Color.appPrimary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 32)

            // Action button
            Button {
                HapticManager.shared.buttonTap()
                if currentPage < pages.count - 1 {
                    withAnimation { currentPage += 1 }
                } else {
                    withAnimation { hasCompletedOnboarding = true }
                }
            } label: {
                Text(currentPage < pages.count - 1 ? "Next" : "Start Coloring")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
            }
            .padding(.horizontal, 32)

            if currentPage < pages.count - 1 {
                Button("Skip") {
                    withAnimation { hasCompletedOnboarding = true }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 12)
            }

            Spacer().frame(height: 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private func onboardingPage(_ page: (icon: String, title: String, subtitle: String)) -> some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.appPrimary.opacity(0.15), .appSecondary.opacity(0.1)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)

                Image(systemName: page.icon)
                    .font(.system(size: 64))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.appPrimary, .appAccent],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
            }

            Text(page.title)
                .font(.title.bold())
                .foregroundColor(.appDark)

            Text(page.subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}
