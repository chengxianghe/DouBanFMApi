//
//  TUDefaultCell.m
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/10.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import "TUDefaultCell.h"
#import "TUDouBanMusicModel.h"
#import <UIImageView+AFNetworking.h>

@interface TUDefaultCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation TUDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(TUDouBanMusicModel *)info {
    [self.iconImageView setImageWithURL:[NSURL URLWithString:info.picture]];
    self.titleLabel.text = info.title;
    self.subTitleLabel.text = info.artist;
}

+ (CGFloat)height {
    return 80;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
