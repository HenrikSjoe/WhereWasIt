//
//  navigate.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import SwiftUI

struct NavigationHandler: ViewModifier {
    @Binding var value: Bool
    let destination: () -> AnyView
    
    func body(content: Content) -> some View {
        Group {
            if value {
                destination()
            } else {
                content
            }
        }
    }
}

extension View {
    func navigate(using state: Binding<Bool>, destination: @escaping () -> AnyView) -> some View {
        self.modifier(NavigationHandler(value: state, destination: destination))
    }
}
