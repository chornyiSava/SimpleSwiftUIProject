//
//  ContentView.swift
//  TestTask
//
//  Created by Sava Chornyi on 2023-02-26.
//

import SwiftUI

struct MainScreen: View {
    
    // MARK: - Variables
    @StateObject private var viewModel: MainScreenViewModel
    @State private var navigateToDetailsImagesScreen: Bool = false
    
    // MARK: - Init
    init(parser: ParserProtocol, networkManager: NetworkManagerProtocol) {
        _viewModel = StateObject(wrappedValue: MainScreenViewModel(
            parser: parser,
            networkManager: networkManager)
        )
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                detailsList()
                if viewModel.isLoading {
                    overlayLoadingView()
                }
            }
            .onAppear {
                viewModel.destroyDetailsImagesScreenViewModel()
                viewModel.stopLoading()
                viewModel.loadData()
            }
        }
    }
    
    // MARK: - Private logic
    private func detailsList() -> some View {
        List(viewModel.details) { detailsItem in
            /// In general I prefer to use Coordinators, but not in case of 2 screens app
            NavigationLink(
                destination: NavigationLazyView(DetailsImagesScreen(viewModel: viewModel.getDetailsImagesScreenViewModel())),
                tag: detailsItem.id,
                selection: $viewModel.detailsImagesScreenUUID) {
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text(detailsItem.title ?? "")
                            .font(.system(size: Constants.titleFontSize, weight: .bold))
                            .multilineTextAlignment(.leading)
                        
                        Text(detailsItem.details ?? "")
                            .font(.system(size: Constants.subTitleFontSize))
                            .multilineTextAlignment(.leading)
                    }
                    .onTapGesture {
                        viewModel.tappedItem(with: detailsItem.id)
                    }
                }
        }
    }
    
    private func overlayLoadingView() -> some View {
        ZStack(alignment: .center) {
            Color.black
                .opacity(Constants.overlayOpacity)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(Constants.progressViewSize)
        }
        .ignoresSafeArea(.all)
    }
    
}

private extension MainScreen {
    struct Constants {
        static let titleFontSize: CGFloat = 16.0
        static let subTitleFontSize: CGFloat = 12.0
        static let progressViewSize: CGSize = CGSize(width: 2.0, height: 2.0)
        static let overlayOpacity: Double = 0.3
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(
            parser: Parser(),
            networkManager: NetworkManager()
        )
    }
}
