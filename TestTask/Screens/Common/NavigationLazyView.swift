//
//  NavigationLazyView.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-27.
//

import SwiftUI

/// This is used to avoid initialzing View before data is loaded
struct NavigationLazyView<Content: View>: View {
    
    // MARK: - Variables
    let build: () -> Content
    
    //MARK: - Init
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    // MARK: - Body
    var body: Content {
        build()
    }
    
}
