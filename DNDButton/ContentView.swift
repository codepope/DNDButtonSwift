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
            
            //            Image(systemName: Status ? "mic.fill" : "globe").resizable()
            //                .foregroundColor(Status ? Color.red : Color.black).padding().frame(maxWidth: .infinity, maxHeight: .infinity)
            //                .onTapGesture {
            //                    let newstatus = !Status ? "1" : "0"
            //                    print("Clck for \(newstatus)")
            //                    self.mqttClient.publish("dnd/0001/state", withString:!Status ? "1" : "0", qos: .qos1, retained: true)
            //                    print(self.mqttClient.connState)
            //                }
            Group {
                Button("Off") {
                    print("Off")
                }.background(RoundedRectangle(cornerRadius: 8).fill(.blue))
                    .foregroundColor(.black)
                
                Button("Clear") {
                    print("Clear")
                }.background(RoundedRectangle(cornerRadius: 8).fill(.black))
                    .foregroundColor(.white)
                
                Button("Enter") {
                    print("Enter")
                }.background(RoundedRectangle(cornerRadius: 8).fill(.green))
                    .foregroundColor(.black)
                
                Button("Do Not Disturb") {
                    print("Do Not Disturb")
                }.background(RoundedRectangle(cornerRadius: 8).fill(.red))
                    .foregroundColor(.white)
                
            }.padding(40)
                .frame(maxWidth: .infinity)
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
