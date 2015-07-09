//
//  WrappingTestView.mm
//  WeView
//
//  Copyright (c) 2015 FiftyThree, Inc. All rights reserved.
//

#import "WrappingTestView.h"

@implementation WrappingTestView

- (id)init
{
    if (self = [super init]) {
        self.blockSize = CGSizeZero;
        self.blockCount = 0;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)guideSize
{
    if (guideSize.width <= 0) {
        // The "ideal" layout for this view is with its block arranged in a horizontal row.
        CGSize result = CGSizeMake(self.blockSize.width * self.blockCount,
                                   self.blockSize.height);
        return result;
    }
    if (self.blockCount < 1) {
        return CGSizeZero;
    }

    // We use double to avoid overflow since the guide size may be very large.
    double maxBlocksPerRow = MAX(1.,
                                 (self.blockSize.width > 0
                                      ? floorf(guideSize.width / self.blockSize.width)
                                      : 1.));
    int blocksPerRow = (int)MIN(self.blockCount,
                                maxBlocksPerRow);
    long long rowCount = (long long)ceilf(self.blockCount / blocksPerRow);
    CGSize result = CGSizeMake(self.blockSize.width * blocksPerRow,
                               self.blockSize.height * rowCount);
    return result;
}

@end
