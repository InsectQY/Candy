import UIKit

public extension String {
    // 调整行间距
    func lineSpace(_ lineSpace: CGFloat
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = lineSpace
        let range = NSRange(location: 0, length: CFStringGetLength(self as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        return attributedString
    }

    func classType<T>() -> T.Type? {
        
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String,
              let nameSpaceClass = NSClassFromString(nameSpace + "." + self),
              let classType = nameSpaceClass as? T.Type
        else {
            return nil
        }
        return classType
    }

    func classObject<T: NSObject>() -> T? {
        guard let classType: T.Type = classType() else {
            return nil
        }
        return classType.init()
    }
}
