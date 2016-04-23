
###1.手势基本使用


本章主要介绍以及基本常用手势的操作,如果你已经是iOS开发老鸟那么就不要浪费时间往下看了,因为我也仅仅是一枚iOS开发新人,如果作为老鸟的你想要指正或者提点一下某菜非常欢迎!

####官方文档中所有的手势操作如下
	 UITapGestureRecognizer
     
     UIPinchGestureRecognizer
     
     UIRotationGestureRecognizer
     
     UISwipeGestureRecognizer
     
     UIPanGestureRecognizer
     
     UIScreenEdgePanGestureRecognizer
     
     UILongPressGestureRecognizer


*	tap手势操作
	
	*	首先在用Xcode创建一个工程,在默认的ViewController中用代码添加一个imageView,这里我选择了一张godfather经典照片作为示范,完成效果如下
	![tap手势](http://7xtajg.com2.z0.glb.clouddn.com/tap.gif)
	
	*	创建tap手势操作对象代码如下所示:
	
		<pre>UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.delegate = self;
    [self.imageView addGestureRecognizer:tap];
    </pre>
    
	*	手势代理方法
	<pre>
	//设置点按范围
	\- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
	{
    //touch 的一些常用属性
	//    NSLog(@"tapCount --- %lu",touch.tapCount);
//    NSLog(@"timestamp --- %f",touch.timestamp);
//
//    NSLog(@"previousLocation --- %@",NSStringFromCGPoint([touch previousLocationInView:self.imageView]));
//    NSLog(@"location --- %@",NSStringFromCGPoint([touch locationInView:self.imageView]));
    //    CGPoint currentPoint = [touch locationInView:self.imageView];
//    if (currentPoint.x > self.imageView.frame.size.width * 0.5) {
//        return NO;
//    }else {
//        return YES;
//    }
    return YES;
}
	</pre>
	


	*	设控制器为代理记得遵守代理方法`UIGestureRecognizerDelegate`否则会有警告在代理中可以根据tap对象方法取出当前点击的位置,可以根据此位置设置是响应点击操作,返回时为BOOL值返回NO代表不做操作,返回YES则会做出响应
	
*	捏合手势
	*	完成后效果如下
	
	![](http://7xtajg.com2.z0.glb.clouddn.com/pinch.gif)

	*	创建捏合手势对象和上面一样不同的是你的图片对象每次缩放需要对pinch的缩放值复位为1,否则缩放值会越来越大成几何级增加,所以当你没有对scale复位时轻轻捏合都会瞬间让图片无限大或者无限小,代码如下:
	<pre>
	\- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)sender
{
    self.tipsLabel.text = @"pinchGestureRecognizer";
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, sender.scale, sender.scale);
    //每一次缩放需要将缩放值还原为1,否则缩放值将会越来越大或者越来越小
    sender.scale = 1;
}
	</pre>

*	滑动手势
	*	完成效果如下:
	
	![](http://7xtajg.com2.z0.glb.clouddn.com/swipe.gif)

	*	创建以及使用同上这里不浪费时间只是说不同点,在创建滑动手势对象的时候需要给`swipe.direction = UISwipeGestureRecognizerDirectionRight;`赋值方向,根据自己需求赋值不同的枚举值,在action方法中判断滑动方向做出相应的操作代码如下:
	<pre>
	\- (void)swipeGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    self.tipsLabel.text = @"swipeGestureRecognizer";
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 50, 50);
        }];
    }
}
	</pre>


*	其他剩下的方法都是大同小异,其中如果是会根据手势调用多次的方法记得复位,每一个手势对象可以根据对应的对象属性或者方法到头文件中查询,根据对应的注释或者便可得知具体的功能,例如长按手势在创建长按手势对象的时候设置其属性`minimumPressDuration`这里头文件定义为一个`NSTimerInterval`类,你可以设置长按时间,默认时间为0.5s

---
####文章开头所有的手势方法我都实现了一遍做了一个练习的小demo,如果解释的不够详细不够清楚可以去我的github上面下载下来自己把玩把玩我只是抛砖引玉.

欢迎吐槽勾搭以下是源码地址:

[github地址](https://github.com/solon1/learniOSDemo/tree/master/Objective-C)


####后期计划
*	后期会在下班之余作一些练习学习的一些小demo,以及一些工作中遇到的技术难题以及解决思路记录下来,希望有和我一样也是一枚iOS新人的码友一起互相学习进步,根据自己学习iOS的经历还是觉得多看别人的代码,然后根据从中汲取的思想或者技巧自己再实现一遍印象会更深刻一点,也能真正的取长补短学以致用


####社交
*	有疑问或者好的建议欢迎私信我,以下是我的私人社交网络地址

	*	微博:[SolonPu](http://weibo.com/311197707)

	*	Twitter:[SolonPu](https://twitter.com/yyzorz)
	
	*	知乎专栏:[龙叔的码道场](http://zhuanlan.zhihu.com/longshu)