//
//  ToastView.swift
//  AppWideStateExample
//
//  Created by TI Digital on 27/06/22.
//

import Foundation
import SwiftUI


struct MultipleDownloadToastView: ViewModifier {
    @Binding var showToast: ToastType
    var text: String
    var color: Color
    var duration: Int
    var extraPadding: CGFloat
    func body(content: Content) -> some View {
        content.overlay(overlayView: Toast(showToast: $showToast, duration: TimeInterval(duration), onViewSlides: {}, onFinishAfterShown: {}, content: {
            VStack(alignment: .leading) {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(color)
            .cornerRadius(4)
            .padding(.bottom, 16 + extraPadding)
        }), show: $showToast)
    }
}

extension View {
    func showToastWithoutButton(showToast: Binding<ToastType>, text: String, color: Color, duration: Int, extraPadding: CGFloat = 0) -> some View {
        self.modifier(MultipleDownloadToastView(showToast: showToast, text: text, color: color, duration: duration, extraPadding: extraPadding))
    }
    
    func showToast(showToast: Binding<ToastType>, text: String, color: Color, duration: Int, extraPadding: CGFloat = 0) -> some View {
        self.modifier(MultipleDownloadToastView(showToast: showToast, text: text, color: color, duration: duration, extraPadding: extraPadding))
    }
}

//
//  ToastView.swift
//  ToastView
//
//  Created by Accounting on 27/08/21.
//

import SwiftUI

struct Toast<Content: View>: View {
    let content: Content
    @Binding var show: ToastType
    @State private var offset = CGSize.zero
    var duration: TimeInterval = 10
    var onViewSlides : () -> Void
    var onFinishAfterShown : () -> Void
    @State private var dismissedByAction = false
    @State var countTimer: Timer?
    @GestureState private var translation: CGFloat = 0
    @State private var animation: AnyTransition = .move(edge: .bottom)

    init(
        showToast: Binding<ToastType>,
        duration: TimeInterval,
        onViewSlides : @escaping () -> Void,
        onFinishAfterShown : @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onViewSlides = onViewSlides
        self.onFinishAfterShown = onFinishAfterShown
        self.duration = duration
        _show = showToast
        self.content = content()
        self.countTimer = nil
    }

    var body: some View {
        GeometryReader { reader in
            HStack {
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        self.content
                            .offset(x: self.translation, y: 0)
                            .opacity(2 - Double(abs(offset.width / 40)))
                            .gesture(
                                DragGesture()
                                    .updating(self.$translation, body: { value, state, _ in
                                        state = value.translation.width
                                    })
                                    .onEnded({ value in
                                        let offset = value.translation.width / reader.size.width
                                        if abs(offset) > 0.5 {
                                            dismissedByAction = true
    //                                        if translation > 0 {
    //                                            animation = .move(edge: .trailing)
    //                                        } else if translation < 0 {
    //                                            animation = .move(edge: .leading)
    //                                        }
                                            self.onViewSlides()
                                            withAnimation {
                                                self.show = .none
                                            }
                                        }
                                    })
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .animation(
            .easeIn(duration: 0.6)
        )
        .onChange(of: show, perform: { newValue in
            if show == .none {
                countTimer?.invalidate()
                countTimer = nil
            } else {
                countTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { timer in
                    if dismissedByAction {
                        timer.invalidate()
                    } else {
                        withAnimation {
                            self.show = .none
                        }
                        self.onFinishAfterShown()
                        timer.invalidate()
                    }
                })
            }
        })
        .onChange(of: translation, perform: { newValue in
            if newValue > 0 {
                animation = .move(edge: .trailing)
            } else if newValue < 0 {
                animation = .move(edge: .leading)
            } else {
                animation = .move(edge: .bottom)
            }
        })
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: animation))
        .onAppear(perform: {
            countTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { timer in
                if dismissedByAction {
                    timer.invalidate()
                } else {
                    withAnimation {
                        self.show = .none
                    }
                    self.onFinishAfterShown()
                    timer.invalidate()
                }

            })
        })
    }
}

struct Overlay<T: View>: ViewModifier {
    @Binding var show: ToastType
    let overlayView: T

    func body(content: Content) -> some View {
        ZStack {
            content
            if show != .none {
                overlayView
                    .zIndex(1)
            }
        }
    }
}

extension View {
    func overlay<T: View>(overlayView: T, show: Binding<ToastType>) -> some View {
        self.modifier(Overlay.init(show: show, overlayView: overlayView))
    }
}

