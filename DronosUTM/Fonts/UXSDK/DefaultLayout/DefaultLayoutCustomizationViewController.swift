//
//  DefaultLayoutCustomizationViewController.swift
//  UXSDK Sample
//
//  MIT License
//
//  Copyright © 2018-2020 DJI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


import UIKit
import CocoaMQTT
import DJIUXSDK
import DJISDK

// We subclass the DUXRootViewController to inherit all its behavior.
class DefaultLayoutCustomizationViewController: DUXDefaultLayoutViewController {

    var isContentViewSwitched = false
    
    var oldContentViewController: DUXFPVViewController?
    
    var fpvViewController: DUXFPVViewController!
    
    var isLiveStreaming = false
    
    var timer: Timer?
    
    var isListening = false
    
    // Dronos MQTT Broker
    let defaultHost = "emqx-mqtt.dronos.ai"
    
    var mqtt5: CocoaMQTT5?
    var animal: String?
    var mqttVesion: String?

    
    @IBAction func connectToServer() {
        if mqttVesion == "5.0"{
            _ = mqtt5!.connect()
        }
    }
    
    func sendAuthToServer(){
        let authProperties = MqttAuthProperties()
        mqtt5!.auth(reasonCode: CocoaMQTTAUTHReasonCode.continueAuthentication, authProperties: authProperties)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpvViewController = DUXFPVViewController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        animal = "ZAHIR"
        mqttVesion = "5.0"
        
        mqttSettingList()
        
        print("welcome to MQTT \(String(describing: mqttVesion))  \(String(describing: animal))")
        
        connectToServer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func switchContent(_ sender: UIButton) {
        
        if isLiveStreaming {
            // Stop live streaming
            print("stop")
        } else {
            mqttSettingList()
            connectToServer()
            
            let publishProperties = MqttPublishProperties()
            publishProperties.contentType = "JSON"
            
            mqtt5?.publish("thing/product/1581F5FHB22A70020AD8/osd", withString: "START PUBLISH", qos: .qos0, DUP: true, retained: false, properties: publishProperties)
            
            // Start live streaming
            print("Publish telemetry")
            
            let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
            
            if isListening {
                DJISDKManager.keyManager()?.stopListening(on: locationKey!, ofListener: self)
                print("Stopped fetching Coordinates")
            } else {
                let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
                
                if isListening {
                    // At anytime, you may stop listening to a key or to all key for a given listener
                    DJISDKManager.keyManager()?.stopListening(on: locationKey!, ofListener: self)
                    print("Stopped fetching Coordinates")
                } else {
                    // Start listening is as easy as passing a block with a key.
                    // Note that start listening won't do a get. Your block will be executed
                    // the next time the associated data is being pulled.
                    
                   
                    
                    DJISDKManager.keyManager()?.startListeningForChanges(on: locationKey!, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                        
                        self.mqtt5?.publish("thing/product/1581F5FHB22A70020AD8/osd", withString: "B", qos: .qos0, DUP: true, retained: false, properties: publishProperties)
                        if newValue != nil {
                            // DJIFlightControllerParamAircraftLocation is associated with a DJISDKLocation object
                            let aircraftCoordinates = newValue!.value! as! CLLocation
                            
                            let batteryLevelKey = DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent)
                            DJISDKManager.keyManager()?.getValueFor(batteryLevelKey!, withCompletion: { [self] (value: DJIKeyedValue?, error: Error?) in
                                
                                print("Altitude: \(aircraftCoordinates.altitude) -  Speed: \(aircraftCoordinates.timestamp)")
//                                telemetryText = "Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)"
                                
                                print("------ TELEMETRY START-----")
                                
                                print("Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)")

                              
                               
                                
                                print("------ TELEMETRY END-----")
                                
                                
                                print("------ START PUBLISH -----")
                                
                                
                                self.mqtt5?.publish("thing/product/1581F5FHB22A70020AD8/osd", withString: "C", qos: .qos0, DUP: true, retained: false, properties: publishProperties)
                                
                                print("------ END PUBLISH -----")
                                return
                            })
                            
                         
                            
                           
                        }
                        else{
                            print("No data")
                        }
                    })
                    print("Started fetching telemetry")
                }
            }
            isListening.toggle()
        }
    }
    
    
    func mqttSettingList(){
        mqttWebsocketSSLSetting()
    }

    func mqttWebsocketSSLSetting() {
      if mqttVesion == "5.0" {
            
            let clientID = "Mobile UTM " + String(ProcessInfo().processIdentifier)
            let websocket = CocoaMQTTWebSocket(uri: "/mqtt")
            mqtt5 = CocoaMQTT5(clientID: clientID, host: defaultHost, port: 8085, socket: websocket)
            
            let connectProperties = MqttConnectProperties()
            connectProperties.topicAliasMaximum = 0
            connectProperties.sessionExpiryInterval = 0
            connectProperties.receiveMaximum = 100
            connectProperties.maximumPacketSize = 500
            
            mqtt5!.connectProperties = connectProperties
            
            mqtt5!.enableSSL = true
            mqtt5!.username = ""
            mqtt5!.password = ""
            mqtt5!.willMessage = CocoaMQTT5Message(topic: "/will", string: "dieout")
            mqtt5!.keepAlive = 60
            mqtt5!.delegate = self
            
        }
        
        
    }
    
    
    @IBOutlet weak var startStopButton: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func close () {
        self.dismiss(animated: true) {
            print("sini la bro")
        }
    }
    
    
    // Override supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // Only support landscape orientation
    }


    func startLiveStreaming(button: UIButton) {
//
    }
    
    func stopLiveStreaming(button: UIButton) {
        isLiveStreaming = false
        button.setTitleColor(.green, for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.green.cgColor
        button.setTitle("Go Live", for: .normal)
        
        // Stop the timer
        timer?.invalidate()
        timer = nil
    }
    
    @objc func printToTerminal() {
        print("Live streaming is active...")
    }
    //
    //    var isLiveStreaming = false
    //    var timer: Timer?
    //
    //    @IBOutlet weak var startStopButton: UIButton!
    //
    //    // MARK: - Lifecycle
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        configureUI()
    //    }
    //
    //    // MARK: - Configuration
    //
    //    func configureUI() {
    //        setStatusBarStyle(.lightContent)
    //        setSupportedInterfaceOrientations(.landscape)
    //    }
    //
    //    func setStatusBarStyle(_ style: UIStatusBarStyle) {
    //        overrideStatusBarStyle = style
    //        setNeedsStatusBarAppearanceUpdate()
    //    }
    //
    //    func setSupportedInterfaceOrientations(_ orientations: UIInterfaceOrientationMask) {
    //        overrideSupportedInterfaceOrientations = orientations
    //    }
    //
    //    // MARK: - Button Actions
    //
    //    @IBAction func switchContent(_ sender: UIButton) {
    //        isLiveStreaming.toggle()
    //        updateLiveStreamingUI()
    //
    //        if isLiveStreaming {
    //            startLiveStreaming()
    //        } else {
    //            stopLiveStreaming()
    //        }
    //    }
    //
    //    func updateLiveStreamingUI() {
    //        let color: UIColor = isLiveStreaming ? .red : .green
    //        startStopButton.setTitleColor(color, for: .normal)
    //        startStopButton.layer.borderWidth = 2.0
    //        startStopButton.layer.borderColor = color.cgColor
    //        startStopButton.setTitle(isLiveStreaming ? "Stop Live" : "Go Live", for: .normal)
    //    }
    //
    //    func startLiveStreaming() {
    //        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(printToTerminal), userInfo: nil, repeats: true)
    //    }
    //
    //    func stopLiveStreaming() {
    //        timer?.invalidate()
    //        timer = nil
    //    }
    //
    //    @objc func printToTerminal() {
    //        print("Live streaming is active...")
    //    }
    
}


extension DefaultLayoutCustomizationViewController: CocoaMQTT5Delegate {
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveDisconnectReasonCode reasonCode: CocoaMQTTDISCONNECTReasonCode) {
        print("disconnect res : \(reasonCode)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveAuthReasonCode reasonCode: CocoaMQTTAUTHReasonCode) {
        print("auth res : \(reasonCode)")
    }
    
    // Optional ssl CocoaMQTT5Delegate
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        TRACE("trust: \(trust)")
        completionHandler(true)
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didConnectAck ack: CocoaMQTTCONNACKReasonCode, connAckData: MqttDecodeConnAck?) {
        TRACE("ack: \(ack)")
        
        if ack == .success {
            if(connAckData != nil){
                print("properties maximumPacketSize: \(String(describing: connAckData!.maximumPacketSize))")
                print("properties topicAliasMaximum: \(String(describing: connAckData!.topicAliasMaximum))")
            }
            
            mqtt5.subscribe("thing/product/1581F5FHB22A70020AD8/osd", qos: CocoaMQTTQoS.qos0)

            print("YEAYY CONNECTED TO DRONOS MQTT BROKER")
            
            let publishProperties = MqttPublishProperties()
            publishProperties.contentType = "JSON"
            
            mqtt5.publish("thing/product/1581F5FHB22A70020AD8/osd", withString: "START PUBLISH", qos: .qos0, DUP: true, retained: false, properties: publishProperties)
            
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didStateChangeTo state: CocoaMQTTConnState) {
        TRACE("new state: \(state)")
        if state == .disconnected {
            
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishMessage message: CocoaMQTT5Message, id: UInt16) {
        TRACE("message: \(message.description), id: \(id)")
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishAck id: UInt16, pubAckData: MqttDecodePubAck?) {
        TRACE("id: \(id)")
        if(pubAckData != nil){
            print("pubAckData reasonCode: \(String(describing: pubAckData!.reasonCode))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishRec id: UInt16, pubRecData: MqttDecodePubRec?) {
        TRACE("id: \(id)")
        if(pubRecData != nil){
            print("pubRecData reasonCode: \(String(describing: pubRecData!.reasonCode))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didPublishComplete id: UInt16,  pubCompData: MqttDecodePubComp?){
        TRACE("id: \(id)")
        if(pubCompData != nil){
            print("pubCompData reasonCode: \(String(describing: pubCompData!.reasonCode))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didReceiveMessage message: CocoaMQTT5Message, id: UInt16, publishData: MqttDecodePublish?){
        if(publishData != nil){
            print("publish.contentType \(String(describing: publishData!.contentType))")
        }
        
        TRACE("message: \(message.string.description), id: \(id)")
        let name = NSNotification.Name(rawValue: "MQTTMessageNotification" + animal!)
        
        NotificationCenter.default.post(name: name, object: self, userInfo: ["message": message.string!, "topic": message.topic, "id": id, "animal": animal as Any])
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didSubscribeTopics success: NSDictionary, failed: [String], subAckData: MqttDecodeSubAck?) {
        TRACE("subscribed: \(success), failed: \(failed)")
        if(subAckData != nil){
            print("subAckData.reasonCodes \(String(describing: subAckData!.reasonCodes))")
        }
    }
    
    func mqtt5(_ mqtt5: CocoaMQTT5, didUnsubscribeTopics topics: [String], unsubAckData: MqttDecodeUnsubAck?) {
        TRACE("topic: \(topics)")
        if(unsubAckData != nil){
            print("unsubAckData.reasonCodes \(String(describing: unsubAckData!.reasonCodes))")
        }
        print("----------------------")
    }
    
    func mqtt5DidPing(_ mqtt5: CocoaMQTT5) {
        TRACE()
    }
    
    func mqtt5DidReceivePong(_ mqtt5: CocoaMQTT5) {
        TRACE()
    }
    
    func mqtt5DidDisconnect(_ mqtt5: CocoaMQTT5, withError err: Error?) {
        TRACE("\(err.description)")
        let name = NSNotification.Name(rawValue: "MQTTMessageNotificationDisconnect")
        NotificationCenter.default.post(name: name, object: nil)
    }
}

extension DefaultLayoutCustomizationViewController {
    func TRACE(_ message: String = "", fun: String = #function) {
        let names = fun.components(separatedBy: ":")
        var prettyName: String
        if names.count == 2 {
            prettyName = names[0]
        } else {
            prettyName = names[1]
        }
        
        if fun == "mqttDidDisconnect(_:withError:)" {
            prettyName = "didDisconnect"
        }
        
        print("[TRACE] [\(prettyName)]: \(message)")
    }
}


extension Optional {
    // Unwrap optional value for printing log only
    var description: String {
        if let self = self {
            return "\(self)"
        }
        return ""
    }
}



