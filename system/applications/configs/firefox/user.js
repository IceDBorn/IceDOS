user_pref("browser.theme.dark-private-windows", false);
user_pref("gnomeTheme.hideWebrtcIndicator", true);
user_pref("image.jxl.enabled", true); // Enable JPEG XL support
user_pref("media.ffmpeg.vaapi.enabled", true); // Enable VA-API hard accelaration
user_pref("svg.context-properties.content.enabled", true);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("widget.wayland.fractional-scale.enabled", true);

// USELESS OPTIONS FOR REFERENCE
// user_pref("gfx.webrender.all", true); This has been the default since 2021, so no reason to force it here
// user_pref("media.hardware-video-decoding.force-enabled", true); Alias for media.ffmpeg.vaapi.enabled, no need to enable
