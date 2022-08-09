//
//  ContentView.swift
//  DNDButton
//
//  Created by Dj Walker-Morgan on 08/08/2022.
//

import SwiftUI
import CocoaMQTT

struct ContentView: View {
    
    let mqttClient = CocoaMQTT(clientID: "dndbuttonswift", host: "jonah.local", port: 1883 )
    
    @State public var Status:Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.mqttClient.publish("dnd/state",withString:!Status ? "1":"0",
                                        qos:.qos1, retained: true)
            }, label: { Image(systemName: Status ? "mic.fill":"globe")
                    .imageScale(.large).frame(width: 200,height: 200)
                .foregroundColor(Status ? Color.red : Color.black)}).onAppear(perform: {
                    self.mqttClient.username="dnd"
                    self.mqttClient.password="dnd"
                    self.mqttClient.keepAlive=60
                    _=self.mqttClient.connect()
                    self.mqttClient.didConnectAck = { mqtt, ack in
                        self.mqttClient.subscribe("dnd/state")
                        self.mqttClient.didReceiveMessage = { mqtt, message, id in
                            Status=(message.string! as NSString).boolValue
                            
                        }
                        print("Done")
                    }
                }
                ).frame(width:200,height:200)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
