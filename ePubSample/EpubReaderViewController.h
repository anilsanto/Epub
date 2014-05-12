

#import <UIKit/UIKit.h>
#import "ZipArchive.h" 
#import "XMLHandler.h"
#import "EpubContent.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"
#import "DropDownView.h"
#import "SearchResult.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
@interface EpubReaderViewController : UIViewController<XMLHandlerDelegate,ChapterDelegate,UIWebViewDelegate,UISearchBarDelegate,DropDownViewDelegate,UITableViewDataSource,UITableViewDelegate> {

	IBOutlet UIWebView*_webview;
	IBOutlet UIImageView *_backGroundImage;
	IBOutlet UILabel *_pageNumberLbl;
	XMLHandler *_xmlHandler;
	EpubContent *_ePubContent;
	NSString *_pagesPath;
	NSString *_rootPath;
	NSString *_strFileName;
	int _pageNumber;
    
    DropDownView *dropView;
    Chapter *chap;
    NSTimer *timer;
    int y;
    AVSpeechSynthesizer *synth;
    
    
    UIView *searchDisplayView;
    NSArray *resultArray;
    UITableView *searchResult;
    
    SearchResult *searchObj;
    
    BOOL searching;
    int index;
}

@property (nonatomic, retain)EpubContent *_ePubContent;
@property (nonatomic, retain)NSString *_rootPath;
@property (nonatomic, retain)NSString *_strFileName;

- (void)unzipAndSaveFile;
- (NSString *)applicationDocumentsDirectory; 
- (void)loadPage;
- (NSString*)getRootFilePath;
- (void)setTitlename:(NSString*)titleText;
- (void)setBackButton;
- (IBAction)onPreviousOrNext:(id)sender;
@end

