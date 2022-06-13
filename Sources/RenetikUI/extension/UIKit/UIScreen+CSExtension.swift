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

public class CSScreen {
    let view: UIView
    init(_ parent: UIView) {
        view = parent
    }

    public var orientation: UIInterfaceOrientation {
        view.window?.windowScene?.interfaceOrientation ?? .unknown
    }

    public var isPortrait: Bool { orientation.isPortrait }
    public var isLandscape: Bool { !isPortrait }
    public var isLandscapeLeft: Bool { orientation == .landscapeLeft }
    public var isLandscapeRight: Bool { orientation == .landscapeRight }

    public var isThin: Bool { isPortrait && UIDevice.isPhone }
    public var isUltraThin: Bool { isPortrait && UIScreen.width <= 375 }
    public var isWide: Bool { !isThin }
    public var isUltraWide: Bool { UIDevice.isTablet && isLandscape }
    public var isShort: Bool { isLandscape && UIDevice.isPhone }
    public var isUltraShort: Bool { isLandscape && isSmallPhone }
    public var isTall: Bool { !isShort } // tablet || portrait
    public var isUltraTall: Bool { UIDevice.isTablet || !isSmallPhone && isPortrait }
    public var isSmallPhone: Bool {
        (UIDevice.typeIsLike == .iphone4 || UIDevice.typeIsLike == .iphone5)
    }
}

public extension UIView {
    var screen: CSScreen { associated("screen") { CSScreen(self) } }
}
