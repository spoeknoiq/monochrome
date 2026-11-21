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
// Apple Music column layout:
// Star at x=16 (width=12), Track number at x=30 (width=18, right-aligned), Title at x=56.
static const CGFloat kStarLeft = 16, kStarWidth = 12;
static const CGFloat kNumberLeft = 30, kNumberWidth = 18;
static const CGFloat kHairlineLeft = 56;

static char kRowKey, kSubtitleKey, kLineKey, kNumberKey, kStarKey, kTitleKey2, kContextBtnKey;

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
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.12].CGColor;
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
    for (UIView *v = row; v; v = v.superview) {
        clearSurface(v);
        if (v == cell) break;
    }

    CGRect bounds = row.bounds;

    // In Apple Music, on an album by a single artist, tracks do NOT display a redundant subtitle
    // repeating the artist name under every title. Hiding it makes the row single-line and clean.
    UIView *subtitle = SGRFindByIdentifier(row, @"EncoreConsumerMobile.View.Granular.Subtitle", &kSubtitleKey);
    if (subtitle && !subtitle.hidden) {
        subtitle.hidden = YES;
    }

    // --- star label (for popular tracks: subtle grey star to the left of the number) ---
    BOOL popular = isPopularRow(row);
    UILabel *starLabel = cachedLabel(row, &kStarKey, ^UILabel *{
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        l.textColor = [UIColor colorWithWhite:1 alpha:0.45];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = @"★";
        l.userInteractionEnabled = NO;
        l.accessibilityElementsHidden = YES;
        return l;
    });
    starLabel.frame = CGRectMake(kStarLeft, 0, kStarWidth, bounds.size.height);
    starLabel.hidden = !popular;

    // --- track number label (Apple Music style: right-aligned in a fixed column) ---
    NSString *numText = trackNumberText(row);
    UILabel *numLabel = cachedLabel(row, &kNumberKey, ^UILabel *{
        UILabel *l = [UILabel new];
        l.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
        l.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        l.textAlignment = NSTextAlignmentRight;
        l.userInteractionEnabled = NO;
        l.accessibilityElementsHidden = YES;
        return l;
    });
    if (numText) numLabel.text = numText;
    numLabel.frame = CGRectMake(kNumberLeft, 0, kNumberWidth, bounds.size.height);
    numLabel.hidden = (numText == nil);

    // --- title: vertically centered single line, starting at x = 56 ---
    UIView *titleContainer = SGRFindByIdentifier(row, @"EncoreConsumerMobile.View.Granular.Title", &kTitleKey2);
    CGFloat textLeft = kHairlineLeft;
    CGFloat textRight = bounds.size.width - SGRSideMargin - 40; // room for ⋯
    if (titleContainer) {
        CGRect tf = CGRectMake(textLeft, round((bounds.size.height - 22) / 2),
                               MAX(0, textRight - textLeft), 22);
        if (!CGRectEqualToRect(titleContainer.frame, tf)) titleContainer.frame = tf;
        SGForEachView(titleContainer, ^(UIView *v) {
            if ([v isKindOfClass:UILabel.class]) {
                UILabel *lbl = (UILabel *)v;
                lbl.textColor = UIColor.whiteColor;
                lbl.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            }
        });
    }

    // --- context menu ⋯: replace Spotify's 3 vertical dots with Apple Music's horizontal ellipsis ---
    UIView *contextBtn = SGRFindByIdentifier(row, @"Components.UI.ContextMenuButton*", &kContextBtnKey);
    if (contextBtn) {
        SGForEachView(contextBtn, ^(UIView *v) {
            if ([v isKindOfClass:UIImageView.class]) {
                UIImageView *iv = (UIImageView *)v;
                UIImage *sym = [UIImage systemImageNamed:@"ellipsis"];
                if (iv.image != sym) {
                    iv.image = sym;
                    iv.tintColor = [UIColor colorWithWhite:1 alpha:0.4];
                    iv.contentMode = UIViewContentModeCenter;
                }
            }
        });
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
