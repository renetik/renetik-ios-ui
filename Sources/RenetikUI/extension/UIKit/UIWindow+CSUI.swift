extension UIWindow {
    public var orientationChange: CSEvent<Void> {
        associated("orientationChange") { event() }
    }

    public var orientation: UIInterfaceOrientation {
        windowScene?.interfaceOrientation ?? .unknown
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
    public var isSmallPhone: Bool { UIDevice.typeIsLike == .iphone4 || UIDevice.typeIsLike == .iphone5 }
}
