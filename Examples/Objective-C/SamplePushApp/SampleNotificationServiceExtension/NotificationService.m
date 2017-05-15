//
//  NotificationService.m
//  SampleNotificationServiceExtension
//
//  Created by Daniel Sykes-Turner on 10/5/17.
//  Copyright © 2017 Localz Pty Ltd. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    
    // Check for the attachment
    NSDictionary *userInfo = request.content.userInfo;
    if (userInfo == nil) {
        [self contentComplete];
        return;
    }
    
    NSString *mediaUrl = userInfo[@"attachment"];
    if (mediaUrl == nil) {
        [self contentComplete];
        return;
    }
    
    // Detect the attachment type to load
    NSArray *urlComponents = [mediaUrl componentsSeparatedByString:@"."];
    NSString *type = [@"." stringByAppendingString:[urlComponents lastObject]];
    
    // Load the attachment
    [self loadAttachmentForUrlString:mediaUrl withType:type completionHandler:^(UNNotificationAttachment *attachment) {
        // Add the attachment to our best attempt content
        if (attachment) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
        }
        [self contentComplete];
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // This will be used to deliver a "best attempt" at the modified content (otherwise the original push payload will be used)
    [self contentComplete];
}

- (void)contentComplete {
    // Confirm the content to be delivered to the user
    self.contentHandler(self.bestAttemptContent);
}

- (void)loadAttachmentForUrlString:(NSString *)urlString withType:(NSString *)type completionHandler:(void(^)(UNNotificationAttachment *))completionHandler  {
    
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlString];
    
    // Download the attachment
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
        
        if (error != nil) NSLog(@"%@", error.localizedDescription);
        else {
            // Store the attachment in a temporary location
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:type]];
            [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
            
            // Link the attachment to our UNNotificationAttachment
            NSError *attachmentError = nil;
            attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
            if (attachmentError) NSLog(@"%@", attachmentError.localizedDescription);
        }
        completionHandler(attachment);
    }] resume];
}
@end
