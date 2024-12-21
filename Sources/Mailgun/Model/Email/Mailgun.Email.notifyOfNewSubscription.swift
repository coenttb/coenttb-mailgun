//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 14/12/2024.
//

//import Foundation
//import EmailAddress
//
//extension Email {
//    public static func notifyOfNewSubscription(
//        from: EmailAddress,
//        subscriberEmail: EmailAddress,
//        companyEmail: EmailAddress,
//        companyName: String,
//        domain: String
//    ) -> Email {
//        return Email.notifyOfNewSubscription(
//            from: from,
//            to: from,
//            subscriberEmail: subscriberEmail,
//            companyEmail: companyEmail,
//            companyName: companyName,
//            domain: domain
//        )
//    }
//}
//
//extension Email {
//    public static func notifyOfNewSubscription(
//        from: EmailAddress,
//        to: EmailAddress,
//        subscriberEmail: EmailAddress,
//        companyEmail: EmailAddress,
//        companyName: String,
//        domain: String
//    ) -> Email {
//        return Email(
//            from: companyEmail,
//            to: [to],
//            subject: "\(companyName) new subscriber: \(subscriberEmail.rawValue)",
//            text: "\(subscriberEmail.rawValue)",
//            html: nil,
//            domain: domain
//        )
//    }
//}
