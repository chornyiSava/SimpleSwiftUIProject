//
//  MainScreenViewModel.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import Foundation

final class MainScreenViewModel: ObservableObject {
    
    // MARK: - Variables
    private let parser: ParserProtocol
    private let networkManager: NetworkManagerProtocol
    private var detailsImagesScreenViewModel: DetailsImagesScreenViewModel?
    var detailsImagesScreenUUID: UUID?
    
    // MARK: - Published Variables
    @Published private(set) var details = [DetailsModel]()
    @Published var isLoading: Bool = false
    
    // MARK: - Inits
    init(parser: ParserProtocol, networkManager: NetworkManagerProtocol) {
        self.parser = parser
        self.networkManager = networkManager
    }
    
    // MARK: - Logic
    func stopLoading() {
        isLoading = false
    }
    
    func loadData() {
        guard details.isEmpty else { return }
        isLoading = true
        guard let path = Bundle.main.path(forResource: "task", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let jsonStrings = jsonResult as? Array<String> else { return }
        let keysForParsing = DetailsKeys.allCases.compactMap { $0.rawValue }
        jsonStrings.forEach {
            let elements = parser.parse(baseString: $0, with: keysForParsing)
            details.append(DetailsModel(stringComponents: elements))
        }
        isLoading = false
    }
    
    func tappedItem(with id: UUID) {
        isLoading = true
        guard let detailsModel = details.first(where: { $0.id == id }) else {
            isLoading = false
            return
        }
        loadImages(from: detailsModel)
    }
    
    func getDetailsImagesScreenViewModel() -> DetailsImagesScreenViewModel {
        return detailsImagesScreenViewModel ?? DetailsImagesScreenViewModel(detailsImages: [])
    }
    
    func destroyDetailsImagesScreenViewModel() {
        detailsImagesScreenViewModel = nil
        detailsImagesScreenUUID = nil
    }
    
    // MARK: - Private logic
    private func loadImages(from detailsModel: DetailsModel) {
        Task(priority: .userInitiated) {
            async let firstImageDownloading = networkManager.downloadImage(with: detailsModel.firstImage ?? "")
            async let secondImageDownloading = networkManager.downloadImage(with: detailsModel.secondImage ?? "")
            async let thirdImageDownloading = networkManager.downloadImage(with: detailsModel.thirdImage ?? "")
            
            let allImages = try await (firstImageDownloading, secondImageDownloading, thirdImageDownloading)
            let detailsImages = [
                DetailsImage(imageData: allImages.0),
                DetailsImage(imageData: allImages.1),
                DetailsImage(imageData: allImages.2)
            ]
            await navigateToDetailsImagesScreen(with: detailsImages, uuid: detailsModel.id)
        }
    }
    
    @MainActor private func navigateToDetailsImagesScreen(with detailsImages: [DetailsImage], uuid: UUID) {
        detailsImagesScreenViewModel = DetailsImagesScreenViewModel(detailsImages: detailsImages)
        isLoading = false
        detailsImagesScreenUUID = uuid
    }
    
}
