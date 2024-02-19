//
//  ToastView.swift
//  MedBook
//
//  Created by Mithun M R on 19/02/24.
//
import SwiftUI

struct ToastView<Content: View>: View {
    let content: Content
    @Binding var isPresented: Bool
    let autohide: Bool
    let dismissAfter: Double

    init(isPresented: Binding<Bool>, autohide: Bool = true, dismissAfter: Double = 2, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._isPresented = isPresented
        self.autohide = autohide
        self.dismissAfter = dismissAfter
    }

    var body: some View {
        ZStack {
            if isPresented {
                withAnimation{
                    content
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            if autohide {
                                DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                                    withAnimation {
                                        isPresented = false
                                    }
                                }
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
