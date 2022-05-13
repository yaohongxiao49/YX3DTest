//
//  YX3DBallBtnMatrix.h
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#ifndef YX3DBallBtnMatrix_h
#define YX3DBallBtnMatrix_h

#import "YX3DBallBtnPoint.h"

struct YX3DBallBtnMatrix {
    
    NSInteger column;
    NSInteger row;
    CGFloat matrix[4][4];
};

typedef struct YX3DBallBtnMatrix YX3DBallBtnMatrix;

static YX3DBallBtnMatrix YX3DBallBtnMatrixMake(NSInteger column, NSInteger row) {
    
    YX3DBallBtnMatrix matrix;
    matrix.column = column;
    matrix.row = row;
    for (NSInteger i = 0; i < column; i++){
        for (NSInteger j = 0; j < row; j++){
            matrix.matrix[i][j] = 0;
        }
    }
    
    return matrix;
}

static YX3DBallBtnMatrix YX3DBallBtnMatrixMakeFromArray(NSInteger column, NSInteger row, CGFloat *data) {
    
    YX3DBallBtnMatrix matrix = YX3DBallBtnMatrixMake(column, row);
    for (int i = 0; i < column; i ++) {
        CGFloat *t = data + (i * row);
        for (int j = 0; j < row; j++) {
            matrix.matrix[i][j] = *(t + j);
        }
    }
    return matrix;
}

static YX3DBallBtnMatrix YX3DBallBtnMatrixMutiply(YX3DBallBtnMatrix a, YX3DBallBtnMatrix b) {
    
    YX3DBallBtnMatrix result = YX3DBallBtnMatrixMake(a.column, b.row);
    for (NSInteger i = 0; i < a.column; i ++) {
        for (NSInteger j = 0; j < b.row; j ++) {
            for (NSInteger k = 0; k < a.row; k++) {
                result.matrix[i][j] += a.matrix[i][k] * b.matrix[k][j];
            }
        }
    }
    return result;
}

static YX3DBallBtnPoint YX3DBallBtnPointMakeRotation(YX3DBallBtnPoint point, YX3DBallBtnPoint direction, CGFloat angle) {

    if (angle == 0) {
        return point;
    }
    
    CGFloat temp2[1][4] = {point.x, point.y, point.z, 1};
    
    YX3DBallBtnMatrix result = YX3DBallBtnMatrixMakeFromArray(1, 4, *temp2);
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1[4][4] = {{1, 0, 0, 0}, {0, cos1, sin1, 0}, {0, -sin1, cos1, 0}, {0, 0, 0, 1}};
        YX3DBallBtnMatrix m1 = YX3DBallBtnMatrixMakeFromArray(4, 4, *t1);
        result = YX3DBallBtnMatrixMutiply(result, m1);
    }
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2[4][4] = {{cos2, 0, -sin2, 0}, {0, 1, 0, 0}, {sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        YX3DBallBtnMatrix m2 = YX3DBallBtnMatrixMakeFromArray(4, 4, *t2);
        result = YX3DBallBtnMatrixMutiply(result, m2);
    }
    
    CGFloat cos3 = cos(angle);
    CGFloat sin3 = sin(angle);
    CGFloat t3[4][4] = {{cos3, sin3, 0, 0}, {-sin3, cos3, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    YX3DBallBtnMatrix m3 = YX3DBallBtnMatrixMakeFromArray(4, 4, *t3);
    result = YX3DBallBtnMatrixMutiply(result, m3);
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2_[4][4] = {{cos2, 0, sin2, 0}, {0, 1, 0, 0}, {-sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        YX3DBallBtnMatrix m2_ = YX3DBallBtnMatrixMakeFromArray(4, 4, *t2_);
        result = YX3DBallBtnMatrixMutiply(result, m2_);
    }
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1_[4][4] = {{1, 0, 0, 0}, {0, cos1, -sin1, 0}, {0, sin1, cos1, 0}, {0, 0, 0, 1}};
        YX3DBallBtnMatrix m1_ = YX3DBallBtnMatrixMakeFromArray(4, 4, *t1_);
        result = YX3DBallBtnMatrixMutiply(result, m1_);
    }
    
    YX3DBallBtnPoint resultPoint = YX3DBallBtnPointMake(result.matrix[0][0], result.matrix[0][1], result.matrix[0][2]);
    
    return resultPoint;
}

#endif /* YX3DBallBtnMatrix_h */
