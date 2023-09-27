//
//  RichLabel.swift
// swiftlint:disable:next force_unwrapping

import UIKit

/// 点击的文本类型
enum TapRichTextType: Int {

    case none = 0     // 没有点击
    case user = 1     // 点击了用户
    case link = 2     // 点击了链接
    case topic = 3    // 点击了话题
}

class RichLabel: UILabel {

    override var attributedText: NSAttributedString? {

        didSet {
            // 把文本设置为可变的
            let attributedString = NSMutableAttributedString(attributedString: attributedText!)
            // 添加属性
            attributedString.addAttribute(.font, value: font ?? UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedString.length))
            // 设置 textStorage 的文本内容
            textStorage.setAttributedString(attributedString)
            // 匹配用户名 
            userRanges = ranges(from: "@.*?:")
            _ = userRanges.map { textStorage.addAttribute(.foregroundColor, value: UIColor.user, range: $0) }
            // 匹配话题
            topicRanges = ranges(from: "#.*?#")
            _ = topicRanges.map { textStorage.addAttribute(.foregroundColor, value: UIColor.user, range: $0) }
            // 匹配链接
            linkRanges = rangesOfLink()
            _ = linkRanges.map { textStorage.addAttribute(.foregroundColor, value: UIColor.user, range: $0) }
        }
    }

    override func drawText(in rect: CGRect) {
        // 绘制字形，设置需要绘制的范围
        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawGlyphs(forGlyphRange: range, at: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置文本
        setupText()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 设置文本
        setupText()
    }
    /// 文本容器，文本可以排版的区域，默认是矩形，可以自定义区域大小
    private lazy var textContainer = NSTextContainer()
    /// 布局管理者，负责对文字进行编辑排版处理，将存储在 NSTextStorage 中的数据转换为可以在视图控件中显示的文本内容
    /// 并把字符编码映射到对应的字形上，然后将字形排版到 NSTextContainer 定义的区域中。
    private lazy var layoutManager = NSLayoutManager()
    /// NSMutableAttributeString 的子类，主要用来存储文本的字符和相关属性
    /// 当 NSTextStorage 中的字符或属性发生改变时，会通知 NSLayoutManager，进而做到文本内容的显示更新。
    private lazy var textStorage = NSTextStorage()
    /// 记录用户名的范围
    private lazy var userRanges = [NSRange]()
    /// 记录链接的范围
    private lazy var linkRanges = [NSRange]()
    /// 记录话题的范围
    private lazy var topicRanges = [NSRange]()
    /// 定义一个闭包，点击回调
    typealias TapRichText = (String, NSRange) -> Void
    var userTapped: TapRichText?
    var linkTapped: TapRichText?
    var topicTapped: TapRichText?
    /// 点击的类型
    private var tapRichTextType: TapRichTextType = .none
    /// 记录用户点击的 range
    var selectedRange = NSRange()
}

extension RichLabel {
    /// 设置文本
    private func setupText() {
        // 将 layoutManager 添加到 textStorage 中
        layoutManager.addTextContainer(textContainer)
        // 将 textContainer 添加到 layoutManager 中
        textStorage.addLayoutManager(layoutManager)
        // 设置可以与用户交互
        isUserInteractionEnabled = true
        // 间距设置 0
        textContainer.lineFragmentPadding = 0.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置容器的大小为 当前 label 的尺寸
        textContainer.size = frame.size
    }

    func rangesOfLink() -> [NSRange] {
        // 检测正则表达式，NSDataDetector 是 NSRegularExpression 的子类
        // swiftlint:disable:next force_try
        let regex = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        return results(from: regex)
    }

    /// 返回正则表达式匹配的结果范围
    func ranges(from pattern: String) -> [NSRange] {
        // 创建正则表达式对象
        // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return results(from: regex)
    }

    /// 返回正则表达式的结果
    private func results(from regex: NSRegularExpression) -> [NSRange] {
        // 开始匹配，返回结果
        let checkingResults = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        return checkingResults.map(\.range)
    }

    /// 根据点击的坐标，获取范围
    private func range(of point: CGPoint) -> NSRange {
        // 判断 textStorage 长度是不是 0
        if textStorage.length == 0 { return NSRange() }
        // 在 textStorage 中的索引
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        // 获取用户名的范围
        for userRange in userRanges {
            if index > userRange.location && index < userRange.location + userRange.length {
                tapRichTextType = .user
                return userRange
            }
        }
        // 获取链接的范围
        for linkRange in linkRanges {
            if index > linkRange.location && index < linkRange.location + linkRange.length {
                tapRichTextType = .link
                return linkRange
            }
        }
        // 获取话题的范围
        for topicRange in topicRanges {
            if index > topicRange.location && index < topicRange.location + topicRange.length {
                tapRichTextType = .topic
                return topicRange
            }
        }
        return NSRange()
    }

    /// 从 range 数组里返回一个 range
    /// 暂未使用
    func range(from ranges: [NSRange], index: Int) -> NSRange {
        // 获取话题的范围
        for item in ranges {
            if index > item.location && index < item.location + item.length { return item }
        }
        return NSRange()
    }
}

extension RichLabel {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取点击的范围
        selectedRange = range(of: touches.first!.location(in: self))
        // 获取点击的范围的内容
        let content = (textStorage.string as NSString).substring(with: selectedRange)
        // 判断点击的类型
        switch tapRichTextType {
        case .user:
            userTapped?(content, selectedRange)
        case .link:
            linkTapped?(content, selectedRange)
        case .topic:
            topicTapped?(content, selectedRange)
        default:
            break
        }
    }
}
