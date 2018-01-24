# ZHGDatePickerView
自定义时间选择器，主要实现设置了最大和最小日期后，最小日期之前的和最大日期之后的日期都不再显示


因项目需求，自己写了一个datePickerView，可设置最大日期、最小日期和默认显示日期，特殊要求就是一旦设置了最大最小日期之后，最大日期之后和最小日期之前的日期不再显示，不再显示！好变态的需求有木有！因为正常都是选择了无效日期会强制滚动回来才对，也就是说数据源是固定的，而这个datePickerView的数据源不是固定的，除非最大日期、最小日期和默认显示日期三者同时都不设置，才会根据当前时间来固定数据源。 说明：代码很低级，就是无数判断，里面可能也有无用代码，不喜勿喷 。若发现问题，欢迎指正

用法很简单：如果不需要工具条的，直接引入头文件"ZHG_CustomDatePickerView.h"
```js
ZHG_CustomDatePickerView *datePickerView = [[ZHG_CustomDatePickerView alloc] initWithFrame:CGRectMake(0,150,self.view.frame.size.width,200)];

/**
  注：默认显示日期、最大日期和最小日期的设置，会根据不同情况自动设置不同的数据源
*/

//设置默认显示日期为明天，若不设置，默认为当前时间
datePickerView.defaultDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
//设置最小日期，若不设置，默认为当前年往前推10年
datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
//设置最大日期，若不设置，默认为当前年往后推10年
datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];

datePickerView.DatePickerSelectedBlock = ^(NSString *selectString,NSDate *selectedDate) {
    //在这里处理你选择的日期，selectString是选择的日期转化的字符串， selectedDate是选择的日期，根据自己需求而定    
};

[self.view addSubview:datePickerView];
```

如果是需要工具条的，直接引入头文件"ZHG_ToolBarDatePickerView.h"
```js
ZHG_ToolBarDatePickerView *datePickerView = [[ZHG_ToolBarDatePickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


/**
  注：默认显示日期、最大日期和最小日期的设置，会根据不同情况自动设置不同的数据源
*/

/** 中间标题 */
//@property (nonatomic, strong) NSString *title;
/** 中间标题字体颜色 */
//@property (nonatomic, strong) UIColor *titleColor;
/** 中间标题字体大小 */
//@property (nonatomic, assign) CGFloat titleFontSize;

/** 取消按钮标题 */
//@property (nonatomic, strong) NSString *cancelTitle;
/** 取消按钮字体颜色 */
//@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 取消按钮字体大小 */
//@property (nonatomic, assign) CGFloat cancelTitleFontSize;

/** 确定按钮标题 */
//@property (nonatomic, strong) NSString *confirmTitle;
/** 确定按钮字体颜色 */
//@property (nonatomic, strong) UIColor *confirmTitleColor;
/** 确定按钮字体大小 */
//@property (nonatomic, assign) CGFloat confirmTitleFontSize;

//设置默认显示日期为明天，若不设置，默认为当前时间
datePickerView.defaultDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
//设置最小日期，若不设置，默认为当前年往前推10年
datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];
//设置最大日期，若不设置，默认为当前年往后推10年
datePickerView.minDate = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 24)];

datePickerView.DatePickerSelectedBlock = ^(NSString *selectString,NSDate *selectedDate) {
    //在这里处理你选择的日期，selectString是选择的日期转化的字符串， selectedDate是选择的日期，根据自己需求而定    
};

[datePickerView show];
```

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/1.imageset/1.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/2.imageset/2.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/3.imageset/3.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/4.imageset/4.gif)


