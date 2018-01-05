//
//  MoreInfoViewController.m
//  CryptoEye
//
//  Created by Akshay on 12/12/17.
//  Copyright © 2017 Akshay. All rights reserved.
//

#import "MoreInfoViewController.h"
@import Lottie;
@import drCharts;
@import MaterialComponents;
#define SECS_PER_DAY (86400)
@interface MoreInfoViewController ()
{
    NSArray *jsonArray;
     NSArray *jsonArray2;
    NSMutableArray *coinid;
    NSMutableArray *onedayvol;
    MultiLineGraphView *graph;
    NSString *graphapi;
NSMutableArray *marketcap;
    NSMutableArray *price;
    NSMutableArray *cirsupply;
    NSMutableArray *per24hr;
    NSString *y;
    NSMutableArray *per1hr;
    NSMutableArray *per7d;
    NSMutableArray *temparr;
    NSMutableArray *symbol;
    NSString *id4api;
    NSString *init;
    NSString *tickerapi;
    UIView* coverView;
    NSMutableArray *price4rmapi;
    NSMutableArray *price4graphdata;
    NSMutableArray *time4graph;
    NSInteger *i ;

    LOTAnimationView *animation;
}

@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated{

    self.webView.delegate = self;
   [self showloader];
    tickerapi = @"https://api.coinmarketcap.com/v1/ticker/";
    self.coinlabel.text = [NSString stringWithFormat:@"%@ (%@)",self.coinLabelStr,self.coinshrt];
    self.coinimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_coinshrt lowercaseString]]];
    self.idlabel.text = self.idstr;
    //setting data from the recived vals from tableview
      [self getid4api];
   graph = [[MultiLineGraphView alloc] initWithFrame:self.refView4Chart.frame];
    // Do any additional setup after loading the view.
    
}
-(void)getgraphdata:(NSString*)his_dur{
    if([his_dur isEqualToString:@"1day"]){
       graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/1day/%@",self.coinshrt];
    }
    else if ([his_dur isEqualToString:@"7day"]){
        graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/7day/%@",self.coinshrt];
    }
    else if ([his_dur isEqualToString:@"30day"]){
      graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/30day/%@",self.coinshrt];
    }
    else if ([his_dur isEqualToString:@"90day"]){
       graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/90day/%@",self.coinshrt];
    }
    else if ([his_dur isEqualToString:@"180day"]){
     graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/180day/%@",self.coinshrt];
    }
    else if ([his_dur isEqualToString:@"360day"]){
       graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/360day/%@",self.coinshrt];
    }
    else {
         graphapi = [NSString stringWithFormat:@"http://www.coincap.io/history/1day/%@",self.coinshrt];
    }
    
 
    NSString *url = graphapi;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if(!([responseCode statusCode] == 200)){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        
    }
    else{
        NSString *data = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            UILabel *label = [[UILabel alloc]initWithFrame:self.refView4Chart.frame];
            label.textColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"No graph data for %@",self.coinlabel.text];
            label.textAlignment = NSTextAlignmentCenter;
            
            [self.view addSubview:label];
            MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
            message.text = label.text;
            [MDCSnackbarManager showMessage:message];
            self.btn1.hidden = YES;
              self.btn2.hidden = YES;
              self.btn3.hidden = YES;
                     self.btn4.hidden = YES;
                     self.btn5.hidden = YES;
                     self.btn6.hidden = YES;
                     self.btn7.hidden = YES;

        }
        else
        {
            self.btn1.hidden = NO;
            self.btn2.hidden = NO;
            self.btn3.hidden = NO;
            self.btn4.hidden = NO;
            self.btn5.hidden = NO;
            self.btn6.hidden = NO;
            self.btn7.hidden = NO;
            self.refView4Chart.hidden = NO;
            price4graphdata = [[NSMutableArray alloc] init];
                  time4graph = [[NSMutableArray alloc] init];
            self.intt = 0;
             jsonArray2 = (NSArray *)jsonObject;
                           price4rmapi =[jsonArray2 valueForKey: @"price"];
            //sperating data to diffrent arrays
            
            for (NSMutableArray *tempObject in price4rmapi) {
                   [time4graph addObject:[tempObject objectAtIndex:0]];
                [price4graphdata addObject:[tempObject objectAtIndex:1]];
            }
                        [self performSelectorInBackground:@selector(createLineGraph) withObject:NULL];
            self.formatter = [[NSDateFormatter alloc] init];
            [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
           
}
    }
}

-(void)showgraph{
    

}
-(void)stoploader{
    animation.loopAnimation = false;
}
-(void)showloader{
    // get your window screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //create a new view with the same size
    coverView = [[UIView alloc] initWithFrame:screenRect];
    animation = [LOTAnimationView animationNamed:@"preloader"];
    animation.contentMode = UIViewContentModeScaleAspectFit;
    animation.center = self.view.center;
    animation.loopAnimation = TRUE;
    [animation playWithCompletion:^(BOOL animationFinished) {
        [UIView animateWithDuration:1.0f animations:^{
            [coverView removeFromSuperview];
        }];
        
       
    }];
    [coverView addSubview:animation];
    // change the background color to black and the opacity to 0.6
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    // add this new view to your main view
    [self.view addSubview:coverView];
}
-(void)getcoins {
    NSString *url = tickerapi;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if(!([responseCode statusCode] == 200)){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        
    }
    
    else{
    NSString *data = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    else
    {
        if ([jsonObject isKindOfClass:[NSArray class]])
        {
            [self stoploader];
        
            jsonArray = (NSArray *)jsonObject;
            //setting individual array data
            coinid  =[jsonArray valueForKey: @"id"];
            onedayvol =[jsonArray valueForKey: @"24h_volume_usd"];
            marketcap =[jsonArray valueForKey: @"market_cap_usd"];
            price = [jsonArray valueForKey: @"price_usd"];
            cirsupply = [jsonArray valueForKey: @"total_supply"];
            per24hr = [jsonArray valueForKey: @"percent_change_24h"];
            per1hr = [jsonArray valueForKey: @"percent_change_1h"];
            per7d = [jsonArray valueForKey: @"percent_change_7d"];
            symbol = [jsonArray valueForKey: @"symbol"];
           
             [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"1day"];

            self.pricelabel.text = [NSString stringWithFormat:@"$%@",price[0]];
            self.marketcaplabel.text = [NSString stringWithFormat:@"$%@",marketcap[0]];
            self.cirsupplylabel.text = [NSString stringWithFormat:@"%@",cirsupply[0]];
            self.twentyfourvolabel.text = [NSString stringWithFormat:@"$%@",onedayvol[0]];
            if ([per24hr[0] rangeOfString:@"-"].location == NSNotFound) {
                //doesnt contain
                self.twentyfourhrperlabel.textColor = [UIColor greenColor];
                self.twentyfourhrperlabel.text = per24hr [0];
            } else {
                self.twentyfourhrperlabel.textColor = [UIColor redColor];
                self.twentyfourhrperlabel.text = per24hr[0];
                //does contain
                
            }
            if ([per7d[0] rangeOfString:@"-"].location == NSNotFound) {
                //doesnt contain
                self.sevendayperlabel.textColor = [UIColor greenColor];
                self.sevendayperlabel.text = per7d[0];
            } else {
                self.sevendayperlabel.textColor = [UIColor redColor];
                self.sevendayperlabel.text = per7d [0];
                //does contain
                
            }
            if ([per1hr[0] rangeOfString:@"-"].location == NSNotFound) {
                //doesnt contain
                self.onehrperlabel.textColor = [UIColor greenColor];
                self.onehrperlabel.text = per1hr [0];
            } else {
                self.onehrperlabel.textColor = [UIColor redColor];
                self.onehrperlabel.text = per1hr [0];
                //does contain
                
            }
        
        
        }
        else {
            [self stoploader];
    
         
            NSLog(@"it is a dictionary");
            NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
            NSLog(@"jsonDictionary - %@",jsonDictionary);
        }
    }
    
}
}


#pragma Mark CreateLineGraph
- (void)createLineGraph{
   [graph setDataSource:NULL];
    [graph setDelegate:self];
    [graph setDataSource:self];
    [graph setLegendViewType:LegendTypeHorizontal];
    [graph setShowCustomMarkerView:TRUE];
 
    [graph drawGraph];
    [self.view addSubview:graph];
}

#pragma mark MultiLineGraphViewDataSource
- (NSInteger)numberOfLinesToBePlotted{
    return 1;
}

- (LineDrawingType)typeOfLineToBeDrawnWithLineNumber:(NSInteger)lineNumber{
    switch (lineNumber) {
        case 0:
            return LineDefault;
            break;
    }
    return LineDefault;
}

- (UIColor *)colorForTheLineWithLineNumber:(NSInteger)lineNumber{

    UIColor *randColor = [UIColor colorWithRed:0/255.0f green:255/255.0f blue:0/255.0f alpha:1.0f];
    return randColor;
}

- (CGFloat)widthForTheLineWithLineNumber:(NSInteger)lineNumber{
    return 1;
}

- (NSString *)nameForTheLineWithLineNumber:(NSInteger)lineNumber{
    return [NSString stringWithFormat:@"Price of %@",self.coinlabel.text];
}

- (BOOL)shouldFillGraphWithLineNumber:(NSInteger)lineNumber{
    switch (lineNumber) {
        case 0:
            return false;
            break;
        default:
            break;
    }
    return false;
}

- (BOOL)shouldDrawPointsWithLineNumber:(NSInteger)lineNumber{
    switch (lineNumber) {
        case 0:
            return true;
            break;
        default:
            break;
    }
    return false;
}

- (NSMutableArray *)dataForYAxisWithLineNumber:(NSInteger)lineNumber {
    switch (lineNumber) {
        case 0:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for (NSMutableArray *tempObject in price4rmapi) {
////                [time4graph addObject:[tempObject objectAtIndex:0]];
//                [array addObject:[tempObject objectAtIndex:1]];
//            }
//            for (int i = 0; i < [price4graphdata count]; i++) {
//                [array addObject:[NSNumber numberWithLong:random() % 100]];
//            }
            for (int index = 0; index <[price4graphdata count]; index++) {
                array[index] = [NSString stringWithFormat:@"%@",[price4graphdata objectAtIndex: index]] ;
            }
            return array;
        }
            break;
      
        default:
            break;
    }
    return [[NSMutableArray alloc] init];
}

- (NSMutableArray *)dataForXAxisWithLineNumber:(NSInteger)lineNumber {
    switch (lineNumber) {
        case 0:
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
//            array = time4graph;
//            for (NSMutableArray *tempObject in price4rmapi) {
//
//                [array addObject:[tempObject objectAtIndex:0]]];
//            }
            for (int index = 0; index <[price4graphdata count]; index++) {
                array[index] = [NSString stringWithFormat:@"%@",[time4graph objectAtIndex: index]] ;
            }
            return array;
        }
            break;
       
        default:
            break;
    }
    return [[NSMutableArray alloc] init];
}

- (UIView *)customViewForLineChartTouchWithXValue:(id)xValue andYValue:(id)yValue{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setCornerRadius:4.0F];
    [view.layer setBorderWidth:1.0F];
    [view.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:2.0F];
    [view.layer setShadowOpacity:0.3F];
    
    CGFloat y = 0;
    CGFloat width = 0;
    for (int i = 0; i < 1 ; i++) {
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[NSString stringWithFormat:@"%@", yValue]];
        [label setFrame:CGRectMake(0, y, 200, 30)];
        [view addSubview:label];
        
        width = WIDTH(label);
        y = BOTTOM(label);
    }
    
    [view setFrame:CGRectMake(0, 0, width, y)];
    return view;
}

#pragma mark MultiLineGraphViewDelegate
- (void)didTapWithValuesAtX:(NSString *)xValue valuesAtY:(NSString *)yValue{
    NSLog(@"%@", yValue);
}



- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}
-(void)getid4api{
    NSString *url2 = [NSString stringWithFormat:@"http://139.59.11.43/api-getid.php?coin=%@",self.coinshrt];
   
    NSURL *url = [NSURL URLWithString:url2];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
   
    [self.webView loadRequest:requestObj];
    

    NSString *str = [self getDataFrom:url2];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",str);
    tickerapi = [NSString stringWithFormat:@"%@%@",tickerapi,str];
        [self performSelectorInBackground:@selector(getcoins) withObject:NULL];
    }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)daybtn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
     [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"1day"];
        [graph reloadGraph];
}

- (IBAction)day7btn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
     [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"7day"];
        [graph reloadGraph];
}

- (IBAction)month1btn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
    [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"30day"];
     [graph reloadGraph];
    }


- (IBAction)month3btn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
     [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"90day"];
        [graph reloadGraph];
}

- (IBAction)month6btn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
     [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"180day"];
         [graph reloadGraph];
}

- (IBAction)year1btn:(id)sender {
    BOOL doesContain = [self.view.subviews containsObject:graph];
    if(doesContain){
        [graph removeFromSuperview];
    }
     [self performSelectorInBackground:@selector(getgraphdata:) withObject:@"360day"];
        [graph reloadGraph];
}
- (IBAction)alldatabtn:(id)sender {
}
@end