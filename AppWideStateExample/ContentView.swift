//
//  ContentView.swift
//  AppWideStateExample
//
//  Created by TI Digital on 27/06/22.
//

import SwiftUI
import Factory

struct ContentView: View {
    
    @Injected(Container.appStateContainer) private var container
    @Injected(Container.toastState) private var toastState
    @State var navigate: Bool = false
    @State var showFullscreen = false
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(isActive: $navigate, destination: {
                    SecondView()
                }, label: {})
                Button(action: {
                    toastState.toastState = .biasa
                }, label: {
                    Text("show toast dong")
                })
                Button(action: {
                    navigate = true
                }, label: {
                    Text("pindah page 2")
                })
                Button(action: {
                    self.showFullscreen = true
                }, label: {
                    Text("pindah fullscreen")
                })
            }
            .navigationTitle("page 1")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showFullscreen, content: {
                FullScreenCoverSatu()
                    .asRootView()
            })
        }
        .asRootView()
        .ignoresSafeArea()
    }
}

struct FullScreenCoverSatu: View {
    @Injected(Container.appStateContainer) private var container
    @State private var navigate = false
    var body: some View {
        NavigationView {
            VStack {
                Text("full screen cover 1")
                Button(action: {
                    self.container.toastState.toastState = .biasa
                }, label: {
                    Text("Show Toast")
                })
                NavigationLink(isActive: $navigate, destination: {
                    FullScreenCoverDua()
                }, label: {
                })
                Button(action: {
                    self.navigate = true
                }, label: {
                    Text("navigate to full screen cover 2")
                })
            }
        }
    }
}

struct FullScreenCoverDua: View {
    private let container = Container.appStateContainer()
    var body: some View {
        VStack {
            Text("full screen cover 2")
            Button(action: {
                self.container.toastState.toastState = .biasa
            }, label: {
                Text("Show Toast")
            })
        }
    }
}

struct SecondView: View {
    private let container = Container.appStateContainer()
    @StateObject var viewModel: ViewModel = ViewModel()
    var body: some View {
        VStack {
            Button(action: {
                viewModel.onShowToastTap()
            }, label: {
                Text("show toast tapi dri page 2")
            })
            Button(action: {
                withAnimation {
                    viewModel.onButtonTap()
                }
                
            }, label: {
                Text("show bottomsheet tapi dri page 2")
            })
        }
        .navigationTitle("page 2")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
    }
}

extension SecondView {
    class ViewModel: ObservableObject, BottomSheetDelegate {
        private let container = Container.appStateContainer()
        func onBackgroundTapped() {
            container.bottomSheet.bottomSheetState = .none
        }
        
        func onShowToastTap() {
            container.toastState.toastState = .biasa
        }
        
        func onAndiTap() {
            container.toastState.toastState = .biasa
        }
        
        func onAsrafilTap() {
            print("asrafil tapped")
        }
        
        func onButtonTap() {
            container.bottomSheet.bottomSheetState = .ebook(self)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
