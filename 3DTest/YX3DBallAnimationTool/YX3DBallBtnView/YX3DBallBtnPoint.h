//
//  YX3DBallBtnPoint.h
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#ifndef YX3DBallBtnPoint_h
#define YX3DBallBtnPoint_h

struct YX3DBallBtnPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct YX3DBallBtnPoint YX3DBallBtnPoint;

YX3DBallBtnPoint YX3DBallBtnPointMake(CGFloat x, CGFloat y, CGFloat z) {
    
    YX3DBallBtnPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif /* YX3DBallBtnPoint_h */
