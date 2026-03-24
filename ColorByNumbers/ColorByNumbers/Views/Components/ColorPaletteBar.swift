import SwiftUI

struct ColorPaletteBar: View {
    @ObservedObject var viewModel: ColoringViewModel

    var body: some View {
        VStack(spacing: 8) {
            // Progress for selected color
            let filled = viewModel.filledCount(for: viewModel.selectedColorIndex)
            let total = viewModel.totalCount(for: viewModel.selectedColorIndex)
            if total > 0 {
                HStack(spacing: 4) {
                    Text(viewModel.artwork.palette[viewModel.selectedColorIndex].name)
                        .font(.caption.bold())
                        .foregroundColor(.appDark)
                    Spacer()
                    Text("\(filled)/\(total)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
            }

            // Scrollable color palette
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.artwork.palette) { paletteColor in
                            let index = paletteColor.id
                            let isSelected = index == viewModel.selectedColorIndex
                            let filledCount = viewModel.filledCount(for: index)
                            let totalCount = viewModel.totalCount(for: index)
                            let isComplete = filledCount >= totalCount

                            Button {
                                viewModel.selectColor(index)
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(paletteColor.color)
                                        .frame(width: isSelected ? 48 : 40, height: isSelected ? 48 : 40)
                                        .overlay(
                                            Circle()
                                                .stroke(isSelected ? Color.appDark : Color.clear, lineWidth: 3)
                                        )
                                        .shadow(color: isSelected ? paletteColor.color.opacity(0.4) : .clear,
                                                radius: 4)

                                    if isComplete {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                    } else {
                                        Text("\(index + 1)")
                                            .font(.caption2.bold())
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.5), radius: 1)
                                    }
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                }
                .onChange(of: viewModel.selectedColorIndex) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .background(
            Color.appCard
                .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
        )
    }
}
