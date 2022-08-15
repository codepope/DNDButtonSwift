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

    let mqttClient = CocoaMQTT(clientID: "dndbuttonswift", host: "jonah.local", port: 1883)

    @State public var Status: Bool = false

    var body: some View {
      VStack(alignment: .leading) {
        Image(systemName: Status ? "mic.fill" : "globe").resizable()
              .foregroundColor(Status ? Color.red : Color.black).padding().frame(maxWidth: .infinity, maxHeight: .infinity).onTapGesture {
              print("Clck")
              self.mqttClient.publish("dnd/state", withString:!Status ? "1" : "0", qos: .qos1, retained: true)
            
        }
    }.onAppear(perform: {
      self.mqttClient.username = "dnd"
      self.mqttClient.password = "dnd"
      self.mqttClient.autoReconnect=true
      self.mqttClient.keepAlive = 60
      _ = self.mqttClient.connect()
      self.mqttClient.didConnectAck = { _, _ in
          self.mqttClient.subscribe("dnd/state")
          self.mqttClient.didReceiveMessage = {
              _, message, _ in Status = (message.string! as NSString).boolValue
          }
          print("Done")
      }
  })}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 500.0, height: 00.0)
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
