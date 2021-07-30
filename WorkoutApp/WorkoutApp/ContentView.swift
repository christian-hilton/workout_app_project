//
//  ContentView.swift
//  WorkoutApp
//
//  Created by Christian Hilton on 7/14/21.
//

import SwiftUI

struct ContentView: View {
    func startRun() -> Void {
        return
    }
    
    func pause() -> Void {
        return
    }
    
    func end() -> Void {
        return
    }
    
    var body: some View {
        VStack {
            Text("WorkoutApp ⚡️")
            Spacer()
            Button("run 🏃‍♂️", action: startRun)
//                .padding(5)
            Button("bike 🚴‍♂️", action: startRun)
        }
        VStack {
            Text("WorkoutApp ⚡️")
            HStack {
                Text("Acceleration").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            Text("Raw Metrics")
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
                        }.padding(5)
            HStack {
                Text("Distance").font(.subheadline)
                            Spacer()
                            Text("X")
                                .font(.subheadline)
            }.padding(5)
//            Spacer()
            HStack{
                Button("Pause", action: startRun)
                Spacer()
                Button("End", action: startRun)
            }.padding(10)
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
