import Flutter
import SwiftUI
import UIKit

final class NativeHomeViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        NativeHomePlatformView(frame: frame, viewId: viewId, arguments: args, messenger: messenger)
    }
}

final class NativeHomePlatformView: NSObject, FlutterPlatformView {
    private let hostingController: UIHostingController<NativeHomeRootView>

    init(frame: CGRect, viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        let configuration = NativeHomeConfiguration(arguments: args)
        hostingController = UIHostingController(rootView: NativeHomeRootView(configuration: configuration))
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = frame
        super.init()
    }

    func view() -> UIView {
        hostingController.view
    }
}

struct NativeHomeConfiguration {
    let title: String
    let subtitle: String
    let accentColor: Color

    init(arguments args: Any?) {
        let values = args as? [String: Any]
        title = values?["title"] as? String ?? "PiliPlus"
        subtitle = values?["subtitle"] as? String ?? "Native iOS 26 UI"

        if let rawValue = values?["accentColor"] as? Int64 {
            accentColor = Color(argb: UInt32(truncatingIfNeeded: rawValue))
        } else if let rawValue = values?["accentColor"] as? Int {
            accentColor = Color(argb: UInt32(truncatingIfNeeded: rawValue))
        } else {
            accentColor = Color(red: 1.0, green: 0.4, blue: 0.6)
        }
    }
}

struct NativeHomeRootView: View {
    let configuration: NativeHomeConfiguration
    @State private var selectedCategory = NativeCategory.recommended
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                NativeBackdrop(accentColor: configuration.accentColor)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        NativeHeroHeader(configuration: configuration)
                        NativeSearchBar(text: $searchText, accentColor: configuration.accentColor)
                        NativeCategoryPicker(selection: $selectedCategory, accentColor: configuration.accentColor)
                        NativeVideoGrid(category: selectedCategory, accentColor: configuration.accentColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
            }
            .navigationTitle(configuration.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .nativeGlassButtonStyle(prominent: false)
                }
            }
        }
    }
}

enum NativeCategory: String, CaseIterable, Identifiable {
    case recommended = "推荐"
    case popular = "热门"
    case dynamic = "动态"
    case live = "直播"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .recommended:
            return "sparkles.tv"
        case .popular:
            return "flame.fill"
        case .dynamic:
            return "dot.radiowaves.left.and.right"
        case .live:
            return "play.rectangle.on.rectangle"
        }
    }
}

struct NativeBackdrop: View {
    let accentColor: Color

    var body: some View {
        LinearGradient(
            colors: [accentColor.opacity(0.28), .blue.opacity(0.10), .purple.opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(accentColor.opacity(0.22))
                .frame(width: 240, height: 240)
                .blur(radius: 42)
                .offset(x: 80, y: -80)
        }
        .overlay(alignment: .bottomLeading) {
            Circle()
                .fill(.cyan.opacity(0.18))
                .frame(width: 280, height: 280)
                .blur(radius: 56)
                .offset(x: -90, y: 120)
        }
    }
}

struct NativeHeroHeader: View {
    let configuration: NativeHomeConfiguration

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: "play.tv.fill")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(configuration.accentColor)
                    .frame(width: 58, height: 58)
                    .nativeGlassSurface(cornerRadius: 22, interactive: false)

                VStack(alignment: .leading, spacing: 4) {
                    Text(configuration.title)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    Text(configuration.subtitle)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 10) {
                NativeMetric(title: "正在看", value: "12.8k")
                NativeMetric(title: "本周更新", value: "248")
                NativeMetric(title: "收藏", value: "98")
            }
        }
        .padding(18)
        .nativeGlassSurface(cornerRadius: 28, interactive: true)
    }
}

struct NativeMetric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NativeSearchBar: View {
    @Binding var text: String
    let accentColor: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("搜索视频、番剧、UP 主", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .accessibilityLabel("清空搜索")
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .nativeGlassSurface(cornerRadius: 18, tint: accentColor.opacity(0.08), interactive: true)
    }
}

struct NativeCategoryPicker: View {
    @Binding var selection: NativeCategory
    let accentColor: Color

    var body: some View {
        if #available(iOS 26, *) {
            GlassEffectContainer(spacing: 8) {
                pickerContent
            }
        } else {
            pickerContent
        }
    }

    private var pickerContent: some View {
        HStack(spacing: 8) {
            ForEach(NativeCategory.allCases) { category in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        selection = category
                    }
                } label: {
                    Label(category.rawValue, systemImage: category.symbolName)
                        .font(.subheadline.weight(.semibold))
                        .labelStyle(.titleAndIcon)
                        .padding(.horizontal, 12)
                        .frame(height: 42)
                        .foregroundStyle(selection == category ? .white : .primary)
                }
                .background {
                    if selection == category {
                        Capsule().fill(accentColor.gradient)
                    }
                }
                .clipShape(Capsule())
                .nativeGlassButtonStyle(prominent: selection == category)
            }
        }
        .padding(6)
        .nativeGlassSurface(cornerRadius: 24, interactive: false)
    }
}

struct NativeVideoGrid: View {
    let category: NativeCategory
    let accentColor: Color

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<8, id: \.self) { index in
                NativeVideoCard(
                    title: "\(category.rawValue) · 原生卡片 \(index + 1)",
                    subtitle: index.isMultiple(of: 2) ? "Liquid Glass" : "SwiftUI",
                    accentColor: accentColor,
                    index: index
                )
            }
        }
    }
}

struct NativeVideoCard: View {
    let title: String
    let subtitle: String
    let accentColor: Color
    let index: Int

    private var playCount: String {
        "\(12 + index * 11).\(index)万"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor.opacity(0.72), .purple.opacity(0.48), .blue.opacity(0.36)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .bottomLeading) {
                    Label(playCount, systemImage: "play.fill")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.22), in: Capsule())
                        .padding(10)
                }
                .aspectRatio(16 / 10, contentMode: .fit)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .nativeGlassSurface(cornerRadius: 24, interactive: true)
    }
}

private extension View {
    @ViewBuilder
    func nativeGlassSurface(cornerRadius: CGFloat, tint: Color = .clear, interactive: Bool) -> some View {
        if #available(iOS 26, *) {
            if interactive {
                self.glassEffect(.regular.tint(tint).interactive(), in: .rect(cornerRadius: cornerRadius))
            } else {
                self.glassEffect(.regular.tint(tint), in: .rect(cornerRadius: cornerRadius))
            }
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(.white.opacity(0.22), lineWidth: 1)
                }
        }
    }

    @ViewBuilder
    func nativeGlassButtonStyle(prominent: Bool) -> some View {
        if #available(iOS 26, *) {
            if prominent {
                self.buttonStyle(.glassProminent)
            } else {
                self.buttonStyle(.glass)
            }
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

private extension Color {
    init(argb: UInt32) {
        let alpha = Double((argb >> 24) & 0xff) / 255.0
        let red = Double((argb >> 16) & 0xff) / 255.0
        let green = Double((argb >> 8) & 0xff) / 255.0
        let blue = Double(argb & 0xff) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
