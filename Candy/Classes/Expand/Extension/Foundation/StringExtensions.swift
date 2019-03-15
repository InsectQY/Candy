import UIKit

extension String {

    public func parseVideoURL() -> (r: UInt32, s: UInt64) {

        let r = arc4random() // 随机数
        let url: NSString = "/video/urls/v/1/toutiao/mp4/\(self)?r=\(r)" as NSString
        let data: NSData = url.data(using: String.Encoding.utf8.rawValue)! as NSData
        // 使用 crc32 校验
        var crc32: UInt64 = UInt64(data.getCRC32())
        // crc32 可能为负数，要保证其为正数
        if crc32 < 0 { crc32 += 0x100000000 }
        // 拼接 url
        return (r: r, s: crc32)
    }

    // 调整行间距
    public func lineSpace(_ lineSpace: CGFloat
        ) -> NSAttributedString {

        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStye = NSMutableParagraphStyle()

        paragraphStye.lineSpacing = lineSpace
        let range = NSRange(location: 0, length: CFStringGetLength(self as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: range)
        return attributedString
    }
}
