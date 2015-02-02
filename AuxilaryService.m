//
//  AuxilaryService.m
//  NParks
//
//  Created by Raja Saravanan on 1/29/12.
//  Copyright (c) 2012 Shownearby. All rights reserved.
//


#import "AuxilaryService.h"
#import "SharedObject.h"
#import "WCAlertView.h"
#import "UIButtonIndexPathAndBlock.h"

@interface AuxilaryService(privateMethods)
-(void)showImageView_Show:(UIImage*)imageV;
@end

@implementation AuxilaryService

//@synthesize sTable;
@synthesize controller;
@synthesize imageDelegate;
@synthesize showImageV;
@synthesize withShowImgView;

static AuxilaryService *sharedInstance_ = nil;  // -- shared instacne class object

+(AuxilaryService*)auxFunctions{
    
    if (sharedInstance_ == nil) {
        sharedInstance_ = [[AuxilaryService alloc] init];
    }
    
    return sharedInstance_;
}
-(id)init{
    
    self = [super init];
    
    if (self) {
        // -- do the initialization here
    }
    
    return  self;
}

#pragma mark - ABAddressBook
//
//-(void)addressBookArrar_ToArray:(NSMutableArray*)array{
//  
//  RDLog(@"Granted F%s",__FUNCTION__);
//  
//  NSMutableArray *addressArr = [[NSMutableArray alloc] initWithCapacity:0];
//  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//  
//  @try {
//    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
//                                                               kCFAllocatorDefault,
//                                                               CFArrayGetCount(allPeople),
//                                                               allPeople
//                                                               );
//    
//    CFRelease(allPeople);
//    
//    CFArraySortValues(
//                      peopleMutable,
//                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
//                      (CFComparatorFunction) ABPersonComparePeopleByName,
//                      (void*) ABPersonGetSortOrdering()
//                      );
//    
//    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//    
//    if (nPeople != 0) {
//      
//      for (int i = 0; i < nPeople; i++ )
//      {
//        
//        NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
//        
//        //ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
//        ABRecordRef ref = CFArrayGetValueAtIndex(peopleMutable, i);
//        
//        // -- NAME
//        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
//        
//        NSMutableString *nameString = [NSMutableString string];
//        
//        if (firstName) {
//          [nameString appendString:(NSString*)firstName];
//          CFRelease(firstName);
//        }
//        
//        
//        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
//        
//        if (lastName) {
//          [nameString appendFormat:@" %@",lastName];
//          CFRelease(lastName);
//        }
//        
//        
//        RDLog(@"nameString -- %@ ",nameString);
//        
//        [addressDict setObject:nameString forKey:CONTACTS_NAME];
//        nameString = nil;
//        
//        // -- PHONE NUMBER
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
//        if (ABMultiValueGetCount(phoneNumbers) != 0) {
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(phoneNumbers);i++)
//          {
//            CFStringRef ph = ABMultiValueCopyValueAtIndex(phoneNumbers, i);
//            NSLog(@"phone numbers - %i = %@‚",i+1,[NSString stringWithFormat:@"%@",ph]);
//            
//            if (ph) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",ph] forKey:CONTACTS_PHONE];
//              CFRelease(ph);
//            }
//            
//            
//            
//            
//          }
//          
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        CFRelease(phoneNumbers);
//        
//        // -- person email
//        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
//        if(ABMultiValueGetCount(emails) != 0){
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(emails);i++)
//          {
//            CFStringRef em = ABMultiValueCopyValueAtIndex(emails, i);
//            NSLog(@"Email-%i = %@‚",i+1,[NSString stringWithFormat:@"%@",em]);
//            if (em) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",em] forKey:CONTACTS_EMAIL];
//              CFRelease(em);
//            }
//            
//            
//            
//          }
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        
//        CFRelease(emails);
//        
//        // -- person image
//        CFDataRef imgeData = ABPersonCopyImageData(ref);
//        if(imgeData)
//        {
//          //delegate.Image =  [UIImage imageWithData:(NSData*)imgeData];
//          [addressDict setObject:[UIImage imageWithData:(NSData*)imgeData] forKey:CONTACTS_IMAGE];
//          CFRelease(imgeData);
//        }
//        else
//        {
//          //delegate.Image = [UIImage imageNamed:@"photo.png"];
//        }
//        
//        [addressArr addObject:addressDict];
//        [addressDict release];
//        addressDict = nil;
//      }
//      
//    }
//    else{
//      // -- No values in contacts list
//    }
//    
//    
//    
//    //CFRelease(allPeople);
//    CFRelease(peopleMutable);
//    CFRelease(addressBook);
//    
//    
//  }
//  @catch (NSException *exception) {
//    RDLog(@"Exception -- %@",exception);
//  }
//  @finally {
//    [pool drain];
//    
//    //return [addressArr autorelease];
//    
//    [array addObjectsFromArray:addressArr];
//    [addressArr release];
//    RDLog(@"\n\nArray %@\n\n\n",array);
//    
//  }
//  
//}
//
//// -- temp block to get address book contacts
//-(NSMutableArray*)addressBookArr_{
//  
//  RDLog(@"Granted F%s",__FUNCTION__);
//  
//  NSMutableArray *addressArr = [[NSMutableArray alloc] initWithCapacity:0];
//  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//  
//  @try {
//    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
//                                                               kCFAllocatorDefault,
//                                                               CFArrayGetCount(allPeople),
//                                                               allPeople
//                                                               );
//    
//    CFRelease(allPeople);
//    
//    CFArraySortValues(
//                      peopleMutable,
//                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
//                      (CFComparatorFunction) ABPersonComparePeopleByName,
//                      (void*) ABPersonGetSortOrdering()
//                      );
//    
//    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//    
//    if (nPeople != 0) {
//      
//      for (int i = 0; i < nPeople; i++ )
//      {
//        
//        NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
//        
//        //ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
//        ABRecordRef ref = CFArrayGetValueAtIndex(peopleMutable, i);
//        
//        // -- NAME
//        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
//        
//        NSMutableString *nameString = [NSMutableString string];
//        
//        if (firstName) {
//          [nameString appendString:(NSString*)firstName];
//          CFRelease(firstName);
//        }
//        
//        
//        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
//        
//        if (lastName) {
//          [nameString appendFormat:@" %@",lastName];
//          CFRelease(lastName);
//        }
//        
//        
//        RDLog(@"nameString -- %@ ",nameString);
//        
//        [addressDict setObject:nameString forKey:CONTACTS_NAME];
//        nameString = nil;
//        
//        // -- PHONE NUMBER
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
//        if (ABMultiValueGetCount(phoneNumbers) != 0) {
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(phoneNumbers);i++)
//          {
//            CFStringRef ph = ABMultiValueCopyValueAtIndex(phoneNumbers, i);
//            NSLog(@"phone numbers - %i = %@‚",i+1,[NSString stringWithFormat:@"%@",ph]);
//            
//            if (ph) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",ph] forKey:CONTACTS_PHONE];
//              CFRelease(ph);
//            }
//            
//            
//            
//            
//          }
//          
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        CFRelease(phoneNumbers);
//        
//        // -- person email
//        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
//        if(ABMultiValueGetCount(emails) != 0){
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(emails);i++)
//          {
//            CFStringRef em = ABMultiValueCopyValueAtIndex(emails, i);
//            NSLog(@"Email-%i = %@‚",i+1,[NSString stringWithFormat:@"%@",em]);
//            if (em) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",em] forKey:CONTACTS_EMAIL];
//              CFRelease(em);
//            }
//            
//            
//            
//          }
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        
//        CFRelease(emails);
//        
//        // -- person image
//        CFDataRef imgeData = ABPersonCopyImageData(ref);
//        if(imgeData)
//        {
//          //delegate.Image =  [UIImage imageWithData:(NSData*)imgeData];
//          [addressDict setObject:[UIImage imageWithData:(NSData*)imgeData] forKey:CONTACTS_IMAGE];
//          CFRelease(imgeData);
//        }
//        else
//        {
//          //delegate.Image = [UIImage imageNamed:@"photo.png"];
//        }
//        
//        [addressArr addObject:addressDict];
//        [addressDict release];
//        addressDict = nil;
//      }
//      
//    }
//    else{
//      // -- No values in contacts list
//    }
//    
//    
//    
//    //CFRelease(allPeople);
//    CFRelease(peopleMutable);
//    CFRelease(addressBook);
//    
//    
//  }
//  @catch (NSException *exception) {
//    RDLog(@"Exception -- %@",exception);
//  }
//  @finally {
//    [pool drain];
//    
//    return [addressArr autorelease];
//    
//  }
//
//}
//
//- (BOOL)isABAddressBookCreateWithOptionsAvailable
//{
//  return &ABAddressBookCreateWithOptions != NULL;
//}
//
//
///*-(BOOL)addressBookArray_Request{
//
//  __block BOOL access_granted = FALSE;
//
//  CFErrorRef error = nil;
//  ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
//  if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//    
//    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//      // First time access has been granted, add the contact
//      access_granted = granted;
//      dispatch_async(dispatch_get_main_queue(), ^{
//        return access_granted;
//      });
//
//    });
//    
//  }
//  else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
//    // The user has previously given access, add the contact
//    access_granted = TRUE;
//  }
//  else {
//    // The user has previously denied access
//    // Send an alert telling user to change privacy setting in settings app
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Address book request denied previously. Please go to your settings and grant access to your address book to show your contacts." delegate:nil cancelTitle:@"Close"];
//    });
//    
//  }
//  
//  return nil;
//
//}*/
//
//-(NSMutableArray*)addressBookArray{
//
//  RDLog(@"Granted F%s",__FUNCTION__);
//  
//  NSMutableArray *addressArr = [[NSMutableArray alloc] initWithCapacity:0];
//  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//  
//  @try {
//    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
//                                                               kCFAllocatorDefault,
//                                                               CFArrayGetCount(allPeople),
//                                                               allPeople
//                                                               );
//    
//    CFRelease(allPeople);
//    
//    CFArraySortValues(
//                      peopleMutable,
//                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
//                      (CFComparatorFunction) ABPersonComparePeopleByName,
//                      (void*) ABPersonGetSortOrdering()
//                      );
//    
//    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//    
//    if (nPeople != 0) {
//      
//      for (int i = 0; i < nPeople; i++ )
//      {
//        
//        NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
//        
//        //ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
//        ABRecordRef ref = CFArrayGetValueAtIndex(peopleMutable, i);
//        
//        // -- NAME
//        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
//        
//        NSMutableString *nameString = [NSMutableString string];
//        
//        if (firstName) {
//          [nameString appendString:(NSString*)firstName];
//          CFRelease(firstName);
//        }
//        
//        
//        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
//        
//        if (lastName) {
//          [nameString appendFormat:@" %@",lastName];
//          CFRelease(lastName);
//        }
//        
//        
//        //RDLog(@"nameString -- %@ ",nameString);
//        
//        [addressDict setObject:nameString forKey:CONTACTS_NAME];
//        nameString = nil;
//        
//        // -- PHONE NUMBER
//        ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
//        if (ABMultiValueGetCount(phoneNumbers) != 0) {
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(phoneNumbers);i++)
//          {
//            CFStringRef ph = ABMultiValueCopyValueAtIndex(phoneNumbers, i);
//            //NSLog(@"phone numbers - %i = %@‚",i+1,[NSString stringWithFormat:@"%@",ph]);
//            
//            if (ph) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",ph] forKey:CONTACTS_PHONE];
//              CFRelease(ph);
//            }
//            
//            
//            
//            
//          }
//          
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        CFRelease(phoneNumbers);
//        
//        // -- person email
//        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
//        if(ABMultiValueGetCount(emails) != 0){
//          
//          
//          for(int i=0;i<ABMultiValueGetCount(emails);i++)
//          {
//            CFStringRef em = ABMultiValueCopyValueAtIndex(emails, i);
//            //NSLog(@"Email-%i = %@‚",i+1,[NSString stringWithFormat:@"%@",em]);
//            if (em) {
//              [addressDict setObject:[NSString stringWithFormat:@"%@",em] forKey:CONTACTS_EMAIL];
//              CFRelease(em);
//            }
//            
//            
//            
//          }
//        }
//        else{
//          //[delegate.emailInfo addObject:@"No Email Found"];
//        }
//        
//        CFRelease(emails);
//        
//        // -- person image
//        CFDataRef imgeData = ABPersonCopyImageData(ref);
//        if(imgeData)
//        {
//          //delegate.Image =  [UIImage imageWithData:(NSData*)imgeData];
//          [addressDict setObject:[UIImage imageWithData:(NSData*)imgeData] forKey:CONTACTS_IMAGE];
//          CFRelease(imgeData);
//        }
//        else
//        {
//          //delegate.Image = [UIImage imageNamed:@"photo.png"];
//        }
//        
//        [addressArr addObject:addressDict];
//        [addressDict release];
//        addressDict = nil;
//      }
//      
//    }
//    else{
//      // -- No values in contacts list
//    }
//    
//    
//    
//    //CFRelease(allPeople);
//    CFRelease(peopleMutable);
//    CFRelease(addressBook);
//    
//    
//  }
//  @catch (NSException *exception) {
//    RDLog(@"Exception -- %@",exception);
//  }
//  @finally {
//    [pool drain];
//    
//    return [addressArr autorelease];
//    
//  }
//}
//
//-(void)getAddressBook_:(NSMutableArray*)suggestedArray callBack_:(id)callback callBackMethod_:(SEL)callBackMethod{
//  if ([self isABAddressBookCreateWithOptionsAvailable])
//  {
//    CFErrorRef error = nil;
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//      
//      if (error)
//      {
//        // display error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Some error in loading your contacts. Please retry later." delegate:nil cancelTitle:@"Close"];
//          if (callback!=nil) {
//            //[callback afterAddressBook_Finished2];
//              [callback performSelector:@selector(afterAddressBook_Finished2)];
//          }
//          
//        });
//        
//      }
//      else if (!granted)
//      {
//        // display access denied error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Address book request denied previously. Please go to your settings and grant access to your address book to show your contacts." delegate:nil cancelTitle:@"Close"];
//          
//          if (callback!=nil) {
//            //[callback afterAddressBook_Finished2];
//              [callback performSelector:@selector(afterAddressBook_Finished2)];
//          }
//
//        });
//        
//      }
//      else
//      {
//        // access granted
//        // do the important stuff here
//        RDLog(@" \n\n no need to do here \n\n\n");
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [self addressBookArrar_ToArray:suggestedArray];
//          
//          //RDLog(@" \n\n suggestedArray %@ \n\n\n",suggestedArray);
//          if (callback!=nil) {
//          [callback performSelector:callBackMethod];
//          }
//
// 
//          
//        });
//        
//      }
//      
//    });
//    
//    //CFRelease(addressBook);
//    
//  }
//  else
//  {
//    // do the important stuff here
//    //return [self addressBookArr_];
//    [self addressBookArrar_ToArray:suggestedArray];
//    //RDLog(@" \n\n suggestedArray %@ \n\n\n",suggestedArray);
//    if (callback!=nil) {
//      [callback performSelector:callBackMethod];
//    }
//
//    
//  }
//}
//
//-(void)getAddressBook_:(NSMutableArray*)suggestedArray :(id)callback{
//  if ([self isABAddressBookCreateWithOptionsAvailable])
//  {
//    CFErrorRef error = nil;
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//      
//      if (error)
//      {
//        // display error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Some error in loading your contacts. Please retry later." delegate:nil cancelTitle:@"Close"];
//          
//          //[callback afterAddressBook_Finished];
//            [callback performSelector:@selector(afterAddressBook_Finished)];
//        });
//        
//      }
//      else if (!granted)
//      {
//        // display access denied error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Address book request denied previously. Please go to your settings and grant access to your address book to show your contacts." delegate:nil cancelTitle:@"Close"];
//          
//          //[callback afterAddressBook_Finished];
//            [callback performSelector:@selector(afterAddressBook_Finished)];
//        });
//        
//      }
//      else
//      {
//        // access granted
//        // do the important stuff here
//        RDLog(@" \n\n no need to do here \n\n\n");
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [self addressBookArrar_ToArray:suggestedArray];
//          
//          //RDLog(@" \n\n suggestedArray %@ \n\n\n",suggestedArray);
//          
//          [callback performSelector:@selector(afterAddressBook_Finished)];
//
//        });
//        
//      }
//      
//    });
//    
//    //CFRelease(addressBook);
//    
//  }
//  else
//  {
//    // do the important stuff here
//    //return [self addressBookArr_];
//    [self addressBookArrar_ToArray:suggestedArray];
//    //RDLog(@" \n\n suggestedArray %@ \n\n\n",suggestedArray);
//    [callback performSelector:@selector(afterAddressBook_Finished)];
//    
//  }
//}
//
//-(void)getAddressBook:(NSMutableArray*)suggestedArray{
//
//  if ([self isABAddressBookCreateWithOptionsAvailable])
//  {
//    CFErrorRef error = nil;
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//      
//      if (error)
//      {
//        // display error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Some error in loading your contacts. Please retry later." delegate:nil cancelTitle:@"Close"];
//          
//        });
//        
//      }
//      else if (!granted)
//      {
//        // display access denied error message here
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [[AuxilaryService auxFunctions] showAlertWithTitle:@"" msg:@"Address book request denied previously. Please go to your settings and grant access to your address book to show your contacts." delegate:nil cancelTitle:@"Close"];
//          
//        });
//        
//      }
//      else
//      {
//        // access granted
//        // do the important stuff here
//        RDLog(@" \n\n no need to do here \n\n\n");
//        dispatch_async(dispatch_get_main_queue(), ^{
//          [self addressBookArrar_ToArray:suggestedArray];
//        });
//        
//      }
//      
//    });
//    
//    //CFRelease(addressBook);
//    
//  }
//  else
//  {
//    // do the important stuff here
//    //return [self addressBookArr_];
//    [self addressBookArrar_ToArray:suggestedArray];
//    
//  }
//}
//
//#pragma mark - Address book  Changes as per the new logic
//-(NSMutableDictionary*)getPhoneNumbersContacts:(NSMutableArray*)selectedContacts{
//    
//    NSMutableDictionary *dictionaryV = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dictionaryV setObject:@"0" forKey:NO_PHONENUMBER_AT_SELECTION];
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    @try {
//        
//        NSMutableArray *tempArray = [selectedContacts mutableCopy];      
//        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
//        
//        for (int j = 0; j<[tempArray count]; j++) {
//            
//            NSMutableDictionary *tempDict = [[tempArray objectAtIndex:j] retain];
//            if ([tempDict objectForKey:CONTACTS_PHONE]) {
//                [phoneArray addObject:[tempDict objectForKey:CONTACTS_PHONE]];
//            }
//            else{
//                [dictionaryV setObject:@"1" forKey:NO_PHONENUMBER_AT_SELECTION];
//                break;
//            }
//
//            [tempDict release];
//            tempDict = nil;
//        }
//        
//        [dictionaryV setObject:phoneArray forKey:PHONENUMBER_CONTACTS_FOR_SELECTION];
//        
//        [phoneArray release];
//        phoneArray = nil;
//        [tempArray release];
//        tempArray = nil;
//        
//    }
//    @catch (NSException *exception) {
//        RDLog(@"Exception -- %@",exception);
//    }
//    @finally {
//        [pool drain];
//        
//        return [dictionaryV autorelease];
//        
//    }
//}
//-(NSMutableDictionary*)getEmailsContacts:(NSMutableArray*)selectedContacts{
//    
//    NSMutableDictionary *dictionaryV = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dictionaryV setObject:@"0" forKey:NO_EMAIL_AT_SELECTION];
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    @try {
//        
//        NSMutableArray *tempArray = [selectedContacts mutableCopy];
//        NSMutableArray *emailArray = [[NSMutableArray alloc] init];
//        
//        for (int j = 0; j<[tempArray count]; j++) {
//            
//            NSMutableDictionary *tempDict = [[tempArray objectAtIndex:j] retain];
//            if ([tempDict objectForKey:CONTACTS_EMAIL]) {
//                [emailArray addObject:[tempDict objectForKey:CONTACTS_EMAIL]];
//            }
//            else{
//                [dictionaryV setObject:@"1" forKey:NO_EMAIL_AT_SELECTION];
//                break;
//            }
//
//            [tempDict release];
//            tempDict = nil;
//        }
//        
//        [dictionaryV setObject:emailArray forKey:EMAIL_CONTACTS_FOR_SELECTION];
//        
//        [emailArray release];
//        emailArray = nil;
//        [tempArray release];
//        tempArray = nil;
//        
//    }
//    @catch (NSException *exception) {
//        RDLog(@"Exception -- %@",exception);
//    }
//    @finally {
//        [pool drain];
//        
//        return [dictionaryV autorelease];
//        
//    }
//}
//
//#pragma mark - Address book Multiple Selection
//-(NSMutableDictionary*)getPhoneNumbersForSelectedRows:(NSArray*)indexPaths addressData:(NSMutableArray*)tempArr{
//    
//    NSMutableDictionary *dictionaryV = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dictionaryV setObject:@"0" forKey:NO_PHONENUMBER_AT_SELECTION];
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    @try {
//      
//        NSMutableArray *tempArray = [tempArr mutableCopy];
//        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
//
//        for (int j = 0; j<[indexPaths count]; j++) {
//            
//            NSMutableDictionary *tempDict = [[tempArray objectAtIndex:[(NSIndexPath*)[indexPaths objectAtIndex:j] row]] retain];
//            if ([tempDict objectForKey:CONTACTS_PHONE]) {
//                [phoneArray addObject:[tempDict objectForKey:CONTACTS_PHONE]];
//            }
//            else{
//                [dictionaryV setObject:@"1" forKey:NO_PHONENUMBER_AT_SELECTION];
//                break;
//            }
//            [tempDict release];
//            tempDict = nil;
//        }
//        
//        [dictionaryV setObject:phoneArray forKey:PHONENUMBER_FOR_SELECTION];
//        
//        [phoneArray release];
//        phoneArray = nil;
//        [tempArray release];
//        tempArray = nil;
//        
//    }
//    @catch (NSException *exception) {
//        RDLog(@"Exception -- %@",exception);
//    }
//    @finally {
//        [pool drain];
//        
//        return [dictionaryV autorelease];
//        
//    }
//}
//-(NSMutableDictionary*)getEmailsForSelectedRows:(NSArray*)indexPaths addressData:(NSMutableArray*)tempArr{
//    
//    NSMutableDictionary *dictionaryV = [[NSMutableDictionary alloc] initWithCapacity:0];
//    [dictionaryV setObject:@"0" forKey:NO_EMAIL_AT_SELECTION];
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    @try {
//        
//        NSMutableArray *tempArray = [tempArr mutableCopy];
//        NSMutableArray *emailArray = [[NSMutableArray alloc] init];
//        
//        for (int j = 0; j<[indexPaths count]; j++) {
//            
//            NSMutableDictionary *tempDict = [[tempArray objectAtIndex:[(NSIndexPath*)[indexPaths objectAtIndex:j] row]] retain];
//            if ([tempDict objectForKey:CONTACTS_EMAIL]) {
//                [emailArray addObject:[tempDict objectForKey:CONTACTS_EMAIL]];
//            }
//            else{
//                [dictionaryV setObject:@"1" forKey:NO_EMAIL_AT_SELECTION];
//                break;
//            }
//            [tempDict release];
//            tempDict = nil;
//        }
//        
//        [dictionaryV setObject:emailArray forKey:EMAIL_FOR_SELECTION];
//        
//        [emailArray release];
//        emailArray = nil;
//        [tempArray release];
//        tempArray = nil;
//        
//    }
//    @catch (NSException *exception) {
//        RDLog(@"Exception -- %@",exception);
//    }
//    @finally {
//        [pool drain];
//        
//        return [dictionaryV autorelease];
//        
//    }
//}
#pragma mark - UIImagePicker Helpers
/*!
 @function
 @discussion used to rescale image to the required size.
 */

-(UIImage*)scaleToSize:(CGSize)size forImage:(UIImage*)imageD
{
	//RDLog(@"%s",__FUNCTION__);
	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[imageD drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        //RDLog(@"\n\n --- imageSavedToPhotosAlbum print success -- ");
    }
    else
    {
        //RDLog(@"\n\n --- imageSavedToPhotosAlbum print error and see -- %@ ",error);
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
        
    [controller dismissModalViewControllerAnimated:TRUE];
  
  if (self.withShowImgView) {
      // -- if its source type from camera save it to the library fro re access
      if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
          // -- save to photos album...
          UIImageWriteToSavedPhotosAlbum([info valueForKey:UIImagePickerControllerOriginalImage], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
      }
      // -- Don't scale it to do it 320 by 300 now fro fitnessChamp its 300,300
      [self showImageView_Show:[self scaleToSize:CGSizeMake(300, 300) forImage:[info valueForKey:UIImagePickerControllerEditedImage]]];

  }
  else{
      // -- if its source type from camera save it to the library fro re access
      if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
          // -- save to photos album...
          UIImageWriteToSavedPhotosAlbum([info valueForKey:UIImagePickerControllerOriginalImage], self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
      }
      
      UIImage *selectedImg = [info valueForKey:UIImagePickerControllerEditedImage];
      NSData* imageData = UIImageJPEGRepresentation((UIImage*)selectedImg, 1.0);
    [imageDelegate selectedImage_Data:imageData];
    // - sending message to concerned controller abt image added
  }
  
	[picker release];
	picker = nil;

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [controller dismissModalViewControllerAnimated:TRUE];
	[picker release];
	picker = nil;
}

-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no{
    
    controller = sender;
    self.withShowImgView = yes_no;
    self.withDeletePhoto = NO; // -- normally its Fals condition..
    
    UIActionSheet *actionSht = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose from library", nil];
    [actionSht setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSht showInView:[controller view]];
    [actionSht release];
    
}

-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andShowInView:(id)hostView{
    
    controller = sender;
    self.withShowImgView = yes_no;
    self.withDeletePhoto = NO; // -- normally its Fals condition..
    
    UIActionSheet *actionSht = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take photo",@"Choose from library", nil];
    [actionSht setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSht showInView:hostView];
    [actionSht release];

}

-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andDeletBtn:(BOOL)showDeleteBtn{
    
    controller = sender;
    self.withShowImgView = yes_no;
    self.withDeletePhoto = showDeleteBtn;
    
    UIActionSheet *actionSht = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete photo" otherButtonTitles:@"Take photo",@"Choose from library", nil];
    [actionSht setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSht showInView:[controller view]];
    [actionSht release];
    
}

-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andDeletBtn:(BOOL)showDeleteBtn andShowInView:(id)hostView{
    
    controller = sender;
    self.withShowImgView = yes_no;
    self.withDeletePhoto = showDeleteBtn;
    
    UIActionSheet *actionSht = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete photo" otherButtonTitles:@"Take photo",@"Choose from library", nil];
    [actionSht setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSht showInView:hostView];
    [actionSht release];

}


// -- CALL THIS METHOD IF USER CLICKS BACK BUTTON FROM CONTROLLER
+(void)removeShowImageView:(id)controller{
    for (UIView* view_ in controller) {
        if ([view_ isKindOfClass:[ShowImageView class]]) {
            [view_ removeFromSuperview];
            //RDLog(@"\n Have image view Show Image View \n\n");
            break;
        }
    }
}
-(void)showImageView_Show:(UIImage*)imageV{

    ShowImageView *sImgV = [[ShowImageView alloc] initWithFrame:[[controller view] frame]];
    [sImgV.showImg setImage:imageV];
    [sImgV setDelegate:self];
    [self setShowImageV:sImgV];
    [[controller view] addSubview:sImgV];
    [sImgV release];
}
                           
#pragma mark  Showimageview Delegates
-(void)addPhotoClicked:(id)sender{
  
  //RDLog(@"\n\n %s \n",__FUNCTION__);
  
    [sender retain];
    [self.showImageV removeFromSuperview];
    //-- sender send image in UI Image format
    //NSData* imageData = UIImagePNGRepresentation((UIImage*)sender);
    NSData* imageData = UIImageJPEGRepresentation((UIImage*)sender , 1.0);
    [imageDelegate selectedImage_Data:imageData]; // - sending message to concerned controller abt image added
    [sender release];
    
}

-(void)cancelPhotoClicked:(id)sender{
  
  //RDLog(@"\n\n %s \n",__FUNCTION__);
    // --sender will send nil value
    [self.showImageV removeFromSuperview];
    
}

-(void)delete_PhotoClicked:(id)sender{
    //RDLog(@"\n\n %s \n",__FUNCTION__);
    // --sender will send nil value

}

#pragma mark  action sheet Delegate Photo addition Images
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //RDLog(@"Clicked buttonIndex %d",buttonIndex);
 
    if (_withDeletePhoto) {
        // -- remove the focus
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setAllowsEditing:TRUE];
        [imagePicker setDelegate:self];
        switch (buttonIndex) {
            case 0: // -- delete photo
                [imageDelegate deleteImageData:YES];
                [imagePicker release];
                //RDLog(@"\n\n  Delete Button --- %d ",buttonIndex);
                break;

            case 1: // -- take photo
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [[controller navigationController] presentViewController:imagePicker animated:TRUE completion:^(){}];
                    
                }
                else{
                    [imagePicker release];
                }
                break;
                
            case 2: // -- choose from library...
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    //[[controller navigationController] presentModalViewController:imagePicker animated:TRUE];
                    [[controller navigationController] presentViewController:imagePicker animated:TRUE completion:^(){}];
                    
                }
                else{
                    [imagePicker release];
                }
                break;
            default:{                
                //RDLog(@"No execution");
                [imagePicker release];
            }
                break;
        }
    }
    else{
        // -- remove the focus
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setAllowsEditing:TRUE];
        [imagePicker setDelegate:self];
        switch (buttonIndex) {
            case 0:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [[controller navigationController] presentViewController:imagePicker animated:TRUE completion:^(){}];
                    
                }
                else{
                    [imagePicker release];
                }
                break;
                
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    
                    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [[controller navigationController] presentViewController:imagePicker animated:TRUE completion:^(){}];
                    
                }
                else{
                    [imagePicker release];
                }
                break;
            default:{
                
                //RDLog(@"No execution");
                [imagePicker release];
            }
                break;
        }
    }
}


#pragma mark - MFMailComposeViewControllerDelegate
-(void)showEmailModalWithReceipients:(NSArray*)receipients subject:(NSString*)sub body:(NSString*)body_ onTarget:(id)target{
    
    //RDLog(@"%s",__FUNCTION__);
        
    if ([MFMailComposeViewController canSendMail]) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:receipients];
        if (sub!=nil) {
            [mailController setSubject:sub];
        }
        if (body_!=nil) {
            [mailController setMessageBody:body_ isHTML:FALSE];
        }
        [target presentModalViewController:mailController animated:YES];
        [mailController release];
        mailController = nil;
        [pool drain];

    }
    else {
        //[[AuxilaryService auxFunctions] showAlertWithTitle:@"No email client found to send E-mail" msg:@"" delegate:nil cancelTitle:@"Close"];
        [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:@"No email client found to send E-mail" title:nil cancelTitle:@"OK" otherTitle: nil];
    }
    

}

-(void)showEmailModalWithReceipients_:(NSArray*)receipients subject_:(NSString*)sub body_:(NSString*)body_ onTarget:(id)target ishtml:(BOOL)html attachData_:(NSData*)attachData{
  
  //RDLog(@"%s",__FUNCTION__);
  if ([MFMailComposeViewController canSendMail]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:receipients];
    if (sub!=nil) {
      [mailController setSubject:sub];
    }
    if (body_!=nil) {
      [mailController setMessageBody:body_ isHTML:html];
    }
    if (attachData!=nil) {
      [mailController addAttachmentData:attachData mimeType:@"image/jpg" fileName:@"photo"];
    }
    
    [target presentModalViewController:mailController animated:YES];
    [mailController release];
    mailController = nil;
    [pool drain];
    
  }
  else {
    //[[AuxilaryService auxFunctions] showAlertWithTitle:@"No email client found to send E-mail" msg:@"" delegate:nil cancelTitle:@"Close"];
      [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:@"No email client found to send E-mail" title:nil cancelTitle:@"OK" otherTitle: nil];
  }
  
  
}


- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    //RDLog(@"%s",__FUNCTION__);
    // Notifies users about errors associated with the interface
    
    NSString *msg = nil;
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
            //[[mailController parentViewController] dismissViewControllerAnimated:TRUE completion:^(){}];
            [mailController dismissViewControllerAnimated:YES completion:^(void){}];
			break;
		case MFMailComposeResultSaved:
            
			msg = @"It is saved in your email draft folder";
			break;
		case MFMailComposeResultSent:
			
			msg = @"Email sent";
			break;
		case MFMailComposeResultFailed:
			
			msg = @"Fail to send";
			break;
		default:
            
			msg = @"There seems to be problems sending. Please try again";
			break;
	}
	
    if (msg) {
        //[[AuxilaryService auxFunctions] showAlertWithTitle:nil msg:msg delegate:nil cancelTitle:@"Close"];
        [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:msg title:nil cancelTitle:@"OK" otherTitle: nil];
    }
    
	[mailController dismissViewControllerAnimated:YES completion:^(void){}];
    //[[mailController parentViewController] dismissViewControllerAnimated:TRUE completion:^(){}];
    
}

#pragma mark -
#pragma mark - SMS Delegate
-(void)showSmsModalWithReceipients:(NSArray*)receipients body:(NSString*)body_ onTarget:(id)target{
    
    //RDLog(@"%s",__FUNCTION__);
    
    // -- block still api response comes back -- progressive view
    
    if ([MFMessageComposeViewController canSendText]) {

        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        [picker setRecipients:receipients];
        [picker setBody:body_];
        [target presentModalViewController:picker animated:YES];
        [picker release];
        [pool drain];

    }
    else {
        //[[AuxilaryService auxFunctions] showAlertWithTitle:@"No network found to send SMS" msg:@"" delegate:nil cancelTitle:@"Close"];
        [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:@"No network found to send SMS" title:nil cancelTitle:@"OK" otherTitle: nil];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller_ didFinishWithResult:(MessageComposeResult)result
{

    //RDLog(@"%s",__FUNCTION__);
	NSString *msg = nil;
    
	switch (result) 
	{
		case MessageComposeResultCancelled:
            //[[controller parentViewController] dismissModalViewControllerAnimated:YES];
            //[[controller_ parentViewController] dismissViewControllerAnimated:TRUE completion:^(){}];
            [controller_ dismissViewControllerAnimated:YES completion:^(void){}];
			break;
		case MessageComposeResultFailed:
			
			msg = @"Fail to send.";
			break;
		case MessageComposeResultSent:
			
			msg = @"Invitation sent";
			break;
		default:
			
			msg = @"There seems to be problems sending. Please try again.";
			break;
	}
	
    if (msg) {
        //[[AuxilaryService auxFunctions] showAlertWithTitle:nil msg:msg delegate:nil cancelTitle:@"Close"];
        [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:msg title:nil cancelTitle:@"OK" otherTitle: nil];
    }
    
    
    //[controller dismissModalViewControllerAnimated:YES];
    [controller_ dismissViewControllerAnimated:YES completion:^(void){}];
    //[[controller_ parentViewController] dismissViewControllerAnimated:TRUE completion:^(){}];
    
}



#pragma mark - Show Alert
-(void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg_ delegate:(id)delegt cancelTitle:(NSString*)cTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(msg_, @"") delegate:delegt cancelButtonTitle:cTitle otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)showInfoButtonAlertWithMessage:(NSString*)msg{
    [self showUniversalPopUpsWithTitle:@"Info" description:msg imageURL:nil];
}

-(void)showInfoButtonAlertWithMessage:(NSString*)msg ButtonTitle:(NSString *) buttonTitle{
    [self showUniversalPopUpsWithTitle:@"Info" description:msg imageURL:nil OnClose:nil ButtonTitle:buttonTitle];
}

-(void)showUniversalPopUpsWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSString *)imageURL OnClose:(void (^) ()) onClose ButtonTitle:(NSString *) buttonTitle{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *popupSuperView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_BOUNDS.size.width, MAIN_SCREEN_BOUNDS.size.height)] autorelease];
    [popupSuperView setBackgroundColor:[UIColor colorWithRed:31.0/255.0f green:32.0/255.0f blue:31/255.0f alpha:1]];
    
    UILabel *titleLbl_ = nil;
    CGFloat yOffset = LEFT_MARGIN;
    // -- title ..
    if (title) {
        
        titleLbl_ = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, popupSuperView.frame.size.width - (2*LEFT_MARGIN), popupSuperView.frame.size.height-(2*LEFT_MARGIN))] autorelease];
        [titleLbl_ setTextColor:[UIColor whiteColor]];
        [titleLbl_ setBackgroundColor:[UIColor clearColor]];
        [titleLbl_ setTextAlignment:NSTextAlignmentCenter];
        [titleLbl_ setNumberOfLines:0];
        [titleLbl_ setFont:[UIFont fontWithName:@"Arial" size:20]];
        [titleLbl_ setText:title];
        
        
        // -- change the text frame according to the text height..
        CGFloat hgtOfTxt = [AuxilaryUIService getHeightOfLabelFor_Text:titleLbl_.text andfont:titleLbl_.font andWidthConstraint:titleLbl_.frame.size.width];
        CGRect framSwap = [titleLbl_ frame];
        framSwap.size.height = hgtOfTxt + 2*LEFT_MARGIN;
        [titleLbl_ setFrame:framSwap];
        
        [popupSuperView addSubview:titleLbl_];
        yOffset += titleLbl_.frame.size.height;
        titleLbl_ = nil;
    }
    if (imageURL) {
        
        AsyncImageView *imageView= [[[AsyncImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, yOffset, MAIN_SCREEN_BOUNDS.size.width, (2/3)*(MAIN_SCREEN_BOUNDS.size.height - (2*LEFT_MARGIN)))] autorelease];
        [imageView setImageURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
        
        [popupSuperView addSubview:imageView];
        
        yOffset += imageView.frame.size.height;
        
    }
    if (description) {
        
        titleLbl_ = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, yOffset-5, popupSuperView.frame.size.width - (2*LEFT_MARGIN), popupSuperView.frame.size.height-(2*LEFT_MARGIN))] autorelease];
        [titleLbl_ setTextColor:[UIColor whiteColor]];
        [titleLbl_ setBackgroundColor:[UIColor clearColor]];
        [titleLbl_ setTextAlignment:NSTextAlignmentCenter];
        [titleLbl_ setNumberOfLines:0];
        [titleLbl_ setFont:[UIFont fontWithName:@"Arial" size:15]];
        [titleLbl_ setText:description];
        
        
        // -- change the text frame according to the text height..
        CGFloat hgtOfTxt = [AuxilaryUIService getHeightOfLabelFor_Text:titleLbl_.text andfont:titleLbl_.font andWidthConstraint:titleLbl_.frame.size.width];
        CGRect framSwap = [titleLbl_ frame];
        framSwap.size.height = hgtOfTxt + 2*LEFT_MARGIN;
        [titleLbl_ setFrame:framSwap];
        
        [popupSuperView addSubview:titleLbl_];
        yOffset += titleLbl_.frame.size.height + LEFT_MARGIN;
        titleLbl_ = nil;
    }
    
    int global_popup_id = 9891;
    
    
    UIButtonIndexPathAndBlock *closeButton = [UIButtonIndexPathAndBlock buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundColor:RGB(214, 23, 0)];
    [[closeButton titleLabel] setFont:[UIFont fontWithName:BEBAS_NEUE_FONT size:20.0]];
    if (buttonTitle==nil) {
        buttonTitle = @"Close";
    }
    [closeButton setTitle:buttonTitle forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(0, yOffset, 320,50)];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [closeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        //RDLog(@"\n\n - %s ",__FUNCTION__);
        
        AppDelegate *appDelegateWindow = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        id popup = [[appDelegateWindow window] viewWithTag:global_popup_id];
        if (popup) {
            [popup removeFromSuperview];
        }
        
        if (onClose) {
            dispatch_async(dispatch_get_main_queue(), onClose);
        }
    }];
    [popupSuperView addSubview:closeButton];
    yOffset += closeButton.frame.size.height;
    
    
    // -- backgroundview here.
    UIView *popupSuperSuperView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_BOUNDS.size.width, MAIN_SCREEN_BOUNDS.size.height)] autorelease];
    [popupSuperSuperView setBackgroundColor:RGBALPHA(0, 0, 0, 0.65)];
    [popupSuperSuperView setTag:global_popup_id];
    
    // -- info button close
    CGRect framSwap = [popupSuperView frame];
    framSwap.size.height = yOffset;
    framSwap.origin.y = (popupSuperSuperView.frame.size.height - framSwap.size.height)/2;
    [popupSuperView setFrame:framSwap];
    [popupSuperSuperView addSubview:popupSuperView];
    
    
    [[appDelegate window] addSubview:popupSuperSuperView];
}

-(void)showUniversalPopUpsWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSString *)imageURL OnClose:(void (^) ()) onClose{
    [self showUniversalPopUpsWithTitle:title description:description imageURL:nil OnClose:onClose ButtonTitle:nil];
}

-(void)showUniversalPopUpsWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSString *)imageURL{
    [self showUniversalPopUpsWithTitle:title description:description imageURL:description OnClose:nil];
}


-(void)showAlertDelegate:(id)delegt msg:(NSString*)msg_ title:(NSString*)title cancelTitle:(NSString*)cTitle otherTitle:(NSString *)otherButtonTitles, ...{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(msg_, @"") delegate:delegt cancelButtonTitle:cTitle otherButtonTitles:nil];
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alert addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alert addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }

  [alert show];
  [alert release];
}

-(void)showWC_AlertDelegate:(id)delegt msg:(NSString *)msg_ title:(NSString *)title cancelTitle:(NSString *)cTitle otherTitle:(NSString *)otherButtonTitles, ...{
    
    //RDLog(@"\n %s \n",__FUNCTION__);
    
    WCAlertView *alert = [[[WCAlertView alloc] initWithTitle:title
                                                     message:msg_
                                                    delegate:delegt cancelButtonTitle:cTitle
                                           otherButtonTitles:nil] autorelease];
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alert addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alert addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }

    alert.style = WCAlertViewStyleBlack;
    [alert show];
}

-(void)showError_AlertDelegate:(id)delegt withTag:(NSInteger)tag Error:(NSError *) error
{
    if (error!=nil && error.userInfo!=nil) {
        [self showWC_AlertDelegate:delegt msg:[error.userInfo valueForKey:@"messageToUser"] title:[error.userInfo valueForKey:@"title"] cancelTitle:nil otherTitle:@"OK", nil];
    }
}


-(void)showWC_AlertDelegate:(id)delegt withTag:(NSInteger)tag msg:(NSString *)msg_ title:(NSString *)title cancelTitle:(NSString *)cTitle otherTitle:(NSString *)otherButtonTitles, ...{
    
    //RDLog(@"\n %s \n",__FUNCTION__);
    
    WCAlertView *alert = [[[WCAlertView alloc] initWithTitle:title
                                                     message:msg_
                                                    delegate:delegt cancelButtonTitle:cTitle
                                           otherButtonTitles:nil] autorelease];
    [alert setTag:tag];
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alert addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alert addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    
    alert.style = WCAlertViewStyleBlack;
    [alert show];
}



#pragma mark - helpers
-(BOOL)isDictionaryHaveData:(NSDictionary*)dict{
    BOOL haveData = FALSE;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (dict!=nil && [[dict allKeys] count]>0 && ![dict isKindOfClass:[NSNull class]] && ![dict isKindOfClass:[NSNull class]]) {
        haveData = TRUE;
    }
    
    [pool drain];
    return haveData;
}

/**
 @brief set non null values to the dictionary
 
 @param dictionary - The mutable dixtionary where the value is to be set
 @param object - The object to set
 @param key - The key for the object in the dictionary
 */
+ (void) setObjectAtDictionary:(NSMutableDictionary *) dictionary object:(id) object forKey:(NSString *) key
{
    // RDLog(@"The dictionary is %@",dictionary);
	
    if (object != nil && object != NULL && ![object isKindOfClass:[NSNull class]])
	{
        
        //RDLog(@"The dictionary is setting the inage object");
		[dictionary setObject:object forKey:key];
	}
	else
	{
		[dictionary removeObjectForKey:key];
	}
}


-(BOOL)isStringAvailable:(NSString*)str inArray:(NSArray*)arr{
    BOOL isAvailable = FALSE;
    
//    for (int i = 0; i<[arr count]; i++) {
//        NSRange keyRange = [(NSString*)[arr objectAtIndex:i] rangeOfString:@"|" options:NSCaseInsensitiveSearch];
//
//    }
    
    for (NSString *strings in arr) {
        if ([strings isEqualToString:str]) {
            isAvailable = TRUE;
            break;
        }
    }
    
    return isAvailable;
}

+(void)enableSubviews:(UIView*)view{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray *subviews = [view subviews];

    for (int i =0; i<[subviews count]; i++) {

        if ([[subviews objectAtIndex:i] respondsToSelector:@selector(setUserInteractionEnabled:)]) {
            [[subviews objectAtIndex:i] setUserInteractionEnabled:TRUE];
        }
        
    }

    [pool drain];
}

#pragma mark - Animation helpers

/**
 @brief The jump animation for the status message. Can be used to jump from current location to the given point.
 
 @param point - the (x,y) point to jump to.
 */
- (void) jumpAnimationForView:(UIView*)animatedView
					  toPoint:(CGPoint)point 
{
	// moving
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:ANIMATION_TIME];
	[animatedView setCenter:point];
	
	// scaling
	CABasicAnimation *scalingAnimation = (CABasicAnimation *)[animatedView.layer animationForKey:@"scaling"];
	if (!scalingAnimation)
	{
		scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
		scalingAnimation.duration=ANIMATION_TIME/2.0f;
		scalingAnimation.autoreverses=YES;
		scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
		scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4, 1.4, 1.0)];
	}
	[animatedView.layer addAnimation:scalingAnimation forKey:@"scaling"];
	[UIView commitAnimations];
}



/// UI Elements
+ (UIButton *) getDefaultButton: (NSString *) title image:(NSString*)img tag:(int)tagV target:(id)target selector:(NSString*)selectorStr
{
    //Initialize an autorelease pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIButton * thisButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    
    @try 
    {
        if (title) {

            thisButton.backgroundColor = STYLE_BUTTON_BACKGROUND_COLOR_DEFAULT;
            thisButton.titleLabel.font = STYLE_FONT_DEFAULT_BOLD;
            thisButton.layer.borderColor = STYLE_FONT_COLOR_DEFAULT.CGColor;
            thisButton.layer.borderWidth = 0.5f;
            thisButton.layer.cornerRadius = 10.0f;
            thisButton.layer.masksToBounds = YES;
            [thisButton setTitle:title forState:UIControlStateNormal];
            [thisButton setTitleColor:STYLE_FONT_COLOR_DEFAULT forState:UIControlStateNormal];
            [thisButton setTitleColor:STYLE_FONT_COLOR_DEFAULT forState:UIControlStateHighlighted];
        }
        
        if (img) {
            
            [thisButton setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
            [thisButton setFrame:CGRectMake((320-[UIImage imageNamed:img].size.width)/2, 0, [UIImage imageNamed:img].size.width, [UIImage imageNamed:img].size.height)];
            [thisButton setTitle:title forState:UIControlStateNormal];
            thisButton.backgroundColor = [UIColor clearColor];
            [thisButton setTitleColor:STYLE_FONT_COLOR_DEFAULT forState:UIControlStateNormal];
            [thisButton setTitleColor:STYLE_FONT_COLOR_DEFAULT forState:UIControlStateHighlighted];

        }
        
        [thisButton setTag:tagV];
        [thisButton addTarget:target action:NSSelectorFromString(selectorStr) forControlEvents:UIControlEventTouchUpInside];
        
    }
    @catch (NSException *exception) 
    {
        //Exception Occurred
        //RDLog(@"Exception in ClassName.getDefaultButton %@",exception);
    }
    @finally 
    {
        //Drain the pool
        [pool drain];
        return [thisButton autorelease];
    }
    
}



//Style
/**
 @brief getColorFromHexString is used to get the color from a string that is given as #HEXSTR 
 
 @param hexString - is the hex string that is given to this function and UIColor representing the color in RGB is given
 */
+ (UIColor *) getColorFromHexString:(NSString *) hexString
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
	NSScanner *scanner2 = [NSScanner scannerWithString:hexString];
	unsigned int baseColor;
	[scanner2 setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; 
	[scanner2 scanHexInt:&baseColor];
	CGFloat red   = ((baseColor & 0xFF0000) >> 16) / 255.0f;
	CGFloat green = ((baseColor & 0x00FF00) >>  8) / 255.0f;
	CGFloat blue  =  (baseColor & 0x0000FF) / 255.0f;
	[pool drain];
	UIColor * returnColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	
	return returnColor;
}

+(UIImage*)scaleImage: (UIImage *) image ToSize:(CGSize)size
{
	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

#pragma mark - Device helper

+ (BOOL) canDeviceCall
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    
}
+ (BOOL) canDeviceMutlitask
{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
    {
        backgroundSupported = device.multitaskingSupported;
    }
    
    return backgroundSupported;
}

#pragma mark - Controller Helpers
#define ICON_BADGE 121
#define ICON_BADGE_IMG  @"icn_badge.png"
+(UIImageView*)getBadgeIcons_WithCount:(NSString*)countV frame:(CGRect)frame_{
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:frame_];
    [iconImg setImage:[UIImage imageNamed:ICON_BADGE_IMG]];
    [iconImg setContentMode:UIViewContentModeScaleAspectFit];
    [iconImg setBackgroundColor:[UIColor clearColor]];
    //[iconImg setBackgroundColor:[UIColor blackColor]];
    [iconImg setUserInteractionEnabled:TRUE];
    //[iconImg setTag:19];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 16, 16)];
    [textLbl setTextColor:RGB(255, 255, 255)];
    [textLbl setBackgroundColor:[UIColor clearColor]];
    [textLbl setTextAlignment:UITextAlignmentCenter];
    [textLbl setText:countV];
    [textLbl setTag:ICON_BADGE];
    [textLbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:10]];
    [textLbl setNumberOfLines:0];
    [iconImg addSubview:textLbl];
    [textLbl release];
    textLbl = nil;
    
    return [iconImg autorelease];
}

+(NSString*)getCsv_ForInterests:(NSArray*)interest_name{
    
    if ([interest_name count]>0) {
        
        NSMutableString *interst_string = [NSMutableString stringWithString:@""];
        
        for (NSDictionary *dict in interest_name) {
            [interst_string appendFormat:@"%@",[dict objectForKey:PLACE_NAME]]; 
        }
        
        return interst_string;

    }
    else {
        return nil;
    }
}

+(NSString*)splitNameFrom_FriendsName:(NSString*)friends_name{
    if (![friends_name isKindOfClass:[NSNull class]] && [friends_name length]!=0) {

        return [[friends_name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] objectAtIndex:0];
        
    }
    else {
        return @"";
    }
}

#pragma mark - Navigation Bar & Navigation Item Helper
+(void)setNavigationTitleStyle_ToPY:(UINavigationBar*)navBar{

//    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 255, 255),NSForegroundColorAttributeName,[UIFont fontWithName:ROBOTO_MEDIUM size:20.0f],NSFontAttributeName,[UIColor clearColor],NSShadowAttributeName,CGSizeZero,NSShadowAttributeName, nil]];

//    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 255, 255),NSForegroundColorAttributeName,[UIFont fontWithName:ROBOTO_MEDIUM size:20.0f],NSFontAttributeName,[UIColor clearColor],NSShadowAttributeName,CGSizeZero,NSShadowAttributeName, nil]];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [navBar setTitleTextAttributes:titleBarAttributes];
}


+(void)setNavigationTitleStyle_ForDict:(NSDictionary*)txtColor nav_Bar:(UINavigationBar*)navBar{
  [navBar setTitleTextAttributes:txtColor];
}

#pragma mark - POP TO DISMISS AND NOTIFICATIONS
-(void)pop2Dismiss:(id)sender{
  
}


+(void)addNotificationForObserver:(id)observer withSelector:(SEL)selector name:(NSString*)name andObject:(id)object{

  
  //RDLog(@"\n\n total objects");
  // -- add it here
  [NOTIFICATION_CENTER addObserver:observer selector:selector name:name object:object];
  
    
  //// --- savign the notificaitons to remove and add in certain conditions
  NSDictionary *notificationDict = nil;
  
  if (object) {
    notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:observer,NOTIFICATION_OBSERVER,NSStringFromSelector(selector),NOTIFICATIONS_SELECTOR,name,NOTIFICATIONS_NAME,object,NOTIFICATIONS_OBJECT, nil];
  }
  else{
    notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:observer,NOTIFICATION_OBSERVER,NSStringFromSelector(selector),NOTIFICATIONS_SELECTOR,name,NOTIFICATIONS_NAME, nil];
  }
  
  NSMutableArray *n_array = [[NSMutableArray alloc] init];
  
  //RDLog(@"\n\n %s total objects in notifications Array BEFORE :::!!!!!!!!\n adding %@ \n\n",__FUNCTION__,[USER_DEFAULTS objectForKey:NOTIFICATIONS_ARRAY]);

  
  if (![USER_DEFAULTS objectForKey:NOTIFICATIONS_ARRAY]) {
    [n_array addObject:notificationDict];
    
    NSData *n_array_archivedData = [NSKeyedArchiver archivedDataWithRootObject:n_array];
    [USER_DEFAULTS setObject:n_array_archivedData forKey:NOTIFICATIONS_ARRAY];
  }
  else{
    
    n_array = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULTS objectForKey:NOTIFICATIONS_ARRAY]];
    //[n_array addObjectsFromArray:[USER_DEFAULTS objectForKey:NOTIFICATIONS_ARRAY]];
    [n_array addObject:notificationDict];
    [USER_DEFAULTS setObject:n_array forKey:NOTIFICATIONS_ARRAY];
  }
  
  //RDLog(@"\n\n %s total objects in notifications Array AFTER ^^^^^^^^^ \n adding %@ \n\n",__FUNCTION__,[USER_DEFAULTS objectForKey:NOTIFICATIONS_ARRAY]);
  
}


#pragma mark - FilePath
- (NSString *)getDocumentDirectory:(NSString *)filePath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentPath stringByAppendingFormat:@"/%@", filePath];
}

#pragma mark  Write & Read.. Data CSV to file
-(BOOL)isFileExists:(NSString*)fileName{
    // -- check whether the file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getDocumentDirectory:fileName]]) {
        // -- No file exists so create the file
        //RDLog(@"\n\n -- file not exists at path --- %s ",__FUNCTION__);
        return NO;
    }
    return YES;
}


@end
