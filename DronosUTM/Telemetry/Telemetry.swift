import SwiftUI
import DJISDK

struct TeelemetryContent: View {
    @State private var isListening = false
    @State private var telemetryText = ""
    
    var body: some View {
        VStack {
            Text(telemetryText)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: startStopListeningCoordinates) {
                Text(isListening ? "Stop Listening" : "Start Listening")
            }
            .padding()
        }
        .onAppear(perform: setupUI)
    }
    
    private func setupUI() {
        // Additional setup code could go here
    }
    
    private func startStopListeningCoordinates() {
        let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
        
        if isListening {
            DJISDKManager.keyManager()?.stopListening(on: locationKey!, ofListener: self)
            telemetryText = "Stopped fetching telemetry.."
            print("Stopped fetching Coordinates")
        } else {
            let locationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
            
            if isListening {
                // At anytime, you may stop listening to a key or to all key for a given listener
                DJISDKManager.keyManager()?.stopListening(on: locationKey!, ofListener: self)
                telemetryText = "Stopped fetching Coordinates.."
                print("Stopped fetching Coordinates")
            } else {
                // Start listening is as easy as passing a block with a key.
                // Note that start listening won't do a get. Your block will be executed
                // the next time the associated data is being pulled.
                DJISDKManager.keyManager()?.startListeningForChanges(on: locationKey!, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                    if newValue != nil {
                        // DJIFlightControllerParamAircraftLocation is associated with a DJISDKLocation object
                        let aircraftCoordinates = newValue!.value! as! CLLocation
                        
                        let batteryLevelKey = DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent)
                        DJISDKManager.keyManager()?.getValueFor(batteryLevelKey!, withCompletion: { [self] (value: DJIKeyedValue?, error: Error?) in
                            
                            //print("Altitude: \(aircraftCoordinates.altitude) -  Speed: \(aircraftCoordinates.timestamp)")
                            telemetryText = "Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)"
                            
                            print("------ TELEMETRY START-----")
                            
                            print("Lat: \(aircraftCoordinates.coordinate.latitude) Long: \(aircraftCoordinates.coordinate.longitude) Alt: \(aircraftCoordinates.altitude) Speed: \(aircraftCoordinates.speed) Timestamp: \(aircraftCoordinates.timestamp)")
                            
                            print("------ TELEMETRY END-----")
                            
                            return
                        })
                        
                     
                        
                       
                    }
                    else{
                        print("No data")
                    }
                })
                telemetryText = "Started fetching telemetry..";
                print("Started fetching telemetry")
            }
        }
        isListening.toggle()
    }
}
