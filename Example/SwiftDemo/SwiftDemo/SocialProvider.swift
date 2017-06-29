//
//  SocialProvider.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import UIKit

public class SocialProvider: Equatable {
    public let name : String
    public let icon : UIImage
    
    public init(name: String, icon: UIImage) {
        self.name = name
        self.icon = icon
    }
    
    public static func ==(lhs: SocialProvider, rhs: SocialProvider) -> Bool
    {
        return lhs.name == rhs.name
    }
}


public class SocialProvidersManager {
    
    static let socialIconsFull:UIImage = UIImage(named:"socialicons")!
    
    static let socialProvidersIconMapping:[(name: String, index: Int)] =
    {
        var LRDefaultSocialProviderNames:[(name: String, index: Int)] = []
        LRDefaultSocialProviderNames += [(name: "Facebook", index: 0)]
        LRDefaultSocialProviderNames += [(name: "Twitter", index: 3)]
        LRDefaultSocialProviderNames += [(name: "LinkedIn", index: 2)]
        LRDefaultSocialProviderNames += [(name: "Google", index: 1)]
        LRDefaultSocialProviderNames += [(name: "GitHub", index: 9)]
        LRDefaultSocialProviderNames += [(name: "Yahoo", index: 4)]
        LRDefaultSocialProviderNames += [(name: "Amazon", index: 5)]
        LRDefaultSocialProviderNames += [(name: "AOL", index: 6)]
        LRDefaultSocialProviderNames += [(name: "Disqus", index: 7)]
        LRDefaultSocialProviderNames += [(name: "FourSquare", index: 8)]
        LRDefaultSocialProviderNames += [(name: "Hyves", index: 10)]
        LRDefaultSocialProviderNames += [(name: "Instagram", index: 11)]
        LRDefaultSocialProviderNames += [(name: "Kaixin", index: 12)]
        LRDefaultSocialProviderNames += [(name: "Line", index: 41)]
        LRDefaultSocialProviderNames += [(name: "Live", index: 13)]
        LRDefaultSocialProviderNames += [(name: "LiveJournal", index: 14)]
        LRDefaultSocialProviderNames += [(name: "Mixi", index: 15)]
        LRDefaultSocialProviderNames += [(name: "Odnoklassniki", index: 16)]
        LRDefaultSocialProviderNames += [(name: "OpenID", index: 18)]
        LRDefaultSocialProviderNames += [(name: "Paypal", index: 19)]
        LRDefaultSocialProviderNames += [(name: "Pinterest", index: 21)]
        LRDefaultSocialProviderNames += [(name: "QQ", index: 22)]
        LRDefaultSocialProviderNames += [(name: "Renren", index: 23)]
        LRDefaultSocialProviderNames += [(name: "Salesforce", index: 24)]
        LRDefaultSocialProviderNames += [(name: "SinaWeibo", index: 25)]
        LRDefaultSocialProviderNames += [(name: "Stackexchange", index: 26)]
        LRDefaultSocialProviderNames += [(name: "Steamcommunity", index: 27)]
        LRDefaultSocialProviderNames += [(name: "Verisign", index: 28)]
        LRDefaultSocialProviderNames += [(name: "Virgilio", index: 29)]
        LRDefaultSocialProviderNames += [(name: "Vkontakte", index: 30)]
        LRDefaultSocialProviderNames += [(name: "Wordpress", index: 31)]
        LRDefaultSocialProviderNames += [(name: "mailru", index: 32)]
        LRDefaultSocialProviderNames += [(name: "Xing", index: 33)]
        return LRDefaultSocialProviderNames
    }()
    
    static let LRDefaultSocialProviders:[SocialProvider] = {

        return generateSocialProviderObjects(providers: socialProvidersIconMapping.map{return $0.name})

    }()
    
    static func generateSocialProviderObjects(providers:[String]) -> [SocialProvider]
    {
        var sp:[SocialProvider] = []
        let iconMap = SocialProvidersManager.socialProvidersIconMapping
        let iconLength = socialIconsFull.cgImage!.width

        for p in providers
        {
            if let index = iconMap.index(where: { $0.name == p })
            {
                let spTuple = iconMap[index]
                let cropRect = CGRect(x: 0, y: spTuple.index*iconLength, width: iconLength, height: iconLength)
                let imageRef:CGImage = socialIconsFull.cgImage!.cropping(to: cropRect)!
                let cropped:UIImage = UIImage(cgImage:imageRef)
            
                sp.append(SocialProvider(name: spTuple.name, icon: cropped))
            }

        }
        return sp
    }

}
