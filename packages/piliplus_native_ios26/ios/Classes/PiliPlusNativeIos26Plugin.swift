import Flutter
import UIKit

public final class PiliPlusNativeIos26Plugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        let factory = NativeHomeViewFactory(messenger: messenger)
        registrar.register(factory, withId: "piliplus_native_ios26/home")

        let channel = FlutterMethodChannel(name: "piliplus_native_ios26/actions", binaryMessenger: messenger)
        let instance = PiliPlusNativeIos26Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openUrl":
            guard
                let arguments = call.arguments as? [String: Any],
                let urlString = arguments["url"] as? String,
                let url = URL(string: urlString)
            else {
                result(FlutterError(code: "bad_args", message: "Missing url", details: nil))
                return
            }

            DispatchQueue.main.async {
                UIApplication.shared.open(url)
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
