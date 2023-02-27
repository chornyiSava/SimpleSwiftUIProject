//
//  DetailsImagesScreen.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-27.
//

import SwiftUI
import UIKit

struct DetailsImagesScreen: View {
    
    // MARK: - Variables
    @StateObject private var viewModel: DetailsImagesScreenViewModel
    
    // MARK: - Init
    init(viewModel: DetailsImagesScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            List(viewModel.detailsImages) { detailsImage in
                createImage(detailsImage.imageData)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.width
                    )
            }
        }
    }
    
    // MARK: - Private logic
    private func createImage(_ value: Data) -> Image {
        let songArtwork: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: songArtwork)
    }
    
}

private extension DetailsImagesScreen {
    struct Constants {
        static let titleFontSize: CGFloat = 16.0
        static let subTitleFontSize: CGFloat = 12.0
        static let progressViewSize: CGSize = CGSize(width: 2.0, height: 2.0)
    }
}

struct DetailsImagesScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailsImagesScreen(viewModel: DetailsImagesScreenViewModel(detailsImages: []))
    }
}

