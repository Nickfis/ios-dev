//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Niklas Fischer on 27/8/22.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext   )
        }
    }
}
