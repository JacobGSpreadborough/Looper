//
//  HelpView.swift
//  Looper
//
//  Created by Jacob Spreadborough on 11/11/25.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationView {
            List{
                NavigationLink(destination: HelpSubView(imageName: "LooperHelp", title: "Looper Help"), label: {
                    HStack {
                        Image(systemName: "repeat")
                        Text("Looper")
                    }
                })
                NavigationLink(destination: HelpSubView(imageName: "LibraryHelp", title: "Library Help"), label: {
                    HStack {
                        Image(systemName: "books.vertical")
                        Text("Library")
                    }
                })
                NavigationLink(destination: HelpSubView(imageName: "EQHelp", title: "Equalization Help"), label: {
                    HStack {
                        Image(systemName: "slider.vertical.3")
                        Text("Equalization")
                    }
                })
                NavigationLink(destination: ImportAudioHelpView(), label: {
                    HStack {
                        Image(systemName: "music.note")
                        Text("Importing Audio")
                    }
                })
                NavigationLink(destination: ContactView(), label: {
                    HStack {
                        Image(systemName: "person")
                        Text("Contact Support")
                    }
                })
            }
            .navigationTitle("Help")
        }
    }
}

struct HelpSubView: View {
    
    var imageName: String
    var title: String
    
    var body: some View{
        NavigationView {
            ScrollView(.vertical) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    //.padding()
            }
        }
        .navigationTitle(title)
    }
}


struct ImportAudioHelpView: View {
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    Image("ImportAudioHelp1")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Image("ImportAudioHelp2")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .navigationTitle("Importing Audio Help")
    }
}

struct ContactView: View {
    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    print("email...")
                }, label: {
                    HStack {
                        Image(systemName: "envelope")
                        Text("support@spreadborough.org")
                    }
                })
                Button(action: {
                    print("website...")
                }, label: {
                    HStack {
                        Image(systemName: "globe")
                        Text("spreadborough.org/looper")
                    }
                })
            }
            .navigationTitle("Contact")
        }
    }
}

#Preview {
    HelpView()
    //ContactView()
}
