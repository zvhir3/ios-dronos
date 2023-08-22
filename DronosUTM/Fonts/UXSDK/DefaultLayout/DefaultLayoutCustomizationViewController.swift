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
import DJIUXSDK
import DJISDK

// We subclass the DUXRootViewController to inherit all its behavior.
class DefaultLayoutCustomizationViewController: DUXDefaultLayoutViewController {
    
    var isContentViewSwitched = false
    
    var oldContentViewController: DUXFPVViewController?
    
    var fpvViewController: DUXFPVViewController!
    
    var isLiveStreaming = false
    
    var timer: Timer?
    
    @IBOutlet weak var startStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fpvViewController = DUXFPVViewController()
        
        // Initialize MQTT client
        //        mqtt = CocoaMQTT(clientID: "your-client-id", host: "your-mqtt-broker-host", port: 1883)
        //        mqtt.delegate = self // Set the delegate if needed
        //        mqtt.connect()
        //        let topic = "your-topic"
        //        let message = "Hello, MQTT!"
        //        mqtt.publish(topic, withString: message)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func close () {
        self.dismiss(animated: true) {
            
        }
    }
    
    
    // Override supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // Only support landscape orientation
    }
    
    
    // Toggle for the content view for our button.  This will swap between our red view controller and the fpv view controller.
    @IBAction func switchContent(_ sender: UIButton) {
        if isLiveStreaming {
            // Stop live streaming
            stopLiveStreaming(button: sender)
        } else {
            // Start live streaming
            startLiveStreaming(button: sender)
        }
    }
    
    
    func startLiveStreaming(button: UIButton) {
        isLiveStreaming = true
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Stop Live", for: .normal)
        
        let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
        
        DJISDKManager.keyManager()?.startListeningForChanges(on: locationKey!, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
            if newValue != nil {
                // DJIFlightControllerParamAircraftLocation is associated with a DJISDKLocation object
                let aircraftCoordinates = newValue!.value! as! CLLocation
           
                button.setTitle("Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) ", for: .normal)
                //print("Altitude: \(aircraftCoordinates.altitude) -  Speed: \(aircraftCoordinates.timestamp)")
                print("Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)")
   
            }
            else{
                print("No data")
            }
        })
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


