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
        
    @State public var connected:Bool=false
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
                Button {
                    send(v:"off")
                } label: {
                    Label("Off",systemImage:"power").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
                
                Button {
                    send(v:"clear")
                } label: {
                    Label("Clear",systemImage:"clear.fill").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
                
                Button {
                    send(v:"enter")
                } label: {
                    Label("Enter",systemImage:"rectangle.righthalf.inset.fill.arrow.right").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
                
                Button {
                    send(v:"dnd")
                } label: {
                    Label("Do Not Disturb",systemImage:"triangle.inset.filled").frame(maxWidth:.infinity)
                }.buttonStyle(StateButtonStyle())
                
            }.onAppear(perform: {
                self.connect()
            })
        }
    }
                       
    func connect() {
                self.mqttClient.username = "dnd"
                self.mqttClient.password = "dnd"
                self.mqttClient.autoReconnect=true
                self.mqttClient.keepAlive = 60
                _ = self.mqttClient.connect()
                self.mqttClient.didConnectAck = { _, _ in
                    print("Connected")
                    self.connected=true
                    self.mqttClient.subscribe("dnd/0001/state")
                    self.mqttClient.didReceiveMessage = {
                        _, message, _ in
                        print(message.payload)
                    }
                    self.mqttClient.didDisconnect = {
                        _, error in
                            connected=false
                    }
                }
            }
    
    func send(v:String) {
        if !connected {
            self.connect()
        }
        self.mqttClient.publish("dnd/0001/status", withString:v, qos: .qos1, retained: true)
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
