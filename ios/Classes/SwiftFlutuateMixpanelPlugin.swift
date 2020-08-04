import Flutter
import UIKit
import Mixpanel

public class SwiftFlutuateMixpanelPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutuate_mixpanel",
                                           binaryMessenger: registrar.messenger())
        let instance = SwiftFlutuateMixpanelPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInstance":
            self.getInstance(call: call, result: result)
            break
        case "flush":
            self.flush(result: result)
            break
        case "track":
            self.track(call: call, result: result)
            break
        case "trackMap":
            self.trackMap(call: call, result: result)
            break
        case "getDeviceInfo":
            self.getDeviceInfo(result: result)
            break
        case "getDistinctId":
            self.getDistinctId(result: result)
            break
        case "optInTracking":
            self.optInTracking(result: result)
            break
        case "optOutTracking":
            self.optOutTracking(result: result)
            break
        case "reset":
            self.reset(result: result)
            break
        case "identify":
            self.identify(call: call, result: result)
            break
        case "enableLogging":
            self.enableLogging(call: call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    //http://online.swiftplayground.run/
    //https://developer.mixpanel.com/docs/swift
    //https://api.flutter.dev/objcdoc/Classes/FlutterMethodChannel.html
    //https://stackoverflow.com/questions/50078947/how-to-implement-a-flutterplugins-method-handler-in-swift
    //https://stackoverflow.com/questions/57664458/how-to-use-passed-parameters-in-swift-setmethodcallhandler-self-methodnamere
    
    private func getInstance(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [:]
        
        guard let token = arguments["token"] as? String else {
            return result(FlutterError(code: "", message: "Missing `token` argument", details: nil))
        }
        
        let instance: MixpanelInstance
        
        if let optOutTrackingDefault = arguments["optOutTrackingDefault"] as? Bool {
            instance = Mixpanel.initialize(token: token, optOutTrackingByDefault: optOutTrackingDefault)
        } else {
            instance = Mixpanel.initialize(token: token)
        }
        
        return result(instance.name)
    }
    
    private func flush(result: @escaping FlutterResult) {
        Mixpanel.mainInstance().flush {
            result(nil)
        }
    }
    
    private func track(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [:]
        
        let eventName = arguments["eventName"] as? String
        let properties = arguments["properties"] as? Properties
        
        Mixpanel.mainInstance().track(event: eventName, properties: properties)
        
        result(nil)
    }
    
    private func trackMap(call: FlutterMethodCall, result: @escaping FlutterResult) {
        track(call: call, result: result)
    }
    
    private func getDeviceInfo(result: @escaping FlutterResult) {
        //TODO verify is exists// let map = Mixpanel.mainInstance().getDeviceInfo() as? Dictionary<String, String>
        let map: [String:String] = [:]
        
        result(map);
    }
    
    private func getDistinctId(result: @escaping FlutterResult) {
        result(Mixpanel.mainInstance().distinctId);
    }
    
    private func optInTracking(result: @escaping FlutterResult) {
        Mixpanel.mainInstance().optInTracking()
        
        result(nil)
    }
    
    private func optOutTracking(result: @escaping FlutterResult) {
        Mixpanel.mainInstance().optOutTracking()
        
        result(nil)
    }
    
    private func reset(result: @escaping FlutterResult) {
        Mixpanel.mainInstance().reset()
        
        result(nil)
    }
    
    private func identify(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String : Any] ?? [:]
        
        guard let distinctId = arguments["distinctId"] as? String else {
            return result(FlutterError(code: "", message: "Missing `distinctId` argument", details: nil))
        }
        
        Mixpanel.mainInstance().identify(distinctId: distinctId);
        
        result(nil)
    }
    
    private func enableLogging(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let enable = call.arguments as? Bool else {
            return result(FlutterError(code: "", message: "Missing boolean argument", details: nil))
        }
        
        Mixpanel.mainInstance().loggingEnabled = enable
        
        result(nil)
    }
}
