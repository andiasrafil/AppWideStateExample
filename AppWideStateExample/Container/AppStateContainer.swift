//
//  AppStateContainer.swift
//  AppWideStateExample
//
//  Created by TI Digital on 27/06/22.
//

import SwiftUI
import Factory

struct RootViewAtom: ViewModifier {
    @StateObject private var toastState: ToastState = Container.toastState()
    @StateObject private var bottomSheetState: BottomSheetState = Container.bottomSheetState()
    func body(content: Content) -> some View {
        content
            .showBottomSheet(bottomSheetType: $bottomSheetState.bottomSheetState)
            .showToast(showToast: $toastState.toastState, text: toastState.toastState.text, color: .cyan, duration: 5)
    }
}

extension View {
    func asRootView() -> some View {
        self.modifier(RootViewAtom())
    }
}

class AppStateContainer: ObservableObject {
    static let shared = AppStateContainer()
    var toastState = ToastState()
    var bottomSheet = BottomSheetState()
}

class ToastState: ObservableObject {
    static let shared = ToastState()
    @Published var toastState: ToastType = .none
}

enum ToastType {
    case biasa
    case none
    
    var text: String {
        switch self {
        case .biasa:
            return "andi ganteng"
        case .none:
            return ""
        }
    }
}

class BottomSheetState: ObservableObject {
    static let shared = BottomSheetState()
    @Published var bottomSheetState: BottomSheetType = .none
}

enum BottomSheetType: Equatable {
    static func == (lhs: BottomSheetType, rhs: BottomSheetType) -> Bool {
        true
    }
    
    
    
    case ebook(BottomSheetDelegate)
    case epaper
    case none
    
    var view: some View {
        switch self {
        case .ebook(let bottomSheetDelegate):
            return AnyView(AndiBottomSheet(bottomSheetDelegate: bottomSheetDelegate))
        case .epaper:
            return AnyView(EmptyView())
        case .none:
            return AnyView(EmptyView())
        }
    }
}
