//
//  ViewController.m
//  TTSDemo
//
//  Created by mahong on 2017/7/14.
//  Copyright © 2017年 Runbey. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kContent = @"关雎 朝代：先秦 作者：西门庆 原文：关关雎鸠，在河之洲。窈窕淑女，君子好逑。参差荇菜，左右流之。窈窕淑女，寤寐求之。求之不得，寤寐思服。悠哉悠哉，辗转反侧。 参差荇菜，左右采之。窈窕淑女，琴瑟友之。参差荇菜，左右芼之。窈窕淑女，钟鼓乐之。";

@interface ViewController ()<AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *speecher;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *voices = [AVSpeechSynthesisVoice speechVoices];
    for (AVSpeechSynthesisVoice *item in voices) {
        NSLog(@"language =%@ \n name = %@",item.language,item.name);
    }
    
    NSString *currentCode = [AVSpeechSynthesisVoice currentLanguageCode];
    NSLog(@"currentCode == %@",currentCode);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    /** 语言设置 */
    AVSpeechSynthesisVoice *speechVoice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    /** 发声设置 */
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:kContent];
    utterance.voice = speechVoice;
    utterance.rate = 0.5;/** 语速 */
    utterance.volume = 1.0;/** 音量 */
    utterance.postUtteranceDelay = 2;/** 读完一段后停顿 */
    
    /** 朗读 */
    self.speecher = [[AVSpeechSynthesizer alloc] init];
    self.speecher.delegate = self;
    [self.speecher speakUtterance:utterance];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /** 暂停 */
        [self.speecher pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /** 继续 */
        [self.speecher continueSpeaking];
    });
}

#pragma mark -  Delegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"start ");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"location == %lu  length == %lu",(unsigned long)characterRange.location,(unsigned long)characterRange.length);
    NSLog(@"speech string == %@",[utterance.speechString substringWithRange:characterRange]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
