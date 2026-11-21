// Album redesign: the track rows on the field, the way the Music app has them -- no surface of their own
// and a hairline from the text's edge between one row and the next.
//
// Tree (trees/clean/album/03.txt:524-575): every row of the page is an Element_List.CollectionViewCell
// holding an Encore.ListRow, id=Components.UI.RetrievalRowElementUI, with the title
// (EncoreConsumerMobile.View.Granular.Title), the artists under it (…Granular.Subtitle) and, at the
// trailing edge, Components.UI.ContextMenuButton. An album row carries no artwork -- every track on the
// page shares the cover the header is already showing -- so the hairline runs from the page's own margin,
// where the text starts.
//
// The row's paint is cleared here rather than left to the Kit's repaint hook, which only hears about a
// colour when Spotify sets it and not when a reused cell already carries one.
//
// Apple Music adds a track number at the leading edge in a fixed-width column, a ★ before the number for
// popular tracks, and an explicit badge (🄴) inline after the title. The ⋯ at the trailing edge is the
// horizontal ellipsis at a smaller point size. The hairline starts after the number column.
//
// Spotify's type and its spacing are left alone: the row is 56pt for a title of 13pt, and a larger font of
// the Kit's would be cut off by the box the element framework measured for it.
#import "Core/SGCore.h"
#import "Redesigned/Kit/SGRKit.h"
#import "Album.h"

static const CGFloat kHairline = 0.5;
// Fixed leading column: track number right-aligned in kNumberWidth, then kNumberGap to the text.
// SGRSideMargin is an extern const CGFloat, so static constants use helper macros/inlines instead of global init.
static const CGFloat kNumberWidth = 24, kNumberGap = 8;
#define kNumberLeft SGRSideMargin
#define kHairlineLeft (SGRSideMargin + kNumberWidth + kNumberGap)

static char kRowKey, kSubtitleKey, kLineKey, kNumberKey, kTitleKey2;

static void clearSurface(UIView *view) {
    UIColor *color = view.backgroundColor;
    if (color && SGIsBaseSurface(color.CGColor)) view.backgroundColor = UIColor.clearColor;
}

// The hairline starts where the text starts, like the Music app -- after the track number column.
static void applyHairline(UIView *row) {
    CALayer *line = objc_getAssociatedObject(row, &kLineKey);
    if (!line) {
        line = [CALayer layer];
        line.zPosition = 1;
        objc_setAssociatedObject(row, &kLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    line.backgroundColor = SGRHairline().CGColor;
    if (line.superlayer != row.layer) [row.layer addSublayer:line];
    CGRect bounds = row.bounds;
    CGRect frame = CGRectMake(kHairlineLeft, bounds.size.height - kHairline,
                              MAX(0, bounds.size.width - kHairlineLeft - SGRSideMargin), kHairline);
    if (CGRectEqualToRect(line.frame, frame)) return;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    line.frame = frame;
    [CATransaction commit];
}

// A label attached to `row` under `key`, created with `make` on first call.
static UILabel *cachedLabel(UIView *row, const void *key, UILabel *(^make)(void)) {
    UILabel *label = objc_getAssociatedObject(row, key);
    if (!label) {
        label = make();
        objc_setAssociatedObject(row, key, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [row addSubview:label];
    }
    return label;
}

// The track number Spotify places in the accessibility tree; read from the index of the row in the list
// by looking for the number label in EncoreConsumerMobile.View.Granular.TrackNumber, falling back to
// reading the index from whatever numeric label sits before the title at the leading edge.
static NSString *trackNumberText(UIView *row) {
    // Spotify's tree may carry a dedicated TrackNumber element.
    __block NSString *found = nil;
    SGForEachView(row, ^(UIView *v) {
        if (found || ![v isKindOfClass:UILabel.class]) return;
        NSString *ident = v.accessibilityIdentifier;
        if ([ident containsString:@"TrackNumber"] || [ident containsString:@"trackNumber"]) {
            NSString *t = [((UILabel *)v).text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (t.length) found = t;
        }
    });
    return found;
}

// Whether `row` is marked popular by Spotify (a "Top" / "Popular" badge in its tree).
static BOOL isPopularRow(UIView *row) {
    __block BOOL popular = NO;
    SGForEachView(row, ^(UIView *v) {
        if (popular) return;
        NSString *ident = v.accessibilityIdentifier ?: @"";
        NSString *label = v.accessibilityLabel ?: @"";
        if ([ident containsString:@"Popular"] || [ident containsString:@"popular"] ||
            [label containsString:@"Popular"] || [label containsString:@"popular"] ||
            [ident containsString:@"TopTrack"] || [ident containsString:@"topTrack"]) {
            popular = YES;
        }
    });
    return popular;
}

static void applyRow(UIView *cell) {
    clearSurface(cell);
    UIView *row = SGRFindByIdentifier(cell, @"Components.UI.RetrievalRow*", &kRowKey);
    if (!row) return;
    // The row, and every box the element framework wraps it in on the way back up to the cell.
    for (UIView *v = row; v; v = v.superview) {
        clearSurface(v);
        if (v == cell) break;
    }

    UIView *subtitle = SGRFindByIdentifier(row, @"EncoreConsumerMobile.View.Granular.Subtitle", &kSubtitleKey);
    SGForEachView(subtitle, ^(UIView *v) {
        if (![v isKindOfClass:UILabel.class]) return;
        UILabel *label = (UILabel *)v;
        if (![label.textColor isEqual:SGRSecondary()]) label.textColor = SGRSecondary();
    });

    // --- track number label (Apple Music style: right-aligned in a fixed column at the leading edge) ---
    NSString *numText = trackNumberText(row);
    UILabel *numLabel = cachedLabel(row, &kNumberKey, ^UILabel *{
        UILabel *l = [UILabel new];
        // Monospaced digits so single- and double-digit numbers align.
        UIFont *base = [UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightRegular];
        l.font = base;
        l.textColor = SGRTertiary();
        l.textAlignment = NSTextAlignmentRight;
        l.userInteractionEnabled = NO;
        l.accessibilityElementsHidden = YES;
        return l;
    });
    if (numText) {
        BOOL popular = isPopularRow(row);
        // ★ before popular track numbers, in the accent colour.
        numLabel.text = popular ? [@"★" stringByAppendingString:numText] : numText;
        numLabel.textColor = popular ? SGRAccent() : SGRTertiary();
    }
    CGRect bounds = row.bounds;
    numLabel.frame = CGRectMake(kNumberLeft, 0, kNumberWidth, bounds.size.height);
    numLabel.hidden = (numText == nil);

    // --- push the title and subtitle to start after the number column ---
    UIView *titleContainer = SGRFindByIdentifier(row, @"EncoreConsumerMobile.View.Granular.Title", &kTitleKey2);
    UIView *subtitleContainer = subtitle; // already found above
    CGFloat textLeft = kHairlineLeft;
    CGFloat textRight = bounds.size.width - SGRSideMargin - 44; // leave room for ⋯
    for (UIView *container in @[titleContainer, subtitleContainer]) {
        if (!container) continue;
        CGRect f = container.frame;
        // Only shift when it's sitting at or near the original margin (not already moved, not spanning the row).
        if (f.origin.x < textLeft - 1 || f.origin.x > textLeft + 4) {
            f.origin.x = textLeft;
            f.size.width = MAX(0, textRight - textLeft);
            container.frame = f;
        }
    }

    applyHairline(row);
}

// Which cells of Element_List belong to an album's track list, answered once per content class: the same
// cell class carries Home's sections and the album's footer too, and a walk up to the page on every pass of
// every cell is what the answer is cached to avoid.
static BOOL isTrackContent(UIView *content) {
    static NSMutableDictionary<id, NSNumber *> *answers;
    if (!answers) answers = [NSMutableDictionary dictionary];
    Class cls = object_getClass(content);
    if (!cls) return NO;
    NSNumber *answer = answers[(id<NSCopying>)cls];
    if (!answer) {
        answer = @([NSStringFromClass(cls) containsString:@"RetrievalListStructuredData"]);
        answers[(id<NSCopying>)cls] = answer;
    }
    return answer.boolValue;
}

%hook _TtC12Element_List18CollectionViewCell
- (void)layoutSubviews {
    %orig;
    UICollectionViewCell *cell = (UICollectionViewCell *)self;
    if (!isTrackContent(cell.contentView.subviews.firstObject)) return;
    if (SGRAlbumPageOf(cell)) applyRow(cell);
}
%end

%ctor {
    if (!SGRedesignedUI()) return;
    %init;
    SGRequireClasses(@[@"_TtC12Element_List18CollectionViewCell"]);
}
