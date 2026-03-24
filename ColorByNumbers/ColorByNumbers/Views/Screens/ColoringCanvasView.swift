import SwiftUI

struct ColoringCanvasView: View {
    @StateObject private var viewModel: ColoringViewModel
    @EnvironmentObject var userProgress: UserProgress
    @Environment(\.dismiss) private var dismiss

    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var currentOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showNumbers = true

    let artwork: Artwork

    init(artwork: Artwork) {
        self.artwork = artwork
        _viewModel = StateObject(wrappedValue: ColoringViewModel(artwork: artwork))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            topBar

            // Canvas
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()

                canvasContent
                    .scaleEffect(currentScale)
                    .offset(currentOffset)
                    .gesture(magnificationGesture)
                    .gesture(dragGesture)

                // Completion overlay
                if viewModel.showCompletion {
                    CompletionOverlay(artwork: artwork) {
                        dismiss()
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }
            }
            .clipped()

            // Color palette
            if !viewModel.showCompletion {
                ColorPaletteBar(viewModel: viewModel)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setup(userProgress: userProgress)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                HapticManager.shared.buttonTap()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundColor(.appDark)
            }

            Spacer()

            Text(artwork.title)
                .font(.headline)
                .foregroundColor(.appDark)

            Spacer()

            // Progress percentage
            Text("\(Int(viewModel.completionPercentage() * 100))%")
                .font(.subheadline.bold())
                .foregroundColor(.appPrimary)

            Button {
                showNumbers.toggle()
            } label: {
                Image(systemName: showNumbers ? "number.square.fill" : "number.square")
                    .font(.title3)
                    .foregroundColor(.appPrimary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.appCard.shadow(color: .black.opacity(0.05), radius: 4, y: 2))
    }

    // MARK: - Canvas

    private var canvasContent: some View {
        GeometryReader { geo in
            let gridW = artwork.gridWidth
            let gridH = artwork.gridHeight
            let cellSize = min(geo.size.width / CGFloat(gridW), (geo.size.height) / CGFloat(gridH))
            let totalW = cellSize * CGFloat(gridW)
            let totalH = cellSize * CGFloat(gridH)
            let offsetX = (geo.size.width - totalW) / 2
            let offsetY = (geo.size.height - totalH) / 2

            Canvas { context, size in
                for region in artwork.regions {
                    guard let cells = region.gridCells else { continue }
                    let isFilled = viewModel.isRegionFilled(region.id)
                    let isSelectedColor = region.colorIndex == viewModel.selectedColorIndex

                    for cell in cells {
                        let rect = CGRect(
                            x: offsetX + CGFloat(cell.col) * cellSize,
                            y: offsetY + CGFloat(cell.row) * cellSize,
                            width: cellSize,
                            height: cellSize
                        )

                        if isFilled {
                            let color = artwork.palette[region.colorIndex].color
                            context.fill(Path(rect), with: .color(color))
                        } else if isSelectedColor {
                            // Highlight cells that match selected color
                            let color = artwork.palette[region.colorIndex].color.opacity(0.2)
                            context.fill(Path(rect), with: .color(color))
                        } else {
                            context.fill(Path(rect), with: .color(.white))
                        }

                        // Grid lines
                        context.stroke(Path(rect), with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
                    }
                }

                // Draw number labels
                if showNumbers && !viewModel.showCompletion {
                    for region in artwork.regions {
                        guard !viewModel.isRegionFilled(region.id) else { continue }
                        let pos = region.numberPosition
                        let x = offsetX + (pos.x + 0.5) * cellSize
                        let y = offsetY + (pos.y + 0.5) * cellSize
                        let fontSize = max(cellSize * 0.35, 8)
                        let text = Text("\(region.colorIndex + 1)")
                            .font(.system(size: fontSize, weight: .semibold))
                            .foregroundColor(.gray)
                        context.draw(text, at: CGPoint(x: x, y: y))
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                let col = Int((location.x - offsetX) / cellSize)
                let row = Int((location.y - offsetY) / cellSize)
                if row >= 0 && row < gridH && col >= 0 && col < gridW {
                    viewModel.tapCell(row: row, col: col)
                }
            }
        }
    }

    // MARK: - Gestures

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let newScale = lastScale * value
                currentScale = min(max(newScale, 1.0), 5.0)
            }
            .onEnded { _ in
                lastScale = currentScale
                if currentScale <= 1.0 {
                    withAnimation(.spring(response: 0.3)) {
                        currentOffset = .zero
                        lastOffset = .zero
                    }
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard currentScale > 1.0 else { return }
                currentOffset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = currentOffset
            }
    }
}
