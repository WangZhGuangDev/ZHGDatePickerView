# ZHGDatePickerView
自定义时间选择器，主要实现设置了最大和最小日期后，最小日期之前的和最大日期之后的日期都不再显示


因项目需求，自己写了一个datePickerView，可设置最大日期、最小日期和默认显示日期，特殊要求就是一旦设置了最大最小日期之后，最大日期之后和最小日期之前的日期不再显示，不再显示！好变态的需求有木有！因为正常都是选择了无效日期会强制滚动回来才对，也就是说数据源是固定的，而这个datePickerView的数据源不是固定的，除非最大日期、最小日期和默认显示日期三者同时都不设置，才会根据当前时间来固定数据源。 说明：代码很低级，就是无数判断，里面可能也有无用代码，不喜勿喷 。若发现问题，欢迎指正

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/1.imageset/1.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/2.imageset/2.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/3.imageset/3.gif)

![image](https://github.com/WangZhGuangDev/ZHGDatePickerView/blob/master/ZHGDatePickerView/ZHGDatePickerView/Assets.xcassets/4.imageset/4.gif)

