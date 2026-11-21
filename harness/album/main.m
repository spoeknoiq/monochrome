// A mock of Spotify's album page under its own class names and accessibility identifiers, built from
// trees/clean/album/03.txt, so Redesigned/Album can be laid out and looked at on the Mac.
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "../download-mock.h"

#pragma mark - Spotify's classes, by name

@interface _TtC28CreativeWorkPlatform_PageKit24CreativeWorkTemplateView : UIView @end
@implementation _TtC28CreativeWorkPlatform_PageKit24CreativeWorkTemplateView @end

@interface _TtC32CreativeWorkPlatform_TemplateKit28CreativeWorkTemplateListView : UIView @end
@implementation _TtC32CreativeWorkPlatform_TemplateKit28CreativeWorkTemplateListView @end

@interface _TtCO19LegacyUI_ECMCoreKit5Views10HeaderView : UIView @end
@implementation _TtCO19LegacyUI_ECMCoreKit5Views10HeaderView @end

@interface _TtC28EncoreConsumerMobile_BaseKit20HeaderNavigationBar : UIView @end
@implementation _TtC28EncoreConsumerMobile_BaseKit20HeaderNavigationBar @end

// Spotify's draws a CAGradientLayer; whether it is the view's own layer is what the device log settles.
@interface _TtC19LegacyUI_ECMCoreKit12GradientView : UIView @end
@implementation _TtC19LegacyUI_ECMCoreKit12GradientView
+ (Class)layerClass { return CAGradientLayer.class; }
@end

@interface _TtC28EncoreConsumerMobile_BaseKit14PlayButtonView : UIView @end
@implementation _TtC28EncoreConsumerMobile_BaseKit14PlayButtonView @end

@interface _TtC12Element_List18CollectionViewCell : UICollectionViewCell @end
@implementation _TtC12Element_List18CollectionViewCell @end

// The element the cell's content is, which is the only thing that says what a cell holds.
@interface MockRetrievalListStructuredDataView : UIView @end
@implementation MockRetrievalListStructuredDataView @end

@interface MockAlbum_PageImpl20FooterStructuredDataView : UIView @end
@implementation MockAlbum_PageImpl20FooterStructuredDataView @end

@interface MockCondensedButton : UIControl @end
@implementation MockCondensedButton @end

@interface MockEncoreButton : UIControl @end
@implementation MockEncoreButton @end

#pragma mark - building the tree

static UIView *box(UIView *parent, Class cls, CGRect frame, NSString *identifier) {
    UIView *view = [[cls alloc] initWithFrame:frame];
    view.accessibilityIdentifier = identifier;
    [parent addSubview:view];
    return view;
}

static UILabel *label(UIView *parent, CGRect frame, NSString *text, CGFloat size, UIColor *color, NSString *identifier) {
    UIView *encore = box(parent, UIView.class, frame, identifier);
    UILabel *inner = [[UILabel alloc] initWithFrame:encore.bounds];
    inner.text = text;
    inner.font = [UIFont systemFontOfSize:size];
    inner.textColor = color;
    inner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inner.accessibilityIdentifier = [identifier stringByAppendingString:@"-internal"];
    [encore addSubview:inner];
    return inner;
}

static UIImage *graduationArtwork(void) {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(400, 400)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGContextRef c = ctx.CGContext;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        // Graduation sky palette (pink -> vibrant magenta -> deep plum -> dark violet)
        CGFloat components[] = {
            0.93, 0.47, 0.64, 1.0, // Pink #EE78A3
            0.62, 0.18, 0.47, 1.0, // Magenta #9E2E78
            0.34, 0.07, 0.25, 1.0, // Deep Plum #571240
            0.15, 0.03, 0.12, 1.0  // Dark Violet #26081F
        };
        CGFloat locations[] = {0.0, 0.45, 0.78, 1.0};
        CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 4);
        CGContextDrawLinearGradient(c, gradient, CGPointMake(200, 0), CGPointMake(200, 400), 0);
        CGGradientRelease(gradient);

        // Rainbow ring arches in the lower center
        NSArray<UIColor *> *ringColors = @[
            [UIColor colorWithRed:0.95 green:0.80 blue:0.25 alpha:0.85],
            [UIColor colorWithRed:0.95 green:0.45 blue:0.25 alpha:0.85],
            [UIColor colorWithRed:0.85 green:0.20 blue:0.55 alpha:0.85],
            [UIColor colorWithRed:0.40 green:0.60 blue:0.95 alpha:0.85]
        ];
        CGContextSetLineWidth(c, 5.0);
        for (NSUInteger i = 0; i < ringColors.count; i++) {
            [ringColors[i] setStroke];
            CGContextAddArc(c, 200, 290, 45 + i * 14, 0, M_PI * 2, 0);
            CGContextStrokePath(c);
        }

        // Floating fluffy clouds
        [[UIColor colorWithWhite:1 alpha:0.25] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(20, 180, 130, 40));
        CGContextFillEllipseInRect(c, CGRectMake(270, 140, 120, 36));
        CGContextFillEllipseInRect(c, CGRectMake(150, 220, 100, 30));

        // The Graduation Bear floating in varsity jacket
        // Bear head
        [[UIColor colorWithRed:0.75 green:0.58 blue:0.45 alpha:1.0] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(160, 50, 80, 75)); // Head
        CGContextFillEllipseInRect(c, CGRectMake(150, 42, 28, 28)); // Left ear
        CGContextFillEllipseInRect(c, CGRectMake(222, 42, 28, 28)); // Right ear
        // Snout
        [[UIColor colorWithRed:0.88 green:0.78 blue:0.68 alpha:1.0] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(180, 75, 40, 35));
        // Big cartoon eyes
        [[UIColor whiteColor] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(168, 60, 22, 26));
        CGContextFillEllipseInRect(c, CGRectMake(210, 60, 22, 26));
        [[UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(172, 65, 14, 16));
        CGContextFillEllipseInRect(c, CGRectMake(214, 65, 14, 16));
        // Varsity jacket body
        [[UIColor colorWithRed:0.55 green:0.68 blue:0.75 alpha:1.0] setFill];
        CGContextFillRoundedRect(c, CGRectMake(165, 120, 70, 75), 14, 14);
        // White sleeves & collar
        [[UIColor whiteColor] setFill];
        CGContextFillRoundedRect(c, CGRectMake(142, 125, 26, 60), 10, 10);
        CGContextFillRoundedRect(c, CGRectMake(232, 125, 26, 60), 10, 10);
        // Varsity letter 'U'
        [[UIColor colorWithRed:0.2 green:0.4 blue:0.85 alpha:1] setFill];
        CGContextFillRect(c, CGRectMake(192, 138, 16, 24));
        // Blue jeans
        [[UIColor colorWithRed:0.25 green:0.45 blue:0.75 alpha:1.0] setFill];
        CGContextFillRoundedRect(c, CGRectMake(172, 190, 24, 45), 6, 6);
        CGContextFillRoundedRect(c, CGRectMake(204, 190, 24, 45), 6, 6);
        // White sneakers
        [[UIColor whiteColor] setFill];
        CGContextFillRoundedRect(c, CGRectMake(164, 230, 34, 18), 7, 7);
        CGContextFillRoundedRect(c, CGRectMake(202, 230, 34, 18), 7, 7);

        CGColorSpaceRelease(space);
    }];
}

static UIImage *fastLifeArtwork(void) {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(400, 400)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        CGContextRef c = ctx.CGContext;
        // Modern glass office airport background
        [[UIColor colorWithRed:0.65 green:0.72 blue:0.78 alpha:1.0] setFill];
        CGContextFillRect(c, CGRectMake(0, 0, 400, 220)); // Sky/outside
        // Window mullions / airport apron
        [[UIColor colorWithRed:0.45 green:0.48 blue:0.52 alpha:1.0] setStroke];
        CGContextSetLineWidth(c, 4.0);
        CGContextStrokeRect(c, CGRectMake(40, 0, 160, 200));
        CGContextStrokeRect(c, CGRectMake(200, 0, 160, 200));
        // Small private jet silhouette in window
        [[UIColor colorWithWhite:0.92 alpha:1] setFill];
        CGContextFillRect(c, CGRectMake(240, 75, 45, 12));
        CGContextFillRect(c, CGRectMake(255, 65, 14, 12));

        // Dark leather sofa interior
        [[UIColor colorWithRed:0.35 green:0.22 blue:0.16 alpha:1.0] setFill];
        CGContextFillRoundedRect(c, CGRectMake(30, 180, 340, 180), 16, 16);
        // Glass coffee table foreground
        [[UIColor colorWithWhite:0.15 alpha:0.8] setFill];
        CGContextFillRect(c, CGRectMake(0, 330, 400, 70));

        // 3 Figures sitting on the couch
        // Left figure in dark tracksuit
        [[UIColor colorWithWhite:0.12 alpha:1.0] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(75, 130, 36, 40)); // Head
        CGContextFillRoundedRect(c, CGRectMake(60, 170, 70, 110), 12, 12); // Torso

        // Center figure in white hoodie
        [[UIColor colorWithWhite:0.92 alpha:1.0] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(180, 145, 40, 42)); // Hood
        CGContextFillRoundedRect(c, CGRectMake(160, 185, 80, 100), 14, 14);

        // Right foreground figure in black tank top
        [[UIColor colorWithRed:0.28 green:0.18 blue:0.14 alpha:1.0] setFill];
        CGContextFillEllipseInRect(c, CGRectMake(250, 175, 48, 52)); // Head
        [[UIColor colorWithWhite:0.10 alpha:1.0] setFill];
        CGContextFillRoundedRect(c, CGRectMake(230, 225, 95, 130), 16, 16); // Torso

        // PARENTAL ADVISORY EXPLICIT CONTENT small badge bottom right
        CGRect advRect = CGRectMake(280, 335, 95, 45);
        [[UIColor whiteColor] setFill];
        CGContextFillRoundedRect(c, advRect, 4, 4);
        [[UIColor blackColor] setFill];
        CGContextFillRect(c, CGRectInset(advRect, 3, 3));
        [[UIColor whiteColor] setFill];
        CGContextFillRect(c, CGRectMake(285, 341, 85, 14));
        // Text indicator bars inside badge
        [[UIColor blackColor] setFill];
        CGContextFillRect(c, CGRectMake(287, 344, 81, 8));
        [[UIColor whiteColor] setFill];
        CGContextFillRect(c, CGRectMake(295, 360, 65, 4));
        CGContextFillRect(c, CGRectMake(302, 367, 51, 3));
    }];
}

static UIImage *playGlyph(void) {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(48, 48)];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(19, 15)];
        [path addLineToPoint:CGPointMake(33, 24)];
        [path addLineToPoint:CGPointMake(19, 33)];
        [path closePath];
        [UIColor.blackColor setFill];
        [path fill];
    }];
}

// One of the round buttons of the header's action row: the element view Spotify's stack arranges, the
// button inside it at the same size, and a glyph in the button.
static UIView *actionButton(UIView *row, CGRect frame, NSString *identifier, NSString *symbol, NSString *a11y) {
    UIView *element = box(row, UIView.class, frame, nil);
    // Drawn by Lottie, its state in its identifier and in the Encore object behind it (issue #65).
    if ([identifier hasPrefix:@"DownloadButton.Granular."]) {
        mockDownloadButton(element);
        return element;
    }
    if ([identifier isEqualToString:@"Components.UI.AddToButton"]) {
        mockAddToButton(element);
        return element;
    }
    UIView *button = box(element, MockEncoreButton.class, element.bounds, identifier);
    button.accessibilityLabel = a11y;
    UIImageView *glyph = [[UIImageView alloc] initWithFrame:CGRectInset(button.bounds, 12, 12)];
    glyph.image = [UIImage systemImageNamed:symbol];
    glyph.tintColor = UIColor.whiteColor;
    [button addSubview:glyph];
    return element;
}

#pragma mark - the metadata row's cells

@interface SGRMetaSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray<NSString *> *items;
@end

@implementation SGRMetaSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)view cellForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewCell *cell = [view dequeueReusableCellWithReuseIdentifier:@"meta" forIndexPath:path];
    for (UIView *old in cell.contentView.subviews) [old removeFromSuperview];
    label(cell.contentView, cell.contentView.bounds, self.items[path.item], 11,
          [UIColor colorWithWhite:0.70 alpha:1], @"Encore.Label");
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)view layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)path {
    CGSize text = [self.items[path.item] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
    return CGSizeMake(ceil(text.width), 15.33);
}

@end

// What the redesign's row shows on Play's right: the label of the Kit's last round button, the trailing one.
static UIControl *trailingButton(UIView *root) {
    NSMutableArray<UIView *> *stack = [NSMutableArray arrayWithObject:root];
    while (stack.count) {
        UIView *v = stack.lastObject;
        [stack removeLastObject];
        if ([NSStringFromClass(v.class) isEqualToString:@"SGRHeaderInfo"]) {
            UIControl *trailing = nil;
            for (UIView *sub in v.subviews) {
                if ([NSStringFromClass(sub.class) isEqualToString:@"SGRMirrorButton"]) trailing = (UIControl *)sub;
            }
            return trailing;
        }
        [stack addObjectsFromArray:v.subviews];
    }
    return nil;
}

// The trailing button's label and the symbol it draws.
static NSString *trailingState(UIView *root) {
    UIControl *trailing = trailingButton(root);
    UIImageView *glyph = nil;
    for (UIView *sub in trailing.subviews) {
        if ([sub isKindOfClass:UIImageView.class] && !sub.hidden) glyph = (UIImageView *)sub;
    }
    return [NSString stringWithFormat:@"\"%@\" %@ tint %@", trailing.accessibilityLabel, glyph.image, glyph.tintColor];
}

static NSString *trailingLabel(UIView *root) {
    NSMutableArray<UIView *> *stack = [NSMutableArray arrayWithObject:root];
    while (stack.count) {
        UIView *v = stack.lastObject;
        [stack removeLastObject];
        if ([NSStringFromClass(v.class) isEqualToString:@"SGRHeaderInfo"]) {
            UIView *trailing = nil;
            for (UIView *sub in v.subviews) {
                if ([NSStringFromClass(sub.class) isEqualToString:@"SGRMirrorButton"]) trailing = sub;
            }
            return trailing && !trailing.hidden ? trailing.accessibilityLabel : @"nothing";
        }
        [stack addObjectsFromArray:v.subviews];
    }
    return @"no header";
}

#pragma mark - the page

static void addAppleMusicChrome(UIView *rootView, CGFloat W, CGFloat H, BOOL staticCover) {
    // 1. Top Bar: Back button < at top-left
    UIView *backBtn = [[UIView alloc] initWithFrame:CGRectMake(16, 54, 38, 38)];
    backBtn.layer.cornerRadius = 19;
    backBtn.layer.cornerCurve = kCACornerCurveContinuous;
    backBtn.clipsToBounds = YES;
    UIVisualEffectView *backGlass = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark]];
    backGlass.frame = backBtn.bounds;
    backGlass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [backBtn addSubview:backGlass];
    UIImageView *backChevron = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 20, 20)];
    backChevron.image = [UIImage systemImageNamed:@"chevron.left"];
    backChevron.tintColor = UIColor.whiteColor;
    backChevron.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addSubview:backChevron];
    [rootView addSubview:backBtn];

    // 2. Top Bar: Combined capsule [ ↑ | ⋯ ] at top-right
    UIView *topCapsule = [[UIView alloc] initWithFrame:CGRectMake(W - 16 - 84, 55, 84, 36)];
    topCapsule.layer.cornerRadius = 18;
    topCapsule.layer.cornerCurve = kCACornerCurveContinuous;
    topCapsule.clipsToBounds = YES;
    UIVisualEffectView *capGlass = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark]];
    capGlass.frame = topCapsule.bounds;
    capGlass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [topCapsule addSubview:capGlass];

    UIImageView *shareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(11, 8, 20, 20)];
    shareIcon.image = [UIImage systemImageNamed:@"square.and.arrow.up"];
    shareIcon.tintColor = UIColor.whiteColor;
    shareIcon.contentMode = UIViewContentModeScaleAspectFit;
    [topCapsule addSubview:shareIcon];

    UIView *div = [[UIView alloc] initWithFrame:CGRectMake(41.75, 9, 0.5, 18)];
    div.backgroundColor = [UIColor colorWithWhite:1 alpha:0.18];
    [topCapsule addSubview:div];

    UIImageView *moreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(52, 8, 20, 20)];
    moreIcon.image = [UIImage systemImageNamed:@"ellipsis"];
    moreIcon.tintColor = UIColor.whiteColor;
    moreIcon.contentMode = UIViewContentModeScaleAspectFit;
    [topCapsule addSubview:moreIcon];
    [rootView addSubview:topCapsule];

    // 3. Floating Mini Player at bottom (matching Photo 2 & 3)
    CGFloat playerY = H - 84 - 56 - 6;
    UIView *miniPlayer = [[UIView alloc] initWithFrame:CGRectMake(16, playerY, W - 32, 56)];
    miniPlayer.layer.cornerRadius = 16;
    miniPlayer.layer.cornerCurve = kCACornerCurveContinuous;
    miniPlayer.clipsToBounds = YES;
    UIVisualEffectView *playerGlass = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark]];
    playerGlass.frame = miniPlayer.bounds;
    playerGlass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [miniPlayer addSubview:playerGlass];

    // Mini player art
    UIImageView *miniArt = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 38, 38)];
    miniArt.image = fastLifeArtwork();
    miniArt.layer.cornerRadius = 6;
    miniArt.clipsToBounds = YES;
    miniArt.contentMode = UIViewContentModeScaleAspectFill;
    [miniPlayer addSubview:miniArt];

    // Mini player text
    UILabel *miniTitle = [[UILabel alloc] initWithFrame:CGRectMake(58, 10, W - 32 - 160, 18)];
    miniTitle.text = @"HA HA HA";
    miniTitle.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightMedium];
    miniTitle.textColor = UIColor.whiteColor;
    [miniPlayer addSubview:miniTitle];

    UILabel *miniSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(58, 29, W - 32 - 160, 16)];
    miniSubtitle.text = @"L2B 🅴";
    miniSubtitle.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightRegular];
    miniSubtitle.textColor = [UIColor colorWithWhite:1 alpha:0.65];
    [miniPlayer addSubview:miniSubtitle];

    // Play & Next icons
    UIImageView *miniPlay = [[UIImageView alloc] initWithFrame:CGRectMake(W - 32 - 82, 17, 22, 22)];
    miniPlay.image = [UIImage systemImageNamed:@"play.fill"];
    miniPlay.tintColor = UIColor.whiteColor;
    miniPlay.contentMode = UIViewContentModeScaleAspectFit;
    [miniPlayer addSubview:miniPlay];

    UIImageView *miniNext = [[UIImageView alloc] initWithFrame:CGRectMake(W - 32 - 42, 17, 24, 22)];
    miniNext.image = [UIImage systemImageNamed:@"forward.fill"];
    miniNext.tintColor = UIColor.whiteColor;
    miniNext.contentMode = UIViewContentModeScaleAspectFit;
    [miniPlayer addSubview:miniNext];
    [rootView addSubview:miniPlayer];

    // 4. Glass Tab Bar at bottom
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, H - 84, W, 84)];
    UIVisualEffectView *tabGlass = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark]];
    tabGlass.frame = tabBar.bounds;
    tabGlass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tabBar addSubview:tabGlass];

    NSArray *tabs = @[
        @[@"Accueil", @"house.fill"],
        @[@"Nouveautés", @"square.grid.2x2.fill"],
        @[@"Radio", @"dot.radiowaves.left.and.right"],
        @[@"Bibliothèque", @"music.note.list"],
        @[@"Recherche", @"magnifyingglass"]
    ];
    CGFloat tabW = W / tabs.count;
    for (NSUInteger i = 0; i < tabs.count; i++) {
        UIView *tabItem = [[UIView alloc] initWithFrame:CGRectMake(i * tabW, 6, tabW, 48)];
        BOOL isSearch = (i == 4);
        UIColor *col = isSearch ? [UIColor colorWithRed:0.91 green:0.25 blue:0.55 alpha:1.0] : [UIColor colorWithWhite:1 alpha:0.6];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((tabW - 24)/2, 2, 24, 24)];
        icon.image = [UIImage systemImageNamed:tabs[i][1]];
        icon.tintColor = col;
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [tabItem addSubview:icon];
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, tabW, 14)];
        txt.text = tabs[i][0];
        txt.font = [UIFont systemFontOfSize:10.5 weight:isSearch ? UIFontWeightSemibold : UIFontWeightRegular];
        txt.textColor = col;
        txt.textAlignment = NSTextAlignmentCenter;
        [tabItem addSubview:txt];
        [tabBar addSubview:tabItem];
    }
    [rootView addSubview:tabBar];
}

@interface SGRHarnessDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) SGRMetaSource *meta;
@end

@implementation SGRHarnessDelegate {
    UIView *_titleBlock, *_titleStack, *_actionRow, *_metaCells;
    NSMutableArray<UIView *> *_actionItems;
    NSMutableArray<NSValue *> *_actionFrames;
    NSMutableArray<_TtC12Element_List18CollectionViewCell *> *_footerCells;
    UIView *_listView;
    CGFloat _tracksBottom;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    CGFloat W = self.window.bounds.size.width, H = self.window.bounds.size.height;
    // `static`: centered square cover (Apple Music's static/non-animated album mode) instead of full bleed.
    BOOL staticCover = [NSProcessInfo.processInfo.arguments containsObject:@"static"];

    UIViewController *root = [UIViewController new];
    root.view.backgroundColor = [UIColor colorWithWhite:0.04 alpha:1];
    self.window.rootViewController = root;

    UIView *page = box(root.view, _TtC28CreativeWorkPlatform_PageKit24CreativeWorkTemplateView.class,
                       CGRectMake(0, 0, W, H), @"CreativeWorkPlatform.CreativeWorkTemplateView");

    // Album details matching Photo 2 (Graduation) or Photo 3 (FAST LIFE)
    NSString *albumTitle = staticCover ? @"FAST LIFE" : @"Graduation";
    NSString *artistName = staticCover ? @"L2B" : @"Kanye West";
    UIImage *coverImg = staticCover ? fastLifeArtwork() : graduationArtwork();

    // Spotify's colour wash behind the header, the height of the header at rest.
    UIView *wash = box(page, _TtCO19LegacyUI_ECMCoreKit5Views10HeaderView.class, CGRectMake(0, 0, W, 486.67), nil);
    UIView *gradient = box(wash, _TtC19LegacyUI_ECMCoreKit12GradientView.class, wash.bounds, nil);
    if (staticCover) {
        ((CAGradientLayer *)gradient.layer).colors = @[(id)[UIColor colorWithRed:0.09 green:0.09 blue:0.12 alpha:1].CGColor,
                                                       (id)[UIColor colorWithRed:0.04 green:0.04 blue:0.05 alpha:1].CGColor];
    } else {
        ((CAGradientLayer *)gradient.layer).colors = @[(id)[UIColor colorWithRed:0.62 green:0.18 blue:0.47 alpha:1].CGColor,
                                                       (id)[UIColor colorWithRed:0.20 green:0.04 blue:0.15 alpha:1].CGColor];
    }

    // the tab, the scroll and the stack the header and the list sit in
    UIView *tab = box(page, UIView.class, CGRectMake(0, 0, W, H), @"CreativeWorkPlatform.Tab");
    UIScrollView *scroll = (UIScrollView *)box(tab, UIScrollView.class, CGRectMake(0, 0, W, H), @"PCFFTabLayoutViewController.containerScrollView");
    scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    UIStackView *stack = (UIStackView *)box(scroll, UIStackView.class, CGRectMake(0, 0, W, 2200), nil);

    UIView *headerElement = box(stack, UIView.class, CGRectMake(0, 0, W, 486.67), @"CreativeWorkPlatform.Header");
    UIView *header = box(headerElement, UIView.class, headerElement.bounds, @"CreativeWorkPlatform.Components.UI.CreativeWorkHeader");
    UIView *inset = box(header, UIView.class, CGRectMake(0, 78, W, 400.67), nil);
    UIStackView *outer = (UIStackView *)box(inset, UIStackView.class, inset.bounds, nil);

    UIView *topGroup = box(outer, UIView.class, CGRectMake(0, 0, W, 321.33), nil);
    UIStackView *groupStack = (UIStackView *)box(topGroup, UIStackView.class, topGroup.bounds, nil);

    UIView *artRow = box(groupStack, UIView.class, CGRectMake(0, 0, W, 248), nil);
    UIView *coverElement = box(artRow, UIView.class, CGRectMake(round((W - 248) / 2), 0, 248, 248), nil);
    UIView *cover = box(coverElement, UIView.class, coverElement.bounds, @"CreativeWorkPlatform.Components.UI.ArtWorkElement.WithCoverArt");
    UIImageView *coverPicture = [[UIImageView alloc] initWithFrame:cover.bounds];
    coverPicture.image = coverImg;
    coverPicture.contentMode = UIViewContentModeScaleAspectFill;
    coverPicture.clipsToBounds = YES;
    coverPicture.accessibilityIdentifier = @"Encore.ImageView";

    // In `static` mode, the cover is a rounded square centred on a dark background (Apple Music Photo 3):
    if (staticCover) {
        coverPicture.layer.cornerRadius = 12;
        coverPicture.layer.cornerCurve = kCACornerCurveContinuous;
        cover.layer.shadowColor = [UIColor blackColor].CGColor;
        cover.layer.shadowOpacity = 0.5;
        cover.layer.shadowRadius = 18;
        cover.layer.shadowOffset = CGSizeMake(0, 8);
    }
    [cover addSubview:coverPicture];
    box(groupStack, UIView.class, CGRectMake(0, 256, 0, 0), nil);

    _titleBlock = box(groupStack, UIView.class, CGRectMake(0, 264, 215.33, 57.33), nil);
    _titleStack = box(_titleBlock, UIStackView.class, CGRectMake(16, 0, 183.33, 57.33), nil);
    label(_titleStack, CGRectZero, @"", 17, UIColor.whiteColor, @"CreativeWorkPlatform.Components.UI.PreTitleRow");
    label(_titleStack, CGRectMake(0, 0, 183.33, 25.33), albumTitle, 22, UIColor.whiteColor,
          @"CreativeWorkPlatform.Components.UI.TitleRow");
    UIView *parentElement = box(_titleStack, UIView.class, CGRectMake(0, 33.33, 96, 24), nil);
    UIView *parentRow = box(parentElement, MockEncoreButton.class, parentElement.bounds, @"CreativeWorkPlatform.Components.UI.ParentRow");
    parentRow.accessibilityLabel = artistName;
    label(parentRow, CGRectMake(0, 4.33, 100, 15.33), artistName, 15, [UIColor colorWithWhite:1 alpha:0.85], @"Encore.Label");

    UIView *bottomGroup = box(outer, UIView.class, CGRectMake(0, 329.33, W, 71.33), nil);
    UIStackView *bottomStack = (UIStackView *)box(bottomGroup, UIStackView.class, bottomGroup.bounds, nil);

    UIView *metaWrap = box(bottomStack, UIView.class, CGRectMake(0, 0, W, 15.33), nil);
    UIStackView *metaStack = (UIStackView *)box(metaWrap, UIStackView.class, CGRectMake(16, 0, W - 32, 15.33), nil);
    UIView *metaElement = box(metaStack, UIView.class, metaStack.bounds, nil);
    UIView *metadata = box(metaElement, UIView.class, metaElement.bounds, @"Components.UI.MetadataRow");
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumInteritemSpacing = 4;
    UICollectionView *cells = [[UICollectionView alloc] initWithFrame:metadata.bounds collectionViewLayout:flow];
    cells.backgroundColor = UIColor.clearColor;
    [cells registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"meta"];
    self.meta = [SGRMetaSource new];
    self.meta.items = staticCover ? @[@"Hip-hop/Rap", @"•", @"2026", @"•", @"∿ Lossless"]
                                  : @[@"Hip-hop/Rap", @"•", @"2007", @"•", @"∿ Lossless"];
    cells.dataSource = self.meta;
    cells.delegate = self.meta;
    [metadata addSubview:cells];
    _metaCells = cells;

    _actionRow = box(bottomStack, UIStackView.class, CGRectMake(0, 23.33, 206, 48), nil);
    _actionItems = [NSMutableArray array];
    _actionFrames = [NSMutableArray array];
    NSArray *actions = @[@[@"Components.UI.WatchFeedEntityExplorerButton", @"play.rectangle", @"Explore", @0, @4, @62, @40],
                         @[@"Components.UI.AddToButton", @"plus", @"Add", @62, @0, @48, @48],
                         @[@"DownloadButton.Granular.None", @"arrow.down.circle", @"Download", @110, @0, @48, @48],
                         @[@"Components.UI.ContextMenuButton-3OxfaVgvTxUTy7276t7SPU", @"ellipsis", @"More options", @158, @0, @48, @48]];
    BOOL late = [NSProcessInfo.processInfo.arguments containsObject:@"late"];
    BOOL downloads = [NSProcessInfo.processInfo.arguments containsObject:@"download"];
    for (NSArray *action in actions) {
        if ((late || downloads) && [action[0] isEqualToString:@"Components.UI.AddToButton"]) continue;
        CGRect frame = CGRectMake([action[3] doubleValue], [action[4] doubleValue], [action[5] doubleValue], [action[6] doubleValue]);
        [_actionItems addObject:actionButton(_actionRow, frame, action[0], action[1], action[2])];
        [_actionFrames addObject:[NSValue valueWithCGRect:frame]];
    }

    // Share button mock in header for tweak discovery
    UIView *shareButtonEl = box(header, UIView.class, CGRectZero, nil);
    UIView *shareButton = box(shareButtonEl, MockEncoreButton.class, CGRectZero, @"Components.UI.ShareButton");
    shareButton.accessibilityLabel = @"Share";

    // the track list under the header
    _listView = box(stack, _TtC32CreativeWorkPlatform_TemplateKit28CreativeWorkTemplateListView.class,
                    CGRectMake(0, 486.67, W, 700), nil);
    _listView.backgroundColor = UIColor.clearColor;
    UIView *collection = box(_listView, UIView.class, _listView.bounds, nil);
    collection.backgroundColor = UIColor.clearColor;

    // Track lists corresponding to Photo 2 (Graduation) or Photo 3 (FAST LIFE)
    NSArray<NSArray<id> *> *tracks;
    if (staticCover) {
        tracks = @[@[@"HA HA HA", @"1", @NO, @YES],
                   @[@"Don't step", @"2", @YES, @YES],
                   @[@"Arme drogue", @"3", @YES, @YES],
                   @[@"Big star", @"4", @YES, @YES],
                   @[@"Ride", @"5", @NO, @YES],
                   @[@"Cali", @"6", @NO, @YES]];
    } else {
        tracks = @[@[@"Good Morning", @"1", @NO, @YES],
                   @[@"Champion", @"2", @NO, @YES],
                   @[@"Stronger", @"3", @YES, @YES],
                   @[@"I Wonder", @"4", @NO, @NO],
                   @[@"Good Life (feat. T-Pain)", @"5", @YES, @YES],
                   @[@"Can't Tell Me Nothing", @"6", @YES, @YES],
                   @[@"Barry Bonds (feat. Lil Wayne)", @"7", @NO, @YES],
                   @[@"Drunk and Hot Girls (feat. Mos Def)", @"8", @NO, @NO],
                   @[@"Flashing Lights (feat. Dwele)", @"9", @YES, @NO]];
    }

    CGFloat y = 8;
    for (NSArray<id> *track in tracks) {
        NSString *title = track[0];
        NSString *numStr = track[1];
        BOOL popular = [track[2] boolValue];
        BOOL explicit = [track[3] boolValue];

        UICollectionViewCell *cell = [[_TtC12Element_List18CollectionViewCell alloc] initWithFrame:CGRectMake(0, y, W, 50)];
        cell.backgroundColor = UIColor.clearColor;
        [collection addSubview:cell];
        UIView *content = box(cell.contentView, MockRetrievalListStructuredDataView.class, cell.contentView.bounds, nil);
        UIView *row = box(content, UIView.class, content.bounds, @"Components.UI.RetrievalRowElementUI");
        row.backgroundColor = UIColor.clearColor;

        // Star column at x=16, width=12
        if (popular) {
            UILabel *starLbl = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 12, 50)];
            starLbl.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
            starLbl.textColor = [UIColor colorWithWhite:1 alpha:0.45];
            starLbl.textAlignment = NSTextAlignmentCenter;
            starLbl.text = @"★";
            [row addSubview:starLbl];
        }

        // Track number at x=30, width=18, right-aligned, monospaced digit
        UILabel *numLabel = [UILabel new];
        numLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
        numLabel.text = numStr;
        numLabel.textColor = [UIColor colorWithWhite:1 alpha:0.50];
        numLabel.textAlignment = NSTextAlignmentRight;
        numLabel.frame = CGRectMake(30, 0, 18, 50);
        numLabel.accessibilityIdentifier = @"EncoreConsumerMobile.View.Granular.TrackNumber";
        [row addSubview:numLabel];

        // Title at x=56, vertically centered, pure white
        NSString *displayTitle = explicit ? [title stringByAppendingString:@" 🅴"] : title;
        label(row, CGRectMake(56, 14, W - 56 - 50, 22), displayTitle,
              16, UIColor.whiteColor, @"EncoreConsumerMobile.View.Granular.Title");

        // Trailing horizontal ellipsis ⋯
        actionButton(row, CGRectMake(W - 48, 2, 44, 46),
                     @"Components.UI.ContextMenuButton-5673WA8EEUSPx1ir26lhGW",
                     @"ellipsis", @"More options");
        y += 50;
    }
    _tracksBottom = y;

    // and under it the footer Spotify sends: the album's own line, the copyright, and the sections the
    // redesign drops -- each with the 16pt spacer Spotify puts between them.
    _footerCells = [NSMutableArray array];
    NSArray *footer = @[@[@"", @16], @[@"Album.ConsumptionExperience", @15.33], @[@"", @16],
                        @[@"heading:More by The Weeknd", @52.67], @[@"cards", @194.33], @[@"", @16],
                        @[@"heading:Related Music Videos", @52.67], @[@"cards", @235.67], @[@"", @16],
                        @[@"heading:Merch", @52.67], @[@"cards", @197], @[@"", @16],
                        @[@"heading:You might also like", @52.67], @[@"cards", @193.33], @[@"", @16],
                        @[@"Album.Copyright", @60.67]];
    for (NSArray *item in footer) {
        NSString *kind = item[0];
        CGFloat height = [item[1] doubleValue];
        _TtC12Element_List18CollectionViewCell *cell =
            [[_TtC12Element_List18CollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, W, height)];
        [collection addSubview:cell];
        UIView *content = box(cell.contentView, MockAlbum_PageImpl20FooterStructuredDataView.class, cell.contentView.bounds, nil);
        if ([kind isEqualToString:@"Album.ConsumptionExperience"]) {
            UIView *line = box(content, UIView.class, content.bounds, kind);
            label(line, CGRectMake(16, 0, W - 32, height), @"22 songs • 1hr 24min", 11, UIColor.whiteColor, @"Encore.Label");
        } else if ([kind isEqualToString:@"Album.Copyright"]) {
            UIView *line = box(content, UIView.class, content.bounds, kind);
            UILabel *text = label(line, CGRectMake(16, 0, W - 32, height),
                                  @"© 2025 The Weeknd XO Music ULC, marketed by Republic Records.\n℗ 2025 The Weeknd XO Music ULC, marketed by Republic Records.",
                                  11, UIColor.whiteColor, @"Encore.Label");
            text.numberOfLines = 0;
        } else if ([kind hasPrefix:@"heading:"]) {
            UIView *heading = box(content, UIView.class, content.bounds, @"Components.UI.SectionHeadingHome");
            label(heading, CGRectMake(16, 16, W - 32, 20.67), [kind substringFromIndex:8], 17, UIColor.whiteColor, @"Encore.Label");
        } else if ([kind isEqualToString:@"cards"]) {
            for (int i = 0; i < 3; i++) {
                UIView *card = box(content, UIView.class, CGRectMake(16 + i * 161, 0, 153, height), @"Components.UI.ContentCardAlbum");
                card.backgroundColor = [UIColor colorWithWhite:0.12 alpha:1];
                card.layer.cornerRadius = 4;
            }
        }
        [_footerCells addObject:cell];
    }

    // An episode page is this same template with cells of its own (device, trees/continuous/1.txt
    // 2026-09-20), and every one of them paints the black the AMOLED made of Spotify's base surface over
    // the field. Put under the tracks, clear of the footer the redesign drops: what is proved here is the
    // paint, not the layout. A card inside one of them is a cell of its own and keeps its own black.
    NSArray *episode = @[@[@"Episode Transcript", @50], @[@"", @24], @[@"", @4.67]];
    CGFloat episodeY = _tracksBottom + 140;
    NSMutableArray<UIView *> *episodePaints = [NSMutableArray array];
    for (NSArray *item in episode) {
        CGFloat height = [item[1] doubleValue];
        UICollectionViewCell *cell = [[_TtC12Element_List18CollectionViewCell alloc]
                                      initWithFrame:CGRectMake(0, episodeY, W, height)];
        [collection addSubview:cell];
        UIView *content = box(cell.contentView, UIView.class, cell.contentView.bounds, nil);
        UIView *paint = box(content, UIView.class, content.bounds, nil);
        paint.backgroundColor = UIColor.blackColor;
        if ([item[0] length]) label(paint, CGRectMake(16, 16, W - 48, 18), item[0], 13, UIColor.whiteColor, @"Encore.Label");
        [episodePaints addObject:paint];
        episodeY += height;
    }
    UICollectionViewCell *carousel = [[_TtC12Element_List18CollectionViewCell alloc]
                                      initWithFrame:CGRectMake(0, episodeY, W, 80)];
    [collection addSubview:carousel];
    UICollectionViewCell *card = [[_TtC12Element_List18CollectionViewCell alloc] initWithFrame:CGRectMake(16, 0, 153, 80)];
    card.backgroundColor = UIColor.blackColor;
    [carousel.contentView addSubview:card];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"[harness] the episode page's paint: %@ %@ %@, and the card inside a cell %@",
              episodePaints[0].backgroundColor ?: @"clear", episodePaints[1].backgroundColor ?: @"clear",
              episodePaints[2].backgroundColor ?: @"clear", card.backgroundColor ?: @"clear");
    });

    // the sticky navigation bar, its gradient hidden until the page scrolls
    UIView *navBar = box(page, _TtC28EncoreConsumerMobile_BaseKit20HeaderNavigationBar.class, CGRectMake(0, 0, W, 118), @"CreativeWorkPlatform.HeaderNavigationBar");
    UIView *navGradient = box(navBar, _TtC19LegacyUI_ECMCoreKit12GradientView.class, navBar.bounds, nil);
    ((CAGradientLayer *)navGradient.layer).colors = @[(id)[UIColor colorWithWhite:0.02 alpha:1].CGColor,
                                                      (id)[UIColor colorWithWhite:0.02 alpha:1].CGColor];
    navGradient.hidden = YES;
    // Scrolled, Spotify shows it by -setHidden:, which is what took a conceal() back.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        navGradient.hidden = NO;
        NSLog(@"[harness] Spotify showed the navigation bar's gradient; mask %@", navGradient.layer.mask ? @"on" : @"off");
    });

    // the two controls Spotify floats over the page, outside the scroll
    UIView *shuffleElement = box(page, UIView.class, CGRectMake(282, 62, 48, 48), nil);
    UIView *shuffle = box(shuffleElement, MockEncoreButton.class, shuffleElement.bounds, @"Components.UI.ShuffleButton");
    shuffle.accessibilityLabel = @"Shuffle tracks";
    mockShuffleGlyph(shuffle);

    UIView *playElement = box(page, UIView.class, CGRectMake(338, 94, 48, 48), nil);
    UIView *playButton = box(playElement, _TtC28EncoreConsumerMobile_BaseKit14PlayButtonView.class, playElement.bounds, @"header-play-button");
    UIControl *condensed = (UIControl *)box(playButton, MockCondensedButton.class, playButton.bounds, nil);
    condensed.accessibilityLabel = @"Lire";
    UIImageView *disc = [[UIImageView alloc] initWithFrame:condensed.bounds];
    disc.image = playGlyph();
    disc.backgroundColor = [UIColor colorWithRed:0.12 green:0.84 blue:0.38 alpha:1];
    disc.layer.cornerRadius = 24;
    disc.clipsToBounds = YES;
    [condensed addSubview:disc];

    [self.window makeKeyAndVisible];
    addAppleMusicChrome(root.view, W, H, staticCover);
    if (downloads) downloadScript();

    // `addto`: saved from elsewhere at 3 s (the ⋯ sheet, nothing laid out), then Play's right tapped at 7 s.
    if ([NSProcessInfo.processInfo.arguments containsObject:@"addto"]) {
        UIView *rootView = root.view;
        for (NSNumber *when in @[@2, @6.5, @8.5]) {
            at(when.doubleValue, ^{ NSLog(@"[harness] add-to at %@s: %@", when, trailingState(rootView)); });
        }
        at(3, ^{ setAddTo(1); NSLog(@"[harness] add-to: saved from elsewhere"); });
        at(7, ^{ [trailingButton(rootView) sendActionsForControlEvents:UIControlEventTouchUpInside]; });
    }

    // In `late`, add arrives at 2.5 s, after every pass of the header's and the metadata's re-reads: an arranged
    // subview of the row, which lays out the row and nothing above it.
    if (late) {
        UIStackView *row = (UIStackView *)_actionRow;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [row insertArrangedSubview:actionButton(row, CGRectMake(62, 0, 48, 48), @"Components.UI.AddToButton", @"plus", @"Add")
                               atIndex:0];
            NSLog(@"[harness] late: add arrived in the row");
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"[harness] late: Play's right shows \"%@\"", trailingLabel(root.view));
        });
    }

    // The list is measured the way the page's collection measures it: every cell is asked how tall it wants
    // to be, which is where AlbumSections.x answers 0 for what the redesign drops, and the answers are
    // stacked. Done a beat after launch, so the header has laid out at least once first.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self measureFooter:W];
        NSLog(@"[harness] hero %@, title stack %@, action row %@",
              NSStringFromCGRect([cover.window convertRect:cover.bounds fromView:cover]),
              NSStringFromCGRect(self->_titleStack.frame), NSStringFromCGRect(self->_actionRow.frame));

        UIView *pinned = nil;
        for (UIView *sub in page.subviews) {
            if ([NSStringFromClass(sub.class) isEqualToString:@"SGRMirrorButton"] ||
                [NSStringFromClass(sub.class) containsString:@"Capsule"]) pinned = sub;
        }
        NSLog(@"[harness] pinned top-bar item: %@ on the page, hidden=%d",
              pinned ? NSStringFromCGRect(pinned.frame) : @"MISSING", pinned.hidden);
        __block UIView *info = nil, *artist = nil;
        __weak UIViewController *weakRoot = root;
        void (^walk)(UIView *) = ^(UIView *v) {
            NSMutableArray<UIView *> *queue = [NSMutableArray arrayWithObject:v];
            while (queue.count) {
                UIView *cur = queue.firstObject;
                [queue removeObjectAtIndex:0];
                if ([NSStringFromClass(cur.class) isEqualToString:@"SGRHeaderInfo"]) info = cur;
                [queue addObjectsFromArray:cur.subviews];
            }
        };
        if (weakRoot.view) walk(weakRoot.view);

        // For Graduation (Photo 2), show the editorial review below the action row
        if (!staticCover && info) {
            SEL showSel = @selector(showTitle:creator:length:about:);
            if ([info respondsToSelector:showSel]) {
                ((void (*)(id, SEL, NSString *, NSString *, NSString *, NSString *))objc_msgSend)(
                    info, showSel, @"Graduation", @"Kanye West", @"Hip-hop/Rap • 2007 • ∿ Lossless",
                    @"On avait découvert Kanye West avec The College Dropout. Late Registration avait confirmé son talent unique, mais Graduation a définitivement propulsé Kanye West au rang de superstar mondiale. PLUS"
                );
            }
        }

        for (UIView *sub in info.subviews) {
            if ([sub isKindOfClass:UILabel.class] && [((UILabel *)sub).text isEqualToString:artistName]) artist = sub;
        }
        UIView *onName = [info hitTest:CGPointMake(CGRectGetMidX(info.bounds), CGRectGetMidY(artist.frame)) withEvent:nil];
        UIView *beside = [info hitTest:CGPointMake(24, CGRectGetMidY(artist.frame)) withEvent:nil];
        NSLog(@"[harness] artist line: on the name %@, beside it %@", onName ? NSStringFromClass(onName.class) : @"through",
              beside ? NSStringFromClass(beside.class) : @"through");
    });
              beside ? NSStringFromClass(beside.class) : @"through");
    });

    // Spotify lays the header out again after the redesign has moved things: the title block, its stack and
    // the action row go back where its own layout puts them, and the redesign has to take them again from
    // its own watch on each.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_titleBlock.frame = CGRectMake(0, 264, 215.33, 57.33);
        self->_titleStack.frame = CGRectMake(16, 0, 183.33, 57.33);
        self->_actionRow.frame = CGRectMake(0, 23.33, 206, 48);
        for (NSUInteger i = 0; i < self->_actionItems.count; i++) {
            self->_actionItems[i].frame = self->_actionFrames[i].CGRectValue;
        }
        [groupStack setNeedsLayout];
        [groupStack layoutIfNeeded];
        [bottomStack setNeedsLayout];
        [bottomStack layoutIfNeeded];
        NSLog(@"[harness] Spotify's own frames put back; the redesign answered with title stack %@, action row %@",
              NSStringFromCGRect(self->_titleStack.frame), NSStringFromCGRect(self->_actionRow.frame));
    });
    return YES;
}

// Every footer cell asked for its height the way the collection's self-sizing asks, then stacked under the
// tracks with whatever each answered.
- (void)measureFooter:(CGFloat)width {
    CGFloat y = _tracksBottom;
    for (_TtC12Element_List18CollectionViewCell *cell in _footerCells) {
        CGFloat natural = cell.bounds.size.height;
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attributes.frame = CGRectMake(0, y, width, natural);
        UICollectionViewLayoutAttributes *answer = [cell preferredLayoutAttributesFittingAttributes:attributes];
        cell.frame = CGRectMake(0, y, width, answer.size.height);
        [cell layoutIfNeeded];
        y += answer.size.height;
    }
    _listView.frame = CGRectMake(0, 486.67, width, y + 24);
    _listView.subviews.firstObject.frame = _listView.bounds;
    UIScrollView *scroll = (UIScrollView *)_listView.superview.superview;
    if ([scroll isKindOfClass:UIScrollView.class]) scroll.contentSize = CGSizeMake(width, CGRectGetMaxY(_listView.frame));
    NSLog(@"[harness] the footer measured %.0fpt under the tracks", y - _tracksBottom);
}

@end

// Before every %ctor, so the redesign's gate reads on.
__attribute__((constructor(101))) static void sgr_harnessDefaults(void) {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"spotifyglass.redesign"];
}

int main(int argc, char *argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(SGRHarnessDelegate.class));
    }
}
