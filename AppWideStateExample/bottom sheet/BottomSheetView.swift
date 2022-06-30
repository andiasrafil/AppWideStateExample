//
//  BottomSheetView.swift
//  AppWideStateExample
//
//  Created by TI Digital on 27/06/22.
//

import Foundation
import SwiftUI

protocol BottomSheetDelegate {
    func onBackgroundTapped()
    func onAndiTap()
    func onAsrafilTap()
}

struct BottomSheetView: ViewModifier {
    @Binding var type: BottomSheetType
    func body(content: Content) -> some View {
        ZStack {
            content
            type.view
                .padding()
        }
        .animation(.easeIn, value: type)
    }
}

struct AndiBottomSheet: View {
    var bottomSheetDelegate: BottomSheetDelegate
    var body: some View {
        Color.black.opacity(0.5)
            .onTapGesture {
                withAnimation {
                    bottomSheetDelegate.onBackgroundTapped()
                }
            }
        VStack {
            Spacer()
            VStack {
                Text("ceritanya bottom sheet")
                Button(action: {
                    withAnimation {
                        bottomSheetDelegate.onAndiTap()
                    }
                    
                }, label: {
                    Text("andi")
                })
                Button(action: {
                    withAnimation {
                        bottomSheetDelegate.onAsrafilTap()
                    }
                }, label: {
                    Text("asrafil")
                })
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(.white)
            .animation(
                .easeIn(duration: 1)
            )
            
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
            
        }
    }
}

extension View {
    func showBottomSheet(bottomSheetType: Binding<BottomSheetType>) -> some View {
        self.modifier(BottomSheetView(type: bottomSheetType))
    }
}

struct OverlayHitam: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
        }
    }
}
