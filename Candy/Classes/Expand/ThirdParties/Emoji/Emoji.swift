//
//  Emoji.swift
//  News
//
//  Created by 杨蒙 on 2017/12/18.
//  Copyright © 2017年 hrscy. All rights reserved.

import UIKit

let emojiManager = EmojiManager.default

struct EmojiManager {

    static let `default` = EmojiManager()
    /// emoji 数组
    private var emojis = [Emoji]()

    init() {

        // 获取 emoji_sort.plist 的路径
        let arrayPath = R.file.emoji_sortPlist()?.path
        // 根据 plist 文件 读取数据
        let emojiSorts = NSArray(contentsOfFile: arrayPath!) as? [String] ?? []
        // 获取 emoji_mapping.plist 的路径
        let mappingPath = R.file.emoji_mappingPlist()?.path
        // 根据 plist 文件 读取数据
        let emojiMapping = NSDictionary(contentsOfFile: mappingPath!) as? [String: String] ?? [:]
        // 临时数组
        var temps = [Emoji]()
        // 遍历
        for (index, id) in emojiSorts.enumerated() {
            if index != 0 && index % 20 == 0 { temps.append(Emoji(isDelete: true)) }
            temps.append(Emoji(id: id, png: "emoji_\(id)_32x32_"))
        }

        // 遍历数组
        for temp in temps {
            var emoji = temp
            // 遍历字典
            for (key, value) in emojiMapping where emoji.id == value {
                emoji.name = "\(key)"
                emojis.append(emoji)
            }
            if emoji.isDelete { emojis.append(emoji) }
        }

        // 判断分页是否有剩余
        let count = emojis.count % 21
        // swiftlint:disable:next empty_count
        guard count != 0 else { return }
        // 添加空白表情
        for index in count..<21 {
            emojis.append(index == 20 ? Emoji(isDelete: true) : Emoji(isEmpty: true))
        }
    }

    /// 显示 emoji 表情
    func convertEmoji(content: String, font: UIFont) -> NSMutableAttributedString {

        // 将 content 转成 attributedString
        let attributedString = NSMutableAttributedString(string: content)
        // emoji 表情的正则表达式
        let emojiPattern = "\\[.*?\\]"
        // 创建正则表达式对象，匹配 emoji 表情
        // // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        // 开始匹配，返回结果
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))

        if !results.isEmpty {
            // 倒序遍历，从最后一个开始替换，如果说从第一个替换的话，字符串的长度就发生变化了
            for index in stride(from: results.count - 1, through: 0, by: -1) {
                // 取出结果的范围
                let result = results[index]
                // 取出 emoji 的名字
                let emojiName = (content as NSString).substring(with: result.range)
                let attachment = NSTextAttachment()
                // 取出对应的 emoji 模型
                guard
                    let emoji = emojis.filter({ $0.name == emojiName }).first
                else {
                    return attributedString
                }
                // 设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attributedImageStr = NSAttributedString(attachment: attachment)
                // 将图片替换为文字
                attributedString.replaceCharacters(in: result.range, with: attributedImageStr)
            }
        }
        return attributedString
    }
}
