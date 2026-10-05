#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// MARK: NSFWgram — startup flight recorder (visible in Files app → NSFWgram)
static void NSFWWriteStartupLog(NSString *text) {
    @autoreleasepool {
        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        if (!docs) { return; }
        NSString *path = [docs stringByAppendingPathComponent:@"startup-log.txt"];
        NSString *line = [NSString stringWithFormat:@"%@ NSFWgram: %@\n", [NSDate date], text];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:path];
            if (fh) {
                [fh seekToEndOfFile];
                [fh writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
                [fh closeFile];
                return;
            }
        }
        [line writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

// runs after all frameworks are loaded, before main()
__attribute__((constructor)) static void NSFWStartupProbe(void) {
    NSFWWriteStartupLog(@"dyld: all frameworks loaded");
}

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSFWWriteStartupLog(@"main() entered");
        return UIApplicationMain(argc, argv, @"Application", @"AppDelegate");
    }
}
