
#import "PellTableViewSelect.h"

@interface  PellTableViewSelect()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *itinerArray;
@property (nonatomic,copy) void(^action)(NSInteger index);

@end
PellTableViewSelect *backgroundView;
UITableView *tableView;
@implementation PellTableViewSelect

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                selectData:(LLCityDescModel *)selectData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate
{
    if (backgroundView != nil) {
        [PellTableViewSelect hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[PellTableViewSelect alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.itinerArray = [LLMetaDataTool getCityItineraries:selectData];
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.4];
    [win addSubview:backgroundView];
    
    // TAB
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(win.bounds.size.width/2-150,150, 300,300) style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 10.0f;
    tableView.rowHeight = 54;
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分享界面背景"]];
    tableView.backgroundColor = [UIColor grayColor];
    [win addSubview:tableView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    if (animate == YES) {
        backgroundView.alpha = 0;
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 0);
        tableView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.5 animations:^{
            backgroundView.alpha = 1;
            tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width,54*backgroundView.itinerArray.count);
            
        }];
        
    }
}
+ (void)tapBackgroundClick
{
    [PellTableViewSelect hiden];
}
+ (void)hiden
{
    [backgroundView removeFromSuperview];
    [tableView removeFromSuperview];
    tableView = nil;
    backgroundView = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return backgroundView.itinerArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"act_edi"]];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    LLCityItinerariesModel *itinerModel = backgroundView.itinerArray[indexPath.row];
    cell.textLabel.text = itinerModel.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    backgroundView.action(indexPath.row);
    [PellTableViewSelect hiden];
}
@end
