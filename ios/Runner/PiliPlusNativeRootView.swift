import SwiftUI

struct PiliPlusNativeRootView: View {
    @State private var selectedTab = NativeTab.home

    var body: some View {
        TabView(selection: $selectedTab) {
            NativeHomeScreen()
                .tabItem { Label("首页", systemImage: "house.fill") }
                .tag(NativeTab.home)
            NativeDynamicScreen()
                .tabItem { Label("动态", systemImage: "bolt.circle.fill") }
                .tag(NativeTab.dynamic)
            NativePopularScreen()
                .tabItem { Label("热门", systemImage: "flame.fill") }
                .tag(NativeTab.popular)
            NativeProfileScreen()
                .tabItem { Label("我的", systemImage: "person.crop.circle.fill") }
                .tag(NativeTab.profile)
        }
        .tint(.pink)
    }
}

enum NativeTab: Hashable {
    case home, dynamic, popular, profile
}

struct NativeVideo: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
    let metric: String

    static let samples: [NativeVideo] = [
        .init(title: "推荐视频 · SwiftUI 原生卡片", subtitle: "PiliPlus Native", symbol: "play.rectangle.fill", tint: .pink, metric: "128.6万"),
        .init(title: "番剧更新 · 原生列表", subtitle: "今日更新", symbol: "sparkles.tv.fill", tint: .purple, metric: "42.1万"),
        .init(title: "直播精选 · iOS 控件", subtitle: "正在直播", symbol: "dot.radiowaves.left.and.right", tint: .red, metric: "8.9万"),
        .init(title: "热门剪辑 · SwiftUI Grid", subtitle: "全站热门", symbol: "flame.fill", tint: .orange, metric: "56.3万"),
        .init(title: "UP 主动态 · 原生导航", subtitle: "关注更新", symbol: "person.2.fill", tint: .blue, metric: "12.4万"),
        .init(title: "收藏推荐 · iOS 风格", subtitle: "稍后再看", symbol: "star.fill", tint: .yellow, metric: "3.7万")
    ]
}

struct NativeHomeScreen: View {
    @State private var query = ""
    @State private var selectedCategory = "推荐"
    private let categories = ["推荐", "热门", "番剧", "直播", "动态"]
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    hero
                    SearchField(text: $query)
                    categoryPicker
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(NativeVideo.samples) { video in
                            NativeVideoCard(video: video)
                        }
                    }
                }
                .padding(16)
            }
            .background(NativeBackground())
            .navigationTitle("PiliPlus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { } label: { Image(systemName: "bell.badge.fill") }
                        .buttonStyle(.bordered)
                        .clipShape(Circle())
                }
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(systemName: "play.tv.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.pink)
                    .frame(width: 64, height: 64)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text("原生 iOS 首页").font(.largeTitle.bold())
                    Text("SwiftUI · UIKit · TabView · NavigationStack")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            HStack(spacing: 10) {
                NativeMetric(title: "播放", value: "12.8k")
                NativeMetric(title: "更新", value: "248")
                NativeMetric(title: "收藏", value: "98")
            }
        }
        .padding(18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.86)) { selectedCategory = category }
                    } label: {
                        Text(category)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .foregroundStyle(selectedCategory == category ? .white : .primary)
                            .background(selectedCategory == category ? Color.pink : Color.clear, in: Capsule())
                            .background(.thinMaterial, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct SearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("搜索视频、番剧、UP 主", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button { text = "" } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary) }
                    .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct NativeMetric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value).font(.headline)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NativeVideoCard: View {
    let video: NativeVideo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(LinearGradient(colors: [video.tint.opacity(0.75), .purple.opacity(0.45), .blue.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .aspectRatio(16 / 10, contentMode: .fit)
                    .overlay { Image(systemName: video.symbol).font(.system(size: 36, weight: .semibold)).foregroundStyle(.white.opacity(0.9)) }
                Label(video.metric, systemImage: "play.fill")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.24), in: Capsule())
                    .padding(10)
            }
            Text(video.title).font(.subheadline.weight(.semibold)).lineLimit(2)
            Text(video.subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct NativeDynamicScreen: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(NativeVideo.samples) { video in
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(video.title).font(.headline)
                            Text("刚刚更新 · \(video.metric) 播放").font(.caption).foregroundStyle(.secondary)
                        }
                    } icon: { Image(systemName: video.symbol).foregroundStyle(video.tint) }
                }
            }
            .navigationTitle("动态")
        }
    }
}

struct NativePopularScreen: View {
    var body: some View {
        NavigationStack {
            List(NativeVideo.samples.indices, id: \.self) { index in
                HStack(spacing: 14) {
                    Text("\(index + 1)").font(.title2.bold()).foregroundStyle(index < 3 ? .pink : .secondary).frame(width: 34)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NativeVideo.samples[index].title)
                        Text(NativeVideo.samples[index].subtitle).font(.caption).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("热门")
        }
    }
}

struct NativeProfileScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill").font(.system(size: 54)).foregroundStyle(.pink)
                        VStack(alignment: .leading) {
                            Text("PiliPlus 用户").font(.headline)
                            Text("原生 iOS 个人中心").foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                Section("功能") {
                    Label("历史记录", systemImage: "clock.arrow.circlepath")
                    Label("我的收藏", systemImage: "star.fill")
                    Label("下载管理", systemImage: "arrow.down.circle.fill")
                    Label("设置", systemImage: "gearshape.fill")
                }
            }
            .navigationTitle("我的")
        }
    }
}

struct NativeBackground: View {
    var body: some View {
        LinearGradient(colors: [.pink.opacity(0.16), .blue.opacity(0.08), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}