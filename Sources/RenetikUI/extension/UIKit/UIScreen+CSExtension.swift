import UIKit

public extension UIScreen {
    class var size: CGSize { main.bounds.size }
    class var width: CGFloat { size.width }
    class var height: CGFloat { size.height }
    class var maxLength: CGFloat { max(width, height) }
    class var minLength: CGFloat { min(width, height) }
    class var isZoomed: Bool { main.nativeScale >= main.scale }
    class var isRetina: Bool { main.scale >= 2.0 }
}
