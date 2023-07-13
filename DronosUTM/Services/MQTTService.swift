//import CocoaMQTT
//
//class MQTTService: CocoaMQTTDelegate {
//    private var mqttClient: CocoaMQTT?
//    
//    func connect() {
//        let clientID = "your_client_id"
//        let host = "mqtt.example.com"
//        let port: UInt16 = 1883
//        
//        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
//        mqttClient?.delegate = self
//        
//        // Uncomment the following line if you need to provide username and password for authentication
//        // mqttClient?.username = "your_username"
//        // mqttClient?.password = "your_password"
//        
//        mqttClient?.connect()
//    }
//    
//    func publishLiveStreamData(data: Data, topic: String) {
//        mqttClient?.publish(data, onTopic: topic)
//    }
//    
//    // MARK: - CocoaMQTTDelegate
//    
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        if ack == .accept {
//            print("MQTT Connected")
//            
//            // Subscribe to specific topics if needed
//            // mqtt.subscribe("topic1")
//            // mqtt.subscribe("topic2")
//        } else {
//            print("MQTT Connection Failed")
//        }
//    }
//    
//    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
//        print("MQTT Message Published")
//    }
//    
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
//        print("MQTT Disconnected")
//    }
//}
