//
//  NotificationService.swift
//  SampleNotificationServiceExtension
//
//  Created by Daniel Sykes-Turner on 17/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        // Check to see if there's an attachment
        guard let attachmentUrl = request.content.userInfo["attachment"] as? String else {
            self.contentComplete()
            return
        }
        
        // Detect the attachment type to load
        let urlComponents = attachmentUrl.components(separatedBy: ".")
        guard let fileType = urlComponents.last else {
            self.contentComplete()
            return
        }
        
        // Load the attachment
        self.loadAttachmentForURLString(attachmentUrl, type: "."+fileType, completionHandler: { (attachment:UNNotificationAttachment?) in
            // Add the attachment to our best attempt content
            if let attachment = attachment {
                self.bestAttemptContent?.attachments = [attachment]
            }
            self.contentComplete()
        })
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        self.contentComplete()
    }
    
    func contentComplete() {
        // Confirm the content to be delivered to the user
        self.contentHandler!(self.bestAttemptContent!)
    }
    
    func loadAttachmentForURLString(_ urlString: String, type: String, completionHandler: @escaping ((_ attachment: UNNotificationAttachment?) -> Void)) {
        
        var attachment:UNNotificationAttachment?
        let attachmentURL = URL(string: urlString)!
        
        // Download the attachment
        let session = URLSession(configuration: URLSessionConfiguration.default)
        (session.downloadTask(with: attachmentURL) { (temporaryURL:URL?, response:URLResponse?, error:Error?) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if let temporaryURL = temporaryURL {
                
                // Store the attachment in a temporary location
                let fileManager = FileManager.default
                let localURL = URL(fileURLWithPath: (temporaryURL.path+type))
                
                // Link the attachment to our UNNotificationAttachment
                do {
                    try fileManager.moveItem(at: temporaryURL, to: localURL)
                    try attachment = UNNotificationAttachment(identifier: "", url: localURL, options: nil)
                } catch {
                    print("Failed to move item to location "+localURL.path+" and create attachment")
                }
            }
            completionHandler(attachment)
        }).resume()
        
    }
}
