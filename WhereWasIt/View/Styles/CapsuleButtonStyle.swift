//
//  CapsuleButtonStyle.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-16.
//

import SwiftUI

public struct CapsuleButtonStyle: ButtonStyle {
    public enum Size {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small:
                return 40

            case .medium:
                return 56

            case .large:
                return 64
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small:
                return 32

            case .medium:
                return 40

            case .large:
                return 56
            }
        }
    }

    public enum ColorStyle {
        case blue
        case darkGray
        case custom(textColor: Color, backgroundColor: Color)

        var textColor: Color {
            switch self {
            case .blue, .darkGray:
                return .white

            case .custom(let textColor, _):
                return textColor
            }
        }

        var backgroundColor: Color {
            switch self {
            case .blue:
                return .blue

            case .darkGray:
                return .gray

            case .custom(_, let backgroundColor):
                return backgroundColor
            }
        }
    }

    private let size: Size
    private let colorStyle: ColorStyle
    private let fullScreenWidth: Bool
    private let hasShadow: Bool

    public init(
        size: Size = .large,
        colorStyle: ColorStyle = .blue,
        fullScreenWidth: Bool = true,
        hasShadow: Bool = false
    ) {
        self.size = size
        self.colorStyle = colorStyle
        self.fullScreenWidth = fullScreenWidth
        self.hasShadow = hasShadow
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: fullScreenWidth ? .infinity : nil)
            .frame(height: size.height)
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, size.horizontalPadding)
            .foregroundColor(colorStyle.textColor)
            .background(
                Capsule(style: .circular)
                    .foregroundColor(colorStyle.backgroundColor)
                    .shadow(
                        color: !hasShadow ? .clear : .black.opacity(0.2),
                        radius: configuration.isPressed ? 0 : 3,
                        x: 0.0,
                        y: configuration.isPressed ? 0 : 3
                    )
            )
    }
}

struct CapsuleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Default") { }
                .buttonStyle(
                    CapsuleButtonStyle()
                )

            Button("Default") { }
                .buttonStyle(
                    CapsuleButtonStyle(colorStyle: .darkGray)
                )

            Button("Test") { }
                .buttonStyle(
                    CapsuleButtonStyle(
                        size: .medium,
                        colorStyle: .custom(textColor: .yellow, backgroundColor: .red),
                        fullScreenWidth: false,
                        hasShadow: true
                    )
                )
        }
    }
}
