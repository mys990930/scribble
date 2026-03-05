import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let shareChannelName = "scribble/share_intent"
  private var pendingShare: [String: Any?]? = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: shareChannelName,
        binaryMessenger: controller.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] call, result in
        guard let self else {
          result(nil)
          return
        }

        switch call.method {
        case "consumePendingShare":
          let payload = self.pendingShare
          self.pendingShare = nil
          result(payload)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    pendingShare = buildPayload(text: nil, url: url.absoluteString, fileUris: [])
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let webpageURL = userActivity.webpageURL?.absoluteString {
      pendingShare = buildPayload(text: nil, url: webpageURL, fileUris: [])
    }

    return super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )
  }

  private func buildPayload(text: String?, url: String?, fileUris: [String]) -> [String: Any?] {
    let hasText = !(text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    let hasUrl = !(url?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    let hasFiles = !fileUris.isEmpty

    let type: String
    if (hasText && hasUrl) || (hasText && hasFiles) || (hasUrl && hasFiles) {
      type = "mixed"
    } else if hasUrl {
      type = "url"
    } else if hasText {
      type = "text"
    } else if hasFiles {
      type = "file"
    } else {
      type = "text"
    }

    return [
      "type": type,
      "text": text,
      "url": url,
      "fileUris": fileUris,
      "mimeType": nil,
      "sourceApp": nil,
    ]
  }
}
