//
//  DetailsImagesScreenViewModel.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-27.
//

import Foundation

struct DetailsImage: Identifiable {
    
    // MARK: - Variables
    let id: UUID = UUID()
    let imageData: Data
    
}

final class DetailsImagesScreenViewModel: ObservableObject {
    
    // MARK: - Published Variables
    @Published private(set) var detailsImages = [DetailsImage]()
    
    // MARK: - Inits
    init(detailsImages: [DetailsImage]) {
        self.detailsImages = detailsImages
    }
    
}
