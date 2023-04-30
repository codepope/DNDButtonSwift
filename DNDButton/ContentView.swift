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
                }.background(RoundedRectangle(cornerRadius: 8).fill(.gray).padding(-30))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                
                Button {
                    print("Clear")
                    self.mqttClient.publish("dnd/0001/status", withString:"clear", qos: .qos1, retained: true)
                } label:{
                    Text("Clear").frame(maxWidth: .infinity)
                }.background(RoundedRectangle(cornerRadius: 8).fill(.black).padding(-30))
                    .foregroundColor(.white)
                
                Button {
                    print("Enter")
                    self.mqttClient.publish("dnd/0001/status", withString:"enter", qos: .qos1, retained: true)
                }label:{
                    Text("Enter").frame(maxWidth: .infinity)
                }.background(RoundedRectangle(cornerRadius: 8).fill(.green).padding(-30))
                    .foregroundColor(.black)
                
                Button {
                    self.mqttClient.publish("dnd/0001/status", withString:"dnd", qos: .qos1, retained: true)
                    print("Do Not Disturb")
                }label:{
                    Text("Do Not Disturb").frame(maxWidth: .infinity)
                }.background(RoundedRectangle(cornerRadius: 8).fill(.red).padding(-30))
                    .foregroundColor(.black)
                
                
            }.padding(40)
                .font(.system(size: 50, weight: Font.Weight.bold))
            
        }.fixedSize().onAppear(perform: {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 100.0, height: 100.0)
    }
}

//            Button(action: {
//
//            }, label: {
//                HStack {
//                    Text("Light")
//                    Image(systemName: Status ? "mic.fill" : "globe")
//                        .foregroundColor(Status ? Color.red : Color.black).imageScale(.large)
//                    Text(Status ? "On" : "Off")
//                }.frame(minWidth: 200, maxWidth: .infinity, minHeight:.infinity)
//            }
//            )
