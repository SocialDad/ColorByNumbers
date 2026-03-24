import SwiftUI

struct CompletionOverlay: View {
    let artwork: Artwork
    let onDismiss: () -> Void

    @State private var showConfetti = false
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 24) {
                // Celebration icon
                ZStack {
                    // Rotating glow
                    Circle()
                        .fill(
                            AngularGradient(
                                colors: [.appPrimary, .appAccent, .appGold, .appSuccess, .appPrimary],
                                center: .center
                            )
                        )
                        .frame(width: 100, height: 100)
                        .blur(radius: 20)
                        .rotationEffect(.degrees(rotationAngle))
                        .onAppear {
                            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                                rotationAngle = 360
                            }
                        }

                    Image(systemName: "star.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.appGold, .orange],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                }

                Text("Masterpiece Complete!")
                    .font(.title.bold())
                    .foregroundColor(.white)

                // Completed artwork preview
                ArtworkPreviewGrid(artwork: artwork)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .appPrimary.opacity(0.3), radius: 12)

                Text(artwork.title)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))

                HStack(spacing: 20) {
                    Button {
                        onDismiss()
                    } label: {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Gallery")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(32)

            // Confetti particles
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Confetti

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    struct ConfettiParticle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let color: Color
        let size: CGFloat
        let rotation: Double
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles) { particle in
                RoundedRectangle(cornerRadius: 2)
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size * 0.6)
                    .rotationEffect(.degrees(particle.rotation))
                    .position(x: particle.x, y: particle.y)
            }
            .onAppear {
                let colors: [Color] = [.appPrimary, .appAccent, .appGold, .appSuccess, .appSecondary, .orange, .pink]
                for _ in 0..<40 {
                    particles.append(ConfettiParticle(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: -20,
                        color: colors.randomElement()!,
                        size: CGFloat.random(in: 6...12),
                        rotation: Double.random(in: 0...360)
                    ))
                }

                // Animate falling
                withAnimation(.easeIn(duration: 2.5)) {
                    for i in particles.indices {
                        particles[i].y = geo.size.height + 40
                        particles[i].x += CGFloat.random(in: -60...60)
                    }
                }
            }
        }
    }
}
