@interface SBApplication: NSObject
@end

@interface UILabel ()
- (UIColor*)customTextColor;
- (void)setCustomTextColor:(UIColor*)arg;
@end

@interface CAShapeLayer ()
- (UIColor*)customStrokeColor;
- (void)setCustomStrokeColor:(UIColor*)arg;
@end

@interface SBMediaController: NSObject
+ (id)sharedInstance;
- (SBApplication*)nowPlayingApplication;
@end

@interface MediaControlsTransportButton: UIButton
@end

@interface MediaControlsTransportStackView: UIView
@property(nonatomic, retain) MediaControlsTransportButton *leftButton;
@property(nonatomic, retain) MediaControlsTransportButton *middleButton;
@property(nonatomic, retain) MediaControlsTransportButton *rightButton;
- (void)_updateButtonVisualStyling: (UIButton*)button;
- (void)colorize;
@end

@interface MPButton: UIButton
@end

@interface CCUICAPackageView: UIView
@end

@interface MediaControlsRoutingButtonView: MPButton
- (CCUICAPackageView*)packageView;
- (void)colorize;
@end

@interface UIView ()
- (id)_viewControllerForAncestor;
@end

@interface MTVisualStylingProvider: NSObject
- (void)stopAutomaticallyUpdatingView:(id)arg1;
@end

@interface UISlider ()
- (id)_minTrackView;
- (id)_maxTrackView;
- (id)_minValueView;
- (id)_maxValueView;
@end

@interface MPVolumeSlider: UISlider
- (id)thumbImageForState:(unsigned long long)arg1;
@end

@interface MediaControlsVolumeSlider: MPVolumeSlider
- (MTVisualStylingProvider*)visualStylingProvider;
- (void)colorize;
@end

@interface MediaControlsVolumeContainerView: UIView
@property(nonatomic, retain) MediaControlsVolumeSlider *volumeSlider;
@end

@interface MediaControlsMasterVolumeSlider : MediaControlsVolumeSlider
- (void)colorize;
@end

@interface MPRouteLabel: UIView
@property (nonatomic,readonly) UILabel *titleLabel;
- (void)setTextColor:(UIColor*)arg1;
@end

@interface UILabel ()
- (void)mt_removeAllVisualStyling;
@end

@interface MediaControlsTimeControl : UIControl
@property(nonatomic, retain) UIView *elapsedTrack;
@property(nonatomic, retain) UIView *remainingTrack;
@property(nonatomic, retain) UIView *knobView;
@property(nonatomic, retain) UILabel *elapsedTimeLabel;
@property(nonatomic, retain) UILabel *remainingTimeLabel;
@property(nonatomic, retain) UILabel *liveLabel;
@property(nonatomic, retain) UIView *liveBackground;
- (MTVisualStylingProvider*)visualStylingProvider;
- (void)colorize;
@end

@interface MediaControlsContainerView: UIView
- (MediaControlsTimeControl*)timeControl;
- (MediaControlsTransportStackView*)transportStackView;
@end

@interface MediaControlsParentContainerView: UIView
- (MediaControlsContainerView*)containerView;
@end

@interface MTMaterialView: UIView
- (void)setRecipe:(long long)arg1;
@end

@interface MPArtworkCatalog : NSObject
@end

@interface MediaControlsHeaderView: UIView
@property(nonatomic, retain) UIImageView *artworkView;
@property(nonatomic, retain) MPRouteLabel *routeLabel;
@property(nonatomic, retain) UILabel *primaryLabel;
@property(nonatomic, retain) UILabel *secondaryLabel;
- (MediaControlsRoutingButtonView*)routingButton;
- (MTVisualStylingProvider*)visualStylingProvider;
- (UIView*)shadow;
- (MTMaterialView*)artworkBackground;
- (void)colorize;
- (void)observeValueForKeyPath: (NSString*)keyPath ofObject: (id)object change: (NSDictionary<NSKeyValueChangeKey, id>*)change context: (void*)context;
@end

@interface NextUpMediaHeaderView: MediaControlsHeaderView
- (void)updateTextColor;
@end

@interface MediaControlsRoutingCornerView
- (void)colorize;
@end

@interface MediaControlsMaterialView : UIView
@end

@interface MRPlatterViewController : UIViewController
@property(nonatomic, retain) MediaControlsRoutingCornerView *routingCornerView;
+ (id)coverSheetPlatterViewController;
- (MediaControlsParentContainerView*)parentContainerView;
- (MediaControlsHeaderView*)nowPlayingHeaderView;
- (MediaControlsVolumeContainerView*)volumeContainerView;
- (UIView*)backgroundView;
- (BOOL)isOnScreen;
- (void)colorize;
@end

@interface CCUIContentModuleContentContainerView : UIView
@end
