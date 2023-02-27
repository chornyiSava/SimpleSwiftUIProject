//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import SwiftUI

@main
struct TestTaskApp: App {
    
    // MARK: - Private Variables
    /// In bigger app this would be placed in a separate class that will hold all helpers and managers instances and will be used for dependency injections all over app
    private let parser: ParserProtocol = Parser()
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            MainScreen(
                parser: parser,
                networkManager: networkManager
            )
        }
    }
}
