//
//  ContentView.swift
//  DNDButton
//
//  Created by Dj Walker-Morgan on 08/08/2022.
//

import CocoaMQTT
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    let mqttClient = CocoaMQTT(clientID: "dndbuttonswift-" + String(ProcessInfo().processIdentifier), host: "jonah.local", port: 1883)
    
    @State public var Status: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                Button {
                    print("Off")
                    self.mqttClient.publish("dnd/0001/status", withString:"off", qos: .qos1, retained: true)
                } label: {
                    Text("Off").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
        
                Button {
                    print("Clear")
                    self.mqttClient.publish("dnd/0001/status", withString:"clear", qos: .qos1, retained: true)
                } label: {
                    Text("Clear").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())

                Button {
                    print("Enter")
                    self.mqttClient.publish("dnd/0001/status", withString:"enter", qos: .qos1, retained: true)
                } label: {
                    Text("Enter").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())

                Button {
                    self.mqttClient.publish("dnd/0001/status", withString:"dnd", qos: .qos1, retained: true)
                    print("Do Not Disturb")
                } label: {
                    Text("Do Not Disturb").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
                
            }.onAppear(perform: {
                print("Appears")
                self.mqttClient.username = "dnd"
                self.mqttClient.password = "dnd"
                self.mqttClient.autoReconnect=true
                self.mqttClient.keepAlive = 60
                _ = self.mqttClient.connect()
                self.mqttClient.didConnectAck = { _, _ in
                    print("Connected")
                    self.mqttClient.subscribe("dnd/0001/state")
                    self.mqttClient.didReceiveMessage = {
                        _, message, _ in
                        Status = (message.string! as NSString).boolValue
                        print(Status)
                    }
                    self.mqttClient.didDisconnect = {
                        _, error in print("Disconnected \(error)")
                    }
                }
            }
            )
        }
    }
}

struct StateButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.background(Color(red:0,green:0,blue:0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(maxWidth:.infinity)
            .padding()
            .font(.largeTitle)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
                  .animation(.easeOut(duration: 0.2), value: configuration.isPressed)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 100.0, height: 100.0)
    }
}
