
#import "EpubReaderViewController.h"

@implementation EpubReaderViewController
{
    UISwipeGestureRecognizer* rightSwipeRecognizer;
    UISwipeGestureRecognizer* leftSwipeRecognizer;
}
@synthesize _ePubContent;
@synthesize _rootPath;
@synthesize _strFileName;

- (void)viewDidLoad {
	
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];
    [self.view setFrame:[screen applicationFrame]];

	[self setBackButton];
    synth = [[AVSpeechSynthesizer alloc] init];

    rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] ;
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	
	leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    _webview=[[SearchWebView alloc]initWithFrame:CGRectMake(0, 50, 320, self.view.frame.size.height-130)];
	[_webview setBackgroundColor:[UIColor clearColor]];
    [_webview addGestureRecognizer:rightSwipeRecognizer];
    [_webview addGestureRecognizer:leftSwipeRecognizer];
    _webview.scrollView.scrollEnabled=NO;
    _webview.delegate=self;
    [self.view addSubview:_webview];

	[self unzipAndSaveFile];
	_xmlHandler=[[XMLHandler alloc] init];
	_xmlHandler.delegate=self;
	[_xmlHandler parseXMLFileAt:[self getRootFilePath]];
    UIButton *chapter =[[UIButton alloc]initWithFrame:CGRectMake(10,5 , 50, 30)];
    chapter.backgroundColor=[UIColor redColor];
    [chapter addTarget:self action:@selector(chapterlist) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chapter];
    UIButton *read =[[UIButton alloc]initWithFrame:CGRectMake(50,5 , 50, 30)];
    read.backgroundColor=[UIColor whiteColor];
    [read addTarget:self action:@selector(readc) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:read];
    UIButton *stop =[[UIButton alloc]initWithFrame:CGRectMake(150,5 , 50, 30)];
    stop.backgroundColor=[UIColor blueColor];
    [stop addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:stop];
    [SearchWebView initMenu];
    
    UIButton *search =[[UIButton alloc]initWithFrame:CGRectMake(210,5 , 50, 30)];
    search.backgroundColor=[UIColor yellowColor];
    [search addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:search];
    [self searchView];
}
-(void)searchView{
    resultArray=[[NSMutableArray alloc]init];
    searchDisplayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+20)];
    searchDisplayView.backgroundColor=[UIColor colorWithRed:((float) 239.0f / 255.0f)
                                                      green:((float) 237.0f/ 255.0f)
                                                       blue:((float) 228.0f / 255.0f)
                                                      alpha:1.0f];
    [self.view addSubview:searchDisplayView];
    searchDisplayView.hidden=YES;
    UIButton *cancel =[[UIButton alloc]initWithFrame:CGRectMake(170,5 , 100, 30)];
    cancel.backgroundColor=[UIColor blueColor];
    [cancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchDown];
    [searchDisplayView addSubview:cancel];
    UISearchBar *searchTool=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 50, 320, 30)];
    searchTool.delegate=self;
    [searchDisplayView addSubview:searchTool];
    UIView *Bgtable=[[UIView alloc]initWithFrame:CGRectMake(48, 98, 224, searchDisplayView.frame.size.height-116)];
    Bgtable.backgroundColor=[UIColor colorWithRed:((float) 177.0f / 255.0f)
                                            green:((float) 166.0f/ 255.0f)
                                             blue:((float) 148.0f / 255.0f)
                                            alpha:1.0f];
    [searchDisplayView addSubview:Bgtable];
    searchResult=[[UITableView alloc]initWithFrame:CGRectMake(50,100, 220, searchDisplayView.frame.size.height-120) style:UITableViewStylePlain];
    searchResult.delegate=self;
    searchResult.dataSource=self;
    [searchDisplayView addSubview:searchResult];

}
-(void)searchClicked{
    searchDisplayView.hidden=NO;
    searching=YES;
}
-(void)cancelClicked{
    searching=NO;
    [self.view endEditing:YES];
    searchDisplayView.hidden=YES;
}
-(void)gotoNextPage{
    NSLog(@"width:%f",_webview.scrollView.contentSize.width);
    if((_webview.scrollView.contentOffset.x+320)<_webview.scrollView.contentSize.width){
        int x=_webview.scrollView.contentOffset.x+320;
        CGPoint top = CGPointMake(x, 0);
        [_webview.scrollView setContentOffset:top animated:YES];
    }
    else{
        _pageNumber++;
        [self loadPage];
    }
}
-(void)gotoPrevPage{
        if((_webview.scrollView.contentOffset.x-320)>=0){
        int x=_webview.scrollView.contentOffset.x-320;
        CGPoint top = CGPointMake(x, 0);
        [_webview.scrollView setContentOffset:top animated:YES];
    }
    else{
        _pageNumber--;
        [self loadPage];
        }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *fullText;
    UILabel *pageText;
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle: UITableViewCellSeparatorStyleSingleLine];
        cell.backgroundColor=[UIColor clearColor];
        
        fullText=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        fullText.font=[UIFont systemFontOfSize:12];
        [cell addSubview:fullText];
    
        pageText=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 200, 20)];
        pageText.font=[UIFont systemFontOfSize:12];
        [cell addSubview:pageText];
        
    }
    fullText.text=[[resultArray objectAtIndex:indexPath.row] fullText];
    pageText.text=[NSString stringWithFormat:@"Chapter %d/Page %d",[[resultArray objectAtIndex:indexPath.row] hitIndex]-1,[[resultArray objectAtIndex:indexPath.row] pageIndex]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    index=indexPath.row;
    searchDisplayView.hidden=YES;
    if(searching){
        searching=NO;
        int scrollY;
        if ([[resultArray objectAtIndex:index] pageIndex]==1) {
            scrollY=0;
        }
        else
            scrollY=([[resultArray objectAtIndex:index] pageIndex]-1)*320;
        CGPoint top = CGPointMake(scrollY, 0);
        [_webview.scrollView setContentOffset:top animated:YES];
    }
}
-(void)chapterlist{
    chap=[[Chapter alloc]init];
    chap.delegate=self;
    [chap parseXMLFileAt:[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest objectForKey:@"ncx"]]];
}
-(void)finishedParsing{
    dropView = [[DropDownView alloc] initWithArrayData:chap.chapterTitle cellHeight:50 heightTableView:350 paddingTop:70 paddingLeft:-2 paddingRight:-150 refView:self.view animation:GROW openAnimationDuration:0.5 closeAnimationDuration:0.2];
    dropView.delegate=self;
    [self.view addSubview:dropView.view];
    [dropView openAnimation];
}
-(void)dropDownCellSelected :(int) indexRow{
    _pageNumber=indexRow;
    [self loadPage];
    [dropView closeAnimation];
}
/*Function Name : setTitlename
 *Return Type   : void
 *Parameters    : NSString- Text to set as title
 *Purpose       : To set the title for the view
 */
-(void)readc{
    if(!synth.paused){
    NSString *str = [_webview stringByEvaluatingJavaScriptFromString:
                     @"document.body.textContent"];
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:str];
    utterance.rate=0.15f;
//    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ar-SA"];
    [synth speakUtterance:utterance];
//    timer   =   [NSTimer    scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    }
    else{
        [synth continueSpeaking];
    }
}
- (void)setTitlename:(NSString*)titleText{
	
	// this will appear as the title in the navigation bar
	CGRect frame = CGRectMake(70, 20, 200, 44);
	UILabel *label = [[UILabel alloc] initWithFrame:frame] ;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:17.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines=0;
	label.textColor=[UIColor whiteColor];
//    [self.view addSubview:label];
	label.text=titleText;
}
-(void)tapped{
    [timer invalidate];
//    [synth stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    [synth pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{

	[self performSelector:@selector(setBackButton)
			   withObject:nil
			   afterDelay:0.1];
}
/*Function Name : setBackButton
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To set the back navigation button
 */

-(void)setBackButton{

	UIBarButtonItem *objBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
	self.navigationItem.leftBarButtonItem= objBarButtonItem;
}

/*Function Name : unzipAndSaveFile
 *Return Type   : void
 *Parameters    : nil
 *Purpose       : To unzip the epub file to documents directory
*/

- (void)unzipAndSaveFile{
	
	ZipArchive* za = [[ZipArchive alloc] init];
    if( [za UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"epub"]] ){
		
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub",[self applicationDocumentsDirectory]];
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"An unknown error occured"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
			
			alert=nil;
		}
		[za UnzipCloseFile];
	}					
	
}

/*Function Name : applicationDocumentsDirectory
 *Return Type   : NSString - Returns the path to documents directory
 *Parameters    : nil
 *Purpose       : To find the path to documents directory
 */

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

/*Function Name : getRootFilePath
 *Return Type   : NSString - Returns the path to container.xml
 *Parameters    : nil
 *Purpose       : To find the path to container.xml.This file contains the file name which holds the epub informations
 */

- (NSString*)getRootFilePath{
	
	//check whether root file path exists
	NSFileManager *filemanager=[[NSFileManager alloc] init];
	NSString *strFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/META-INF/container.xml",[self applicationDocumentsDirectory]];
	if ([filemanager fileExistsAtPath:strFilePath]) {
		
		//valid ePub
		NSLog(@"Parse now");
		
		filemanager=nil;
		
		return strFilePath;
	}
	else {
		
		//Invalid ePub file
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"Root File not Valid"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
        alert=nil;
		
	}
	filemanager=nil;
	return @"";
}


#pragma mark XMLHandler Delegate Methods

- (void)foundRootPath:(NSString*)rootPath{
	
	//Found the path of *.opf file
	
	//get the full path of opf file
	NSString *strOpfFilePath=[NSString stringWithFormat:@"%@/UnzippedEpub/%@",[self applicationDocumentsDirectory],rootPath];
	NSFileManager *filemanager=[[NSFileManager alloc] init];
	
	self._rootPath=[strOpfFilePath stringByReplacingOccurrencesOfString:[strOpfFilePath lastPathComponent] withString:@""];
	
	if ([filemanager fileExistsAtPath:strOpfFilePath]) {
		
		//Now start parse this file
		[_xmlHandler parseXMLFileAt:strOpfFilePath];
	}
	else {
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
													  message:@"OPF File not found"
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		alert=nil;
	}
	filemanager=nil;
	
}


- (void)finishedParsing:(EpubContent*)ePubContents{

	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[ePubContents._manifest valueForKey:[ePubContents._spine objectAtIndex:0]]];
	self._ePubContent=ePubContents;
	_pageNumber=0;
	[self loadPage];
}

#pragma mark Button Actions

- (IBAction)onPreviousOrNext:(id)sender{
	
	
	UIBarButtonItem *btnClicked=(UIBarButtonItem*)sender;
	if (btnClicked.tag==0) {
		
		if (_pageNumber>0) {
			
			_pageNumber--;
			[self loadPage];
		}
	}
	else {
		
		if ([self._ePubContent._spine count]-1>_pageNumber) {
			
			_pageNumber++;
			[self loadPage];
		}
	}
}

- (IBAction)onBack:(id)sender{

	[self.navigationController popViewControllerAnimated:YES];
}

/*Function Name : loadPage
 *Return Type   : void 
 *Parameters    : nil
 *Purpose       : To load actual pages to webview
 */

- (void)loadPage{
	searchDisplayView.hidden=YES;
   // [_webview loadHTMLString:@"" baseURL:[NSURL URLWithString:@""]];
	_pagesPath=[NSString stringWithFormat:@"%@/%@",self._rootPath,[self._ePubContent._manifest valueForKey:[self._ePubContent._spine objectAtIndex:_pageNumber]]];
	[_webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:_pagesPath]]];
	//set page number
	_pageNumberLbl.text=[NSString stringWithFormat:@"%d",_pageNumber+1];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 100];
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: lightblue;')"];
    [_webview stringByEvaluatingJavaScriptFromString:varMySheet];
    [_webview stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	[_webview stringByEvaluatingJavaScriptFromString:addCSSRule];
	[_webview stringByEvaluatingJavaScriptFromString:insertRule1];
	[_webview stringByEvaluatingJavaScriptFromString:insertRule2];
	[_webview stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
    
    
}
-(void)scroll{
    y=_webview.scrollView.contentOffset.x;
    y+=320;
    CGPoint top = CGPointMake(y, 0);
    [_webview.scrollView setContentOffset:top animated:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [resultArray removeAllObjects];
    if(searchBar.text.length==0)
        [_webview removeAllHighlights];
    else{
        int resultCount = [_webview highlightAllOccurencesOfString:searchBar.text];
        NSLog(@"result:  %@",[_webview stringByEvaluatingJavaScriptFromString:@"results"]);
        NSString *result=[_webview stringByEvaluatingJavaScriptFromString:@"results"];
        NSLog(@"%d",resultCount);
        NSArray *temp=[result componentsSeparatedByString:@";"];
        for (int i=0; i<temp.count; i++) {
            NSArray *temp1=[[temp objectAtIndex:i] componentsSeparatedByString:@","];
            if(temp1.count==3){
                SearchResult *obj=[[SearchResult alloc]init];
                obj.hitIndex=_pageNumber;
                obj.pageIndex=ceilf([[temp1 objectAtIndex:1] integerValue]/_webview.bounds.size.height);
                obj.searchString=searchBar.text;
                obj.fullText= [[temp1 objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                [resultArray addObject:obj];
            }
        }
        [searchResult removeFromSuperview];
        searchResult=nil;
        searchResult=[[UITableView alloc]initWithFrame:CGRectMake(50,100, 220, searchDisplayView.frame.size.height-120) style:UITableViewStylePlain];
        searchResult.delegate=self;
        searchResult.dataSource=self;
        [searchDisplayView addSubview:searchResult];
    }
}
#pragma mark Memory handlers
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
}
- (void)dealloc {
	_webview=nil;
    _ePubContent=nil;
	_pagesPath=nil;
	_rootPath=nil;
	_strFileName=nil;
	_backGroundImage=nil;
	
    
}

@end
