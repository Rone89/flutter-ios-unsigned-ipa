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
        subtitle = values?["subtitle"] as? String ?? "Native iOS UI"

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
        NavigationView {
            ZStack {
                NativeBackdrop(accentColor: configuration.accentColor)
                    .edgesIgnoringSafeArea(.all)

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
            .navigationBarTitle(configuration.title, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "person.crop.circle")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                gradient: Gradient(colors: [accentColor.opacity(0.28), Color.blue.opacity(0.10), Color.purple.opacity(0.12)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(accentColor.opacity(0.22))
                .frame(width: 240, height: 240)
                .blur(radius: 42)
                .offset(x: 80, y: -80)

            VStack {
                Spacer()
                HStack {
                    Circle()
                        .fill(Color.blue.opacity(0.16))
                        .frame(width: 280, height: 280)
                        .blur(radius: 56)
                        .offset(x: -90, y: 120)
                    Spacer()
                }
            }
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
                    .foregroundColor(configuration.accentColor)
                    .frame(width: 58, height: 58)
                    .nativeGlassSurface(cornerRadius: 22)

                VStack(alignment: .leading, spacing: 4) {
                    Text(configuration.title)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text(configuration.subtitle)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 10) {
                NativeMetric(title: "正在看", value: "12.8k")
                NativeMetric(title: "本周更新", value: "248")
                NativeMetric(title: "收藏", value: "98")
            }
        }
        .padding(18)
        .nativeGlassSurface(cornerRadius: 28)
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
                .foregroundColor(.secondary)
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
                .foregroundColor(.secondary)
            TextField("搜索视频、番剧、UP 主", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Button(action: { text = "" }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .nativeGlassSurface(cornerRadius: 18, tint: accentColor.opacity(0.08))
    }
}

struct NativeCategoryPicker: View {
    @Binding var selection: NativeCategory
    let accentColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(NativeCategory.allCases) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            selection = category
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.symbolName)
                            Text(category.rawValue)
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 12)
                        .frame(height: 42)
                        .foregroundColor(selection == category ? .white : .primary)
                        .background(selection == category ? accentColor : Color.clear)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(6)
        }
        .nativeGlassSurface(cornerRadius: 24)
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
                    subtitle: index.isMultiple(of: 2) ? "Native blur" : "SwiftUI",
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
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [accentColor.opacity(0.72), Color.purple.opacity(0.48), Color.blue.opacity(0.36)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(16 / 10, contentMode: .fit)

                HStack(spacing: 4) {
                    Image(systemName: "play.fill")
                    Text(playCount)
                }
                .font(.caption.bold())
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .foregroundColor(.white)
                .background(Color.black.opacity(0.22))
                .clipShape(Capsule())
                .padding(10)
            }

            Text(title)
                .font(.subheadline.bold())
                .lineLimit(2)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .nativeGlassSurface(cornerRadius: 24)
    }
}

private extension View {
    func nativeGlassSurface(cornerRadius: CGFloat, tint: Color = .clear) -> some View {
        self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color(.systemBackground).opacity(0.72))
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(tint)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 10)
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
