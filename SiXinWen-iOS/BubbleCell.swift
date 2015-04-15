//
//  CommentCell.swift
//  SiXinWen-iOS
//
//  Created by walker on 15/3/25.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit


let oppoTag = 0, teamTag = 1

let bubbleTag = 8

func coloredImage(image: UIImage, color:UIColor) -> UIImage! {
    let rect = CGRect(origin: CGPointZero, size: image.size)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    var components = CGColorGetComponents(color.CGColor)
    CGContextSetRGBFillColor(context, components[0],components[1],components[2],components[3])
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
    CGContextFillRect(context, rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

func bubbleImageMake() -> (oppo: UIImage, oppoHighlighed: UIImage, team: UIImage, teamHighlighed: UIImage) {
    let maskTeam = UIImage(named: "MessageBubble")!
    let maskOppo = UIImage(CGImage: maskTeam.CGImage, scale: 2, orientation: .UpMirrored)!
    
    let capInsetsOppo = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsTeam = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)

    let oppo = coloredImage(maskOppo,leftColor).resizableImageWithCapInsets(capInsetsOppo)
    let oppoHighlighted = coloredImage(maskOppo, highLeftColor).resizableImageWithCapInsets(capInsetsOppo)
    let team = coloredImage(maskTeam, rightColor).resizableImageWithCapInsets(capInsetsTeam)
    let teamHighlighted = coloredImage(maskTeam,highRightColor).resizableImageWithCapInsets(capInsetsTeam)
    
    return (oppo, oppoHighlighted, team, teamHighlighted)
}


let bubbleImage = bubbleImageMake()

let FontSize: CGFloat = 17

class BubbleCell: UITableViewCell {
    
    
//    let usrPhoto:UIImage
    
    let bubbleImageView: UIImageView
    let bubbleText: UILabel
    let like: UIButton
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        bubbleImageView = UIImageView(image: bubbleImage.oppo, highlightedImage: bubbleImage.oppoHighlighed)
        bubbleImageView.backgroundColor = bgColor
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true // #CopyMesage
        
        bubbleText = UILabel(frame: CGRectZero)
        bubbleText.font = UIFont.systemFontOfSize(FontSize)
        bubbleText.numberOfLines = 0
        bubbleText.userInteractionEnabled = false   // #Copycomment
       
        like = UIButton(frame: CGRectZero)
        
        
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(bubbleText)
        
        bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bubbleText.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 4.5))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Width, relatedBy: .Equal, toItem: bubbleText, attribute: .Width, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -4.5))
        
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .CenterX, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterX, multiplier: 1, constant: 3))
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .CenterY, relatedBy: .Equal, toItem: bubbleImageView, attribute: .CenterY, multiplier: 1, constant: -0.5))
        bubbleText.preferredMaxLayoutWidth = 218
        bubbleImageView.addConstraint(NSLayoutConstraint(item: bubbleText, attribute: .Height, relatedBy: .Equal, toItem: bubbleImageView, attribute: .Height, multiplier: 1, constant: -15))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Highlight cell #Copy
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureWithMessage(message: singleMessage) {
        bubbleText.text = message.text
        
//        if comment.incoming != (tag == incomingTag) {
            var layoutAttribute: NSLayoutAttribute
            var layoutConstant: CGFloat
            bubbleText.textColor = UIColor.whiteColor()
            if message.oppo {
                tag = oppoTag
                bubbleImageView.image = bubbleImage.oppo
                bubbleImageView.highlightedImage = bubbleImage.oppoHighlighed
               
                layoutAttribute = .Left
                layoutConstant = 10
            } else { // outgoing
                tag = teamTag
                bubbleImageView.image = bubbleImage.team
                bubbleImageView.highlightedImage = bubbleImage.teamHighlighed
                
                layoutAttribute = .Right
                layoutConstant = -10
            }
            
            let layoutConstraint: NSLayoutConstraint = bubbleImageView.constraints()[1] as! NSLayoutConstraint // `messageLabel` CenterX
            layoutConstraint.constant = -layoutConstraint.constant
            
            let constraints: NSArray = contentView.constraints()
            let indexOfConstraint = constraints.indexOfObjectPassingTest { (var constraint, idx, stop) in
                return (constraint.firstItem as! UIView).tag == bubbleTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
            contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant))
//        }
    }
    
    
    
    
    
}