//
//  DetailsModel.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import Foundation

enum DetailsKeys: String, CaseIterable {
    case title
    case firstimg
    case secondimg
    case thirdimg
    case details
}

struct DetailsModel: Identifiable {
    
    // MARK: - Variables
    let id: UUID = UUID()
    let title: String?
    let firstImage: String?
    let secondImage: String?
    let thirdImage: String?
    let details: String?
    
    // MARK: - Inits
    init(
        title: String? = nil,
        firstImage: String? = nil,
        secondImage: String? = nil,
        thirdImage: String? = nil,
        details: String? = nil
    ) {
        self.title = title
        self.firstImage = firstImage
        self.secondImage = secondImage
        self.thirdImage = thirdImage
        self.details = details
    }
    
    init(stringComponents: [String: String]) {
        title = stringComponents[DetailsKeys.title.rawValue]
        firstImage = stringComponents[DetailsKeys.firstimg.rawValue]
        secondImage = stringComponents[DetailsKeys.secondimg.rawValue]
        thirdImage = stringComponents[DetailsKeys.thirdimg.rawValue]
        details = stringComponents[DetailsKeys.details.rawValue]
    }
    
}
