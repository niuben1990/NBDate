//
//  NLCInsertEventViewController.m
//  生辰纲
//
//  Created by tarena on 15/12/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NLCInsertEventViewController.h"
#import "NLCEventDataTool.h"
#import "NBDate.h"
#import "NSObject+HUD.h"

@interface NLCInsertEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lunarSegmented;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (nonatomic, strong) NLCEvent *event;

@property (nonatomic, strong) NSMutableArray *allYears;
@property (nonatomic, strong) NSMutableArray *allMonths;
@property (nonatomic, strong) NSMutableArray *allDays;

@end

@implementation NLCInsertEventViewController

#pragma mark --- 懒加载
- (NSMutableArray *)allYears {
    if (!_allYears) {
        _allYears = [NSMutableArray array];
        for (int i = 1970; i < 2038; i++) {
            [_allYears addObject:@(i)];
        }
    }
    return _allYears;
}

- (NSMutableArray *)allMonths {
    if (!_allMonths) {
        _allMonths = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            [_allMonths addObject:@(i)];
        }
    }
    return _allMonths;
}

- (NSMutableArray *)allDays {
    if (!_allDays) {
        _allDays = [NSMutableArray array];
        for (int i = 1; i <= 31; i++) {
            [_allDays addObject:@(i)];
        }
    }
    return _allDays;
}

- (NLCEvent *)event {
    if (!_event) {
        _event = [NLCEvent new];
    }
    return _event;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPickerView];
    
    [self setupHeaderImageView];
    
}

- (void)setupPickerView {
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

- (void)setupHeaderImageView {
    NSString *imageStr = [NSString stringWithFormat:@"headerImage_%u", arc4random() % 5];
    self.headerImageView.image = [UIImage imageNamed:imageStr];
    self.headerImageView.layer.cornerRadius = 10;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    [self.headerImageView addGestureRecognizer:tapGR];
}

- (void)tapGR:(UITapGestureRecognizer *)gr {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"获取图片" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoLibraryAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark --- UIPickerViewDelegate/DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (self.lunarSegmented.selectedSegmentIndex == 0) {
            return 2037-1970+1;
        } else {
            return 60;
        }
    } else if (component == 1) {
        return 12;
    } else {
        return self.allDays.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.lunarSegmented.selectedSegmentIndex == 0) {
        if (component == 0) {
            return [self.allYears[row] stringValue];
        } else if (component == 1) {
            return [self.allMonths[row] stringValue];
        } else {
            return [self.allDays[row] stringValue];
        }
    } else {
        if (component == 0) {
            return self.allYears[row];
        } else if (component == 1) {
            return self.allMonths[row];
        } else {
            return self.allDays[row];
        }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.lunarSegmented.selectedSegmentIndex == 0) {
        NSInteger selectedYear = 0;
        NSInteger selectedMonth = 0;
        if (component == 0) {
            selectedYear = [self.allYears[row] integerValue];
            self.event.year = [NSString stringWithFormat:@"%ld", selectedYear];
        } else if (component == 1) {
            selectedMonth = [self.allMonths[row] integerValue];
            self.event.month = [NSString stringWithFormat:@"%ld", selectedMonth];
            NSDate *date = [NBDate dateWithDay:1 withMonth:selectedMonth withYear:selectedYear];
            NSInteger daysNum = [NBDate numberOfDaysInMonthWithDate:date];
            NSMutableArray *daysArray = [NSMutableArray array];
            for (int i = 1; i <= daysNum; i++) {
                [daysArray addObject:@(i)];
            }
            self.allDays = daysArray;
            [pickerView reloadComponent:2];
        } else {
            self.event.day = [self.allDays[row] stringValue];
        }
    } else {
        NSString *selectedYear = nil;
        NSString *selectedMonth = nil;
        if (component == 0) {
            selectedYear = self.allYears[row];
            self.event.year = selectedYear;
        } else if (component == 1) {
            selectedMonth = self.allMonths[row];
            self.event.month = selectedMonth;
            NSInteger daysNum = [NBDate numberOfLunarDaysInLunarMonth:selectedMonth andLunarYear:selectedYear];
            NSMutableArray *daysArray = [NSMutableArray array];
            for (int i = 0; i < daysNum; i++) {
                [daysArray addObject:CHINESE_DAY_ALL[i]];
            }
            self.allDays = daysArray;
            [pickerView reloadComponent:2];
        } else {
            self.event.day = self.allDays[row];
        }
    }
}

#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    UIImage *newImage = [NLCEventDataTool thumbnaiWithImage:image size:CGSizeMake(80, 80)];
    self.headerImageView.image = newImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)insertEvent:(id)sender {
    self.event.type = self.eventType;
    self.event.headerImageString = [NLCEventDataTool base64WithImage:self.headerImageView.image];
    
    if ([self.titleTextField.text isEqualToString: @""] || [self.genderTextField.text isEqualToString:@""]) {
        [self showAlert:@"请输入完整信息"];
        return;
    } else {
        self.event.title = self.titleTextField.text;
        self.event.detail = self.genderTextField.text;
    }
    self.event.isLunar = self.lunarSegmented.selectedSegmentIndex;
    [NLCEventDataTool insertEventToSQLiteWithEvent:self.event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventDidInsert" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)segmentedSelected:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.allDays = nil;
        self.allMonths = nil;
        self.allYears = nil;
        [self.picker reloadAllComponents];
        self.event.isLunar = NO;
    } else {
        self.allYears = (NSMutableArray *)CHINESE_YEAR_ALL;
        self.allMonths = (NSMutableArray *)CHINESE_MONTH_ALL;
        self.allDays = (NSMutableArray *)CHINESE_DAY_ALL;
        [self.picker reloadAllComponents];
        self.event.isLunar = YES;
    }
}

- (IBAction)didFinishInput:(UITextField *)sender {
    [sender endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
