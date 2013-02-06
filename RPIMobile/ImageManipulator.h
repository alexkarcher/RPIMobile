@interface ImageManipulator : NSObject {
}
+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;
@end