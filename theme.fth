�����6J�A_s��!   -�p6�,bG��$@��Q�d   �e��Od]��3D�9C       X   $if(%ispaused%,Paused,Playing) | %codec% | %bitrate% kbps | %samplerate% Hz | %channels%F��OմLH��.�� JI$   %Hq�K��b�%���       �t�o�@����LQ�9;         QiDUN�Y���C�y � q��Wc	�t{W   ��rh�J�#�$�N��~x ���.hx�L�w��H�3�nlj�6�O�7d{�]�&0Ԑ�1��E�v�0���a g �   ���.hx�L�w��H�3�nlj�6�O�7d{�]�&E.  R3 ^  0Ԑ�1��E�v�0���nlj�6�O�7d{�]�&  �'  `  {    #!X�iI@��;ᏴS       toggle �� ,          �����������������  �   ;  �     JScript�  var COLOR_BTNFACE = 15;
var toggle = window.GetProperty("toggle", false);
var ww = 0, wh = 0;
var COLOR_BTNFACE = 15;
var g_syscolor = 0;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
    if(toggle) {
        window.MinWidth = 242;
        window.MaxWidth = 242;
    } else {
        window.MinWidth = 1;
        window.MaxWidth = 1;
    };
    window.MinHeight = 4;
    window.MaxHeight = 4;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_mouse_lbtn_up(x, y) {
    toggle = !toggle;
    window.SetProperty("toggle", toggle);
    if(toggle) {
        window.MinWidth = 242;
        window.MaxWidth = 242;
    } else {
        window.MinWidth = 1;
        window.MaxWidth = 1;
    };
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_notify_data(name, info) {
    switch(name) {
        case "left_pane":
            toggle = !toggle;
            window.SetProperty("toggle", toggle);
            if(toggle) {
                window.MinWidth = 242;
                window.MaxWidth = 242;
            } else {
                window.MinWidth = 1;
                window.MaxWidth = 1;
            };
            break;
    }
}

function on_mouse_rbtn_up(x, y) {
    return true;
} 0Ԑ�1��E�v�0���nlj�6�O�7d{�]�&(  �%  =  {    ���z�I�M%�܅�N       ,          �����������������   �   �       JScript�  var ww = 0, wh = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_mouse_rbtn_up(x, y) {
    return true;
} ���.hx�L�w��H�30Ԑ�1��E�v�0��?#  (  }&  0Ԑ�1��E�v�0�����.hx�L�w��H�3�!    |  {   ��(eG�7O�+ye��u       Gloss Effect ��   Padding       Selection Mode    1 ,          �����������������  �   �       JScriptT!  // ==PREPROCESSOR==
// @name "Simple Cover Art Panel"
// @version "2.0"
// @author "Br3tt"
// @import "%fb2k_profile_path%themes\fooRazor\scripts\WSHcommon.js"
// ==/PREPROCESSOR==

//=================================================// Images
var gloss_img;

//=================================================// Read Options/Properties
// 0 = prefer selection // 1 = prefer Now Playing
var selection_mode = window.GetProperty("Selection Mode", "1");
var show_gloss = window.GetProperty("Gloss Effect", true);
var cover_margin = window.GetProperty("Padding", 4);

// ================================================== Globals
var g_metadb;
var g_path;
var g_track_type;

var g_instancetype = window.InstanceType;
var g_font = null;
var ww = 0, wh = 0;
var g_textcolor = 0, g_textcolor_hl = 0;
var g_backcolor = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;
var mouse_x;
var mouse_y;
var hand;

// cover
var cover_img = null;
var cover_w;
var cover_h;
var is_embedded = false;
var is_art = false;
var is_stream = false;

var nocover_img;
var streamcover_img;

function get_font() {
    if (g_instancetype == 0) { // CUI
        g_font = window.GetFontCUI(FontTypeCUI.items);
    } else if (g_instancetype == 1) { // DUI
        g_font = window.GetFontDUI(FontTypeDUI.defaults);
    } else {
        // None
    }
}
get_font();

function get_colors() {
    if (g_instancetype == 0) { // CUI
        g_textcolor = window.GetColorCUI(ColorTypeCUI.text);
        g_textcolor_hl = window.GetColorCUI(ColorTypeCUI.text);
        g_backcolor = window.GetColorCUI(ColorTypeCUI.background);
    } else if (g_instancetype == 1) { // DUI
        g_textcolor = window.GetColorDUI(ColorTypeDUI.text);
        g_textcolor_hl = window.GetColorDUI(ColorTypeDUI.highlight);
        g_backcolor = window.GetColorDUI(ColorTypeDUI.background);
    } else {
        // None
    }
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

function on_init() {
}
on_init();

function on_size() {
    ww = window.Width;
    wh = window.Height;
    
    window.MaxHeight = ww-cover_margin;
    window.MinHeight = ww-cover_margin;

    cover_w = ww;
    cover_h = wh+cover_margin;

    init_icons();
    on_item_focus_change();
}

function on_paint(gr) {
    // background
    gr.FillSolidRect(0,0,ww,wh,g_syscolor);
    
    var left_padding = cover_margin>2?cover_margin-1:cover_margin;
    
    // draw formatted cover art
    gr.FillSolidRect(left_padding-1, 0-1, cover_w-cover_margin*2+1, cover_h-cover_margin*2+1, RGBA(0,0,0,20));
    gr.FillSolidRect(left_padding+1, 0+1, cover_w-cover_margin*2+1, cover_h-cover_margin*2+1, RGBA(0,0,0,60));
    gr.FillSolidRect(left_padding+1, 0+1, cover_w-cover_margin*2, cover_h-cover_margin*2, RGBA(0,0,0,150));

    if(cover_img) {
        if(is_art) {
            gr.DrawImage(cover_img, left_padding, 0, cover_w, cover_h, 0, 0, cover_w, cover_h, 0, 255);
        } else {
            gr.DrawImage(cover_img, left_padding, 0, cover_w, cover_h, 0, 0, cover_w, cover_h, 0, 255);
        }
        if(show_gloss) {
            gr.DrawImage(gloss_img, left_padding, 0, cover_w, cover_h, 0, 0, cover_w, cover_h, 0, 150);
        }
    }

}

function on_mouse_lbtn_down(x, y) {
}

function on_mouse_lbtn_up(x, y) {
}

function on_mouse_move(x, y) {
}

function on_mouse_leave() {
}

function on_timer(id) {
}

function on_notify_data(name, info) {
}

//=================================================// Playback Callbacks
function on_playback_new_track(info) {  
    on_item_focus_change();
    window.Repaint();
}   

function on_playback_stop(reason) {
    if(reason==0) {
        // on user Stop
        on_item_focus_change();
        window.Repaint();
    }
}

function on_playback_pause(state){
}

function on_playback_time(time) {
}

//=================================================// Events
function on_selection_changed(metadb) {
}

function on_item_focus_change() {
    if(g_metadb) {
        window.UnwatchMetadb();
    }
    if(selection_mode=="1") {
        g_metadb = fb.IsPlaying?fb.GetNowPlaying():fb.PlaylistItemCount(fb.ActivePlaylist)>0?fb.GetFocusItem():false;
    } else {
        g_metadb = fb.PlaylistItemCount(fb.ActivePlaylist)>0?fb.GetFocusItem():(fb.IsPlaying?fb.GetNowPlaying():false);
    }
    if(g_metadb) {
        on_metadb_changed();
        window.WatchMetadb(g_metadb);
    } 
}

function on_metadb_changed() {
    if(g_metadb) {
        g_track_type = TrackType(g_metadb.RawPath.substring(0,4));
        refresh_cover();
    }
    window.Repaint();
}

//=================================================// Callbacks

function on_font_changed() {
    get_font();
    window.Repaint();
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

//=================================================// Tools
function FormatCover(image) {
	if(!image) return image;
    if(cover_w<=0 || cover_h<=0) return image; 
    return image.Resize(cover_w-cover_margin*2,cover_h-cover_margin*2,7);
}

function refresh_cover() {
    var type = 0;
    is_art=false;
    is_stream=false;
	if(g_track_type!=3) {
        is_stream=false;
        if(g_metadb) {
            cover_img = FormatCover(utils.GetAlbumArtEmbedded(g_metadb.rawpath, type));
            if(cover_img) {
                is_art = true
                is_embedded = true;
            } else {
                is_embedded = false;
                cover_img = FormatCover(utils.GetAlbumArtV2(g_metadb, type));
                if(!cover_img) {
                    is_art = false;                   
                    cover_img = FormatCover(nocover_img);
                } else {
                    is_art = true;
                }
            }
        }
	} else if (fb.IsPlaying && fb.PlaybackLength) {
        is_art=false;
		is_stream=true;
        cover_img = FormatCover(streamcover_img);
	} else {
        is_art=false;
		is_stream=false;
        cover_img = FormatCover(nocover_img);
	}
}

function on_drag_enter(action) {
    action.Parsable = false;
}

function on_script_unload() {
}

function on_mouse_rbtn_up(x, y) {
    window.Repaint();
    return true;
}

//=================================================// Init Icons and Images (no_cover ...)
function init_icons() {
    var gb;
    var gui_font;
    
    gloss_img = draw_gloss_effect(cover_w-cover_margin*2,cover_h-cover_margin*2);

    nocover_img = gdi.CreateImage(200, 200);
    gb = nocover_img.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 108, 1);
    gb.DrawString("NO", gui_font, g_textcolor&0x25ffffff, 0, 0, 200, 110, cc_stringformat);
    gui_font = gdi.Font("Segoe UI", 48, 1);
    gb.DrawString("COVER", gui_font, g_textcolor&0x20ffffff, 1, 70, 200, 110, cc_stringformat);
    gb.FillSolidRect(24, 155, 152, 20, g_textcolor&0x15ffffff);
    nocover_img.ReleaseGraphics(gb);

    streamcover_img = gdi.CreateImage(200, 200);
    gb = streamcover_img.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 42, 0);
    gb.DrawString("stream", gui_font, g_backcolor, 1, 2, 200, 190, cc_stringformat);
    gb.DrawString("stream", gui_font, g_textcolor&0x99ffffff, 1, 0, 200, 190, cc_stringformat);
    streamcover_img.ReleaseGraphics(gb);

};

function draw_gloss_effect(w, h) {
    // Mask for glass effect
    if(w<0) return;
    var Mask_img = gdi.CreateImage(w, h);
    var gb = Mask_img.GetGraphics();
    gb.FillSolidRect(0,0,w,h,0xffffffff);
    gb.FillGradRect(0,0,w-20,h,0,0xaa000000,0,1.0);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(-20, 25, w*2+40, h*2, 0xffffffff);
    Mask_img.ReleaseGraphics(gb);
    // drawing the white rect
    var glass_img = gdi.CreateImage(w, h);
    gb = glass_img.GetGraphics();
    gb.FillSolidRect(0, 0, w, h, 0xffffffff);
    glass_img.ReleaseGraphics(gb);
    // resizing and applying the mask
    var Mask = Mask_img.Resize(w, h);
    glass_img.ApplyMask(Mask);
    Mask.Dispose();
    return glass_img;
};
 ���`E�Q��T��Y�y�S@��;[
�Vfe   �   �                     ����   %artist% %album% %title%   Standard                    ����������������      ��������������������������������P   <P>1-All Music
<P>2-Touhou
<P>3-Western
<P>0-Others
<P>4-New
<P>5-Done
<P>6-DAP
    `   ��������`   ��������{    ���z�I�M%�܅�N       ,          �����������������   �   �       JScript�  var ww = 0, wh = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_mouse_rbtn_up(x, y) {
    return true;
} `   ����   `      ����`   �����������.hx�L�w��H�3���.hx�L�w��H�3
%   �  ���.hx�L�w��H�30Ԑ�1��E�v�0��O �� �
  0Ԑ�1��E�v�0��0Ԑ�1��E�v�0��*  �L 5  {    ��XK�>I���ؤӍ�       ,          �����������������   <  -  �     JScript�  var ww = 0, wh = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_mouse_rbtn_up(x, y) {
    return true;
}
 {   NP*��bPL�������@      *USER.background.image.enabled      *USER.background.image.path    .\images\background.jpg   *USER.cover.art.enabled ��$   *USER.cover.art.glass.effect.enabled ��   *USER.cover.glass.effect ��   *USER.cover.keep.aspect.ratio ��   *USER.cover.keep.ratio.aspect ��   *USER.cover.maximum.size ,     *USER.custom.background.color    RGB(10,10,10)!   *USER.custom.text.color.highlight    RGB(150,200,250)   *USER.custom.text.color.normal    RGB(200,200,210)!   *USER.custom.text.color.selection    RGB(64,128,200)   *USER.floor.reflection.percent       *USER.group Key    %album artist%%album%   *USER.group TF text info %   %album artist%[ | %album%][ | %date%]   *USER.group.rows.number       *USER.image.loading    .\images\loading.png   *USER.image.nocover    .\images\nocover.png   *USER.image.stream    .\images\stream.png   *USER.items.gradient.lines   !   *USER.panel.opacity.level [0,255] �      *USER.show.progress.bar      *USER.title-artist.separator    |   *USER.total.tracks.visible ��   ----------------------------    ----------------------------   SYSTEM.columns.bitrate.enabled      SYSTEM.columns.mood.enabled ��    SYSTEM.columns.playcount.enabled ��   SYSTEM.columns.playicon.enabled ��   SYSTEM.columns.rating.enabled ��   SYSTEM.columns.title.pattern    "   SYSTEM.columns.tracknumber.enabled ��   SYSTEM.cover.draw.focus.border ��   SYSTEM.cover.draw.reflection ��   SYSTEM.dragndrop.enabled ��   SYSTEM.group Key !   %album artist%%album%%discnumber%   SYSTEM.group.type        SYSTEM.group_pattern_album !   %album artist%%album%%discnumber%   SYSTEM.group_pattern_artist    %artist%   SYSTEM.group_pattern_path    %directory%   SYSTEM.mousewheel.scrollstep       SYSTEM.no.group.header      SYSTEM.panel.active.playlist       SYSTEM.panel.album.info      SYSTEM.panel.custom.colors      SYSTEM.panel.flat.mode      SYSTEM.panel.lock.playlist      SYSTEM.panel.scroll.effect ��   SYSTEM.panel.themed      SYSTEM.row.height       SYSTEM.scrollbar.themed      SYSTEM.scrollbar.visible      SYSTEM.shadow.border.enabled ��   SYSTEM.side.shadows.visible      SYSTEM.sort_pattern_album U   %album artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%   SYSTEM.sort_pattern_artist O   %artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%   SYSTEM.sort_pattern_date    %date%   SYSTEM.sort_pattern_genre    %genre%   SYSTEM.sort_pattern_path    %path%   SYSTEM.statistics.enabled ��   SYSTEM.toolbar.lock      SYSTEM.vscrollbar.step       SYSTEM.vscrollbar.visible ��   toggle �� ,          ����������������&     $  Y     JScript9�A // ==PREPROCESSOR==
// @name "CoverFlow View"
// @version "1.4.1"
// @author "Br3tt aka Falstaff >> http://br3tt.deviantart.com"
// @feature "v1.4"
// @feature "watch-metadb"
// @feature "dragdrop"
// @import "%fb2k_profile_path%themes\fooRazor\scripts\WSHcommon.js"
// ==/PREPROCESSOR==

// [Requirements]
// * foobar2000 v1.1 or better  >> http://foobar2000.org
// * WSH panel Mod v1.5.2 or better  >> http://code.google.com/p/foo-wsh-panel-mod/downloads/list
// * Optional: Font uni 05_53  >> http://www.dafont.com/uni-05-x.font
//    this font is required to display total tracks info
// [/Requirements]

// [Installation]
// * import/paste this jscript into a WSH Panel Mod instance of your foobar2000 layout (DUI or CUI)
// [/Installation]

// [Informations]
// * change colors and fonts in foobar2000 Preferences > DefaultUI or ColumsUI
// * Some Settings (*USER_xxx ones only) can be changed in window Properties
// * middle click on cover > Send album tracks to specific playlist "CoverFlow View"
// * keyboard keys : left/right arrows, Home/End, page up/down, spacebar to set focus on the centered album, Return key to play ...
// * Type as you Search feature : type artist name with keyboard to automatically set the focus on its first album
// * Think about it >> Adjust size/effects of the panel according to your cpu capacities to avoid bad perf
// [/Informations]

//=================================================// Image declarations
var nocover;
var nocover_img;
var streamcover;
var streamcover_img;
var loading;
var loading_img;
var star_img_off;
var star_img_on;
var star_img_hov;
var star_img_kill;
var toggle_scrollbar;
var menu_button;
var glass_reflect_img;

//=================================================// Cover Tools
image_cache = function () {
    this._cachelist = {};
    this.hit = function (item) {
        var img = this._cachelist[item.metadb.Path];
        if (list.drag_stop && typeof img == "undefined") {
            if(!cover.load_timer) {
                cover.load_timer = window.SetTimeout(function() {
                    utils.GetAlbumArtAsync(window.ID, item.metadb, 0, true, false, false);
                    cover.load_timer && window.ClearTimeout(cover.load_timer);
                    cover.load_timer = false;
                }, 35);
            };
        };
        return img;
    };
    this.getit = function (item, image) {
        var img;
        var quotient = (panel.flat_mode) ? 2 : 12;
        if(cover.keepaspectratio) {
            if(!image) {
                var pw = (cover.w+cover.margin*quotient);
                var ph = (cover.h+cover.margin*quotient);
            } else {
                if(image.Height>=image.Width) {
                    var ratio = image.Width / image.Height;
                    var pw = (cover.w+cover.margin*quotient)*ratio;
                    var ph = (cover.h+cover.margin*quotient);
                } else {
                    var ratio = image.Height / image.Width;
                    var pw = (cover.w+cover.margin*quotient);
                    var ph = (cover.h+cover.margin*quotient)*ratio;
                };
            };
        } else {
            var pw = (cover.w+cover.margin*quotient);
            var ph = (cover.h+cover.margin*quotient);
        };
        // item.cover_type : 0 = nocover, 1 = external cover, 2 = embedded cover, 3 = stream
        if(item.track_type!=3) {
            if(item.metadb) {
                img = FormatCover(image, pw, ph);
                if(!img) {
                    img = nocover_img;
                    item.cover_type = 0;
                } else {
                    item.cover_type = 1;
                };
            };
        } else {
            img = streamcover_img;
            item.cover_type = 3;
        };    
        this._cachelist[item.metadb.Path] = img;
        return img;
    };
};
var g_image_cache = new image_cache;

function FormatCover(image, w, h) {
	if(!image || w<=0 || h<=0) return image;
    if(cover.draw_glass_effect) {
        var new_img = image.Resize(w, h, 2);
        var gb = new_img.GetGraphics();
        if(h>w) {
            gb.DrawImage(glass_reflect_img, Math.floor((h-w)/2)*-1, 0, h, h, 0, 0, glass_reflect_img.Width, glass_reflect_img.Height, 0, 150);
        } else {
            gb.DrawImage(glass_reflect_img, 0, Math.floor((w-h)/2)*-1, w, w, 0, 0, glass_reflect_img.Width, glass_reflect_img.Height, 0, 150);
        };
        new_img.ReleaseGraphics(gb);
        return new_img;
    } else {
        return image.Resize(w, h, 2);
    };
};

function draw_glass_reflect(w, h) {
    // Mask for glass effect
    var Mask_img = gdi.CreateImage(w, h);
    var gb = Mask_img.GetGraphics();
    gb.FillSolidRect(0,0,w,h,0xffffffff);
    gb.FillGradRect(0,0,w-20,h,0,0x99000000,0,1.0);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(-20, 25, w*2+40, h*2, 0xffffffff);
    Mask_img.ReleaseGraphics(gb);
    // drawing the white rect
    var glass_img = gdi.CreateImage(w, h);
    gb = glass_img.GetGraphics();
    gb.FillSolidRect(0, 0, w, h, 0xffffffff);
    glass_img.ReleaseGraphics(gb);
    // resizing and applying the mask
    var Mask = Mask_img.Resize(w, h);
    glass_img.ApplyMask(Mask);
    Mask.Dispose();
    return glass_img;
};

function reset_cover_timers() {
    cover.load_timer && window.ClearTimeout(cover.load_timer);
    cover.load_timer = false;
};

function on_get_album_art_done(metadb, art_id, image, image_path) {
    var len = list.item.length;
    for(var i=0;i<len;i++) {
        if(list.item[i].metadb) {
            if(list.item[i].metadb.Compare(metadb)) {
                list.item[i].cover_img = g_image_cache.getit(list.item[i], image);
                if(list.item[i].show) {
                    if(panel.vertical_mode) {
                        if(!list.item[i].y) list.item[i].y = 5; else if(list.item[i].y<5) list.item[i].y = 5;
                        try{
                            window.RepaintRect(cover.pad_left_mid-10, list.item[i].y-10, ww-cover.pad_left_mid+20, list.item[i].h+20);
                        } catch(e) {};
                    } else {
                        if(!list.item[i].x) list.item[i].x = 5; else if(list.item[i].x<5) list.item[i].x = 5;
                        try{
                            window.RepaintRect(list.item[i].x-10, cover.pad_top_mid-10, list.item[i].w+20, wh-cover.pad_top_mid+20);
                        } catch(e) {};
                    };
                } else {
                    list.item[i].show = true;
                };
                break;
            };
        };
    };
};

//=================================================// Item Object
ItemStates = {normal: 0, hover: 1, selected: 2};
item = function (id, idx, gh_id) {
    var i;
    if (typeof this.id == "undefined") {
        if(id<0) {
            this.id = id;
            this.idx = idx;
            this.gh_id = gh_id;
            this.metadb = false;
            this.albumartist = "";
            this.album = "";
            this.track_type = null;
            this.group_info = "";
        } else {
            this.id = id;
            this.idx = idx;
            this.gh_id = gh_id;
            this.metadb = list.handlelist.Item(this.id);
            if(this.metadb) {
                this.albumartist = tf_albumartist.EvalWithMetadb(this.metadb);
                this.album = tf_album.EvalWithMetadb(this.metadb);
                this.track_type = TrackType(this.metadb.rawpath.substring(0,4));
                this.group_info = tf_group_info.EvalWithMetadb(this.metadb);
                this.group_key = tf_group_key.EvalWithMetadb(this.metadb);
            };
        };
        this.left = 0;
        this.top = 0;
    };

    this.update_infos = function() {
        if(this.metadb) {
            this.albumartist = tf_albumartist.EvalWithMetadb(this.metadb);
            this.track_type = TrackType(this.metadb.rawpath.substring(0,4));
            this.group_info = tf_group_info.EvalWithMetadb(this.metadb);
            this.group_key = tf_group_key.EvalWithMetadb(this.metadb);
        } else {
            this.albumartist = "";
            this.track_type = null;
            this.group_info = "";
        };
    };

    this.draw = function(gr, id, idx, level, show) {
        if(panel.vertical_mode) {
            // --------------
            // VERTICAL MODE
            // --------------
            this.show = show;
            if(panel.flat_mode) {
                this.h = cover.h;
                this.w = cover.h;
                this.x = cover.pad_left_mid;
                this.x += Math.floor(((ww-cover.pad_left_mid-cover.pad_right_mid)-cover.w)/2);
                this.y = Math.floor((wh/2) - (this.h/2) + (cover.margin/2)*0) - (level*this.h);
            } else {
                if(list.mid==idx) {
                    this.h = cover.h;
                    this.w = cover.h;
                    this.x = cover.pad_left_mid;
                    this.x += Math.floor(((ww-cover.pad_left_mid-cover.pad_right_mid)-cover.w)/2);
                    this.y = Math.floor((wh/2) - (cover.h/2));
                } else {
                    this.h = Math.abs(level)==1 ? cover.h - cover.normal_delta*1 : cover.h - cover.normal_delta*2;
                    this.w = this.h;
                    this.y = Math.abs(level)==1 ? Math.floor((wh/2) - (this.h/2)) - (level*(this.h-0010)): Math.floor((wh/2) - (this.h/2)) - (level*this.h);
                    this.x = Math.abs(level)==1 ? cover.pad_left_mid + Math.ceil(cover.normal_delta/2) : cover.pad_left_mid + cover.normal_delta;
                    this.x += Math.floor(((ww-cover.pad_left_mid-cover.pad_right_mid)-cover.w)/2);
                };
            };
            if(panel.scroll_effect) this.y += scroll.delta;
            // cover
            if(this.id>=0) {
                this.cover_img = g_image_cache.hit(this);
                if(typeof(this.cover_img) != "undefined") {
                    // *** check aspect ratio *** //
                    if(this.cover_img.Height>=this.cover_img.Width) {
                        var ratio = this.cover_img.Width / this.cover_img.Height;
                        var pw = this.w*ratio;
                        var ph = this.h;
                        this.left = Math.floor((ph-pw) / 2);
                        this.top = 0;
                        this.x += this.left;
                        this.y += this.top;
                        this.w = this.w - this.left*2 - cover.margin - 1;
                        this.h = this.h - this.top*2 - cover.margin - 1;
                    } else {
                        var ratio = this.cover_img.Height / this.cover_img.Width;
                        var pw = this.w;
                        var ph = this.h*ratio;
                        this.top = Math.floor((pw-ph) / 2);
                        this.left = 0;
                        this.x += this.left;
                        this.y += this.top;
                        this.w = this.w - this.left*2 - cover.margin - 1;
                        this.h = this.h - this.top*2 - cover.margin - 1;
                    };
                    // Draw true Cover
                    gr.DrawImage(this.cover_img, this.x, Math.floor(cover.margin/2)+this.y, this.w, this.h, 0, 0, this.cover_img.Width, this.cover_img.Height, 0, 255);
                    gr.DrawRect(this.x, Math.floor(cover.margin/2)+this.y, this.w-1, this.h-1, 1.0, RGB(90,90,90));
                    gr.DrawRect(this.x, Math.floor(cover.margin/2)+this.y, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                } else {
                    // adjust cover size with margin
                    this.w = this.w - cover.margin - 1;
                    this.h = this.h - cover.margin - 1;
                    // Draw loading Cover
                    gr.DrawImage(loading_img, this.x, Math.floor(cover.margin/2)+this.y, this.w, this.h, 0, 0, loading_img.Width, loading_img.Height, 0, 255);
                    gr.DrawRect(this.x, Math.floor(cover.margin/2)+this.y, this.w-1, this.h-1, 1.0, g_backcolor);
                    gr.DrawRect(this.x, Math.floor(cover.margin/2)+this.y, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                };
                // Draw text item info if flat mode activated
                if(panel.flat_mode && panel.show_text) {
                    var text_y = this.y+this.h+this.top+Math.floor(cover.margin/2);
                    var text_x = cover.pad_left_mid;
                    var text_h = cover.margin;
                    var text_w = ww - cover.pad_left_mid*2 - (scrollbar.show?vscrollbar.w:0);
                    if(list.item[list.mid].id>=0) {
                        try {
                            gr.GdiDrawText(this.album, g_font, g_backcolor, text_x, text_y+1, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.GdiDrawText(this.album, g_font, g_textcolor, text_x, text_y, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        } catch(e) {
                            gr.GdiDrawText(this.album, gdi.Font("tahoma", 11), g_backcolor, text_x, text_y+1, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.GdiDrawText(this.album, gdi.Font("tahoma", 11), g_textcolor, text_x, text_y, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        };
                    };
                };
                // focus item border (selection marker)
                if(typeof(this.cover_img) != "undefined" && this.gh_id == list.selected_gh_id) {
                    list.focus_id_item_idx = this.idx;
                    if(cover.draw_focus_border) {
                        gr.SetSmoothingMode(2);
                        gr.DrawRoundRect(this.x-1, Math.floor(cover.margin/2)+this.y-1, this.w-cover.margin*0+1, this.h-cover.margin*0+2, 2, 2, 3.0, g_backcolor_sel);
                        gr.DrawRoundRect(this.x-2, Math.floor(cover.margin/2)+this.y-2, this.w-cover.margin*0+3, this.h-cover.margin*0+4, 3, 3, 1.0, RGBA(255,255,255,60));
                        gr.SetSmoothingMode(0);
                        gr.DrawRect(this.x+1, Math.floor(cover.margin/2)+this.y+1, this.w-cover.margin*0-3, this.h-cover.margin*0-2, 1.0, g_backcolor_sel);
                        gr.DrawRect(this.x+1, Math.floor(cover.margin/2)+this.y+1, this.w-cover.margin*0-3, this.h-cover.margin*0-2, 1.0, RGBA(0,0,0,40));
                    };
                };
                // total tracks counter
                if(panel.flat_mode) {
                    if(panel.tracks_counter_show) {
                        if(typeof(this.cover_img) != "undefined") {
                            gr.SetSmoothingMode(2);
                            gr.FillRoundRect(this.x-7, Math.floor(cover.margin/2)+this.y-6, 28, 16, 3, 3, RGBA(0,0,0,210));
                            gr.DrawRoundRect(this.x-6, Math.floor(cover.margin/2)+this.y-5, 26, 14, 1, 1, 1.0, RGBA(255,255,255,60));
                            gr.DrawRoundRect(this.x-7, Math.floor(cover.margin/2)+this.y-6, 28, 16, 1, 1, 1.0, RGBA(0,0,0,200));
                            gr.GdiDrawText(list.groups[this.gh_id], mini_font, RGB(250,250,250), this.x-6, Math.floor(cover.margin/2)+this.y-6, 29, 16, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.SetSmoothingMode(0);
                        };
                    };
                };
            };
            this.y = this.y + Math.floor(cover.margin/2);
        } else {
            // ----------------
            // HORIZONTAL MODE
            // ----------------
            this.show = show;
            if(panel.flat_mode) {
                this.w = cover.w;
                this.h = cover.w;
                this.y = cover.pad_top_mid;
                this.y += Math.floor(((wh-cover.pad_top_mid-cover.pad_bot_mid)-cover.h)/2);
                this.x = Math.floor((ww/2) - (this.w/2) + (cover.margin/2)*0) - (level*this.w);                
            } else {
                if(list.mid==idx) {
                    this.w = cover.w;
                    this.h = cover.w;
                    this.y = cover.pad_top_mid;
                    this.y += Math.floor(((wh-cover.pad_top_mid-cover.pad_bot_mid)-cover.h)/2);
                    this.x = Math.floor((ww/2) - (cover.w/2));
                } else {
                    this.w = Math.abs(level)==1 ? cover.w - cover.normal_delta*1 : cover.w - cover.normal_delta*2;
                    this.h = this.w;
                    this.x = Math.abs(level)==1 ? Math.floor((ww/2) - (this.w/2)) - (level*(this.w-0010)): Math.floor((ww/2) - (this.w/2)) - (level*this.w);
                    this.y = Math.abs(level)==1 ? cover.pad_top_mid + Math.ceil(cover.normal_delta/2) : cover.pad_top_mid + cover.normal_delta;
                    this.y += Math.floor(((wh-cover.pad_top_mid-cover.pad_bot_mid)-cover.h)/2);
                };
            };
            if(panel.scroll_effect) this.x += scroll.delta;
            // cover
            if(this.id>=0) {
                this.cover_img = g_image_cache.hit(this);
                if(typeof(this.cover_img)!="undefined") {
                    // *** check aspect ratio *** //
                    if(this.cover_img.Height>=this.cover_img.Width) {
                        var ratio = this.cover_img.Width / this.cover_img.Height;
                        var pw = this.w*ratio;
                        var ph = this.h;
                        this.left = Math.floor((ph-pw) / 2);
                        this.top = 0;
                        this.x += this.left;
                        this.y += this.top*2;
                        this.w = this.w - this.left*2 - cover.margin - 1;
                        this.h = this.h - this.top*2 - cover.margin - 1;
                    } else {
                        var ratio = this.cover_img.Height / this.cover_img.Width;
                        var pw = this.w;
                        var ph = this.h*ratio;
                        this.top = Math.floor((pw-ph) / 2);
                        this.left = 0;
                        this.x += this.left;
                        this.y += this.top*2;
                        this.w = this.w - this.left*2 - cover.margin - 1;
                        this.h = this.h - this.top*2 - cover.margin - 1;
                    };
                    // Draw Reflect (true COVER)
                    var reflect_strength = 255-Math.floor(cover.reflect_strength_percent*2.55);
                    if(cover.draw_reflection && reflect_strength>0 && cover.reflect_strength_percent>0) {
                        gr.DrawImage(this.cover_img, Math.floor(cover.margin/2)+this.x+this.w, this.y + this.h, -1*this.w, this.h, 0, 0, this.cover_img.Width, this.cover_img.Height, 180, 255);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y + this.h+1, this.w-1, this.h-1, 1.0, g_backcolor);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y + this.h+1, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                        // Overlay
                        if(panel.flat_mode) {
                            gr.FillGradRect(Math.floor(cover.margin/2)+this.x-1, this.y + this.h - 10, this.w+2, this.h + 11, 90, RGBA(g_backcolor_R, g_backcolor_G, g_backcolor_B, reflect_strength), g_backcolor, 1.0);
                        } else {
                            gr.FillGradRect(Math.floor(cover.margin/2)+this.x, this.y + this.h - 10, this.w, this.h + 11, 90, RGBA(g_backcolor_R, g_backcolor_G, g_backcolor_B, reflect_strength), g_backcolor, 1.0);
                        };
                    };
                    // Draw true Cover
                    gr.DrawImage(this.cover_img, Math.floor(cover.margin/2)+this.x, this.y, this.w, this.h, 0, 0, this.cover_img.Width, this.cover_img.Height, 0, 255);
                    gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y, this.w-1, this.h-1, 1.0, g_backcolor);
                    gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                } else {
                    // adjust cover size with margin
                    this.w = this.w - cover.margin - 1;
                    this.h = this.h - cover.margin - 1;
                    // Draw Reflect (loading COVER)
                    var reflect_strength = 255-Math.floor(cover.reflect_strength_percent*2.55);
                    if(cover.draw_reflection && reflect_strength>0 && cover.reflect_strength_percent>0) {
                        gr.DrawImage(loading_img, Math.floor(cover.margin/2)+this.x+this.w, this.y + this.h, -1*this.w, this.h, 0, 0, loading_img.Width, loading_img.Height, 180, 255);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y + this.h+1, this.w-1, this.h-1, 1.0, g_backcolor);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y + this.h+1, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                        // Overlay
                        gr.FillGradRect(Math.floor(cover.margin/2)+this.x, this.y + this.h - 10, this.w, this.h + 11, 90, RGBA(g_backcolor_R, g_backcolor_G, g_backcolor_B, reflect_strength), g_backcolor, 1.0);
                    };
                    // Draw loading Cover
                    gr.DrawImage(loading_img, Math.floor(cover.margin/2)+this.x, this.y, this.w, this.h, 0, 0, loading_img.Width, loading_img.Height, 0, 255);
                    gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y, this.w-1, this.h-1, 1.0, g_backcolor);
                    gr.DrawRect(Math.floor(cover.margin/2)+this.x, this.y, this.w-1, this.h-1, 1.0, g_textcolor&0x40ffffff);
                };
                // item info if flat mode activated (tangle effect off)
                if(panel.flat_mode && panel.show_text) {
                    var text_x = this.x + Math.floor(this.w/2) - Math.floor(cover.w/2) + cover.margin;
                    var text_y = wh - cover.pad_bot_mid - cover.margin;
                    var text_w = cover.w - cover.margin;
                    var text_h = (cover.pad_bot_mid + cover.margin) - (scrollbar.show?hscrollbar.h:0);
                    if(list.item[list.mid].id>=0) {
                        try {
                            gr.GdiDrawText(this.album, g_font, g_backcolor, text_x, text_y+1, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.GdiDrawText(this.album, g_font, g_textcolor, text_x, text_y, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        } catch(e) {
                            gr.GdiDrawText(this.album, gdi.Font("tahoma", 11), g_backcolor, text_x, text_y+1, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.GdiDrawText(this.album, gdi.Font("tahoma", 11), g_textcolor, text_x, text_y, text_w, text_h, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        };
                    };
                };
                // focus item border (selection marker)
                if(typeof(this.cover_img) != "undefined" && this.gh_id == list.selected_gh_id) {
                    list.focus_id_item_idx = this.idx;
                    if(cover.draw_focus_border) {
                        gr.SetSmoothingMode(2);
                        gr.DrawRoundRect(Math.floor(cover.margin/2)+this.x-1, this.y-1, this.w-cover.margin*0+1, this.h-cover.margin*0+2, 2, 2, 3.0, g_backcolor_sel);
                        gr.DrawRoundRect(Math.floor(cover.margin/2)+this.x-2, this.y-2, this.w-cover.margin*0+3, this.h-cover.margin*0+4, 3, 3, 1.0, RGBA(255,255,255,60));
                        gr.SetSmoothingMode(0);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x+1, this.y+1, this.w-cover.margin*0-3, this.h-cover.margin*0-2, 1.0, g_backcolor_sel);
                        gr.DrawRect(Math.floor(cover.margin/2)+this.x+1, this.y+1, this.w-cover.margin*0-3, this.h-cover.margin*0-2, 1.0, RGBA(0,0,0,40));
                    };
                };
                // total tracks counter
                if(panel.flat_mode) {
                    if(panel.tracks_counter_show) {
                        if(typeof(this.cover_img) != "undefined") {
                            gr.SetSmoothingMode(2);
                            gr.FillRoundRect(this.x-1, this.y-6, 28, 16, 3, 3, RGBA(0,0,0,210));
                            gr.DrawRoundRect(this.x-0, this.y-5, 26, 14, 1, 1, 1.0, RGBA(255,255,255,60));
                            gr.DrawRoundRect(this.x-1, this.y-6, 28, 16, 1, 1, 1.0, RGBA(0,0,0,200));
                            gr.GdiDrawText(list.groups[this.gh_id], mini_font, RGB(250,250,250), this.x, this.y-6, 29, 16, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                            gr.SetSmoothingMode(0);
                        };
                    };
                };
            };
            this.x = this.x + Math.floor(cover.margin/2);
        };
    };
    
    this.checkstate = function (event, x, y, id) {
        if(y<toolbar.delta) return true;
        if(this.id>=0) {
            this.ishover = (x > this.x && x < this.x + this.w && y >= this.y && y < this.y + this.h);
        } else {
            this.ishover = false;
        };
        switch (event) {
        case "down":
            if(this.id>=0) {
                if(plman.IsPlaylistItemSelected(panel.active_playlist, this.id)) {
                    if(this.ishover) {
                        if(panel.lock_playlist) {
                            this.checkstate("mid", x, y, id);
                        } else {
                            SelectGroupItems(this.id, this.gh_id, true);
                        };
                        if(panel.scroll_effect) {
                          if(this.idx<list.mid) {
                              var tmp = list.mid - this.idx;
                              scrollcoverflow(0, tmp, scroll.factor);
                          } else if(this.idx>list.mid) {
                              var tmp = this.idx - list.mid;
                              scrollcoverflow(tmp, 0, scroll.factor);
                          }
                        }
                        g_saved = this;
                        refresh_spv(panel.active_playlist, bool_on_size);
                    };
                } else {
                    if(this.ishover) {
                        if(utils.IsKeyPressed(VK_SHIFT)) {
                            if(list.focus_id != this.id) {
                                if(list.SHIFT_start_id!=null) {
                                    //SelectAtoB(list.SHIFT_start_id, this.id);
                                } else {
                                    //SelectAtoB(list.focus_id, this.id);
                                };
                            };
                        } else if(utils.IsKeyPressed(VK_CONTROL)) {
                            if(panel.lock_playlist) {
                                this.checkstate("mid", x, y, id);
                            } else {
                                SelectGroupItems(this.id, this.gh_id, true);
                                if(panel.scroll_effect) {
                                  if(this.idx<list.mid) {
                                      var tmp = list.mid - this.idx;
                                      scrollcoverflow(0, tmp, scroll.factor);
                                  } else if(this.idx>list.mid) {
                                      var tmp = this.idx - list.mid;
                                      scrollcoverflow(tmp, 0, scroll.factor);
                                  }
                                }
                            };
                        } else {
                            SelectGroupItems(this.id, this.gh_id, true);
                            if(panel.scroll_effect) {
                              if(this.idx<list.mid) {
                                  var tmp = list.mid - this.idx;
                                  scrollcoverflow(0, tmp, scroll.factor);
                              } else if(this.idx>list.mid) {
                                  var tmp = this.idx - list.mid;
                                  scrollcoverflow(tmp, 0, scroll.factor);
                              }
                            }
                            g_saved = this;
                            if(panel.lock_playlist) {
                                g_saved.checkstate("mid", x, y, id);
                            };
                        };
                    };
                };
            } else {
                g_saved = null;
            };
            break;

        case "dblclk":
            if(this.id>=0 && g_saved!=null) {
                if(plman.IsPlaylistItemSelected(panel.active_playlist, this.id)) {
                    if(panel.lock_playlist) {
                        if(this.id==g_saved.id) {
                            plman.ExecutePlaylistDefaultAction(panel.active_playlist, list.hlist[g_saved.gh_id]);
                            g_saved = null;
                        };
                    } else {
                        if(this.id==g_saved.id) {
                            plman.ExecutePlaylistDefaultAction(panel.active_playlist, list.hlist[g_saved.gh_id]);
                            g_saved = null;
                            window.Repaint();
                        };
                    };
                };
            };
            break;
            
        case "mid":
            if(this.ishover) {
                if(plman.GetPlaylistName(panel.active_playlist)!="CoverFlow View") {
                    SelectGroupItems(this.id, this.gh_id, true);
                    var found = false;
                    var playlist_CF_id = 0;
                    var source_pl = panel.active_playlist;
                    var pl_count = plman.PlaylistCount;
                    for(var i=0; i<pl_count; i++) {
                        if(plman.GetPlaylistName(i)=="CoverFlow View") {
                            found = true;
                            playlist_CF_id = i;
                            break;
                        };
                    };
                    if(!found) {
                        bypass.on_playlists_changed = true;
                        playlist_CF_id = plman.PlaylistCount;
                        plman.CreatePlaylist(plman.PlaylistCount, "CoverFlow View");
                    };
                    plman.ActivePlaylist = playlist_CF_id;
                    fb.ClearPlaylist();
                    var insert_index = fb.PlaylistItemCount(playlist_CF_id);
                    plman.InsertPlaylistItems(playlist_CF_id, insert_index, plman.GetPlaylistSelectedItems(source_pl), false);
                    plman.SetPlaylistFocusItem(playlist_CF_id, 0);
                };
            };
            break;
                        
        case "right":
            if(this.ishover) {
                if(panel.lock_playlist) {
                    list.selected_gh_id = this.gh_id;
                    list.focus_id = this.id;
                    bypass.on_item_focus_change = true;
                    this.checkstate("mid", x, y, id);
                } else {
                    list.selected_gh_id = this.gh_id;
                    list.focus_id = this.id;
                    bypass.on_item_focus_change = true;
                    SelectGroupItems(this.id, this.gh_id, true);
                };
            };
            break;
            
        case "up":

            break;
            
        case "move":

            break;
            
        case "leave":

            break;
        };
        return this.ishover;
    };
};

//=================================================// Titleformat field
var tf_path = fb.TitleFormat("$left(%_path_raw%,4)");
var tf_albumartist = fb.TitleFormat("$if(%length%,%album artist%,'Stream')");
var tf_album = fb.TitleFormat("$if2(%album%,$if(%length%,'Single(s)','web radios'))");
var tf_group_key = fb.TitleFormat(window.GetProperty("*USER.group Key", "%album artist%%album%"));
var tf_group_info = fb.TitleFormat(window.GetProperty("*USER.group TF text info", "%album artist%[ | %album%][ | %date%]"));

//=================================================// Globals
var g_instancetype = window.InstanceType;
var g_font = null;
var g_font_headers = null;
var mini_font = gdi.Font("uni 05_53", 8, 0);
var ww = 0, wh = 0;
var mouse_x = 0, mouse_y = 0;
var g_textcolor = 0, g_textcolor_sel = 0, g_textcolor_hl = 0, g_backcolor = 0, g_backcolor_sel = 0;
var g_syscolor = 0;
var g_syscolor_text = 0;
var COLOR_TEXT = 8;
var COLOR_BTNFACE = 15;
var g_metadb;
var bool_on_size = false;
var g_search_string = "";
var incsearch_font = gdi.Font("lucida console", 9, 0);
var incsearch_font_big = gdi.Font("lucida console", 20, 1);
var clear_incsearch_timer = false;
var incsearch_timer = false;
var incsearch_timer_lock = false;
var g_saved = null;
var hand = false;
var g_menu_displayed = false;
var g_drag = false;
var toggle = window.GetProperty("toggle", false);

bypass = {
    on_item_focus_change: false,
    on_playlists_changed: false
};
panel = {
    max_width: 300,
    max_height: 300,
    arr_buttons: Array(),
    show_text: window.GetProperty("SYSTEM.panel.album.info", true),
    lock_playlist: window.GetProperty("SYSTEM.panel.lock.playlist", false),
    active_playlist: window.GetProperty("SYSTEM.panel.active.playlist", 0),
    vertical_mode: false,
    scroll_effect: window.GetProperty("SYSTEM.panel.scroll.effect", true),
    flat_mode: window.GetProperty("SYSTEM.panel.flat.mode", false),
    custom_textcolor: window.GetProperty("*USER.custom.text.color.normal", "RGB(240,240,240)"),
    custom_textcolor_selection: window.GetProperty("*USER.custom.text.color.selection", "RGB(64,128,250)"),
    custom_backcolor: window.GetProperty("*USER.custom.background.color", "RGB(0,0,0)"),
    custom_colors: window.GetProperty("SYSTEM.panel.custom.colors", false),
    tracks_counter_show: window.GetProperty("*USER.total.tracks.visible", true),
    side_shadows_show: window.GetProperty("SYSTEM.side.shadows.visible", false),
    properties_separator: window.GetProperty("----------------------------", "----------------------------")
};
list = {
    first_launch: true,
    total: 0,
    total_gh: 0,
    start_id: 0,
    nbvis: 0,
    mid: 0,
    item: Array(),
    hlist: Array(),
    groups: Array(),
    handlelist: null,
    metadblist_selection: plman.GetPlaylistSelectedItems(panel.active_playlist),
    focus_id: 0,
    focus_id_item_idx: 0,
    selected_gh_id: 0,
    marker_id: 0, 
    gh_id: 0,
    mousewheel_timer_value: 20,
    key_timer_value: 60,
    nowplaying: 0,
    SHIFT_start_id: null,
    SHIFT_count: 0,
    inc_search_noresult: false,
    nb_cover_to_draw: 0,
    buttonclicked: false,
    drag_stop: true,
    drag_timer: false
};
images = {
    nocover: window.GetProperty("*USER.image.nocover", ".\\images\\nocover.png"),
    stream: window.GetProperty("*USER.image.stream", ".\\images\\stream.png"),
    loading: window.GetProperty("*USER.image.loading", ".\\images\\loading.png")
};
scroll = {
    delta: 0,
    step: 0,
    timerID: false,
    nbcovers: 0,
    direction: 0,
    factor: 2
};
toolbar = {
    h: 0,
    lock: window.GetProperty("SYSTEM.toolbar.lock", false),
    button_total: 3,
    buttons: Array(),
    timerID_on: false,
    timerID_off: false,
    timerID1: false,
    timerID2: false,
    collapsed_y: -24,
    delta: 0,
    step: 3,
    state: false
};
scrollbar = {
    theme: false,
    themed: window.GetProperty("SYSTEM.scrollbar.themed", false),
    show: window.GetProperty("SYSTEM.scrollbar.visible", true),
    visible: true,
    step: 3,
    letter: null,
    button_total: 2,
    arr_buttons: Array(),
    timerID: false
}
hscrollbar = {
    hover: false,
    x: 0,
    y: 0,
    default_h: get_system_scrollbar_height(),
    h: get_system_scrollbar_height(),
    w: 0
};
vscrollbar = {
    hover: false,
    x: 0,
    y: 0,
    default_w: get_system_scrollbar_width(),
    w: get_system_scrollbar_width(),
    h: 0
};
scrollbarbt = {
    timerID1: false,
    timerID2: false,
    timer1_value: 400,
    timer2_value: 60
};
button_up = {
    img_normal: null,
    img_hover: null,
    img_down: null,
    x: 0,
    y: 0,
    w: hscrollbar.default_h,
    h: hscrollbar.default_h
};
button_down = {
    img_normal: null,
    img_hover: null,
    img_down: null,
    x: 0,
    y: 0,
    w: hscrollbar.default_h,
    h: hscrollbar.default_h
};
cursor = {
    bt: null,
    img_normal: null,
    img_hover: null,
    img_down: null,
    popup: null,
    x: 0,
    y: 0,
    w: hscrollbar.default_h,
    h: hscrollbar.default_h,
    default_w: hscrollbar.default_h+3,
    hover: false,
    drag: false,
    grap_x: 0,
    timerID: false,
    last_x: 0
};
cover = {
    margin_default: 2,
    margin: 2,
    max_size: window.GetProperty("*USER.cover.maximum.size", 300),
    keepaspectratio: window.GetProperty("*USER.cover.keep.ratio.aspect", true),
    w: 0,
    h: 0,
    top_offset: 0,
    default_pad_top_mid: 32,
    default_pad_bot_mid: 36,
    pad_top_mid: 32,
    pad_bot_mid: 36,
    default_pad_left_mid: 15,
    default_pad_right_mid: 12,
    pad_left_mid: 15,
    pad_right_mid: 12,
    normal_delta: 20,
    draw_reflection: window.GetProperty("SYSTEM.cover.draw.reflection", true),
    reflect_strength_percent: window.GetProperty("*USER.floor.reflection.percent", 25),
    draw_focus_border: window.GetProperty("SYSTEM.cover.draw.focus.border", true),
    draw_glass_effect: window.GetProperty("*USER.cover.glass.effect", true),
    load_timer: false
};

function scrollcoverflow(from, to, step_factor) {
    var diff = to - from;
    var tmp1, tmp2;
    scroll.nbcovers = Math.abs(diff);
    var tval = Math.round(60/scroll.nbcovers);
    if(tval<40) tval = 40;
    if(panel.flat_mode) {
        scroll.step = Math.floor(cover.w/(scroll.nbcovers==1?step_factor+1:scroll.nbcovers>(panel.flat_mode?2:3)?1:step_factor));
    } else {
        scroll.step = Math.floor((cover.w - cover.normal_delta*2)/(scroll.nbcovers==1?step_factor+1:scroll.nbcovers>(panel.flat_mode?2:3)?1:step_factor));
    };
    if(diff<0) {
        if(list.item[list.mid].gh_id<list.total_gh-1) {
            if(panel.flat_mode) {
                scroll.delta = (cover.w*scroll.nbcovers); // delta > 0
            } else {
                scroll.delta = ((cover.w - cover.normal_delta*2)*scroll.nbcovers); // delta > 0
            };
            tmp1 = scroll.delta;
            for(var j = 0; j < scroll.nbcovers; j++) {
                scrolldown_spv(panel.active_playlist);
            };
            scroll.timerID && window.ClearInterval(scroll.timerID);
            scroll.timerID = window.SetInterval(function() {
                tmp2 = scroll.delta;
                scroll.delta = scroll.delta - scroll.step;
                if(scroll.delta <= 0) {
                   scroll.delta = 0;
                   window.ClearInterval(scroll.timerID);
                   scroll.timerID = false;
                   window.Repaint();
                } else {
                    // pas de repaint au 1er cran de scrolling
                    if(tmp2!=tmp1) window.Repaint();
                };
            }, tval);
        };
    } else {
        if(list.item[list.mid].gh_id>0 ) {
            if(panel.flat_mode) {
                scroll.delta = (cover.w*scroll.nbcovers) * -1; // delta < 0
            } else {
                scroll.delta = ((cover.w - cover.normal_delta*2)*scroll.nbcovers) * -1; // delta < 0
            };
            tmp1 = scroll.delta;
            for(var j = 0; j < scroll.nbcovers; j++) {
                scrollup_spv(panel.active_playlist);
            };
            scroll.timerID && window.ClearInterval(scroll.timerID);
            scroll.timerID = window.SetInterval(function() {
                tmp2 = scroll.delta;
                scroll.delta = scroll.delta + scroll.step;
                if(scroll.delta >= 0) {
                   scroll.delta = 0;
                   window.ClearInterval(scroll.timerID);
                   scroll.timerID = false;
                   window.Repaint();
                } else {
                    // pas de repaint au 1er cran de scrolling
                    if(tmp2!=tmp1) window.Repaint();
                };
            }, tval);
        };
    };
};

function refresh_spv_cursor(pls) {
    if(panel.vertical_mode) {
        var ratio = (cursor.y-vscrollbar.y) / (vscrollbar.h-cursor.h);
    } else {
        var ratio = (cursor.x-hscrollbar.x) / (hscrollbar.w-cursor.w);
    };
    if(ratio>1) ratio = 1;
    if(ratio<0) ratio = 0;
    var r = Math.round(ratio * list.total_gh);
    set_gh_id(pls, list.hlist[r-1]);
    window.Repaint();
}

function set_gh_id(pls, id) {
    reset_cover_timers();
    // RAZ actual list
    list.item.splice(0, list.item.length);
    if(list.total_gh<=0) return true;
    // rech gh idx of the searched item
    list.gh_id = get_gh_id(id);
    if(list.gh_id==null) {
        list.gh_id = 0;
    };
    var r = list.gh_id - list.mid;
    if(r<0) {
        list.start_id = Math.abs(r);
        r = 0;
    } else {
        list.start_id = 0;
    };
    for(var k = 0; k < list.nbvis; k++) {
        if(k>=list.start_id && r<list.total_gh) {
            list.item.push(new item(list.hlist[r] , k, r));
            r++;
        } else {
            list.item.push(new item(-1 , k, -1));
        };
    };
};

function scrollup_spv(pls) {
    var r = list.item[list.mid].gh_id;
    if(r>0) {
        var s = list.item[0].gh_id;
        if(s>0) {
            list.item.unshift(new item(list.hlist[s-1] , 0, s-1));
        } else {
            list.item.unshift(new item(-1 , 0, -1));
        };
        list.item.pop();
    };
    var len = list.item.length;
    for(var i=0; i<len; i++) {
        list.item[i].idx = i;
    };
    setcursorx();
};

function scrolldown_spv(pls) {
    var r = list.item[list.mid].gh_id;
    if(r<list.total_gh-1) {
        var s = list.item[list.item.length-1].gh_id;
        if(s>0 && s<list.total_gh-1) {
            list.item.push(new item(list.hlist[s+1] , 0, s+1));
        } else {
            list.item.push(new item(-1 , 0, -1));
        };
        list.item.shift();
    };
    var len = list.item.length;
    for(var i=0; i<len; i++) {
        list.item[i].idx = i;
    };
    setcursorx();
};

function refresh_spv(pls, force) {
    reset_cover_timers();
    // RAZ actual list
    list.item.splice(0, list.item.length);
    if(list.total_gh<=0) return true;
    // rech gh idx of the focus item
    list.gh_id = get_gh_id(list.focus_id);
    if(list.gh_id==null) {
        init_active_pls();
        return true;
    };
    list.selected_gh_id = list.gh_id;
    var r = list.gh_id - list.mid;
    if(r<0) {
        list.start_id = Math.abs(r);
        r = 0;
    } else {
        list.start_id = 0;
    };
    for(var k = 0; k < list.nbvis; k++) {
        if(k>=list.start_id && r<list.total_gh) {
            list.item.push(new item(list.hlist[r] , k, r));
            r++;
        } else {
            list.item.push(new item(-1 , k, -1));
        };
    };
    if(scrollbar.show) {
        if(list.total_gh<2) scrollbar.visible = false; else scrollbar.visible=true;
    } else {
        scrollbar.visible = false;
    };
    if(panel.vertical_mode) {
        cursor.h = Math.round(vscrollbar.h / list.total_gh);
        // boundaries for cursor height
        if(cursor.h>vscrollbar.h) cursor.h = vscrollbar.h;
        if(cursor.h<cursor.default_w) cursor.h = cursor.default_w;
    } else {
        cursor.w = Math.round(hscrollbar.w / list.total_gh);
        // boundaries for cursor height
        if(cursor.w>hscrollbar.w) cursor.w = hscrollbar.w;
        if(cursor.w<cursor.default_w) cursor.w = cursor.default_w;
    };
    // redraw cursor image
    set_scroller();
    // set cursor position
    setcursorx();
};

function get_gh_id(focus_id) {
    var mid_id = Math.floor(list.total_gh / 2);
    if(focus_id < list.hlist[mid_id]) {
        var start_id = 0;
    } else {
        var start_id = mid_id;
    };
    for(var i = start_id; i < list.total_gh; i++) {
        if(i<list.total_gh-1) {
            if(focus_id >= list.hlist[i] && focus_id < list.hlist[i+1]) {
                return i;
            };
        } else { // we are on the last item of the array
            if(focus_id >= list.hlist[i]) {
                return i;
            } else {
                //fb.trace("error: gh_id not found");
                return null;
            };
        };
    };
};

function setcursorx() {
    if(list.item.length>0) {
        var centered_id = Math.floor(list.item.length/2);
        var centered_gh_id = list.item[centered_id].gh_id;
        var ratio = centered_gh_id / (list.total_gh-1);
        if(panel.vertical_mode) {
            cursor.y = vscrollbar.y + Math.round(ratio * (vscrollbar.h-cursor.h));
        } else {
            cursor.x = hscrollbar.x + Math.round(ratio * (hscrollbar.w-cursor.w));
        };
    } else {
        if(panel.vertical_mode) {
            cursor.y = vscrollbar.y;
        } else {
            cursor.x = hscrollbar.x;
        };
    };
};

function init_active_pls() {
    var temp_key1;
    var temp_key2;
    var metadb = null;
    var count = 0;
    
    //var d1 = new Date();
    //var t1 = d1.getSeconds()*1000 + d1.getMilliseconds();
    //fb.trace("avant="+t1);
      
    list.hlist.splice(0, list.hlist.length);
    list.groups.splice(0, list.groups.length);
    if(list.handlelist) list.handlelist.Dispose();
    list.handlelist = plman.GetPlaylistItems(panel.active_playlist);
    list.total = list.handlelist.Count;
    for (var i = 0; i < list.total; i++) {
        metadb = list.handlelist.Item(i);
        temp_key2 = tf_group_key.EvalWithMetadb(metadb);
        if(temp_key1 != temp_key2){
            if(i>0) {
                list.groups.push(count);
            };
            count = 0;
            list.hlist.push(i);
            temp_key1 = temp_key2;
        };
        count++;
        // on last item
        if(i == list.total - 1) {
            list.groups.push(count);
        };
    };
    list.total_gh = list.hlist.length;

    //var d2 = new Date();
    //var t2 = d2.getSeconds()*1000 + d2.getMilliseconds();
    //fb.trace("old apres="+t2+" ==> delta = "+Math.round(t2-t1)+" // total_gh="+list.total_gh);
};

//=================================================// Colour & Font Callbacks
function on_font_changed() {
    get_font();
    on_playlist_switch();
};

function on_colors_changed() {
    get_colors();   
    init_icons();
    redraw_stub_images();
    init_hscrollbar_buttons();
    set_scroller();
    g_image_cache = new image_cache;
    CollectGarbage();
    on_playlist_switch();
};

//=================================================// Init
function on_init() {
};

//=================================================// OnSize
function on_size() {
    if (!window.Width || !window.Height) return;
    
    window.DlgCode = DLGC_WANTALLKEYS;
    
    bool_on_size = true;
    
    if(g_instancetype == 0) { // CUI
        window.MinWidth = 160;
        window.MinHeight = 160;
    } else if(g_instancetype == 1) { // DUI
        window.MinWidth = 160;
        window.MinHeight = 160;
    };
    ww = window.Width;
    wh = window.Height;
       
    if(ww>wh) {
        panel.vertical_mode = false;
        if(wh<160) wh = 158;
    } else {
        panel.vertical_mode = true;
        if(ww<160) ww = 158;
    };

    if(toggle) {
        window.MaxHeight = panel.max_height;
    } else {
        window.MaxHeight = 1;
    };
    
    // test TF group text, if empty, reset to default
    var temp = window.GetProperty("*USER.group TF text info", "%album artist%[ | %album%][ | %date%]");
    if(temp=="") window.SetProperty("*USER.group TF text info", "%album artist%[ | %album%][ | %date%]");
    tf_group_info = fb.TitleFormat(window.GetProperty("*USER.group TF text info", "%album artist%[ | %album%][ | %date%]"));

    get_font();
    get_colors();
    init_icons();

    recalc_datas();
    redraw_stub_images();
          
    // only on first launch
    if(list.first_launch) {
        list.first_launch = false;
        on_playlist_switch();
    } else {
        // if just a window resize, refresh list.item and repaint :)
        g_image_cache = new image_cache;
        CollectGarbage();
        refresh_spv(panel.active_playlist, true);
    };
    

};

//=================================================// OnPaint
function on_paint(gr) {

    // default background
    gr.FillSolidRect(0, 0, ww, wh, g_backcolor);
    /*
    if(panel.vertical_mode) {
        gr.FillGradRect(0, 0, Math.floor(ww/4), wh, 0, g_textcolor&0x10ffffff, 0, 1.0);
        gr.FillGradRect(ww-Math.floor(ww/4), 0, Math.floor(ww/4), wh, 0, 0, g_textcolor&0x10ffffff, 1.0);
        gr.DrawLine(ww-Math.floor(ww/4), 0, ww-Math.floor(ww/4), wh, 1.0, g_backcolor);
    } else {
        gr.FillGradRect(0, 0, ww, Math.floor(wh/4), 90, g_textcolor&0x10ffffff, 0, 1.0);
    };
    */

    if(list.item.length>0) {
        var cover_show, mid2;
        list.item[list.mid].draw(gr, list.item[list.mid].id, list.mid, 0, true);
        for(var idx = 1; idx < list.mid + 1; idx++) {
            if(idx>1 && idx <= list.mid) {
                cover_show = true;
            } else {
                cover_show = false;
            };
            mid2 = list.mid - idx;
            if(mid2>=0 && mid2<=list.item.length-1) {
                list.item[mid2].draw(gr, list.item[mid2].id, mid2, idx, cover_show);
            };
            mid2 = list.mid + idx;
            if(mid2>=0 && mid2<=list.item.length-1) {
                list.item[mid2].draw(gr, list.item[mid2].id, mid2, idx*-1, cover_show);
            };
        };
        
        // draw final cover in the right order (stack effect)
        mid2 = list.mid - 1;
        if(mid2>=0 && mid2<=list.item.length-1) {
            list.item[mid2].draw(gr, list.item[mid2].id, mid2, 1, true);
        };
        mid2 = list.mid + 1;
        if(mid2>=0 && mid2<=list.item.length-1) {
            list.item[mid2].draw(gr, list.item[mid2].id, mid2, -1, true);
        };
        if(!panel.flat_mode) {
            list.item[list.mid].draw(gr, list.item[list.mid].id, list.mid, 0, true);
        };

        // draw text info on the centered album
        if(!panel.vertical_mode) {
            if(!panel.flat_mode && panel.show_text) {
                var text_x = 10;
                var text_w = ww-20;
                if(list.item[list.mid].id>=0) {
                    try {
                        gr.GdiDrawText(list.item[list.mid].group_info, g_font, g_backcolor, text_x, 2, text_w, cover.pad_top_mid, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(list.item[list.mid].group_info, g_font, g_textcolor, text_x, 1, text_w, cover.pad_top_mid, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    } catch(e) {
                        gr.GdiDrawText(list.item[list.mid].group_info, gdi.Font("tahoma", 11), g_backcolor, text_x, 2, text_w, cover.pad_top_mid, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(list.item[list.mid].group_info, gdi.Font("tahoma", 11), g_textcolor, text_x, 1, text_w, cover.pad_top_mid, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                };
            };
        };
    } else {
        if(fb.PlaylistCount>0) {
            var text_top = fb.GetPlaylistName(fb.ActivePlaylist);
            var text_bot = "This playlist is empty";
        } else {
            var text_top = "Br3tt's WSH CoverFlow";
            var text_bot = "Create a playlist to start!";
        };
        // if empty playlist, display text info
        gr.SetTextRenderingHint(5);
        gr.DrawString(text_top, gdi.Font("Tahoma", 17, 0), g_textcolor&0x40ffffff, 0, -20, ww, wh, cc_stringformat);
        gr.DrawString(text_bot, gdi.Font("Tahoma", 13, 0), g_textcolor&0x40ffffff, 0, 20, ww, wh, cc_stringformat);
        gr.FillGradRect(40, Math.floor(wh/2), ww-80, 1, 0, 0, g_textcolor&0x40ffffff, 0.5);
    
    };
    
    // draw left/right shadows
    if(panel.side_shadows_show) {
        if(!panel.vertical_mode) {
            gr.FillGradRect(-3, 0, 15, wh, 0, g_backcolor, 0, 1.0);
            gr.FillGradRect(ww-12, 0, 16, wh, 0, 0, g_backcolor, 1.0);
        };
    };

    // draw scrollbar
    if(list.total_gh>0 && scrollbar.visible && scrollbar.show) {
        if(panel.vertical_mode) {
            // draw scrollbar background
            try {
                scrollbar.theme.SetPartAndStateId(6, 1);
                scrollbar.theme.DrawThemeBackground(gr, ww-vscrollbar.w, 0, vscrollbar.w, wh);
            } catch(e) {
                gr.FillSolidRect(ww-vscrollbar.w, 0, vscrollbar.w, wh, g_backcolor&0x77ffffff);
                gr.FillSolidRect(ww-vscrollbar.w, 0, 1, wh, RGBA(0,0,0,20));
            };
            
            // draw cursor
            cursor.bt.draw(gr, ww-vscrollbar.w, cursor.y, 255);
            
            try {
                scrollbar.theme.SetPartAndStateId(9, 1);
                scrollbar.theme.DrawThemeBackground(gr, ww-vscrollbar.w, cursor.y, cursor.w, cursor.h);
            } catch(e) {};
            
            // draw scrollbar buttons (up/down)
            for(i=0;i<scrollbar.arr_buttons.length;i++) {
                switch (i) {
                 case 0:
                    scrollbar.arr_buttons[i].draw(gr, ww-vscrollbar.w, button_up.y, 255);
                    break;
                 case 1:
                    scrollbar.arr_buttons[i].draw(gr, ww-vscrollbar.w, button_down.y, 255);
                    break;
                };
            };
            
            if(cursor.drag) {
                scrollbar.letter = list.item[Math.floor(list.nbvis/2)].group_key.substring(0,1).toUpperCase();
                cursor.popup && gr.DrawImage(cursor.popup, ww-vscrollbar.w-cursor.popup.Width-00, cursor.y+Math.floor(cursor.h/2)-Math.floor(cursor.popup.Height/2), cursor.popup.Width, cursor.popup.Height, 0, 0, cursor.popup.Width, cursor.popup.Height, 0, 155);
                cursor.popup && gr.GdiDrawText(scrollbar.letter, gdi.Font("segoe ui", 14, 0), g_backcolor, ww-vscrollbar.w-cursor.popup.Width-00, cursor.y+Math.floor(cursor.h/2)-Math.floor(cursor.popup.Height/2), cursor.popup.Width-5, cursor.popup.Height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            };
        } else {
            
            // draw scrollbar background
            try {
                scrollbar.theme.SetPartAndStateId(4, 1);
                scrollbar.theme.DrawThemeBackground(gr, 0, wh-hscrollbar.h, ww, hscrollbar.h);
                gr.FillSolidRect(0, wh-hscrollbar.h-1, ww, 1, RGBA(0,0,0,10));
            } catch(e) {
                gr.FillSolidRect(0, wh-hscrollbar.h, ww, hscrollbar.h, g_backcolor&0x77ffffff);
                gr.FillSolidRect(0, wh-hscrollbar.h, ww, 1, RGBA(0,0,0,20));
            };
            
            // draw cursor
            try {
                cursor.bt.draw(gr, cursor.x, cursor.y, 255);
            } catch(e) {};
            
            try {
                scrollbar.theme.SetPartAndStateId(8, 1);
                scrollbar.theme.DrawThemeBackground(gr, cursor.x, wh-hscrollbar.h+0, cursor.w, cursor.h);
            } catch(e) {};
            
            // draw scrollbar buttons (up/down)
            for(i=0;i<scrollbar.arr_buttons.length;i++) {
                switch (i) {
                 case 0:
                    scrollbar.arr_buttons[i].draw(gr, button_up.x, button_up.y, 255);
                    break;
                 case 1:
                    scrollbar.arr_buttons[i].draw(gr, button_down.x, button_down.y, 255);
                    break;
                };
            };
            
            if(cursor.drag) {
                scrollbar.letter = list.item[Math.floor(list.nbvis/2)].group_key.substring(0,1).toUpperCase();
                cursor.popup && gr.DrawImage(cursor.popup, cursor.x+Math.floor(cursor.w/2)-Math.floor(cursor.popup.Width/2), wh-hscrollbar.h-cursor.popup.Height, cursor.popup.Width, cursor.popup.Height, 0, 0, cursor.popup.Width, cursor.popup.Height, 0, 155);
                cursor.popup && gr.GdiDrawText(scrollbar.letter, gdi.Font("segoe ui", 14, 0), g_backcolor, cursor.x+Math.floor(cursor.w/2)-Math.floor(cursor.popup.Width/2), wh-hscrollbar.h-cursor.popup.Height, cursor.popup.Width, cursor.popup.Height-5, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            };
        };
    };
       
    // Thin top line (border)
    if(!panel.vertical_mode) {
        //gr.FillGradRect(0, 0, ww, 1, 0, 0, g_textcolor&0x25ffffff, 0.5);
    };

    // Incremental Search Tooltip (bot/left corner)
    if(g_search_string.length>0) {
        gr.SetSmoothingMode(2);
        var tt_x = Math.floor((ww / 2) - ((g_search_string.length*13)+(10*2)) / 2);
        var tt_y = Math.floor(wh/2) - 30;
        var tt_w = ((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        gr.FillRoundRect(tt_x, tt_y, tt_w, tt_h, 5, 5, RGBA(0,0,0,150));
        gr.DrawRoundRect(tt_x, tt_y, tt_w, tt_h, 5, 5, 2.0, RGBA(255,255,255,200));
        gr.DrawRoundRect(tt_x+2, tt_y+2, tt_w-4, tt_h-4, 3, 3, 1.0, RGBA(0,0,0,150));
        gr.GdiDrawText(g_search_string, incsearch_font_big, RGB(0,0,0), tt_x+1, tt_y+1 , tt_w , tt_h, DT_CENTER | DT_NOPREFIX | DT_CALCRECT | DT_VCENTER);
        gr.GdiDrawText(g_search_string, incsearch_font_big, list.inc_search_noresult?RGB(255,75,75):RGB(250,250,250), tt_x, tt_y , tt_w , tt_h, DT_CENTER | DT_NOPREFIX | DT_CALCRECT | DT_VCENTER);
    };
    
    // draw toolbar
    var vscrollbar_w = panel.vertical_mode ? (scrollbar.visible?vscrollbar.w:0) : 0;
    if(!toolbar.state && !toolbar.timerID1) {
        // draw marker to indicate toolbar expandable
        gr.DrawLine(Math.floor((ww-vscrollbar_w)/2)-3, 2, Math.floor((ww-vscrollbar_w)/2)+3, 2, 1.0, g_textcolor&0x44ffffff);
        gr.DrawLine(Math.floor((ww-vscrollbar_w)/2)-2, 3, Math.floor((ww-vscrollbar_w)/2)+0, 5, 1.0, g_textcolor&0x44ffffff);
        gr.DrawLine(Math.floor((ww-vscrollbar_w)/2)+2, 3, Math.floor((ww-vscrollbar_w)/2)+1, 4, 1.0, g_textcolor&0x44ffffff);
    }
    if(toolbar.state || toolbar.timerID1) {
        gr.SetSmoothingMode(2);
        gr.FillRoundRect(09, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar_w-20 + 2, Math.abs(toolbar.collapsed_y) + 10 + 1, 6, 6, RGBA(0,0,0,60));
        gr.FillRoundRect(10, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar_w-20, Math.abs(toolbar.collapsed_y) + 10, 5, 5, RGBA(0,0,0,190));
        gr.DrawRoundRect(11, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar_w-20-2, Math.abs(toolbar.collapsed_y) + 10-1, 4, 4, 1.0, RGBA(250,250,250,40));
        gr.SetSmoothingMode(0);
        // draw toolbar buttons
        for(i=0;i<toolbar.buttons.length;i++) {
            switch (i) {
             case 0:
                if(!panel.lock_playlist) {
                    toolbar.buttons[i].draw(gr, ww-vscrollbar_w-33, (toolbar.collapsed_y + toolbar.delta) + 4, (fb.IsPlaying || list.total_gh>0)?255:80);
                };
                break;
             case 1:
                toolbar.buttons[i].draw(gr, 16, (toolbar.collapsed_y + toolbar.delta) + 3, 255);
                break;
             case 2:
                if(panel.lock_playlist) {
                    toolbar.buttons[i].draw(gr, ww-vscrollbar_w-33, (toolbar.collapsed_y + toolbar.delta) + 4, 255);
                };
                break;
            };
        };
    };

};

//=================================================// Mouse Callbacks
function on_mouse_lbtn_down(x, y) {
    
    g_drag = true;
    
    bool_on_size = false;

    var len = list.item.length;
    var mid2 = 0;
    if(list.total_gh>0) {
        if(!list.item[list.mid].checkstate("down", x, y, list.mid)) {
            for(var i = 1; i < list.mid + 1; i++) {
                mid2 = list.mid - i;
                if(mid2>=0 && mid2<=len-1) {
                    if(list.item[mid2].checkstate("down", x, y, mid2)) {
                        break;
                    };
                };
                mid2 = list.mid + i;
                if(mid2>=0 && mid2<=len-1) {
                    if(list.item[mid2].checkstate("down", x, y, mid2)) {
                        break;
                    };
                };
            };
        };
    };

    if(list.total_gh>0 && scrollbar.visible && scrollbar.show) {
        if(panel.vertical_mode) {
            if(cursor.bt.checkstate("down", x, y)==ButtonStates.down) {
                cursor.drag = true;
                cursor.grap_y = y - cursor.y;
                cursor.last_y = cursor.y;
            };
            if(vscrollbar.hover && !cursor.drag) {
                scrollbar.step = Math.floor(list.nb_cover_to_draw/2);
                if(scrollbar.step<1) scrollbar.step = 1;
                if(y<cursor.y) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_scrolling(scrollbar.step, 1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            on_mouse_wheel(scrollbar.step);
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                if(hscrollbar.hover) {
                                    if(mouse_x>ww-vscrollbar.w && cursor.y > mouse_y) {
                                        on_mouse_wheel(scrollbar.step);
                                    };
                                };
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                } else {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_scrolling(-1*scrollbar.step, 1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            on_mouse_wheel(-1*scrollbar.step);
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                if(hscrollbar.hover) {
                                    if(mouse_x>ww-vscrollbar.w && cursor.y+cursor.h < mouse_y) {
                                        on_mouse_wheel(-1*scrollbar.step);
                                    };
                                };
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                };
            };
        } else {
            if(cursor.bt.checkstate("down", x, y)==ButtonStates.down) {
                cursor.drag = true;
                cursor.grap_x = x - cursor.x;
                cursor.last_x = cursor.x;
            };
            if(hscrollbar.hover && !cursor.drag) {
                scrollbar.step = Math.floor(list.nb_cover_to_draw/2);
                if(scrollbar.step<1) scrollbar.step = 1;
                if(x<cursor.x) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_scrolling(scrollbar.step, 1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            on_mouse_wheel(scrollbar.step);
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                if(hscrollbar.hover) {
                                    if(mouse_y>wh-hscrollbar.h && cursor.x > mouse_x) {
                                        on_mouse_wheel(scrollbar.step);
                                    };
                                };
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                } else {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_scrolling(-1*scrollbar.step, 1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            on_mouse_wheel(-1*scrollbar.step);
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                if(hscrollbar.hover) {
                                    if(mouse_y>wh-hscrollbar.h && cursor.x+cursor.w < mouse_x) {
                                        on_mouse_wheel(-1*scrollbar.step);
                                    };
                                };
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                };
            };
        };
        
        // check scrollbar buttons (UP & DOWN buttons)
        for(i=0;i<scrollbar.arr_buttons.length;i++) {
            switch(i) {
             case 0:
                if(scrollbar.arr_buttons[i].checkstate("down", x, y)==ButtonStates.down) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_mouse_wheel(1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            reset_cover_timers();
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                on_mouse_wheel(1);
                            }, scrollbarbt.timer2_value+10);
                        }, scrollbarbt.timer1_value);
                    };
                };
                break;
             case 1:
                if(scrollbar.arr_buttons[i].checkstate("down", x, y)==ButtonStates.down) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        on_mouse_wheel(-1);
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            reset_cover_timers();
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                on_mouse_wheel(-1);
                            }, scrollbarbt.timer2_value+10);
                        }, scrollbarbt.timer1_value);
                    };
                };
                break;
            };
        };
    };

    // check panel buttons
    for(var i=0;i<toolbar.buttons.length;i++) {
        switch(i) {
            case 0:
                if(!panel.lock_playlist) {
                    if(fb.IsPlaying || list.total_gh>0) {
                        toolbar.buttons[i].checkstate("down", x, y);
                    };
                };
                break;
            default:
                toolbar.buttons[i].checkstate("down", x, y);
        };
    };

};

function on_mouse_lbtn_dblclk(x, y, mask) {
    if(list.total_gh>0) {
        if(panel.vertical_mode) {
            if(x<cover.pad_left_mid) {
                //ShowNowPlaying();
            } else if(x<ww-cover.pad_right_mid) {
                var len = list.item.length;
                for(var i=0;i<len;i++) {
                    list.item[i].checkstate("dblclk", x, y, i);
                };
            } else {
                on_mouse_lbtn_down(x, y);
            };  
        } else {
            if(y<cover.pad_top_mid) {
                //ShowNowPlaying();
            } else if(y<wh-cover.pad_bot_mid) {
                var len = list.item.length;
                for(var i=0;i<len;i++) {
                    if(list.item[i].id>=0) {
                        list.item[i].checkstate("dblclk", x, y, i);
                    };
                };
            } else {
                on_mouse_lbtn_down(x, y);
            };
        };
    };
};

function on_mouse_lbtn_up(x, y) {
    
    // scrollbar button up and down RESET
    list.buttonclicked = false;
    scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
    scrollbar.timerID = false;
    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
    scrollbarbt.timerID1 = false;
    scrollbarbt.timerID2 && window.ClearTimeout(scrollbarbt.timerID2);
    scrollbarbt.timerID2 = false;
    
    if(list.drag_timer) {
        window.ClearTimeout(list.drag_timer);
        list.drag_timer = false;
        list.drag_stop = true;
    }
        
    // check panel buttons
    for(i=0;i<toolbar.buttons.length;i++) {
        switch(i) {
            case 0:
                if(!panel.lock_playlist) {
                    if(fb.IsPlaying || list.total_gh>0) {
                        if(toolbar.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                            ShowNowPlaying();
                        };
                    };
                };
                break;
            case 1:
                if(toolbar.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    g_menu_displayed = true;
                    settings_menu(x, y);
                };
                break;
            case 2:
                if(panel.lock_playlist) {
                    if(toolbar.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                        panel.lock_playlist = false;
                        window.SetProperty("SYSTEM.panel.lock.playlist", panel.lock_playlist);
                        plman.ActivePlaylist = panel.active_playlist;
                    };
                };
                break;
        };
    };
   
    // toolbar collapse if mouse out after a lbtn up
    if(!toolbar.lock) {
        if(y>30 || x<10 || x>ww-vscrollbar.w-10) {
            if(toolbar.delta==0) {
                toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                toolbar.timerID_on = false;
            };
            if(toolbar.state) {
                if(!toolbar.timerID_off) {
                    if(toolbar.delta == toolbar.collapsed_y*-1) {
                        toolbar.timerID_off = window.SetTimeout(function() {
                            if(!toolbar.timerID2) {
                                toolbar.timerID2 = window.SetInterval(function() {
                                    toolbar.delta -= toolbar.step;
                                    if(toolbar.delta <= 0) {
                                        toolbar.delta = 0;
                                        toolbar.state = false;
                                        window.ClearInterval(toolbar.timerID2);
                                        toolbar.timerID2 = false;
                                    };
                                    window.RepaintRect(0, 0, ww, 30);
                                }, 30);
                            } ;
                            toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                            toolbar.timerID_off = false;
                        }, 400);
                    };
                };   
            };
        };
    };
    
    if(list.total_gh>0) {
        
        // check scrollbar buttons
        cursor.bt.checkstate("up", x, y);
        for(var i=0;i<scrollbar.arr_buttons.length;i++) {
            scrollbar.arr_buttons[i].checkstate("up", x, y);
        };
               
        if(cursor.drag) {
            window.RepaintRect(0, wh-hscrollbar.h, ww, hscrollbar.h);
            cursor.drag = false;
        } else {
            // check items
            var len = list.item.length;
            for(i=0;i<len;i++) {
                list.item[i].checkstate("up", x, y, i);
            };
        };
        
        setcursorx();
        
        window.Repaint();
    };
    
    g_drag = false;
};

function on_mouse_mbtn_down(x, y, mask) {
    bool_on_size = false;
    var len = list.item.length;
    if(list.total_gh>0) {
        for(var i=0;i<len;i++) {
            list.item[i].checkstate("mid", x, y, i);
        };
    };
};

function on_mouse_rbtn_down(x, y) {
    bool_on_size = false;
    var len = list.item.length;
    var item_found = false;
    var mid2 = list.mid;

    if(list.total_gh>0) {
        if(list.item[list.mid].checkstate("right", x, y, list.mid)) {
            item_found = true;
        } else {
            for(var i = 1; i < list.mid + 1; i++) {
                mid2 = list.mid - i;
                if(mid2>=0 && mid2<=len-1) {
                    if(list.item[mid2].checkstate("right", x, y, mid2)==true) {
                        item_found = true;
                        break;
                    };
                };
                mid2 = list.mid + i;
                if(mid2>=0 && mid2<=len-1) {
                    if(list.item[mid2].checkstate("right", x, y, mid2)==true) {
                        item_found = true;
                        break;
                    };
                };
            };
        };
        if(item_found) {
            if(y>toolbar.delta) {
                new_context_menu(x, y, list.item[mid2].id, list.item[mid2].idx);
            };
        };
    };
};

function on_mouse_rbtn_up(x, y) {
    if(!utils.IsKeyPressed(VK_SHIFT)) {
        return true;
    };
};

function on_mouse_move(x, y) {
       
    if(x==mouse_x && y==mouse_y) return true;
    
    hand = false;
    
    if(cursor.drag) {
        list.drag_stop = false;
        if(list.drag_timer) {
            window.ClearTimeout(list.drag_timer);
            list.drag_timer = false;
        }
        list.drag_timer = window.SetTimeout(function() {
            list.drag_stop = true;
            window.ClearTimeout(list.drag_timer);
            list.drag_timer = false;
            window.Repaint();
        }, 25);
    } else {
        list.drag_stop = true;
    };
    
    if(list.total_gh>0 && scrollbar.visible && scrollbar.show) {
        if(panel.vertical_mode) {
            vscrollbar.hover = (x>=ww-vscrollbar.w && x<=ww && y>=vscrollbar.y && y<=vscrollbar.y+vscrollbar.h);
            cursor.hover = (x>=cursor.x && x<=cursor.x+cursor.w && y>=cursor.y && y<=cursor.y+cursor.h);
            // check buttons
            cursor.bt.checkstate("move", x, y);
                   
            for(var i=0;i<scrollbar.arr_buttons.length;i++) {
                scrollbar.arr_buttons[i].checkstate("move", x, y);
            };
            if(cursor.drag && mouse_y!=y) {
                reset_cover_timers();
                cursor.y = y - cursor.grap_y;
                // check boundaries
                if(cursor.y<vscrollbar.y) cursor.y = vscrollbar.y;
                if(cursor.y>vscrollbar.y+vscrollbar.h-cursor.h) cursor.y = vscrollbar.y+vscrollbar.h-cursor.h;
                if(!cursor.timerID) {
                    cursor.timerID = window.SetTimeout(function() {
                        refresh_spv_cursor(fb.ActivePlaylist);
                        window.Repaint();
                        cursor.timerID = false;
                    }, 30);
                };
            };
        } else {
            hscrollbar.hover = (y>=wh-hscrollbar.h && y<=wh && x>=hscrollbar.x && x<=hscrollbar.x+hscrollbar.w);
            cursor.hover = (x>=cursor.x && x<=cursor.x+cursor.w && y>=cursor.y && y<=cursor.y+cursor.h);
            // check buttons
            cursor.bt.checkstate("move", x, y);
                   
            for(var i=0;i<scrollbar.arr_buttons.length;i++) {
                scrollbar.arr_buttons[i].checkstate("move", x, y);
            };
            if(cursor.drag && mouse_x!=x) {
                reset_cover_timers();
                cursor.x = x - cursor.grap_x;
                // check boundaries
                if(cursor.x<hscrollbar.x) cursor.x = hscrollbar.x;
                if(cursor.x>hscrollbar.x+hscrollbar.w-cursor.w) cursor.x = hscrollbar.x+hscrollbar.w-cursor.w;
                if(!cursor.timerID) {
                    cursor.timerID = window.SetTimeout(function() {
                        refresh_spv_cursor(panel.active_playlist);
                        window.Repaint();
                        cursor.timerID && window.ClearTimeout(cursor.timerID);
                        cursor.timerID = false;
                    }, 30);
                };
            }; 
        };
    };
    
    // check panel buttons   
    for(var j=0;j<toolbar.buttons.length;j++) {
        switch (j) {
            case 0:
                if(!panel.lock_playlist) {
                    if(fb.IsPlaying || list.total_gh>0) {
                        if(toolbar.buttons[j].checkstate("move", x, y)==ButtonStates.hover) {
                            hand = true;
                        };
                    };
                };
                break;
            case 2:
                if(panel.lock_playlist) {
                    if(toolbar.buttons[j].checkstate("move", x, y)==ButtonStates.hover) {
                        hand = true;
                    };
                };
                break;
            default:
                if(toolbar.buttons[j].checkstate("move", x, y)==ButtonStates.hover) {
                    hand = true;
                };
        };
    };
    
    // hide/show toolbar
    var vscrollbar_w = panel.vertical_mode ? (scrollbar.visible?vscrollbar.w:0) : 0;
    if(!toolbar.lock && !g_drag) {
        if(y>=0 && y<=15 && x>10 && x<ww-vscrollbar_w-10) {
            if(toolbar.delta==toolbar.collapsed_y*-1) {
                toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                toolbar.timerID_off = false;
            };
            if(!toolbar.timerID_on) {
                if(toolbar.delta==0) {
                    toolbar.timerID_on = window.SetTimeout(function() {
                        toolbar.timerID2 && window.ClearInterval(toolbar.timerID2);
                        toolbar.timerID2 = false;
                        if(!toolbar.timerID1) {
                            toolbar.timerID1 = window.SetInterval(function() {
                                toolbar.delta += toolbar.step;
                                if(toolbar.collapsed_y + toolbar.delta >= 0) {
                                    toolbar.delta = toolbar.collapsed_y*-1;
                                    toolbar.state = true;
                                    window.ClearInterval(toolbar.timerID1);
                                    toolbar.timerID1 = false;
                                };
                                window.RepaintRect(0, 0, ww, 30);
                            }, 30);
                        };
                        toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                        toolbar.timerID_on = false;
                    }, 400);
                } else if(toolbar.timerID2) {
                    toolbar.timerID2 && window.ClearInterval(toolbar.timerID2);
                    toolbar.timerID2 = false;
                    if(!toolbar.timerID1) {
                        toolbar.timerID1 = window.SetInterval(function() {
                            toolbar.delta += toolbar.step;
                            if(toolbar.collapsed_y + toolbar.delta >= 0) {
                                toolbar.delta = toolbar.collapsed_y*-1;
                                toolbar.state = true;
                                window.ClearInterval(toolbar.timerID1);
                                toolbar.timerID1 = false;
                            };
                            window.RepaintRect(0, 0, ww, 30);
                        }, 30);
                    };
                };
            };
        } else if(y>30 || x<10 || x>ww-vscrollbar_w-10) {
            if(toolbar.delta==0) {
                toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                toolbar.timerID_on = false;
            };
            if(toolbar.state) {
                if(!toolbar.timerID_off) {
                    if(toolbar.delta == toolbar.collapsed_y*-1) {
                        toolbar.timerID_off = window.SetTimeout(function() {
                            if(!toolbar.timerID2) {
                                toolbar.timerID2 = window.SetInterval(function() {
                                    toolbar.delta -= toolbar.step;
                                    if(toolbar.delta <= 0) {
                                        toolbar.delta = 0;
                                        toolbar.state = false;
                                        window.ClearInterval(toolbar.timerID2);
                                        toolbar.timerID2 = false;
                                    };
                                    window.RepaintRect(0, 0, ww, 30);
                                }, 30);
                            } ;
                            toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                            toolbar.timerID_off = false;
                        }, 400);
                    };
                };   
            };
        };
    };
    
    // Mouse Cursor
    window.SetCursor(hand? IDC_HAND : IDC_ARROW);

    mouse_x = x;
    mouse_y = y;
};

function on_mouse_wheel(delta) {
       
    var abs_delta = Math.abs(delta);
    reset_cover_timers();
    
    if(list.total_gh>0) {
        if(!scrollbar.timerID) {
            if(abs_delta>=1) {
                if(delta>0) {
                    if(panel.scroll_effect) {
                        for(var i=0; i<abs_delta-1; i++) {
                            scrollup_spv(panel.active_playlist);
                        };
                        scrollcoverflow(0, 1, scroll.factor);
                    } else {
                        for(var i=0; i<abs_delta; i++) {
                            scrollup_spv(panel.active_playlist);
                        };
                    };
                    scrollbar.timerID = window.SetTimeout(function () {
                        window.Repaint();
                        scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
                        scrollbar.timerID = false;
                    }, list.mousewheel_timer_value);
                } else {
                    if(panel.scroll_effect) {
                        for(var i=0; i<abs_delta-1; i++) {
                            scrolldown_spv(panel.active_playlist);
                        };
                        scrollcoverflow(1, 0, scroll.factor);
                    } else {
                        for(var i=0; i<abs_delta; i++) {
                            scrolldown_spv(panel.active_playlist);
                        };
                    };
                    scrollbar.timerID = window.SetTimeout(function () {
                        window.Repaint();
                        scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
                        scrollbar.timerID = false;
                    }, list.mousewheel_timer_value);                        
                };
            };
        };
    };
};

function on_scrolling(delta, factor) {
    
    var abs_delta = Math.abs(delta);
    reset_cover_timers();
    
    if(list.total_gh>0) {
        if(!scrollbar.timerID) {
            if(abs_delta>=1) {
                if(delta>0) {
                    if(panel.scroll_effect) {
                        scrollcoverflow(0, abs_delta, factor);
                    } else {
                        for(var i=0; i<abs_delta; i++) {
                            scrollup_spv(panel.active_playlist);
                        };
                        scrollbar.timerID = window.SetTimeout(function () {
                            window.Repaint();
                            scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
                            scrollbar.timerID = false;
                        }, list.mousewheel_timer_value);
                    };
                } else {
                    if(panel.scroll_effect) {
                        scrollcoverflow(abs_delta, 0, factor);
                    } else {
                        for(var i=0; i<abs_delta; i++) {
                            scrolldown_spv(panel.active_playlist);
                        }
                        scrollbar.timerID = window.SetTimeout(function () {
                            window.Repaint();
                            scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
                            scrollbar.timerID = false;
                        }, list.mousewheel_timer_value);                        
                    };
                };
            };
        };
    };
};

function on_mouse_leave() {
    var len = list.item.length;
    if(list.total_gh>0) {
        for(var i=0;i<len;i++) {
            list.item[i].checkstate("leave", 0, 0, i);
        };
    };
    for(i=0;i<toolbar.buttons.length;i++) {
        toolbar.buttons[i].checkstate("leave", 0, 0);
    };

    // toolbar is to hide if visible or amorced
    if(toolbar.delta==0) {
        toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
        toolbar.timerID_on = false;
    };
    if(!toolbar.lock && !g_drag) {
        if(!g_menu_displayed) {
            if(!toolbar.timerID_off) {
                toolbar.timerID_off = window.SetTimeout(function() {
                    if(!toolbar.timerID2) {
                        toolbar.timerID2 = window.SetInterval(function() {
                            toolbar.delta -= toolbar.step;
                            if(toolbar.delta <= 0) {
                                toolbar.delta = 0;
                                toolbar.state = false;
                                window.ClearInterval(toolbar.timerID2);
                                toolbar.timerID2 = false;
                            };
                            window.RepaintRect(0, 0, ww, 30);
                        }, 30);
                    } ;
                    toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                    toolbar.timerID_off = false;
                }, 400);
            };   
        };
    };
    window.Repaint();
};

//=================================================// Callbacks

function on_playlist_switch() {
    // set/check the active playlist for the panel
    if(!panel.lock_playlist) {
        panel.active_playlist = plman.ActivePlaylist;
    };

    // test if there is an active playlist focused (may happen whenyou delete a playlist from pl manager)
    if(plman.ActivePlaylist < 0 || plman.ActivePlaylist > fb.PlaylistCount) {
        if(fb.PlaylistCount>0) {
            plman.ActivePlaylist = 0;
        };
    };
    init_active_pls();
    list.focus_id = plman.GetPlaylistFocusItemIndex(panel.active_playlist);
    if(list.focus_id<0) {
        list.focus_id = 0;
    }
    refresh_spv(panel.active_playlist, true);
    window.Repaint();
};

function on_playlist_items_added(playlist_idx) {
    if(playlist_idx==panel.active_playlist) {
        on_playlist_switch();
    };
    plman.SetActivePlaylistContext();
};

function on_playlist_items_removed(playlist_idx, new_count) {
    if(playlist_idx==panel.active_playlist) {
        on_playlist_switch();
    };
    plman.SetActivePlaylistContext();
};

function on_playlist_items_reordered(playlist_idx) {
    if(playlist_idx==panel.active_playlist) {
        on_playlist_switch();
    };
};

function on_selection_changed(metadb) {
};

function on_playlist_items_selection_change() {
};

function on_playlists_changed() {
    if(bypass.on_playlists_changed) {
        //bypass.on_playlists_changed = false;
        return true;
    } else {
        if(panel.lock_playlist) {
            // unlock on playlist changed because locked playlist may have be moved or deleted
            panel.lock_playlist = !panel.lock_playlist;
            window.SetProperty("SYSTEM.panel.lock.playlist", panel.lock_playlist);
            plman.ActivePlaylist = panel.active_playlist;
            window.Repaint();
        };
    };
};

function on_item_focus_change(playlist, from, to) {
    if(bypass.on_item_focus_change || to<0) {
        bypass.on_item_focus_change = false;
        return true;
    };
    if(playlist==panel.active_playlist) {
        list.focus_id = to;
        plman.SetActivePlaylistContext();
        refresh_spv(panel.active_playlist, bool_on_size);
        bool_on_size = false;
        window.Repaint();
    };
};

function on_metadb_changed(metadb_or_metadbs, fromhook) { 
    var len = list.item.length;
    for(var i=0;i<len;i++) {
        list.item[i].update_infos();
    };
    window.Repaint();
};

function on_focus(is_focused) {
    if(is_focused) {
        plman.SetActivePlaylistContext();
    };
};

//=================================================// Keyboard Callbacks
function on_key_up(vkey) {
    // scrollbar button up and down RESET
    list.buttonclicked = false;
    scrollbar.timerID && window.ClearTimeout(scrollbar.timerID);
    scrollbar.timerID = false;
    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
    scrollbarbt.timerID1 = false;
    scrollbarbt.timerID2 && window.ClearTimeout(scrollbarbt.timerID2);
    scrollbarbt.timerID2 = false;
};

function on_key_down(vkey) {
    var mask = GetKeyboardMask();

    if (mask == KMask.none) {
        switch (vkey) {
        case VK_SHIFT:
            list.SHIFT_count = 0;
            break;
        case VK_BACK:
            if(g_search_string.length>0) {
                var tt_x = Math.floor((ww / 2) - ((g_search_string.length*13)+(10*2)) / 2);
                var tt_y = Math.floor(wh/2) - 30;
                var tt_w = ((g_search_string.length*13)+(10*2));
                var tt_h = 60;
                g_search_string = g_search_string.substring(0, g_search_string.length-1);
                window.RepaintRect(0, tt_y-2, ww, tt_h+4);
                clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
                incsearch_timer && window.ClearTimeout(incsearch_timer);
                incsearch_timer = window.SetTimeout(function () {
                    IncrementalSearch();
                    window.ClearTimeout(incsearch_timer);
                    incsearch_timer = false;
                }, 400);
            };
            break;
        case VK_ESCAPE:
        case 222:
            var tt_x = Math.floor((ww / 2) - ((g_search_string.length*13)+(10*2)) / 2);
            var tt_y = Math.floor(wh/2) - 30;
            var tt_w = ((g_search_string.length*13)+(10*2));
            var tt_h = 60;
            g_search_string = "";
            window.RepaintRect(0, tt_y-2, ww, tt_h+4);
            break;
        case VK_UP:
        case VK_LEFT:
            if(list.total_gh>0) {
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(1);
                    window.Repaint();
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        reset_cover_timers();
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            on_mouse_wheel(1);
                        }, scrollbarbt.timer2_value);
                    }, scrollbarbt.timer1_value);
                };
            };
            break;
        case VK_DOWN:
        case VK_RIGHT:
            if(list.total_gh>0) {
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(-1);
                    window.Repaint();
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        reset_cover_timers();
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            on_mouse_wheel(-1);
                        }, scrollbarbt.timer2_value);
                    }, scrollbarbt.timer1_value);
                };
            };
            break;
        case VK_PGUP:
            if(list.total_gh>0) {
                scrollbar.step = Math.floor(list.nb_cover_to_draw/2);
                if(scrollbar.step<1) scrollbar.step = 1;
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(scrollbar.step);
                    window.Repaint();
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        reset_cover_timers();
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            on_mouse_wheel(scrollbar.step);
                        }, scrollbarbt.timer2_value);
                    }, scrollbarbt.timer1_value);
                };
            };
            break;
        case VK_PGDN:
            if(list.total_gh>0) {
                scrollbar.step = Math.floor(list.nb_cover_to_draw/2);
                if(scrollbar.step<1) scrollbar.step = 1;
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(scrollbar.step*-1);
                    window.Repaint();
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        reset_cover_timers();
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            on_mouse_wheel(scrollbar.step*-1);
                        }, scrollbarbt.timer2_value);
                    }, scrollbarbt.timer1_value);
                };
            };
            break;
        case VK_RETURN:
            // play focus item
            if(list.total_gh>0) {
                plman.ExecutePlaylistDefaultAction(panel.active_playlist, list.focus_id);
            };
            break;
        case VK_END:
            if(list.total_gh>0) {
                plman.SetPlaylistFocusItem(panel.active_playlist, list.total-1);
                plman.ClearPlaylistSelection(panel.active_playlist);
                plman.SetPlaylistSelectionSingle(panel.active_playlist, list.total-1, true);
            };
            break;
        case VK_HOME:
            if(list.total_gh>0) {
                plman.SetPlaylistFocusItem(panel.active_playlist, 0);
                plman.ClearPlaylistSelection(panel.active_playlist);
                plman.SetPlaylistSelectionSingle(panel.active_playlist, 0, true);
            };
            break;
        case VK_DELETE:
            if(list.total_gh>0) {
                if(!fb.IsAutoPlaylist(panel.active_playlist)) {
                    plman.RemovePlaylistSelection(panel.active_playlist, false);
                    plman.SetPlaylistSelectionSingle(panel.active_playlist, plman.GetPlaylistFocusItemIndex(panel.active_playlist), true);
                };
            };
            break;
        case VK_SPACEBAR:
            if(g_search_string.length==0) {
                if(list.total_gh>0) {
                    if(panel.lock_playlist) {
                        plman.SetPlaylistFocusItem(panel.active_playlist, new_focus_id);
                        plman.ClearPlaylistSelection(panel.active_playlist);
                        plman.SetPlaylistSelectionSingle(panel.active_playlist, new_focus_id, true);
                        var mid_idx = Math.floor(list.nbvis/2);
                        list.item[mid_idx].checkstate("mid", list.item[mid_idx].x+5, list.item[mid_idx].y+5, mid_idx);
                    } else {
                        var new_focus_id = list.item[Math.floor(list.nbvis/2)].id;
                        SelectGroupItems(new_focus_id, get_gh_id(new_focus_id), true);
                    };
                };
                break;
            };
        };
    } else {
        switch(mask) {
            case KMask.shift:
                break;
            case KMask.ctrl:
                if(vkey==65) { // CTRL+A
                    fb.RunMainMenuCommand("Edit/Select all");
                    window.Repaint();
                };
                if(vkey==70) { // CTRL+F
                    fb.RunMainMenuCommand("Edit/Search");
                };
                if(vkey==78) { // CTRL+N
                    fb.RunMainMenuCommand("File/New playlist");
                };
                if(vkey==79) { // CTRL+O
                    fb.RunMainMenuCommand("File/Open...");
                };
                if(vkey==80) { // CTRL+P
                    fb.RunMainMenuCommand("File/Preferences");
                };
                if(vkey==83) { // CTRL+S
                    fb.RunMainMenuCommand("File/Save playlist...");
                };
                break;
            case KMask.alt:
                if(vkey==65) { // ALT+A
                    fb.RunMainMenuCommand("View/Always on Top");
                };
                break;
        };
    };
};

function on_char(code) {
    if(list.total_gh>0) {
        var tt_x = Math.floor((ww / 2) - ((g_search_string.length*13)+(10*2)) / 2);
        var tt_y = Math.floor(wh/2) - 30;
        var tt_w = ((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        if(code==32 && g_search_string.length==0) return true; // SPACE Char not allowed on 1st char
        if(g_search_string.length<=20 && tt_w<=ww-50) {
            if (code > 31) {
                g_search_string = g_search_string + String.fromCharCode(code).toUpperCase();
                window.RepaintRect(0, tt_y-2, ww, tt_h+4);
                clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
                clear_incsearch_timer = false;
                incsearch_timer && window.ClearTimeout(incsearch_timer);
                incsearch_timer = window.SetTimeout(function () {
                    IncrementalSearch();
                    window.ClearTimeout(incsearch_timer);
                    incsearch_timer = false;
                }, 400);
            };
        };
    };
};

//=================================================// Playback Callbacks
function on_playback_new_track(info) {
    g_metadb = fb.GetNowPlaying();
    window.Repaint();
};

function on_playback_stop(reason) {
    if(reason==0) { // on user Stop
        g_metadb = fb.GetFocusItem();
        on_metadb_changed();
    };
};

function on_playback_pause(state){
};

function on_playback_time(time) {
};

//=================================================// Font & Colors
function get_font() {
    if (g_instancetype == 0) { // CUI
        g_font = window.GetFontCUI(FontTypeCUI.items);
        g_font_headers = window.GetFontCUI(FontTypeCUI.labels);
    } else if (g_instancetype == 1) { // DUI
        g_font = window.GetFontDUI(FontTypeDUI.playlists);
        g_font_headers = window.GetFontDUI(FontTypeDUI.tabs);
    };
};

function get_colors() {
    if(g_instancetype == 0) { // CUI
        g_textcolor = window.GetColorCUI(ColorTypeCUI.text);
        g_textcolor_sel = window.GetColorCUI(ColorTypeCUI.selection_text);
        g_textcolor_hl = window.GetColorCUI(ColorTypeCUI.active_item_frame);
        g_backcolor = window.GetColorCUI(ColorTypeCUI.background);
        g_backcolor_sel = window.GetColorCUI(ColorTypeCUI.selection_background);
    } else if(g_instancetype == 1) { // DUI
        g_textcolor = window.GetColorDUI(ColorTypeDUI.text);
        g_textcolor_sel = window.GetColorDUI(ColorTypeDUI.selection);
        g_textcolor_hl = window.GetColorDUI(ColorTypeDUI.highlight);
        g_backcolor = window.GetColorDUI(ColorTypeDUI.background);
        g_backcolor_sel = g_textcolor_sel;
    };
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
    g_syscolor_text = utils.GetSysColor(COLOR_TEXT);
    
    // Custom colors set in Properties of the panel
    if(panel.custom_colors) {
        try{
            if(panel.custom_textcolor.length>0) g_textcolor = eval(panel.custom_textcolor);
            if(panel.custom_textcolor_selection.length>0) {
                g_textcolor_sel = eval(panel.custom_textcolor_selection);
                g_backcolor_sel = g_textcolor_sel;
            };
            if(panel.custom_backcolor.length>0) g_backcolor = eval(panel.custom_backcolor);
        } catch(e) {};
    };
    
    //g_backcolor = g_syscolor;
    //g_textcolor = g_syscolor_text;
    
    g_backcolor_R = getRed(g_backcolor);
    g_backcolor_G = getGreen(g_backcolor);
    g_backcolor_B = getBlue(g_backcolor);
};

//=================================================// Images (general)
function set_scroller() {
    var gb;
        
    if(panel.vertical_mode) {
        try {
            cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
        } catch(e) {
            cursor.h = cursor.default_h;
            cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
        };
        
        gb = cursor.img_normal.GetGraphics();
        // Draw Themed Scrollbar (lg/col)
        try {
            scrollbar.theme.SetPartAndStateId(3, 1);
            scrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
        } catch(e) {
            gb.SetSmoothingMode(2);
            gb.FillRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, g_textcolor&0x44ffffff);
            gb.DrawRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, 1.0, g_textcolor&0x44ffffff);
            gb.SetSmoothingMode(0);
        };
        cursor.img_normal.ReleaseGraphics(gb);

        cursor.img_hover = gdi.CreateImage(cursor.w, cursor.h);
        gb = cursor.img_hover.GetGraphics();
        // Draw Themed Scrollbar (lg/col)
        try {
            scrollbar.theme.SetPartAndStateId(3, 2);
            scrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
        } catch(e) {
            gb.SetSmoothingMode(2);
            gb.FillRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, g_textcolor&0x88ffffff);
            gb.DrawRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, 1.0, g_textcolor&0x88ffffff);
            gb.SetSmoothingMode(0);
        };
        cursor.img_hover.ReleaseGraphics(gb);
        cursor.bt = new button(cursor.img_normal, cursor.img_hover, cursor.img_hover);
    } else {
        try {
            cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
        } catch(e) {
            cursor.h = cursor.default_h;
            cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
        };

        gb = cursor.img_normal.GetGraphics();
        // Draw Themed Scrollbar (lg/col)
        try {
            scrollbar.theme.SetPartAndStateId(2, 1);
            scrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
        } catch(e) {
            gb.SetSmoothingMode(2);
            gb.FillRoundRect(0, 3, cursor.w-1, cursor.h-6, 1, 1, g_textcolor&0x44ffffff);
            gb.DrawRoundRect(0, 3, cursor.w-1, cursor.h-6, 1, 1, 1.0, g_textcolor&0x44ffffff);
            gb.SetSmoothingMode(0);
        };
        cursor.img_normal.ReleaseGraphics(gb);

        cursor.img_hover = gdi.CreateImage(cursor.w, cursor.h);
        gb = cursor.img_hover.GetGraphics();
        // Draw Themed Scrollbar (lg/col)
        try {
            scrollbar.theme.SetPartAndStateId(2, 2);
            scrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
        } catch(e) {
            gb.SetSmoothingMode(2);
            gb.FillRoundRect(0, 3, cursor.w-1, cursor.h-6, 1, 1, g_textcolor&0x88ffffff);
            gb.DrawRoundRect(0, 3, cursor.w-1, cursor.h-6, 1, 1, 1.0, g_textcolor&0x88ffffff);
            gb.SetSmoothingMode(0);
        };
        cursor.img_hover.ReleaseGraphics(gb);
        cursor.bt = new button(cursor.img_normal, cursor.img_hover, cursor.img_hover);
    };
};

function init_hscrollbar_buttons() {
    var i, gb;

    cursor.popup = gdi.CreateImage(22, 27);
    gb = cursor.popup.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillRoundRect(0,0,22-1,22-1,3,3,g_textcolor);
    gb.DrawRoundRect(0,0,22-1,22-1,3,3,1.0,RGBA(0,0,0,150));
    var points = Array(7,22-2, 11,22-2+6, 22-7,22-2);
    gb.FillPolygon(g_textcolor, 0, points);
    gb.DrawPolygon(RGBA(0,0,0,150), 1.0, points);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(6,22-4,22-10,3,g_textcolor);
    cursor.popup.ReleaseGraphics(gb);
    
    button_up.img_normal = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 9);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(10, mid_y-4, 6, mid_y+0, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(7, mid_y+0, 10, mid_y+3, 2.0, g_textcolor&0x44ffffff);
    };
    button_up.img_normal.ReleaseGraphics(gb);

    button_up.img_hover = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 10);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(10, mid_y-4, 6, mid_y+0, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(7, mid_y+0, 10, mid_y+3, 2.0, g_textcolor&0x88ffffff);
    };
    button_up.img_hover.ReleaseGraphics(gb);

    button_up.img_down = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 11);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(10, mid_y-4, 6, mid_y+0, 2.0, g_textcolor);
        gb.DrawLine(7, mid_y+0, 10, mid_y+3, 2.0, g_textcolor);
    };
    button_up.img_down.ReleaseGraphics(gb);

    button_down.img_normal = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 13);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(button_down.w-11, mid_y-4, button_down.w-7, mid_y+0, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(button_down.w-8, mid_y+0, button_down.w-11, mid_y+3, 2.0, g_textcolor&0x44ffffff);
    };
    button_down.img_normal.ReleaseGraphics(gb);

    button_down.img_hover = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 14);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(button_down.w-11, mid_y-4, button_down.w-7, mid_y+0, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(button_down.w-8, mid_y+0, button_down.w-11, mid_y+3, 2.0, g_textcolor&0x88ffffff);
    };
    button_down.img_hover.ReleaseGraphics(gb);

    button_down.img_down = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 15);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_y = Math.round(button_up.h/2);
        gb.DrawLine(button_down.w-11, mid_y-4, button_down.w-7, mid_y+0, 2.0, g_textcolor);
        gb.DrawLine(button_down.w-8, mid_y+0, button_down.w-11, mid_y+3, 2.0, g_textcolor);
    };
    button_down.img_down.ReleaseGraphics(gb);

    scrollbar.arr_buttons.splice(0, scrollbar.arr_buttons.length);
    for(i=0;i<scrollbar.button_total;i++) {
        switch(i) {
         case 0:
            scrollbar.arr_buttons.push(new button(button_up.img_normal, button_up.img_hover, button_up.img_down));
            break;
         case 1:
            scrollbar.arr_buttons.push(new button(button_down.img_normal, button_down.img_hover, button_down.img_down));
            break;            
        };
    };
};

function init_vscrollbar_buttons() {
    var i, gb;

    cursor.popup = gdi.CreateImage(27, 22);
    gb = cursor.popup.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillRoundRect(0,0,22-1,22-1,3,3,g_textcolor);
    gb.DrawRoundRect(0,0,22-1,22-1,3,3,1.0,RGBA(0,0,0,150));
    var points = Array(22-2,7, 22-2+6,11, 22-2,22-7);
    gb.FillPolygon(g_textcolor, 0, points);
    gb.DrawPolygon(RGBA(0,0,0,150), 1.0, points);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(22-4,6,3,22-10,g_textcolor);
    cursor.popup.ReleaseGraphics(gb);
    
    button_up.img_normal = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 1);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor&0x44ffffff);
    };
    button_up.img_normal.ReleaseGraphics(gb);

    button_up.img_hover = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 2);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor&0x88ffffff);
    };
    button_up.img_hover.ReleaseGraphics(gb);

    button_up.img_down = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 3);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor);
    };
    button_up.img_down.ReleaseGraphics(gb);

    button_down.img_normal = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 5);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor&0x44ffffff);
    };
    button_down.img_normal.ReleaseGraphics(gb);

    button_down.img_hover = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 6);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor&0x88ffffff);
    };
    button_down.img_hover.ReleaseGraphics(gb);

    button_down.img_down = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        scrollbar.theme.SetPartAndStateId(1, 7);
        scrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor);
    };
    button_down.img_down.ReleaseGraphics(gb);

    scrollbar.arr_buttons.splice(0, scrollbar.arr_buttons.length);
    for(i=0;i<scrollbar.button_total;i++) {
        switch(i) {
         case 0:
            scrollbar.arr_buttons.push(new button(button_up.img_normal, button_up.img_hover, button_up.img_down));
            break;
         case 1:
            scrollbar.arr_buttons.push(new button(button_down.img_normal, button_down.img_hover, button_down.img_down));
            break;            
        };
    };
};

//=================================================// Init Icons and Images (no_cover ...)
function init_icons() {
    var gb;
    var gui_font;
    
    glass_reflect_img = draw_glass_reflect(200, 200);

    nocover = gdi.CreateImage(200, 200);
    gb = nocover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 108, 1);
    gb.DrawString("NO", gui_font, g_textcolor&0x25ffffff, 0, 0, 200, 110, cc_stringformat);
    gui_font = gdi.Font("Segoe UI", 48, 1);
    gb.DrawString("COVER", gui_font, g_textcolor&0x20ffffff, 1, 70, 200, 110, cc_stringformat);
    gb.FillSolidRect(24, 155, 152, 20, g_textcolor&0x15ffffff);
    nocover.ReleaseGraphics(gb);

    streamcover = gdi.CreateImage(200, 200);
    gb = streamcover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 42, 0);
    gb.DrawString("stream", gui_font, g_backcolor, 1, 2, 200, 190, cc_stringformat);
    gb.DrawString("stream", gui_font, g_textcolor&0x99ffffff, 1, 0, 200, 190, cc_stringformat);
    streamcover.ReleaseGraphics(gb);

    loading = gdi.CreateImage(200, 200);
    gb = loading.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 40, 0);
    gb.DrawString("loading...", gui_font, g_backcolor, 1, 2, 200, 190, cc_stringformat);
    gb.DrawString("loading...", gui_font, g_textcolor&0x99ffffff, 1, 0, 200, 190, cc_stringformat);
    loading.ReleaseGraphics(gb);
    
    // Show Now Playing button
    nowplaying_button_normal = gdi.CreateImage(20, 20);
    gb = nowplaying_button_normal.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillEllipse(6, 8, 8, 6, RGB(140,140,140));
    gb.DrawLine(10, 1, 13, 9, 1.0, RGB(140,140,140));
    gb.DrawLine(11, 2, 14, 3, 2.0, RGB(140,140,140));
    gb.DrawLine(14, 3, 15, 5, 1.0, RGB(140,140,140));
    gb.SetSmoothingMode(0);
    nowplaying_button_normal.ReleaseGraphics(gb);
    
    nowplaying_button_hover = gdi.CreateImage(20, 20);
    gb = nowplaying_button_hover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillEllipse(6, 8, 8, 6, RGB(180,180,180));
    gb.DrawLine(10, 1, 13, 9, 1.0, RGB(180,180,180));
    gb.DrawLine(11, 2, 14, 3, 2.0, RGB(180,180,180));
    gb.DrawLine(14, 3, 15, 5, 1.0, RGB(180,180,180));
    gb.SetSmoothingMode(0);
    nowplaying_button_hover.ReleaseGraphics(gb);
    
    nowplaying_button_down = gdi.CreateImage(20, 20);
    gb = nowplaying_button_down.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillEllipse(6, 8, 8, 6, RGB(220,220,220));
    gb.DrawLine(10, 1, 13, 9, 1.0, RGB(220,220,220));
    gb.DrawLine(11, 2, 14, 3, 2.0, RGB(220,220,220));
    gb.DrawLine(14, 3, 15, 5, 1.0, RGB(220,220,220));
    gb.SetSmoothingMode(0);
    nowplaying_button_down.ReleaseGraphics(gb);
        
    // Settings Menu button
    bt_settings_off = gdi.CreateImage(30, 20);
    gb = bt_settings_off.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(150,150,150), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(140,140,140));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,200));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,80));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(140,140,140));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(140,140,140));
    bt_settings_off.ReleaseGraphics(gb);

    bt_settings_ov = gdi.CreateImage(30, 20);
    gb = bt_settings_ov.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(190,190,190), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,220));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,140));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(180,180,180));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(180,180,180));
    bt_settings_ov.ReleaseGraphics(gb);
    
    bt_settings_on = gdi.CreateImage(30, 20);
    gb = bt_settings_on.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(230,230,230), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,240));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,160));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(220,220,220));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(220,220,220));
    bt_settings_on.ReleaseGraphics(gb);
    
    // Lock Playlist button
    lock_button_normal = gdi.CreateImage(20, 20);
    gb = lock_button_normal.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(7, 2, 6, 6, 1.0, RGB(140,140,140));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(6, 7, 9, 6, RGB(140,140,140));
    gb.FillSolidRect(10, 9, 1, 2, RGB(20,20,20));
    lock_button_normal.ReleaseGraphics(gb);
    
    lock_button_hover = gdi.CreateImage(20, 20);
    gb = lock_button_hover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(7, 2, 6, 6, 1.0, RGB(180,180,180));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(6, 7, 9, 6, RGB(180,180,180));
    gb.FillSolidRect(10, 9, 1, 2, RGB(20,20,20));
    lock_button_hover.ReleaseGraphics(gb);
    
    lock_button_down = gdi.CreateImage(20, 20);
    gb = lock_button_down.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(7, 2, 6, 6, 1.0, RGB(220,220,220));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(6, 7, 9, 6, RGB(220,220,220));
    gb.FillSolidRect(10, 9, 1, 2, RGB(20,20,20));
    lock_button_down.ReleaseGraphics(gb);

    toolbar.buttons.splice(0, toolbar.buttons.length);
    for(var i=0;i<toolbar.button_total;i++) {
        switch(i) {
         case 0:
            toolbar.buttons.push(new button(nowplaying_button_normal, nowplaying_button_hover, nowplaying_button_down));
            break;
         case 1:
            toolbar.buttons.push(new button(bt_settings_off, bt_settings_ov, bt_settings_on));
            break;
         case 2:
            toolbar.buttons.push(new button(lock_button_normal, lock_button_hover, lock_button_down));
            break;
        };
    };
};

function recalc_datas() {
    
    if(toolbar.lock) {
        toolbar.delta = toolbar.collapsed_y*-1;
        toolbar.state = true;
    };
    
    if(panel.vertical_mode) {
                
        if(panel.flat_mode) {
            cover.margin = panel.show_text ? 28 : 12;
            if(scrollbar.show) {
                cover.pad_right_mid = cover.default_pad_right_mid - 26 + vscrollbar.default_w;
            } else {
                cover.pad_right_mid = cover.default_pad_right_mid - 26;
            }
        } else {
            cover.margin = cover.margin_default;
            if(scrollbar.show) {
                cover.pad_right_mid = cover.default_pad_right_mid + vscrollbar.default_w;
            } else {
                cover.pad_right_mid = cover.default_pad_right_mid;
            }
        };
        cover.h = ww - cover.pad_left_mid - cover.pad_right_mid;
        if(cover.h>cover.max_size) cover.h = cover.max_size;
        cover.w = cover.h;
        
        if(panel.flat_mode) {
            list.nbvis = Math.floor(wh/(cover.h+cover.margin*0)) + 2 + 20;
            if(list.nbvis/2==Math.floor(list.nbvis/2)) {
                list.nbvis--;
            }
            list.mid = Math.floor(list.nbvis/2);
            list.nb_cover_to_draw = Math.floor(wh/(cover.h+cover.margin*0)) + 2; 
        } else {
            list.nbvis = Math.floor(wh/(cover.h-cover.normal_delta*2)) + 2 + 20;
            if(list.nbvis/2==Math.floor(list.nbvis/2)) {
                list.nbvis--;
            }
            list.mid = Math.floor(list.nbvis/2);
            list.nb_cover_to_draw = Math.floor(wh/(cover.h-cover.normal_delta*2)) + 2;
        };
        
        if(scrollbar.themed) {
            scrollbar.theme = window.CreateThemeManager("scrollbar");
        } else {
            scrollbar.theme = false;
        };
        init_vscrollbar_buttons();
      
        button_up.x = ww - button_up.w;
        button_up.y = 0;
        button_down.x = ww - button_down.w;
        button_down.y = wh - button_down.h;
        vscrollbar.y = button_up.h;
        vscrollbar.h = wh - button_up.h - button_down.h;
        cursor.x = ww-vscrollbar.w;
        cursor.y = vscrollbar.y;
        cursor.w = vscrollbar.w;

    } else {
        
        if(panel.flat_mode) {
            cover.margin = 10;
        } else {
            cover.margin = cover.margin_default;
        };
        
        // mid cover (max size)
        if(scrollbar.show) {
            cover.pad_bot_mid = cover.default_pad_bot_mid - (panel.flat_mode?0:5);
        } else {
            cover.pad_bot_mid = cover.default_pad_bot_mid - hscrollbar.default_h - (panel.flat_mode?0:5);
        }
        if(panel.show_text) {
            cover.pad_top_mid = cover.default_pad_top_mid - (panel.flat_mode?16:0);
        } else {
            cover.pad_top_mid = cover.default_pad_top_mid - 16;
            cover.pad_bot_mid -= (panel.flat_mode?10:0);
        };
        cover.w = wh - cover.pad_top_mid - cover.pad_bot_mid;
        if(cover.w>cover.max_size) cover.w = cover.max_size;
        cover.h = cover.w;
        
        if(panel.flat_mode) {
            list.nbvis = Math.floor(ww/(cover.w+cover.margin*0)) + 2 + 20;
            if(list.nbvis/2==Math.floor(list.nbvis/2)) {
                list.nbvis--;
            }
            list.mid = Math.floor(list.nbvis/2);
            list.nb_cover_to_draw = Math.floor(ww/(cover.w+cover.margin*0)) + 2;
        } else {
            list.nbvis = Math.floor(ww/(cover.w-cover.normal_delta*2)) + 2 + 20;
            if(list.nbvis/2==Math.floor(list.nbvis/2)) {
                list.nbvis--;
            }
            list.mid = Math.floor(list.nbvis/2);
            list.nb_cover_to_draw = Math.floor(ww/(cover.w-cover.normal_delta*2)) + 2;
        };
        
        if(scrollbar.themed) {
            scrollbar.theme = window.CreateThemeManager("scrollbar");
        } else {
            scrollbar.theme = false;
        };
        init_hscrollbar_buttons();
      
        button_up.x = 0;
        button_up.y = wh - hscrollbar.h;
        button_down.x = ww - button_down.w;
        button_down.y = wh - hscrollbar.h;
        hscrollbar.x = button_up.w;
        hscrollbar.w = ww - button_up.w - button_down.w;
        cursor.y = wh - hscrollbar.h;
        cursor.x = hscrollbar.x;
        cursor.h = hscrollbar.h;
    };
};

function redraw_stub_images() {
    if(gdi.Image(images.nocover)) {
        nocover_img = FormatCover(gdi.Image(images.nocover), cover.w, cover.h);
    } else {
        nocover_img = FormatCover(nocover, cover.w, cover.h);
    };
    if(gdi.Image(images.stream)) {
        streamcover_img = FormatCover(gdi.Image(images.stream), cover.w, cover.h);       
    } else {
        streamcover_img = FormatCover(streamcover, cover.w, cover.h);
    };
    if(gdi.Image(images.loading)) {
        loading_img = FormatCover(gdi.Image(images.loading), cover.w, cover.h);
    } else {
        loading_img = FormatCover(loading, cover.w, cover.h);
    };
};

function SelectGroupItems(start_id, start_gh_id, setfocus) {
    var count = 0;
    var affectedItems = Array();
    
    if(!utils.IsKeyPressed(VK_CONTROL)) plman.ClearPlaylistSelection(panel.active_playlist);
    
    if(start_gh_id<list.total_gh-1) {
        var last_id = list.hlist[start_gh_id+1];
    } else {
        var last_id = list.total;
    };
    for(var i = start_id; i < last_id; i++) {
        affectedItems.push(i);
        if(++count>9999) break;
    };
    plman.SetPlaylistSelection(panel.active_playlist, affectedItems, true);
    if(setfocus) {
        plman.SetPlaylistFocusItem(panel.active_playlist, start_id);
    };
    CollectGarbage();
};

function ShowSelected() {
    if(panel.lock_playlist) return true;

    if(plman.PlaylistItemCount(plman.ActivePlaylist)==0 || !fb.GetFocusItem(false)) return true;
    plman.ClearPlaylistSelection(plman.ActivePlaylist);
    var pid = plman.GetPlaylistFocusItemIndex(plman.ActivePlaylist);
    plman.SetPlaylistFocusItem(plman.ActivePlaylist, pid);
    plman.SetPlaylistSelectionSingle(plman.ActivePlaylist, pid, true);
    if(pid>=0 && pid<list.total) {
        refresh_spv(plman.ActivePlaylist, true);
    }; 
};

function ShowNowPlaying() {
    if(panel.lock_playlist) return true;
    if(fb.IsPlaying) {
        if(plman.PlaylistItemCount(plman.PlayingPlaylist)==0) {
            return true;
        };
        plman.ClearPlaylistSelection(plman.PlayingPlaylist);
        list.nowplaying = plman.GetPlayingItemLocation();
        var pid = list.nowplaying.PlaylistItemIndex;
        if(pid>=0 && pid<plman.PlaylistItemCount(plman.PlayingPlaylist)) {
            plman.SetPlaylistFocusItem(plman.PlayingPlaylist, pid);
            plman.SetPlaylistSelectionSingle(plman.PlayingPlaylist, pid, true);
            plman.ActivePlaylist = plman.PlayingPlaylist;
            refresh_spv(plman.PlayingPlaylist, true);
        };
    } else {
        if(plman.PlaylistItemCount(plman.ActivePlaylist)==0 || !fb.GetFocusItem(false)) return true;
        plman.ClearPlaylistSelection(plman.ActivePlaylist);
        var pid = plman.GetPlaylistFocusItemIndex(plman.ActivePlaylist);
        plman.SetPlaylistFocusItem(plman.ActivePlaylist, pid);
        plman.SetPlaylistSelectionSingle(plman.ActivePlaylist, pid, true);
        if(pid>=0 && pid<list.total) {
            refresh_spv(plman.ActivePlaylist, true);
        }; 
    };
};

function ShowSearchedItem(pls, pid) {
    if(list.total==0 || !fb.GetFocusItem(false)) return true;
    if(pid<0) {
        pid = plman.GetPlaylistFocusItemIndex(pls);
    };

    plman.SetPlaylistFocusItem(pls, pid);
    plman.ClearPlaylistSelection(pls);
    plman.SetPlaylistSelectionSingle(pls, pid, true);
    refresh_spv(pls, true);

    if(panel.lock_playlist) {
        incsearch_timer_lock = window.SetTimeout(function() {
            var mid_idx = Math.floor(list.nbvis/2);
            list.item[mid_idx].checkstate("mid", list.item[mid_idx].x+5, list.item[mid_idx].y+5, mid_idx);
            incsearch_timer_lock && window.ClearTimeout(incsearch_timer_lock);
            incsearch_timer_lock = false;
        }, 100);
    };
};

function IncrementalSearch() {
    var count=0;
    var groupkey;
    var chr;
    var gstart;
    var pid = -1;
    var grp_first_item_id;
    
    // exit if no search string in cache
    if(g_search_string.length<=0) return true;
    
    // 1st char of the search string
    var first_chr = g_search_string.substring(0,1);  
    var len = g_search_string.length;
    
    // which start point for the search
    if(list.total_gh>500) {
        grp_first_item_id = list.hlist[Math.floor(list.total_gh/2)];
        groupkey = tf_group_key.EvalWithMetadb(list.handlelist.Item(grp_first_item_id));
        chr = groupkey.substring(0,1);
        if(first_chr.charCodeAt(first_chr) > chr.charCodeAt(chr)) {
            gstart = Math.floor(list.total_gh/2);
        } else {
            gstart = 0;
        };
    } else {
        gstart = 0;
    };
       
    var format_str = "";
    for(var i=gstart;i<list.total_gh;i++) {
        grp_first_item_id = list.hlist[i];
        groupkey = tf_group_key.EvalWithMetadb(list.handlelist.Item(grp_first_item_id));
        format_str = groupkey.substring(0,len).toUpperCase();
        if(format_str==g_search_string) {
            pid = list.hlist[i];
            break;
        };
    };
    
    if(pid>=0) { // found!
        plman.ClearPlaylistSelection(panel.active_playlist);
        ShowSearchedItem(panel.active_playlist, pid);
    } else {
        list.inc_search_noresult = true;
        window.Repaint();
    };
    
    clear_incsearch_timer && window.ClearTimeout(clear_incsearch_timer);
    clear_incsearch_timer = window.SetTimeout(function () {
        // reset incremental search string after 2 seconds without any key pressed
        var tt_x = Math.floor((ww / 2) - ((g_search_string.length*13)+(10*2)) / 2);
        var tt_y = Math.floor(wh/2) - 30;
        var tt_w = ((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        g_search_string = "";
        window.RepaintRect(0, tt_y-2, ww, tt_h+4);
        clear_incsearch_timer && window.ClearTimeout(clear_incsearch_timer);
        clear_incsearch_timer = false;
        list.inc_search_noresult = false;
    }, 1000);
};

//=================================================// Item Context Menu
function new_context_menu(x, y, id, array_id) {
          
    var _menu = window.CreatePopupMenu();
    var Context = fb.CreateContextMenuManager();
    
    var _child01 = window.CreatePopupMenu();
    var _child02 = window.CreatePopupMenu();
    
    list.metadblist_selection = plman.GetPlaylistSelectedItems(panel.active_playlist);
    Context.InitContext(list.metadblist_selection);
    Context.BuildMenu(_menu, 1, -1);

    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    _menu.AppendMenuItem(MF_STRING | MF_POPUP, _child01.ID, "Selection...");

    _child01.AppendMenuItem((fb.IsAutoPlaylist(panel.active_playlist))?MF_DISABLED|MF_GRAYED:MF_STRING, 1000, "Remove");
    _child01.AppendMenuItem(MF_STRING | MF_POPUP, _child02.ID, "Add to...");

    _child02.AppendMenuItem(MF_STRING, 2000, "a New playlist...");
    _child02.AppendMenuItem(MF_SEPARATOR, 0, "");
    var pl_count = fb.PlaylistCount;
    for(var i=0;i<pl_count;i++) {
        if(i!=panel.active_playlist && !fb.IsAutoPlaylist(i)) {
            _child02.AppendMenuItem(MF_STRING, 2001+i, plman.GetPlaylistName(i));
        };
    };

    var ret = _menu.TrackPopupMenu(x, y);
    if(ret<800) {
        Context.ExecuteByID(ret - 1);
    } else if(ret<1000) {
        switch (ret) {
           case 880:

                break;
            case 890:

                break;
        };
    } else {
        switch (ret) {
            case 1000:
                plman.RemovePlaylistSelection(panel.active_playlist, false);
                break;
            case 2000:
                fb.RunMainMenuCommand("File/New playlist");
                plman.InsertPlaylistItems(plman.PlaylistCount-1, 0, list.metadblist_selection, false);
                break;
            default:
                var insert_index = plman.PlaylistItemCount(ret-2001);
                plman.InsertPlaylistItems((ret-2001), insert_index, list.metadblist_selection, false);
        };
    };
};

function settings_menu(x, y) {
    var idx;
    var _menu = window.CreatePopupMenu();
    var _appearance = window.CreatePopupMenu();
    
    var current_pl_name = plman.GetPlaylistName(plman.ActivePlaylist);
    var lock_enabled = (current_pl_name!="CoverFlow View" && list.total_gh>0);
    
    _menu.AppendMenuItem(MF_STRING, 99, "Lock Toolbar");
    _menu.CheckMenuItem(99, toolbar.lock?1:0);
    _menu.AppendMenuItem((lock_enabled || panel.lock_playlist)?MF_STRING:MF_DISABLED|MF_GRAYED, 1, "Lock to Current Playlist");
    _menu.CheckMenuItem(1, panel.lock_playlist?1:0);
    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    _menu.AppendMenuItem(MF_STRING, 5, "CoverFlow Mode");
    _menu.AppendMenuItem(MF_STRING, 6, "Flat Mode");
    _menu.CheckMenuRadioItem(5, 6, panel.flat_mode?6:5);
    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    
    _appearance.AppendTo(_menu, MF_STRING, "Appearance");   
    _appearance.AppendMenuItem(MF_STRING, 2, "Show Scrollbar");
    _appearance.CheckMenuItem(2, scrollbar.show?1:0);
    _appearance.AppendMenuItem(MF_STRING, 3, "Themed Scrollbar Style");
    _appearance.CheckMenuItem(3, scrollbar.themed?1:0);
    _appearance.AppendMenuItem(MF_STRING, 4, "Use Scroll Effect");
    _appearance.CheckMenuItem(4, panel.scroll_effect?1:0);
    _appearance.AppendMenuItem(MF_STRING, 7, "Use Custom Colors");
    _appearance.CheckMenuItem(7, panel.custom_colors?1:0);
    if(!panel.vertical_mode) {
        _appearance.AppendMenuItem(MF_STRING, 8, "Show Album Info");
        _appearance.CheckMenuItem(8, panel.show_text?1:0);
        _appearance.AppendMenuItem(MF_STRING, 9, "Show Floor Reflection");
        _appearance.CheckMenuItem(9, cover.draw_reflection?1:0);
    };
    if(panel.flat_mode) {
        // tracks_counter_show: window.GetProperty("*USER.total.tracks.visible", true),
        _appearance.AppendMenuItem(MF_STRING, 10, "Show Tracks Counter");
        _appearance.CheckMenuItem(10, panel.tracks_counter_show?1:0);
    };
    
    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    _menu.AppendMenuItem((list.total>0)?MF_STRING:MF_DISABLED|MF_GRAYED, 22, "Refresh CoverFlow");
    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    _menu.AppendMenuItem(MF_STRING, 20, "Properties");
    _menu.AppendMenuItem(MF_STRING, 21, "Configure...");
    idx = _menu.TrackPopupMenu(x, y);
    
    switch(idx) {
        case 1:
            if(panel.lock_playlist) {
                // unlock, set ActivePlaylist with locked playlist
                panel.lock_playlist = false;
                window.SetProperty("SYSTEM.panel.lock.playlist", panel.lock_playlist);
                plman.ActivePlaylist = panel.active_playlist;
            } else {
                //ShowSelected();
                //window.Repaint();
                // lock current playlist
                panel.lock_playlist = true;
                window.SetProperty("SYSTEM.panel.lock.playlist", panel.lock_playlist);
                panel.active_playlist = plman.ActivePlaylist;
                window.SetProperty("SYSTEM.panel.active.playlist", panel.active_playlist);
                //
                var mid_idx = Math.floor(list.nbvis/2);
                mid_idx = list.focus_id_item_idx;
                //mid_idx = list.marker_id;
                list.item[mid_idx].checkstate("mid", list.item[mid_idx].x+5, list.item[mid_idx].y+5, mid_idx);
            };
            break;
        case 2:
            if(list.total_gh>=2) {
                scrollbar.show = !scrollbar.show;
                if(scrollbar.show) {
                    scrollbar.visible = true;
                } else {
                    scrollbar.visible = false;
                };
            } else {
                scrollbar.visible = false;
            };
            window.SetProperty("SYSTEM.scrollbar.visible", scrollbar.show);
            //
            recalc_datas();
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            on_playlist_switch();
            break;
        case 3:
            scrollbar.themed = !scrollbar.themed;
            window.SetProperty("SYSTEM.scrollbar.themed", scrollbar.themed);
            if(scrollbar.themed) {
                scrollbar.theme = window.CreateThemeManager("scrollbar");
            } else {
                scrollbar.theme = false;
            };
            if(panel.vertical_mode) {
                init_vscrollbar_buttons();
            } else {
                init_hscrollbar_buttons();
            };
            set_scroller();
            window.Repaint();
            break;
        case 4:
            panel.scroll_effect = !panel.scroll_effect;
            window.SetProperty("SYSTEM.panel.scroll.effect", panel.scroll_effect);
            window.Repaint();
            break;
        case 5:
        case 6:
            panel.flat_mode = !panel.flat_mode;
            window.SetProperty("SYSTEM.panel.flat.mode", panel.flat_mode);
            //
            recalc_datas();
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            on_playlist_switch();
            break;
        case 7:
            panel.custom_colors = !panel.custom_colors;
            window.SetProperty("SYSTEM.panel.custom.colors", panel.custom_colors);
            on_colors_changed();
            break;
        case 8:
            panel.show_text = !panel.show_text;
            window.SetProperty("SYSTEM.panel.album.info", panel.show_text);
            //
            recalc_datas();
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            on_playlist_switch();
            break;
        case 9:
            cover.draw_reflection = !cover.draw_reflection;
            window.SetProperty("SYSTEM.cover.draw.reflection", cover.draw_reflection);
            window.Repaint();
            break;
        case 10:
            panel.tracks_counter_show = !panel.tracks_counter_show;
            window.SetProperty("*USER.total.tracks.visible", panel.tracks_counter_show),
            window.Repaint();
            break;
        case 20:
            window.ShowProperties();
            break;
        case 21:
            window.ShowConfigure();
            break;
        case 22:
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            on_playlist_switch();
            break;
        case 99:
            toolbar.lock = !toolbar.lock;
            window.SetProperty("SYSTEM.toolbar.lock", toolbar.lock);
            break;
        default:

    };
    _appearance.Dispose();
    _menu.Dispose();
    g_menu_displayed = false;
    // toolbar collapse
    if(!toolbar.lock) {
        if(toolbar.delta==0) {
            toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
            toolbar.timerID_on = false;
        };
        if(toolbar.state) {
            if(!toolbar.timerID_off) {
                if(toolbar.delta == toolbar.collapsed_y*-1) {
                    toolbar.timerID_off = window.SetTimeout(function() {
                        if(!toolbar.timerID2) {
                            toolbar.timerID2 = window.SetInterval(function() {
                                toolbar.delta -= toolbar.step;
                                if(toolbar.delta <= 0) {
                                    toolbar.delta = 0;
                                    toolbar.state = false;
                                    window.ClearInterval(toolbar.timerID2);
                                    toolbar.timerID2 = false;
                                };
                                window.RepaintRect(0, 0, ww, 30);
                            }, 30);
                        } ;
                        toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                        toolbar.timerID_off = false;
                    }, 400);
                };
            };   
        };
    };
    return true;
}

//=================================================// Drag'n'Drop Callbacks
var wsh_dragging = false;

function on_drag_enter() {
    wsh_dragging = true;
};

function on_drag_leave() {
    wsh_dragging = false;
};

function on_drag_over(action, x, y, mask) {
    on_mouse_move(x, y);
};

function on_drag_drop(action, x, y, mask) {
    wsh_dragging = false;
    // We are going to process the dropped items to a playlist
    action.ToPlaylist();
    action.Playlist = plman.ActivePlaylist;
    action.ToSelect = false;
};


function on_notify_data(name, info) {
    switch(name) {
        case "coverflow_pane":
            toggle = !toggle;
            window.SetProperty("toggle", toggle);
            if(toggle) {
                window.MinHeight = panel.max_height;
                window.MaxHeight = panel.max_height;
            } else {
                window.MinHeight = 1;
                window.MaxHeight = 1;
            };
            break;
    };
}; `      ����{   �J��Q�5@�lר��D+      *USER.background.image.enabled      *USER.background.image.path    .\images\background.jpg   *USER.cover.art.enabled ��$   *USER.cover.art.glass.effect.enabled ��   *USER.cover.keep.aspect.ratio ��   *USER.custom.background.color    RGB(30,30,35)!   *USER.custom.text.color.highlight    RGB(150,200,250)   *USER.custom.text.color.normal    RGB(200,200,210)!   *USER.custom.text.color.selection    RGB(64,128,200)   *USER.group.rows.number       *USER.items.gradient.lines   !   *USER.panel.opacity.level [0,255] �      *USER.show.progress.bar ��   *USER.title-artist.separator    |   ----------------------------    ----------------------------   SYSTEM.columns.bitrate.enabled      SYSTEM.columns.mood.enabled ��    SYSTEM.columns.playcount.enabled ��   SYSTEM.columns.playicon.enabled ��   SYSTEM.columns.rating.enabled ��   SYSTEM.columns.title.pattern    "   SYSTEM.columns.tracknumber.enabled ��   SYSTEM.dragndrop.enabled ��   SYSTEM.group Key !   %album artist%%album%%discnumber%   SYSTEM.group.type        SYSTEM.group_pattern_album !   %album artist%%album%%discnumber%   SYSTEM.group_pattern_artist    %artist%   SYSTEM.group_pattern_path    %directory%   SYSTEM.mousewheel.scrollstep       SYSTEM.no.group.header      SYSTEM.panel.custom.colors      SYSTEM.panel.themed ��   SYSTEM.row.height       SYSTEM.shadow.border.enabled      SYSTEM.sort_pattern_album U   %album artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%   SYSTEM.sort_pattern_artist O   %artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%   SYSTEM.sort_pattern_date    %date%   SYSTEM.sort_pattern_genre    %genre%   SYSTEM.sort_pattern_path    %path%   SYSTEM.statistics.enabled      SYSTEM.toolbar.lock      SYSTEM.vscrollbar.step       SYSTEM.vscrollbar.visible �� ,          ����������������(  z   z  f     JScript� // ==PREPROCESSOR==
// @name "WSH Playlist Viewer"
// @version "2.0.7"
// @author "Br3tt aka Falstaff >> http://br3tt.deviantart.com"
// @feature "v1.4"
// @feature "watch-metadb"
// @feature "dragdrop"
// @import "%fb2k_profile_path%themes\fooRazor\scripts\WSHcommon.js"
// ==/PREPROCESSOR==

// [Requirements]
// * foobar2000 v1.1 or better  >> http://foobar2000.org
// * WSH panel Mod v1.5.3.1 or better  >> http://code.google.com/p/foo-wsh-panel-mod/downloads/list
// * Optional: Font uni 05_53  >> http://www.dafont.com/uni-05-x.font
//    this font is required to display extra info in group header (codec + genre) and playcount info
// * Optional: Font guifx v2 transports  >> http://blog.guifx.com/2009/04/02/guifx-v2-transport-font
//    this font is required to get nice stars for the rating columns, but if not installed, it will works with standard star (*) character
// [/Requirements]

// [Installation]
// * import/paste this jscript into a WSH Panel Mod instance of your foobar2000 layout (DUI or CUI)
// [/Installation]

// [Informations]
// * Use Jscript9 engine (if supported by your system) for better performances
// * change colors and fonts in foobar2000 Preferences > DefaultUI or ColumsUI
// * Some Settings can be changed in window Properties (Properties from settings menu -> toolbar button)
// * double click on toolbar > Show Now Playing item
// * use keyboard to search artist in the playlist (incremental search feature)
// [/Informations]

//=================================================// Sort pattern used in this panel
var sort_pattern_album = window.GetProperty("SYSTEM.sort_pattern_album", "%album artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%");
var sort_pattern_artist = window.GetProperty("SYSTEM.sort_pattern_artist", "%artist%|$if(%album%,$if2(%date%,9999),0000)|%album%|%discnumber%|%tracknumber%");
var sort_pattern_path = window.GetProperty("SYSTEM.sort_pattern_path", "%path%");
var sort_pattern_date = window.GetProperty("SYSTEM.sort_pattern_date", "%date%");
var sort_pattern_genre = window.GetProperty("SYSTEM.sort_pattern_genre", "%genre%");

//=================================================// Group pattern used in this panel
var group_pattern_album = window.GetProperty("SYSTEM.group_pattern_album", "%album artist%%album%%discnumber%");
var group_pattern_artist = window.GetProperty("SYSTEM.group_pattern_artist", "%artist%");
var group_pattern_path = window.GetProperty("SYSTEM.group_pattern_path", "%directory%");

//=================================================// Image declarations
var playicon_off;
var playicon_on;
var nocover;
var nocover_img;
var noartist;
var noartist_img;
var streamcover;
var streamcover_img;
var glass_reflect_img;
var icon_arrow_left;
var singleline_group_header_icon;
var bt_settings_off;
var bt_settings_ov;
var bt_settings_on;
var bt_sort_off;
var bt_sort_ov;
var bt_sort_on;

function on_get_album_art_done(metadb, art_id, image, image_path) {
    var draw_limit = list.tocut+list.nbvis+group.nbrows+1;
    if(draw_limit>list.item.length) draw_limit = list.item.length;
    for(var i=list.tocut;i<draw_limit;i++) {
        if(list.item[i].metadb && list.item[i].gridx==group.nbrows) {
            if(list.item[i].metadb.Compare(metadb)) {
                list.item[i].cover_img = g_image_cache.getit(list.item[i], image);
                var cx = list.item[i].x + cover.margin;
                var cy = list.item[i].y - ((group.nbrows-1)*row.h);
                cx = cover.margin;
                cy = list.item[i].y - ((group.nbrows-1)*row.h);
                // fix for a weird behaviour with engine Jscript9
                if(!cx) cx = 2; else if(cx<2) cx = 2;
                if(!cy) cy = 2; else if(cy<2) cy = 2;
                window.RepaintRect(cx-2, cy-2, group.nbrows*row.h, group.nbrows*row.h);
                break;
            };
        };
    };
};

//=================================================// Cover Tools
image_cache = function () {
    this._cachelist = {};
    this.hit = function (item) {
        var img = this._cachelist[item.metadb.Path];
        if (typeof img == "undefined") {
            if(!cover.load_timer) {
                cover.load_timer = window.SetTimeout(function() {
                    switch(group.type){
                        case 0:
                            var art_id = AlbumArtId.front;
                            break;
                        case 1:
                            var art_id = AlbumArtId.artist;
                            break;
                        case 2:
                            var art_id = AlbumArtId.front;
                            break;
                    };
                    utils.GetAlbumArtAsync(window.ID, item.metadb, art_id, true, false, false);
                    cover.load_timer && window.ClearTimeout(cover.load_timer);
                    cover.load_timer = false;
                }, 35);
            };
        };
        return img;
    };
    this.getit = function (item, image, image_path) {
        var img;
        if(cover.keepaspectratio) {
            if(!image) {
                var pw = (cover.w-cover.margin*2);
                var ph = (cover.h-cover.margin*2);
            } else {
                if(image.Height>=image.Width) {
                    var ratio = image.Width / image.Height;
                    var pw = (cover.w-cover.margin*2)*ratio;
                    var ph = (cover.h-cover.margin*2);
                } else {
                    var ratio = image.Height / image.Width;
                    var pw = (cover.w-cover.margin*2);
                    var ph = (cover.h-cover.margin*2)*ratio;
                };
            };
        } else {
            var pw = cover.w-cover.margin*2;
            var ph = cover.h-cover.margin*2;
        };
        // item.cover_type : 0 = nocover, 1 = external cover, 2 = embedded cover, 3 = stream
        if(item.track_type!=3) {
            if(item.metadb) {
                img = FormatCover(image, pw, ph);
                if(!img) {
                    img = (group.type==1)?noartist_img:nocover_img;
                    item.cover_type = 0;
                } else {
                    item.cover_type = 1;
                };
            };
        } else {
            img = streamcover_img;
            item.cover_type = 3;
        };   
        this._cachelist[item.metadb.Path] = img;
        return img;
    };
};
var g_image_cache = new image_cache;

function FormatCover(image, w, h) {
	if(!image || w<=0 || h<=0) return image;
    if(cover.draw_glass_effect) {
        var new_img = image.Resize(w, h, 2);
        var gb = new_img.GetGraphics();
        if(h>w) {
            gb.DrawImage(glass_reflect_img, Math.floor((h-w)/2)*-1+1, 1, h-2, h-2, 0, 0, glass_reflect_img.Width, glass_reflect_img.Height, 0, 150);
        } else {
            gb.DrawImage(glass_reflect_img, 1, Math.floor((w-h)/2)*-1+1, w-2, w-2, 0, 0, glass_reflect_img.Width, glass_reflect_img.Height, 0, 150);
        };
        new_img.ReleaseGraphics(gb);
        return new_img;
    } else {
        return image.Resize(w, h, 2);
    };
};

function FormatWP(image, w, h) {
	if(!image || w<=0 || h<=0) return image;
    return image.Resize(w, h, 2);
};

function draw_glass_reflect(w, h) {
    // Mask for glass effect
    var Mask_img = gdi.CreateImage(w, h);
    var gb = Mask_img.GetGraphics();
    gb.FillSolidRect(0,0,w,h,0xffffffff);
    gb.FillGradRect(0,0,w-20,h,0,0xaa000000,0,1.0);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(-20, 25, w*2+40, h*2, 0xffffffff);
    Mask_img.ReleaseGraphics(gb);
    // drawing the white rect
    var glass_img = gdi.CreateImage(w, h);
    gb = glass_img.GetGraphics();
    gb.FillSolidRect(0, 0, w, h, 0xffffffff);
    glass_img.ReleaseGraphics(gb);
    // resizing and applying the mask
    var Mask = Mask_img.Resize(w, h);
    glass_img.ApplyMask(Mask);
    Mask.Dispose();
    return glass_img;
};

function reset_cover_timers() {
    cover.load_timer && window.ClearTimeout(cover.load_timer);
    cover.load_timer = false;
};

function repaint_rating(ry) {
    if(!columns.rating_timerID) {
        //columns.rating_timerID = window.SetTimeout(function() {
            window.RepaintRect(columns.rating_x, ry, columns.rating_w, row.h);
            columns.rating_timerID && window.ClearTimeout(columns.rating_timerID);
            columns.rating_timerID = false;
        //},50);
    };
};

function repaint_mood(ry) {
    if(!columns.mood_timerID) {
        //columns.mood_timerID = window.SetTimeout(function() {
            window.RepaintRect(columns.mood_x, ry, columns.mood_w, row.h);
            columns.mood_timerID && window.ClearTimeout(columns.mood_timerID);
            columns.mood_timerID = false;
        //},25);
    };
};

//=================================================// Item Object
ItemStates = {normal: 0, hover: 1, selected: 2};
item = function (id, idx, gridx) {
    if (typeof this.id == "undefined") {
        this.id = id;
        this.idx = idx;
        this.gridx = gridx;
        this.grp_idx = 0;
        this.metadb = list.handlelist.Item(this.id);
        this.x = 0;
        this.defaulty = toolbar.h + (idx) * row.h;
        this.w = ww;
        this.h = row.h;
        this.l_rating = 0;
        this.l_mood = 0;
        this.tooltip = false;
        if(this.metadb) {
            this.albumartist = tf_albumartist.EvalWithMetadb(this.metadb);
            this.album = tf_album.EvalWithMetadb(this.metadb);
            this.group_key = tf_group_key.EvalWithMetadb(this.metadb);
            this.track_type = TrackType(this.metadb.rawpath.substring(0,4));
            if(this.gridx==0) {
                this.tracknumber = tf_tracknumber.EvalWithMetadb(this.metadb);
                this.artist = tf_artist.EvalWithMetadb(this.metadb);
                this.title = tf_title.EvalWithMetadb(this.metadb);
                this.playcount = columns.playcount ? tf_playcount.EvalWithMetadb(this.metadb) : 0;
                this.duration = tf_duration.EvalWithMetadb(this.metadb);
                this.mood = columns.mood ? tf_mood.EvalWithMetadb(this.metadb) : 0;
                this.rating = columns.rating ? tf_rating.EvalWithMetadb(this.metadb) : 0;
                this.bitrate = columns.bitrate ? tf_bitrate.EvalWithMetadb(this.metadb) : "";
            } else {
                this.genre = tf_genre.EvalWithMetadb(this.metadb);
                this.date = tf_date.EvalWithMetadb(this.metadb);
                this.codec = tf_codec.EvalWithMetadb(this.metadb);
                this.disc_info = tf_disc_info.EvalWithMetadb(this.metadb);
            };
        };
    };


    this.update_infos = function() {
        if(this.metadb) {
            this.albumartist = tf_albumartist.EvalWithMetadb(this.metadb);
            this.album = tf_album.EvalWithMetadb(this.metadb);
            this.group_key = tf_group_key.EvalWithMetadb(this.metadb);
            this.track_type = TrackType(this.metadb.rawpath.substring(0,4));
            if(this.gridx==0) {
                this.tracknumber = tf_tracknumber.EvalWithMetadb(this.metadb);
                this.artist = tf_artist.EvalWithMetadb(this.metadb);
                this.title = tf_title.EvalWithMetadb(this.metadb);
                this.playcount = tf_playcount.EvalWithMetadb(this.metadb);
                this.duration = tf_duration.EvalWithMetadb(this.metadb);
                this.mood = columns.mood ? tf_mood.EvalWithMetadb(this.metadb) : 0;
                this.rating = columns.rating ? tf_rating.EvalWithMetadb(this.metadb) : 0;
                this.bitrate = columns.bitrate ? tf_bitrate.EvalWithMetadb(this.metadb) : "";
            } else {
                this.genre = tf_genre.EvalWithMetadb(this.metadb);
                this.date = tf_date.EvalWithMetadb(this.metadb);
                this.codec = tf_codec.EvalWithMetadb(this.metadb);
                this.disc_info = tf_disc_info.EvalWithMetadb(this.metadb);
            };
        };
    };


    this.draw = function(gr, id, idx) {
        this.y = this.defaulty - (list.tocut * row.h);
        if(this.gridx==0) {
            // ---------------------
            // ::: Draw item
            // ---------------------
            if(list.focus_id==this.id) {
                // focused item bg
                var state = 2;
                try {
                    list.theme.SetPartAndStateId(6, 10);
                    list.theme.DrawThemeBackground(gr, this.x, this.y, ww-vscrollbar.w, this.h);
                } catch(e) {
                    gr.SetSmoothingMode(2);
                    gr.DrawRoundRect(this.x+0, this.y, this.w-vscrollbar.w-1, this.h-1, 2, 2, 1.0, g_textcolor&0x20ffffff);
                    gr.FillGradRect(this.x+1, this.y, this.w-vscrollbar.w-2, this.h-1, 90, 0, g_textcolor&0x15ffffff, 1.0);
                    gr.SetSmoothingMode(0);
                };
            } else {
                if(plman.IsPlaylistItemSelected(plman.ActivePlaylist, this.id)) {
                    // selected item bg
                    var state = 1;
                    try {
                        list.theme.SetPartAndStateId(6, 10);
                        list.theme.DrawThemeBackground(gr, this.x, this.y, ww-vscrollbar.w, this.h);
                    } catch(e) {
                        gr.SetSmoothingMode(2);
                        gr.DrawRoundRect(this.x+0, this.y, this.w-vscrollbar.w-1, this.h-1, 2, 2, 1.0, g_textcolor&0x20ffffff);
                        gr.FillGradRect(this.x+1, this.y, this.w-vscrollbar.w-2, this.h-1, 90, 0, g_textcolor&0x15ffffff, 1.0);
                        gr.SetSmoothingMode(0);
                    };
                } else {
                    // default item bg (odd/even)
                    var state = 0;
                    if(Math.floor(this.grp_idx/2) == this.grp_idx/2) {
                        gr.FillSolidRect(this.x, this.y, this.w-vscrollbar.w, this.h, RGBA(255,255,255,5));
                    } else {
                        gr.FillSolidRect(this.x, this.y, this.w-vscrollbar.w, this.h, RGBA(0,0,0,5));
                    };
                    if(list.gradient_lines_show) {
                        gr.FillGradRect(this.x+30, this.y, this.w-vscrollbar.w-60, 1, 0, 0, RGBA(0,0,0,80), 0.5);
                        gr.FillGradRect(this.x+30, this.y+1, this.w-vscrollbar.w-60, 1, 0, 0, RGBA(255,255,255,15), 0.5);
                    };
                };
            };
            
            // last item shadow effect
            if(this.id==list.total-1) {
                gr.FillSolidRect(this.x, this.y+this.h+0, this.w-vscrollbar.w, 1, RGBA(0,0,0,75));
                gr.FillSolidRect(this.x, this.y+this.h+1, this.w-vscrollbar.w, 1, RGBA(0,0,0,35));
                gr.FillSolidRect(this.x, this.y+this.h+2, this.w-vscrollbar.w, 1, RGBA(0,0,0,12));
            };
            
            // ****************************
            // .start. *** cols metrics ***
            // ****************************
            columns.playicon_x = 0;
            if(columns.playicon) {
                columns.playicon_w = (cover.margin + 20);
            } else {
                columns.playicon_w = 3;
            };
            //
            columns.tracknumber_x = columns.playicon_x + columns.playicon_w;
            if(columns.tracknumber) {
                columns.tracknumber_w = 36;
            } else {
                columns.tracknumber_w = 5;
            };
            //
            if(columns.rating || columns.bitrate || columns.mood) {
                if(columns.duration_w<=0) {
                    columns.duration_w = gr.CalcTextWidth("00:00:00", g_font);
                };
            } else {
                columns.duration_w = gr.CalcTextWidth(" -"+this.duration, g_font);
            };
            //
            columns.duration_x = ww-vscrollbar.w - columns.duration_w - cover.margin;
            //
            if(columns.rating_w<=0) {
                if(g_font_guifx_found) {
                    columns.rating_w = gr.CalcTextWidth("bbbbb", rating_font);
                } else {
                    columns.rating_w = gr.CalcTextWidth("*****", rating_font);
                };
            };
            columns.rating_x = columns.duration_x - (columns.rating_w*columns.rating);
            //
            if(columns.mood_w<=0) {
                if(g_font_guifx_found) {
                    columns.mood_w = gr.CalcTextWidth("v", mood_font) + 3;
                } else {
                    columns.mood_w = gr.CalcTextWidth("♥", mood_font) + 3;
                };
            };
            columns.mood_x = columns.rating_x - (columns.mood_w*columns.mood);
            //
            if(columns.bitrate_w<=0) {
                columns.bitrate_w = gr.CalcTextWidth("XXXXXXX", g_font)*columns.bitrate;
            };
            columns.bitrate_x = columns.mood_x - (columns.bitrate_w*columns.bitrate);
            //
            if(columns.playcount && this.playcount>0) {
                var playcount_w = gr.CalcTextWidth(this.playcount, mini_font)+3;
            } else {
                var playcount_w = 0;
            };
            //
            columns.title_x = columns.tracknumber_x + columns.tracknumber_w;
            columns.title_w = (columns.rating_x - columns.title_x - 3 - playcount_w) - (columns.bitrate_w*columns.bitrate) - (columns.mood_w*columns.mood);
            // **************************
            // .end. *** cols metrics ***
            // **************************
            
            row.parity = (row.h/2==Math.floor(row.h))?1:0;
            
            // now playing info : Play icon + Progress bar
            var duration = this.duration;
            var bitrate = this.bitrate;
            if(plman.PlayingPlaylist == plman.ActivePlaylist) {
                if(fb.IsPlaying) {
                    list.nowplaying = plman.GetPlayingItemLocation();
                    if(this.id==list.nowplaying.PlaylistItemIndex) {
                        var isplaying = true;
                        g_playing_item_y = this.y;
                        // progress bar (if not a stream!)
                        if(this.track_type!=3 && row.show_progress && fb.PlaybackLength) {
                            var length_seconds = tf_length_seconds.EvalWithMetadb(this.metadb);
                            var progress = Math.round(g_seconds / length_seconds * (ww-vscrollbar.w-this.x-0));
                            gr.FillGradRect(this.x+0, this.y, progress, this.h, 90, g_textcolor_sel&0x20ffffff, 0, 0.5);
                        };
                        // calc dynamic other tf values
                        duration = tf_playback_time_remaining.Eval(true);
                        bitrate = tf_bitrate_playing.Eval(true);
                        if(columns.playicon) {
                            if(g_seconds/2==Math.floor(g_seconds/2)) {
                                gr.DrawImage(playicon_off, columns.playicon_x+9, this.y, playicon_off.Width, playicon_off.Height, 0, 0, playicon_off.Width, playicon_off.Height, 0, 255);
                            } else {
                                gr.DrawImage(playicon_on, columns.playicon_x+9, this.y, playicon_off.Width, playicon_off.Height, 0, 0, playicon_off.Width, playicon_off.Height, 0, 255);
                            };
                        };
                    } else {
                        var isplaying = false;
                    };
                };
            };
            // draw tracknumber
            if(columns.tracknumber) {
                if(plman.IsPlaybackQueueActive()) {
                    var queue_index = plman.FindPlaybackQueueItemIndex(this.metadb, plman.ActivePlaylist, this.id);
                };
                gr.SetSmoothingMode(2);
                gr.FillRoundRect(columns.tracknumber_x+3, this.y+4, columns.tracknumber_w-9, this.h-9, 2, 2, RGB(20,20,20));
                gr.SetSmoothingMode(0);
                //var new_tracknumber = (this.tracknumber>0)? this.tracknumber : (group.nbrows>0?num(this.grp_idx+1,2):"?");
                var new_tracknumber = (queue_index>=0) ? " " + num(queue_index+1,2) + "*" : ((this.tracknumber>0)? this.tracknumber : num(this.grp_idx+1,2));
                try {
                    gr.GdiDrawText(new_tracknumber, gdi.Font("tahoma", 10), (queue_index>=0 || isQueuePlaylistActive())?RGB(100,180,100):(isplaying?g_textcolor_sel:RGB(250,250,250)), columns.tracknumber_x, this.y, columns.tracknumber_w-1, this.h-row.parity, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                } catch(e) {
                    gr.GdiDrawText(new_tracknumber, gdi.Font("tahoma", 10), (queue_index>=0 || isQueuePlaylistActive())?RGB(100,180,100):(isplaying?g_textcolor_sel:RGB(250,250,250)), columns.tracknumber_x, this.y, columns.tracknumber_w-1, this.h-row.parity, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                };
            };

            // draw title
            try {
                tf_title_w = gr.CalcTextWidth(this.title, g_font);
                if(tf_title_w > columns.title_w) {
                    tf_title_w = columns.title_w;
                    this.tooltip = true;
                };
                gr.GdiDrawText(this.title, g_font, isplaying?g_textcolor_sel:g_textcolor, columns.title_x, this.y, columns.title_w, this.h-row.parity, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            } catch(e) {
                tf_title_w = gr.CalcTextWidth(this.title, gdi.Font("tahoma", 11));
                if(tf_title_w > columns.title_w) {
                    tf_title_w = columns.title_w;
                    this.tooltip = true;
                };
                gr.GdiDrawText(this.title, gdi.Font("tahoma", 11), isplaying?g_textcolor_sel:g_textcolor, columns.title_x, this.y, columns.title_w, this.h-row.parity, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            };
            
            // draw artist
            if(group.nbrows==0 || (columns.title==1 && this.artist!=this.albumartist) || columns.title==2) {
                var artist_x = columns.title_x + tf_title_w;
                try {
                    var artist_w = columns.title_w - tf_title_w;
                    tf_artist_w = gr.CalcTextWidth(" "+panel.tag_separator+" "+this.artist, g_font);
                    if(tf_artist_w > artist_w) {
                        tf_artist_w = artist_w;
                        this.tooltip = true;
                    };
                    if(tf_title_w < columns.title_w) {
                        gr.GdiDrawText(" "+panel.tag_separator+" "+this.artist, g_font, g_textcolor_hl, artist_x, this.y, artist_w, this.h-row.parity, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                } catch(e) {
                    var artist_w = columns.title_w - tf_title_w;
                    tf_artist_w = gr.CalcTextWidth(" "+panel.tag_separator+" "+this.artist, gdi.Font("tahoma", 11));
                    if(tf_artist_w > artist_w) {
                        tf_artist_w = artist_w;
                        this.tooltip = true;
                    };
                    if(tf_title_w < columns.title_w) {
                        gr.GdiDrawText(" "+panel.tag_separator+" "+this.artist, gdi.Font("tahoma", 11), g_textcolor_hl, artist_x, this.y, artist_w, this.h-row.parity, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                };
            } else {
                if(tf_title_w > columns.title_w) this.tooltip = true;
                tf_artist_w = 0;
            };
            
            // draw playcount
            if(columns.playcount && playcount_w>0) {
                var playcount_x = columns.title_x + tf_title_w + tf_artist_w;
                try {
                    gr.DrawString(this.playcount, mini_font, g_textcolor&0x40ffffff, playcount_x, this.y-4, playcount_w, this.h-row.parity, rc_stringformat);
                } catch(e) {
                    gr.DrawString(this.playcount, gdi.Font("tahoma", 8), g_textcolor&0x40ffffff, playcount_x, this.y-4, playcount_w, this.h-row.parity, rc_stringformat);
                };
            };
            
            // draw rating
            if(columns.rating) {
                // Rating engine
                if(this.rating_hover) {
                    var boolx = false;
                    for (var i = 1; i < 6; i++){
                        if(this.track_type<2){
                            var r_color = (i > (this.rating_hover ? this.l_rating : this.rating)) ? g_textcolor&0x12ffffff : (this.rating_hover ? (i==this.rating ? (i==this.l_rating ? RGB(255,50,50) : g_textcolor_sel) : g_textcolor_sel) : g_textcolor&0x90ffffff);
                            if(this.rating_hover && this.l_rating==this.rating) {
                                r_color = i<=this.l_rating ? RGB(255,50,50) : g_textcolor&0x12ffffff;
                                boolx = i<=this.l_rating ? true : false;
                            }
                        } else {
                            var r_color = g_textcolor&0x12ffffff;
                            boolx = false;
                        };
                        if(g_font_guifx_found) {
                            gr.SetTextRenderingHint(5);
                            if(boolx){
                                gr.DrawString("x", del_rating_font, r_color, columns.rating_x+14*(i-1)+1, this.y-1, 14, row.h, lc_stringformat);
                            } else {
                                gr.DrawString("b", rating_font, r_color, columns.rating_x+14*(i-1), this.y, 14, row.h, lc_stringformat);
                            };
                        } else {
                            gr.SetTextRenderingHint(3);
                            gr.DrawString("*", rating_font, r_color, columns.rating_x+12*(i-1), this.y+4, 12, row.h, lc_stringformat);
                        };
                    };
                } else {
                    if(g_font_guifx_found) {
                        gr.SetTextRenderingHint(5);
                        gr.DrawString("bbbbb", rating_font, g_textcolor&0x12ffffff, columns.rating_x, this.y-1, columns.rating_w+1, row.h, lc_stringformat);
                        gr.DrawString("b".repeat(Math.round(this.rating)), rating_font, g_textcolor&0x90ffffff, columns.rating_x, this.y-1, columns.rating_w+1, row.h, lc_stringformat);
                    } else {
                        gr.SetTextRenderingHint(3);
                        gr.DrawString("*****", rating_font, g_textcolor&0x12ffffff, columns.rating_x, this.y+4, columns.rating_w+1, row.h, lc_stringformat);
                        gr.DrawString("*".repeat(Math.round(this.rating)), rating_font, g_textcolor&0x90ffffff, columns.rating_x, this.y+4, columns.rating_w+1, row.h, lc_stringformat);
                    };
                };
            };

            // draw bitrate
            if(columns.bitrate) {
                try {
                    gr.GdiDrawText(bitrate, g_font, isplaying?g_textcolor_sel:g_textcolor, columns.bitrate_x, this.y, columns.bitrate_w, this.h-row.parity, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                } catch(e) {
                    gr.GdiDrawText(bitrate, gdi.Font("tahoma", 11), isplaying?g_textcolor_sel:g_textcolor, columns.bitrate_x, this.y, columns.bitrate_w, this.h-row.parity, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                };
            };
            
            // draw Mood icon
            if(columns.mood) {
                if(this.track_type<2){
                    r_color = this.mood_hover ? g_textcolor_sel : (this.mood!=0 ? RGB(255,80,120) : g_textcolor&0x12ffffff);
                } else {
                    var r_color = g_textcolor&0x12ffffff;
                };
                if(g_font_guifx_found) {
                    gr.SetTextRenderingHint(4);
                    gr.DrawString("v", mood_font, r_color, columns.mood_x, this.y+1, columns.mood_w, row.h, lc_stringformat);
                } else {
                    gr.SetTextRenderingHint(4);
                    gr.DrawString("♥", mood_font, r_color, columns.mood_x, this.y, columns.mood_w, row.h, lc_stringformat);
                };

            };
            
            // draw playbacktime/duration
            try {
                gr.GdiDrawText(duration, g_font, isplaying?g_textcolor_sel:g_textcolor, columns.duration_x, this.y, columns.duration_w, this.h-row.parity, DT_RIGHT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            } catch(e) {
                gr.GdiDrawText(duration, gdi.Font("tahoma", 11), isplaying?g_textcolor_sel:g_textcolor, columns.duration_x, this.y, columns.duration_w, this.h-row.parity, DT_RIGHT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
            };
            
            // if dragging items, draw line at top of the hover items to show where dragged items will be inserted on mouse button up
            if(dragndrop.drag_in && this.ishover && panel.ishover) {
                if(!plman.IsPlaylistItemSelected(plman.ActivePlaylist, this.id)) {
                    if(this.id>dragndrop.drag_id) {
                        gr.DrawLine(this.x+5, this.y+this.h, ww-vscrollbar.w-5, this.y+this.h, 2.0, g_textcolor);
                        gr.DrawImage(icon_arrow_left, this.x, this.y+this.h-4, 8, 8, 0, 0, 8, 8, 0, 255);
                        gr.DrawImage(icon_arrow_left, this.x+ww-vscrollbar.w, this.y+this.h-4, -8, 8, 0, 0, 8, 8, 0, 255);
                        dragndrop.drop_id = this.id;
                    } else if(this.id<dragndrop.drag_id) {
                        gr.DrawLine(this.x+5, this.y, ww-vscrollbar.w-5, this.y, 2.0, g_textcolor);
                        gr.DrawImage(icon_arrow_left, this.x, this.y-4, 8, 8, 0, 0, 8, 8, 0, 255);
                        gr.DrawImage(icon_arrow_left, this.x+ww-vscrollbar.w, this.y-4, -8, 8, 0, 0, 8, 8, 0, 255);
                        dragndrop.drop_id = this.id;
                    };
                };
            };

        } else if(this.gridx==group.nbrows && group.nbrows>0) {
            // ---------------------
            // ::: Draw group Header
            // ---------------------
            
            // total items in the group
            var total_grp_items = list.groups[list.hlist[this.id]-1];
            
            // background
            if(group.nbrows>1 && group.type==0) {  // display the year only if group by album (group.type = 0)
                var date_str = gr.MeasureString(this.date, gh_date_font, 0, 0, 200, 30, 0);
                var year_x = ww-vscrollbar.w-date_str.Width-cover.margin;
                var year_w = (group.nbrows>1 && (this.album.length>0 || total_grp_items==1) && this.date)?date_str.Width+cover.margin*2:0;
            } else {
                var year_x = 0;
                var year_w = 0;
            };
            gr.FillGradRect(this.x, this.y-((group.nbrows-1)*row.h), this.w-vscrollbar.w-year_w, group.nbrows*row.h, 90, RGBA(255,255,255,15), RGBA(0,0,0,15), 1.0);
            //
            gr.FillGradRect(this.x-30, this.y-((group.nbrows-1)*row.h), this.w-vscrollbar.w+60, 1, 0, 0, RGBA(0,0,0,15), 0.5);
            gr.FillSolidRect(this.x, this.y-((group.nbrows-1)*row.h)+1, this.w-vscrollbar.w, 1, RGBA(255,255,255,15));
            gr.FillSolidRect(this.x, this.y+row.h-0, this.w-vscrollbar.w, 1, RGBA(255,255,255,5));
            gr.FillSolidRect(this.x, this.y+row.h-1, this.w-vscrollbar.w, 1, RGBA(0,0,0,15));
            // draw cover art
            if(cover.show && cover.visible && this.y>(0-group.nbrows*row.h) && this.y<(wh-toolbar.h)+(group.nbrows*row.h)) {
                // cover bg
                var cv_x = this.x+cover.margin;
                var cv_y = ((this.y+row.h)-(row.h*group.nbrows))+cover.margin;
                var cv_w = cover.w-cover.margin*2;
                var cv_h = cover.h-cover.margin*2;
                if(!cover.keepaspectratio) {
                    gr.FillSolidRect(cv_x+1, cv_y+1, cv_w-2, cv_h-2, g_backcolor);
                    gr.FillSolidRect(cv_x+1, cv_y+1, cv_w-2, cv_h-2, g_textcolor&0x15ffffff);
                    gr.DrawRect(cv_x, cv_y, cv_w-1, cv_h-1, 1.0, g_textcolor&0x80ffffff);
                };
                //
                this.cover_img = g_image_cache.hit(this);
                //
                if(this.cover_img) {
                    if(cover.keepaspectratio) {
                        // *** check aspect ratio *** //
                        if(this.cover_img.Height>=this.cover_img.Width) {
                            var ratio = this.cover_img.Width / this.cover_img.Height;
                            var pw = cv_w*ratio;
                            var ph = cv_h;
                            this.left = Math.floor((ph-pw) / 2);
                            this.top = 0;
                            cv_x += this.left;
                            cv_y += this.top*1;
                            cv_w = cv_w - this.left*2 - cover.margin - 1;
                            cv_h = cv_h - this.top*2 - cover.margin - 1;
                        } else {
                            var ratio = this.cover_img.Height / this.cover_img.Width;
                            var pw = cv_w;
                            var ph = cv_h*ratio;
                            this.top = Math.floor((pw-ph) / 2);
                            this.left = 0;
                            cv_x += this.left;
                            cv_y += this.top*1;
                            cv_w = cv_w - this.left*2 - cover.margin - 1;
                            cv_h = cv_h - this.top*2 - cover.margin - 1;
                        };
                        // *** check aspect ratio *** //
                    };
                    
                    // Draw Cover Art (when available)
                    if(cover.keepaspectratio) {
                        gr.DrawRect(cv_x+2, cv_y+2, cv_w+cover.margin*1, cv_h+cover.margin*1, 1.0, RGBA(0,0,0,15));
                        gr.DrawRect(cv_x+1, cv_y+1, cv_w+cover.margin*1, cv_h+cover.margin*1, 1.0, RGBA(0,0,0,45));
                        gr.DrawImage(this.cover_img, cv_x, cv_y, cover.w, cover.h, 0, 0, cover.w, cover.h, 0, 255);
                        gr.DrawRect(cv_x, cv_y, cv_w+cover.margin*1, cv_h+cover.margin*1, 1.0, g_backcolor);
                        gr.DrawRect(cv_x, cv_y, cv_w+cover.margin*1, cv_h+cover.margin*1, 1.0, g_textcolor&0x80ffffff);                    
                    } else {
                        gr.DrawRect(cv_x+2, cv_y+2, cv_w-1, cv_h-1, 1.0, RGBA(0,0,0,15));
                        gr.DrawRect(cv_x+1, cv_y+1, cv_w-1, cv_h-1, 1.0, RGBA(0,0,0,45));
                        gr.DrawImage(this.cover_img, cv_x, cv_y, cover.w, cover.h, 0, 0, cover.w, cover.h, 0, 255);
                        gr.DrawRect(cv_x, cv_y, cv_w-1, cv_h-1, 1.0, g_backcolor);
                        gr.DrawRect(cv_x, cv_y, cv_w-1, cv_h-1, 1.0, g_textcolor&0x80ffffff);
                    };
                };
            };
            
            // draw TF text info of the group header
            var grp_y = cover.margin+this.y-((group.nbrows-1)*row.h);
            var grp_h = group.nbrows*row.h - cover.margin*2;
            
            // Year info (& date separator & backgound)
            if(year_w>0) {
                gr.FillSolidRect(ww-vscrollbar.w-year_w, this.y-((group.nbrows-1)*row.h), year_w, group.nbrows*row.h, RGBA(0,0,0,15));
                gr.FillGradRect(ww-vscrollbar.w-year_w, this.y-((group.nbrows-1)*row.h), 5, group.nbrows*row.h, 00, RGBA(0,0,0,15), 0, 1.0);
                gr.FillGradRect(ww-vscrollbar.w-year_w-1, this.y-((group.nbrows-1)*row.h)+5, 1, group.nbrows*row.h-10, 90, 0, RGBA(255,255,255,25), 0.5);
                gr.FillGradRect(ww-vscrollbar.w-year_w+0, this.y-((group.nbrows-1)*row.h)+5, 1, group.nbrows*row.h-10, 90, 0, RGBA(0,0,0,40), 0.5);
                gr.FillGradRect(ww-vscrollbar.w-year_w+1, this.y-((group.nbrows-1)*row.h)+10, 1, group.nbrows*row.h-20, 90, 0, RGBA(0,0,0,15), 0.5);
                gr.FillGradRect(ww-vscrollbar.w-year_w+1, this.y-((group.nbrows-1)*row.h)+15, 1, group.nbrows*row.h-30, 90, 0, RGBA(0,0,0,5), 0.5);
                gr.SetTextRenderingHint(3);
                gr.DrawString(this.date, gh_date_font, g_backcolor&0xddffffff, year_x, grp_y-7, year_w, group.nbrows*row.h-1, lc_stringformat);
                gr.DrawString(this.date, gh_date_font, g_textcolor&0x25ffffff, year_x, grp_y-8, year_w, group.nbrows*row.h-1, lc_stringformat);
            };
            
            // Artist + Album infos
            if(group.type==0) {
                var album_tag = this.album.length>0?this.album:(total_grp_items>1?"Singles":"Single");
                if(group.nbrows>1) {
                    var text_x = (cover.show && cover.visible) ? this.x+cover.w : this.x + cover.margin;
                    var text_w = (ww-vscrollbar.w)-cover.w-cover.margin*2-(year_w-5);
                    try {
                        gr.GdiDrawText(this.albumartist, g_font, g_backcolor, text_x, grp_y+1, text_w, Math.floor(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(this.albumartist, g_font, g_textcolor_hl, text_x, grp_y, text_w, Math.floor(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(album_tag+this.disc_info, g_font, g_backcolor, text_x, grp_y+Math.floor(grp_h/group.nbrows)+1, text_w, Math.ceil(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(album_tag+this.disc_info, g_font, g_textcolor_hl, text_x, grp_y+Math.floor(grp_h/group.nbrows), text_w, Math.ceil(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    } catch(e) {
                        gr.GdiDrawText(this.albumartist, gdi.Font("tahoma",11), g_textcolor_hl, text_x, grp_y, text_w, Math.floor(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(album_tag+this.disc_info, gdi.Font("tahoma",11), g_textcolor_hl, text_x, grp_y+Math.floor(grp_h/group.nbrows), text_w, Math.ceil(grp_h/group.nbrows), DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                } else {
                    gr.DrawImage(singleline_group_header_icon, cover.margin, this.y+Math.floor(row.h/2)-8, 16, 16, 0, 0, 16, 16, 0, 255);
                    var text_x = this.x+cover.margin+singleline_group_header_icon.Width;
                    var text_w = ww-vscrollbar.w-cover.margin*2-singleline_group_header_icon.Width;
                    try {
                        gr.GdiDrawText(this.albumartist+" "+panel.tag_separator+" "+album_tag+this.disc_info, g_font, g_backcolor, text_x, grp_y+1, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(this.albumartist+" "+panel.tag_separator+" "+album_tag+this.disc_info, g_font, g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    } catch(e) {
                        gr.GdiDrawText(this.albumartist+" "+panel.tag_separator+" "+album_tag+this.disc_info, gdi.Font("tahoma",11), g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                };
            } else {
                var t_path = this.group_key;
                if(group.nbrows>1) {
                    var text_x = (cover.show && cover.visible) ? this.x+cover.w : this.x + cover.margin;
                    var text_w = (ww-vscrollbar.w)-cover.w-cover.margin*2-(year_w-5);
                    try {
                        gr.GdiDrawText(t_path, g_font, g_backcolor, text_x, grp_y+1, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(t_path, g_font, g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    } catch(e) {
                        gr.GdiDrawText(t_path, gdi.Font("tahoma",11), g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                   };
                } else {
                    gr.DrawImage(singleline_group_header_icon, cover.margin, this.y+Math.floor(row.h/2)-8, 16, 16, 0, 0, 16, 16, 0, 255);
                    var text_x = this.x+cover.margin+singleline_group_header_icon.Width;
                    var text_w = ww-vscrollbar.w-cover.margin*2-singleline_group_header_icon.Width;
                    try {
                        gr.GdiDrawText(t_path, g_font, g_backcolor, text_x, grp_y+1, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                        gr.GdiDrawText(t_path, g_font, g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    } catch(e) {
                        gr.GdiDrawText(t_path, gdi.Font("tahoma",11), g_textcolor_hl, text_x, grp_y, text_w, grp_h, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
                    };
                }; 
            };
            
            // extra group infos (3rd line)
            gr.SetTextRenderingHint(5);
            //var total_grp_length = TimeFromSeconds(list.groups[list.hlist[this.id]-1]);
            if(group.nbrows==2 && group.type!=0) {
                try {
                    gr.DrawString(total_grp_items+(total_grp_items>1?" TRKS":" TRK")+" | "+this.codec+" | "+this.genre.toUpperCase(), mini_font, g_textcolor&0x44ffffff, text_x+1, (this.y-cover.margin)+2, text_w-1, row.h, lb_stringformat);
                } catch(e) {
                    gr.DrawString(total_grp_items+(total_grp_items>1?" TRKS":" TRK")+" | "+this.codec+" | "+this.genre.toUpperCase(), gdi.Font("tahoma",11), g_textcolor&0x44ffffff, text_x+1, (this.y-cover.margin)+2, text_w-1, row.h, lb_stringformat);
                };
            } else if(group.nbrows>2) {
                try {
                    gr.DrawString(total_grp_items+(total_grp_items>1?" TRKS":" TRK")+" | "+this.codec+" | "+this.genre.toUpperCase(), mini_font, g_textcolor&0x44ffffff, text_x+1, (this.y-cover.margin)+2, text_w-1, row.h, lc_stringformat);
                } catch(e) {
                    gr.DrawString(total_grp_items+(total_grp_items>1?" TRKS":" TRK")+" | "+this.codec+" | "+this.genre.toUpperCase(), gdi.Font("tahoma",11), g_textcolor&0x44ffffff, text_x+1, (this.y-cover.margin)+2, text_w-1, row.h, lc_stringformat);
                };
            };
        };
        
        if(group.nbrows>0 && this.gridx>0) {
            // if dragging items, draw line at top of the hover items to show where dragged items will be inserted on mouse button up
            if(dragndrop.drag_in && this.ishover && panel.ishover) {
                if(!plman.IsPlaylistItemSelected(plman.ActivePlaylist, this.id)) {
                    if(this.id<=dragndrop.drag_id) {
                        gr.DrawLine(this.x+5, this.y-(this.gridx-1)*row.h, ww-vscrollbar.w-5, this.y-(this.gridx-1)*row.h, 2.0, g_textcolor);
                        gr.DrawImage(icon_arrow_left, this.x, this.y-(this.gridx-1)*row.h-4, 8, 8, 0, 0, 8, 8, 0, 255);
                        gr.DrawImage(icon_arrow_left, this.x+ww-vscrollbar.w, this.y-(this.gridx-1)*row.h-4, -8, 8, 0, 0, 8, 8, 0, 255);
                        dragndrop.drop_id = this.id;
                    } else {
                        gr.DrawLine(this.x+5, this.y+(group.nbrows-this.gridx+1)*row.h, ww-vscrollbar.w-5, this.y+(group.nbrows-this.gridx+1)*row.h, 2.0, g_textcolor);
                        gr.DrawImage(icon_arrow_left, this.x, this.y+(group.nbrows-this.gridx+1)*row.h-4, 8, 8, 0, 0, 8, 8, 0, 255);
                        gr.DrawImage(icon_arrow_left, this.x+ww-vscrollbar.w, this.y+(group.nbrows-this.gridx+1)*row.h-4, -8, 8, 0, 0, 8, 8, 0, 255);
                        dragndrop.drop_id = this.id>0?this.id-1:0;
                    };
                };
            };            
        };
        
    };

    this.checkstate = function (event, x, y, id) {
        var state = 0;
        if(y<toolbar.delta) return true;
        var act_pls = plman.ActivePlaylist;
        var prev_rating_hover = this.rating_hover;
        var prev_l_rating = this.l_rating;
        var prev_mood_hover = this.mood_hover;
        var prev_l_mood = this.l_mood;
        if(y>toolbar.h) {
            this.ishover = (x > this.x && x < this.x + this.w - vscrollbar.w && y >= this.y && y < this.y + this.h);
        } else {
            this.ishover = false;
        };
        this.rating_hover = (this.gridx==0 && x>=columns.rating_x && x<=columns.rating_x+columns.rating_w && y>this.y+2 && y<this.y+this.h-2);
        this.mood_hover = (this.gridx==0 && x>=columns.mood_x && x<=columns.mood_x+columns.mood_w-3 && y>this.y+2 && y<this.y+this.h-2);
        
        if(row.buttons_hover) {
            toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
            toolbar.timerID_on = false;
        } else {
            row.buttons_hover = (this.rating_hover || this.mood_hover);
        };
        
        switch (event) {
        case "down":
            if(this.gridx>0) {
                if(this.ishover) {
                    SelectGroupItems(this.id);
                    if(list.metadblist_selection.Count>=1) {
                        dragndrop.drag_out = true;
                        dragndrop.drag_id = this.id;
                        if(!isQueuePlaylistActive()) {
                            dragndrop.timerID = window.SetTimeout(function() {
                                dragndrop.drag_in = true;
                                dragndrop.timerID && window.ClearTimeout(dragndrop.timerID);
                                dragndrop.timerID = false;
                            }, 250);
                        };
                    };
                };
            } else {
                if(this.rating_hover) {
                    columns.rating_drag = true;
                } else if(this.mood_hover) {
                    columns.mood_drag = true;
                } else {
                    if(plman.IsPlaylistItemSelected(act_pls, this.id)) {
                        if(this.ishover) {
                            if(list.metadblist_selection.Count>=1) {
                                dragndrop.drag_out = true;
                                if(list.metadblist_selection.Count>1) {
                                    // test if selection is contigus, if not, drag'n drop disable
                                    var first_item_selected_id = list.handlelist.Find(list.metadblist_selection.item(0));
                                    var last_item_selected_id = list.handlelist.Find(list.metadblist_selection.item(list.metadblist_selection.Count-1));
                                    var contigus_count = (last_item_selected_id - first_item_selected_id)+1;
                                } else {
                                    var contigus_count = 0;
                                };
                                if(list.metadblist_selection.Count==1 || list.metadblist_selection.Count == contigus_count) {
                                    dragndrop.drag_id = this.id;
                                    if(!isQueuePlaylistActive()) {
                                        dragndrop.timerID = window.SetTimeout(function() {
                                            dragndrop.drag_in = true;
                                            dragndrop.timerID && window.ClearTimeout(dragndrop.timerID);
                                            dragndrop.timerID = false;
                                        }, 250);
                                    };
                                };
                            };
                            if(utils.IsKeyPressed(VK_SHIFT)) {
                                if(list.focus_id != this.id) {
                                    if(list.SHIFT_start_id!=null) {
                                        SelectAtoB(list.SHIFT_start_id, this.id);
                                    } else {
                                        SelectAtoB(list.focus_id, this.id);
                                    };
                                };
                            } else if(utils.IsKeyPressed(VK_CONTROL)) {
                                if(plman.GetPlaylistFocusItemIndex(act_pls)!=this.id) {
                                    plman.SetPlaylistSelectionSingle(act_pls, this.id, false);
                                };
                            } else if(list.metadblist_selection.Count==1) {
                                plman.SetPlaylistFocusItem(act_pls, this.id);
                                plman.ClearPlaylistSelection(act_pls);
                                plman.SetPlaylistSelectionSingle(act_pls, this.id, true);
                            };
                        };
                    } else {
                        if(this.ishover) {
                            if(utils.IsKeyPressed(VK_SHIFT)) {
                                if(list.focus_id != this.id) {
                                    if(list.SHIFT_start_id!=null) {
                                        SelectAtoB(list.SHIFT_start_id, this.id);
                                    } else {
                                        SelectAtoB(list.focus_id, this.id);
                                    };
                                };
                            } else if(utils.IsKeyPressed(VK_CONTROL)) {
                                plman.SetPlaylistFocusItem(act_pls, this.id);
                                plman.SetPlaylistSelectionSingle(act_pls, this.id, true);
                            } else {
                                plman.SetPlaylistFocusItem(act_pls, this.id);
                                plman.ClearPlaylistSelection(act_pls);
                                plman.SetPlaylistSelectionSingle(act_pls, this.id, true);
                            };
                        };
                    };
                    list.metadblist_selection = plman.GetPlaylistSelectedItems(act_pls);
                };
            };
            break;

        case "dblclk":
            if(this.gridx==0) {
                if(this.rating_hover) {
                    
                } else if(this.mood_hover) {
                    
                } else {
                    if(!isQueuePlaylistActive()) {
                        if(plman.IsPlaylistItemSelected(act_pls, this.id)) {
                            if(this.ishover) {
                                plman.ExecutePlaylistDefaultAction(act_pls, this.id);
                                window.Repaint();
                            };
                        };
                    };
                };
            };
            break;
            
        case "right":
            if(this.ishover) {
                if(this.rating_hover) {
                    
                } else if(this.mood_hover) {
                    
                } else {
                    if(plman.IsPlaylistItemSelected(act_pls, this.id)) {
                        
                    } else {
                        plman.SetPlaylistFocusItem(act_pls, this.id);
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, this.id, true);
                    };
                    new_context_menu(x, y, this.id, this.idx);
                    state = -1;
                };
            };
            break;
            
        case "up":
            if(this.ishover) {
                if(this.rating_hover) {
                    // Rating
                    if(this.track_type<2) {
                        if(foo_playcount) {
                            // Rate to database statistics brought by foo_playcount.dll
                            if (this.l_rating != this.rating) {
                                if(this.metadb) {
                                    var bool = fb.RunContextCommandWithMetadb("Rating/"+((this.l_rating==0) ? "<not set>" : this.l_rating), this.metadb);
                                    this.rating = this.l_rating;
                                };
                            } else {
                                var bool = fb.RunContextCommandWithMetadb("Rating/<not set>", this.metadb);
                                this.rating = 0;
                            };
                        } else {
                            // Rate to file
                            if (this.l_rating != this.rating) {
                                if(this.metadb) {
                                    var bool = this.metadb.UpdateFileInfoSimple("RATING", this.l_rating);
                                    this.rating = this.l_rating;
                                };
                            } else {
                                var bool = this.metadb.UpdateFileInfoSimple("RATING","");
                                this.rating = 0;
                            };
                        };
                    };
                } else if(this.mood_hover) {
                    // Mood
                    if(this.track_type<2) {
                        // tag to file
                        if (this.l_mood != this.mood) {
                            if(this.metadb) {
                                var bool = this.metadb.UpdateFileInfoSimple("MOOD", getTimestamp());
                                this.mood = this.l_mood;
                            };
                        } else {
                            var bool = this.metadb.UpdateFileInfoSimple("MOOD","");
                            this.mood = 0;
                        };
                    };
                } else {
                    if(plman.IsPlaylistItemSelected(act_pls, this.id)) {
                        if(!utils.IsKeyPressed(VK_SHIFT) && !utils.IsKeyPressed(VK_CONTROL)) {
                            if(!dragndrop.drag_in) {
                                if(this.gridx==0) {
                                    plman.SetPlaylistFocusItem(act_pls, this.id);
                                    plman.ClearPlaylistSelection(act_pls);
                                    plman.SetPlaylistSelectionSingle(act_pls, this.id, true);
                                };
                            };
                            dragndrop.timerID && window.ClearTimeout(dragndrop.timerID);
                            dragndrop.timerID = false;
                            dragndrop.drag_in = false;
                            dragndrop.drag_out = false;
                        };
                    };
                };
            };
            columns.rating_drag = false;
            columns.mood_drag = false;
            break;
            
        case "move":

            if(columns.rating && !columns.rating_drag) {
                if(this.rating_hover) {
                    this.l_rating = Math.floor((x - columns.rating_x) / (g_font_guifx_found?14:12)) + 1;
                    if(this.l_rating>5) this.l_rating = 5;
                } else {
                    this.l_rating = 0;
                };
                if(this.rating_hover != prev_rating_hover || this.l_rating != prev_l_rating) {
                    repaint_rating(this.y);
                };
            };
            if(columns.mood && !columns.mood_drag) {
                if(this.mood_hover) {
                    this.l_mood = 1;
                } else {
                    this.l_mood = 0;
                };
                if(this.mood_hover != prev_mood_hover || this.l_mood != prev_l_mood) {
                    repaint_mood(this.y);
                };
            };
            break;
            
        case "leave":
        
            break;
        };
        return state;
    };
};

//=================================================// Titleformat field
var tf_cover_path = fb.TitleFormat("$replace(%path%,%filename_ext%,)");
var tf_tracknumber = fb.TitleFormat("$num($if2(%tracknumber%,0),2)");
var tf_artist = fb.TitleFormat("$if(%length%,%artist%,'Stream')");
var tf_title = fb.TitleFormat("%title%");
var tf_albumartist = fb.TitleFormat("$if(%length%,%album artist%,'Stream')");
var tf_album = fb.TitleFormat("$if2(%album%,$if(%length%,,'web radios'))");
var tf_disc = fb.TitleFormat("$if2(%discnumber%,0)");
var tf_disc_info = fb.TitleFormat("$if(%discnumber%,$ifgreater(%totaldiscs%,1,' - [disc '%discnumber%$if(%totaldiscs%,'/'%totaldiscs%']',']'),),)");
var tf_rating = fb.TitleFormat("$if2(%rating%,0)");
var tf_mood = fb.Titleformat("$if(%mood%,1,0)");
var tf_playcount = fb.TitleFormat("$if2(%play_counter%,$if2(%play_count%,0))");
var tf_duration = fb.TitleFormat("$if2(%length%,' 0:00')");
var tf_date = fb.TitleFormat("[$year($replace(%date%,/,-,.,-))]");
var tf_genre = fb.TitleFormat("$if2(%genre%,'Other')");
var tf_playback_time = fb.TitleFormat("%playback_time%");
var tf_playback_time_remaining = fb.TitleFormat("$if(%length%,-%playback_time_remaining%,'0:00')");
var tf_length_seconds = fb.TitleFormat("%length_seconds_fp%");
// GROUP
var tf_group_key = fb.TitleFormat(group_pattern_album);
// TECH 
var tf_codec = fb.Titleformat("%__codec%");
var tf_samplerate = fb.Titleformat("%__samplerate%");
var tf_bitrate = fb.TitleFormat("$if(%__bitrate_dynamic%,$if(%el_isplaying%,%__bitrate_dynamic%'K',$if($stricmp($left(%codec_profile%,3),'VBR'),%codec_profile%,%__bitrate%'K')),$if($stricmp($left(%codec_profile%,3),'VBR'),%codec_profile%,%__bitrate%'K'))");
var tf_bitrate_playing = fb.TitleFormat("$if(%__bitrate_dynamic%,$if(%_isplaying%,$select($add($mod(%_time_elapsed_seconds%,2),1),%__bitrate_dynamic%,%__bitrate_dynamic%),%__bitrate_dynamic%),%__bitrate%)'K'");
var tf_channels = fb.TitleFormat("$if($stricmp($codec(),MP3),$get(space2)$caps(%__mp3_stereo_mode%),$if(%__channels%,$ifgreater(%__channels%,1,Stereo,Mono),$if($strcmp(%__channels%,4),4 Ch,$sub(%__channels%,1)'.1' Ch)))");


//=================================================// Globals
var g_instancetype = window.InstanceType;
var g_font = null;
var g_font_headers = null;
var gh_date_font = gdi.Font("Segoe UI", 25, 2);
var g_font_guifx_found = utils.CheckFont("guifx v2 transports");
var rating_font = null;
var mood_font = null;
var del_rating_font = null;
var mini_font = gdi.Font("uni 05_53", 8, 0);
var ww = 0, wh = 0;
var mouse_x = 0, mouse_y = 0;
var g_textcolor = 0, g_textcolor_sel = 0, g_textcolor_hl = 0, g_backcolor = 0, g_backcolor_sel = 0;
var g_backcolor_R = 0, g_backcolor_G = 0, g_backcolor_B = 0;
var g_syscolor = 0;
var g_metadb;
var bool_on_size = false;
var g_search_string = "";
var incsearch_font = gdi.Font("lucida console", 9, 0);
var incsearch_font_big = gdi.Font("lucida console", 20, 1);
var clear_incsearch_timer = false;
var incsearch_timer = false;
var g_playing_item_y = null;
var g_seconds = 0;
var foo_playcount = utils.CheckComponent("foo_playcount", true);
var g_tooltip = window.CreateTooltip();
var g_tooltip_timer = false;
var show_tooltip = false;
var g_menu_displayed = false;
var g_add_items_timerID = false;
var g_drag = false;
var COLOR_BTNFACE = 15;

panel = {
    themed: window.GetProperty("SYSTEM.panel.themed", true),
    wallpaper_path: window.GetProperty("*USER.background.image.path", ".\\images\\background.jpg"),
    wallpaper_img: false,
    show_wallpaper: window.GetProperty("*USER.background.image.enabled", false),
    show_shadow_border: window.GetProperty("SYSTEM.shadow.border.enabled", true),
    opacity: window.GetProperty("*USER.panel.opacity.level [0,255]", 255),
    custom_textcolor: window.GetProperty("*USER.custom.text.color.normal", "RGB(200,200,210)"),
    custom_textcolor_selection: window.GetProperty("*USER.custom.text.color.selection", "RGB(64,128,200)"),
    custom_textcolor_highlight: window.GetProperty("*USER.custom.text.color.highlight", "RGB(150,200,250)"),
    custom_backcolor: window.GetProperty("*USER.custom.background.color", "RGB(30,30,35)"),
    custom_colors: window.GetProperty("SYSTEM.panel.custom.colors", false),   
    nogroupheader: window.GetProperty("SYSTEM.no.group.header", false),
    tag_separator: window.GetProperty("*USER.title-artist.separator", "|"),
    properties_separator: window.GetProperty("----------------------------", "----------------------------")
};

dragndrop = {
    enabled: window.GetProperty("SYSTEM.dragndrop.enabled", true),
    drag_id: -1,
    drop_id: -1,
    timerID: false,
    drag_in: false,
    drag_out: false
};

clipboard = {
    selection: null
};

columns = {
    playicon: window.GetProperty("SYSTEM.columns.playicon.enabled", true),
    playicon_x: 0,
    playicon_w: 0,
    tracknumber: window.GetProperty("SYSTEM.columns.tracknumber.enabled", true),
    tracknumber_x: 0,
    tracknumber_w: 0,
    title: window.GetProperty("SYSTEM.columns.title.pattern", 1),
    title_x: 0,
    title_w: 0,
    rating: window.GetProperty("SYSTEM.columns.rating.enabled", true),
    rating_x: 0,
    rating_w: 0,
    rating_timerID: false,
    rating_drag: false,
    mood: window.GetProperty("SYSTEM.columns.mood.enabled", true),
    mood_x: 0,
    mood_w: 0,
    mood_timerID: false,
    mood_drag: false,
    bitrate: window.GetProperty("SYSTEM.columns.bitrate.enabled", false),
    bitrate_x: 0,
    bitrate_w: 0,
    duration_x: 0,
    duration_w: 0,
    playcount: window.GetProperty("SYSTEM.columns.playcount.enabled", true)
};

list = {
    theme: false,
    first_launch: true,
    total: 0,
    total_gh: 0,
    total_with_gh: 0,
    nbvis: 0,
    gridx: 0,
    item: Array(),
    hlist: Array(),
    empty: Array(),
    groups: Array(),
    collapse: false,
    handlelist: null,
    metadblist_selection: plman.GetPlaylistSelectedItems(plman.ActivePlaylist),
    focus_id: 0,
    tocut: 0,
    mousewheel_scrollstep: window.GetProperty("SYSTEM.mousewheel.scrollstep", 3),
    nowplaying: 0,
    SHIFT_start_id: null,
    SHIFT_count: 0,
    inc_search_noresult: false,
    keypressed: false,
    buttonclicked: false,
    gradient_lines_show: window.GetProperty("*USER.items.gradient.lines", false)
};
row = {
    h: window.GetProperty("SYSTEM.row.height", 25),
    parity: 0,
    show_progress: window.GetProperty("*USER.show.progress.bar", true),
    buttons_hover: false
};
group = {
    nbrows_default: window.GetProperty("*USER.group.rows.number", 3),
    nbrows: 0,
    min_item_per_group: 5,
    type: window.GetProperty("SYSTEM.group.type", 0),
    key: window.GetProperty("SYSTEM.group Key", group_pattern_album),
    w: 0
};
toolbar = {
    h: 0,
    lock: window.GetProperty("SYSTEM.toolbar.lock", false),
    buttons: Array(),
    timerID_on: false,
    timerID_off: false,
    timerID1: false,
    timerID2: false,
    collapsed_y: -24,
    delta: 0,
    step: 3,
    state: false
};
vscrollbar = {
    theme: false,
    show: window.GetProperty("SYSTEM.vscrollbar.visible", true),
    visible: true,
    hover: false,
    x: 0,
    y: 0,
    default_w: get_system_scrollbar_width(),
    w: get_system_scrollbar_width(),
    h: 0,
    button_total: 2,
    default_step: window.GetProperty("SYSTEM.vscrollbar.step", 3),
    step: 3,
    arr_buttons: Array(),
    letter : null
};
scrollbarbt = {
    timerID1: false,
    timerID2: false,
    timer1_value: 400,
    timer2_value: 60
};
button_up = {
    img_normal: null,
    img_hover: null,
    img_down: null,
    x: 0,
    y: 0,
    w: vscrollbar.default_w,
    h: vscrollbar.default_w
};
button_down = {
    img_normal: null,
    img_hover: null,
    img_down: null,
    x: 0,
    y: 0,
    w: vscrollbar.default_w,
    h: vscrollbar.default_w
};
cursor = {
    bt: null,
    img_normal: null,
    img_hover: null,
    img_down: null,
    popup: null,
    x: 0,
    y: 0,
    w: vscrollbar.default_w,
    h: vscrollbar.default_w+3,
    default_h: vscrollbar.default_w+3,
    hover: false,
    drag: false,
    grap_y: 0,
    timerID: false,
    last_y: 0
};
cover = {
    show: window.GetProperty("*USER.cover.art.enabled", true),
    draw_glass_effect: window.GetProperty("*USER.cover.art.glass.effect.enabled", true),
    keepaspectratio: window.GetProperty("*USER.cover.keep.aspect.ratio", true),
    visible: true,
    margin: 6,
    w: 0,
    nbrows: 0,
    h: 0,
    top_offset: 0,
    load_timer: false
};

// stats globals (used in on_playback_time & on_playback_new_track Callbacks)
stats = {
    metadb: null,
    path_prefix: "",
    taggable_file: false,
    enabled: window.GetProperty("SYSTEM.statistics.enabled", false), 
    updated: false,
    foo_playcount: utils.CheckComponent("foo_playcount", true),
    tf_length_seconds: fb.TitleFormat("%length_seconds_fp%"),
    tf_first_played: fb.Titleformat("%first_played%"),
    tf_play_counter: fb.Titleformat("%play_counter%"),
    tf_play_count: fb.Titleformat("%play_count%"),
    time_elapsed: 0,
    delay: 0,
    limit: 0
};

//=================================================// Playlist load
function refresh_spv_cursor(pls) {
    
    reset_cover_timers();
    
    // RAZ actual list
    list.item.splice(0, list.item.length);
    list.tocut = 0;

    // calc ratio of the scroll cursor to calc the equivalent item for the full playlist (with gh)
    var ratio = (cursor.y-vscrollbar.y) / (vscrollbar.h-cursor.h);
    
    // calc idx of the item (of the full playlist with gh) to display at top of the panel list (visible)
    var idx = Math.round((list.total_with_gh - list.nbvis) * ratio);
    
    // search what's the item that is the first to display in the list, and calc the list.tocut if needed
    var start_id_min = Math.floor(idx / (group.nbrows+1));
    var b = 0;
    for(var id = start_id_min; id < list.total; id++) {
        b = id + (list.hlist[id]*group.nbrows);
        if(b >= idx) {
            break;
        };
    };
    // item (id) is found, now we check how many line are to cut (c)!
    if(b > idx) {
        var c = b - group.nbrows;
        for(var d = 1; d < group.nbrows+1; d++) {
            if(idx == c + d) {
                list.tocut = d;
                break;
            };
        };
    } else if(b == idx) {
        if(id==0) {
            list.tocut = group.nbrows;
        } else {
            if(list.hlist[id] > list.hlist[id-1]) {
                list.tocut = group.nbrows;
            } else {
                list.tocut = 0;
            };
        };
    };
   
    if(id<=0) {
        id = 0;
        var previous_group_key = null;
    } else {
        var previous_group_key = list.hlist[id-1];
    };
    
    var i = id;
    var k = 0;
    while(i < list.total && k<=list.nbvis+group.nbrows) {
        list.item.push(new item(i, k, 0));
        if(group.nbrows>0) {
            if(list.hlist[i] != previous_group_key) {
                list.item[k].gridx = 1;
                list.item[k].update_infos();
                k++;
                for(var j = 1; j < group.nbrows; j++) {
                    list.item.push(new item(i, k, j+1));
                    k++;
                };
                list.item.push(new item(i, k, 0));
            };
        };
        previous_group_key = list.hlist[i];
        k++;
        i++;
    };
    
    // affect group index of each track of each group in list.item[]
    set_grp_idx_all();
};

//=================================================// Playlist scroll down
function scrolldown_spv(pls, step) {
    
    if(list.item.length<=list.nbvis) return true;
    
    reset_cover_timers();
    
    var last_item_id = list.item[list.item.length-1].id;
    if(last_item_id >= list.total-1) {  // dernier item id = le dernier id de la playlist!
        var last_item_gridx = list.item[list.item.length-1].gridx;
        if(last_item_gridx>0) {
            var k = list.item.length;
            for(var j=last_item_gridx+1;j<=group.nbrows;j++) {
                list.item.push(new item(last_item_id, k, j));
                k++;
            };
            list.item.push(new item(last_item_id, k, 0));
        } else {
            // is last_item already visible? otherwise, no scroll to do, bottom reached!
            var idx_last_item_vis = list.tocut+list.nbvis-1;
            if(idx_last_item_vis>list.item.length-1) idx_last_item_vis = list.item.length-1;
            var last_item_vis_gridx = list.item[idx_last_item_vis].gridx;
            if(last_item_vis_gridx>0) {
                var last_item_vis_id = list.item[idx_last_item_vis].id - 1;
            } else {
                var last_item_vis_id = list.item[idx_last_item_vis].id;
            };
            if(last_item_vis_id >= last_item_id) {
                return true;
            } else {
                // scroll to do (no new item to add at bottom, but tocut index to increase)
                list.tocut++;
            };
        };
    } else {
        // on n'est pas sur le dernier id, on peut en ajouter un au tableau item!
        var last_item_group_key = list.hlist[last_item_id];
        var last_item_gridx = list.item[list.item.length-1].gridx;
        
        if(last_item_gridx > 0) {
            if(last_item_gridx < group.nbrows) {
                var next_item_id = last_item_id;
                var next_item_gridx = last_item_gridx + 1;
            } else {
                var next_item_id = last_item_id;
                var next_item_gridx = 0;
            };
        } else {
            var next_item_id = last_item_id + 1;
            if(list.hlist[next_item_id] != last_item_group_key) {
                if(group.nbrows>0) {
                    var next_item_gridx = 1;
                } else {
                    var next_item_gridx = 0;
                };
            } else {
                var next_item_gridx = 0;
            };
        };
        // add the next item (new one) to the array
        list.item.push(new item(next_item_id, list.item.length, next_item_gridx));
        if(list.item[list.item.length-2].gridx>0) {
            list.item[list.item.length-1].grp_idx = 0;
        } else {
            list.item[list.item.length-1].grp_idx = list.item[list.item.length-2].grp_idx + 1;
        };
        // remove the first item of the array, to always keep the same number of items in the Array
        list.item.shift();
    };
    
    var len = list.item.length;
    for(var i=0; i<len; i++) {
        list.item[i].idx = i;
        list.item[i].defaulty = toolbar.h + i * row.h;
        list.item[i].y = list.item[i].defaulty - (list.tocut * row.h);
    };
          
    setcursory();

};

//=================================================// Playlist scroll up
function scrollup_spv(pls, step) {

    if(list.item.length<list.nbvis) return true;
    
    reset_cover_timers();
    
    var first_item_id = list.item[0].id;
    
    if(first_item_id <= 0) {
        // is the first id already visible? otherwise, no scroll to do, top of the list is already reached!
        var first_item_vis_id = list.item[list.tocut].id;
        if(first_item_id >= first_item_vis_id) {
            if(group.nbrows > 0) {
                var first_item_gridx = list.item[0].gridx;
                if(first_item_gridx==1) {
                    if(list.tocut==0) {
                        return true;
                    } else {
                        list.tocut--;
                    };
                } else {
                    // prev item to add to complete the group header of the first item
                    var prev_item_id = first_item_id;
                    var prev_item_gridx = (first_item_gridx==0) ? group.nbrows : first_item_gridx - 1;
                    // add the next item (new one) to the array
                    list.item.unshift(new item(prev_item_id, 0, prev_item_gridx));
                    // set group index value of the new item
                    if(prev_item_gridx>0) {
                        list.item[0].grp_idx = 0;
                    } else {
                        if(list.item[1].gridx>0) {
                            set_grp_idx_first();
                        } else {
                            list.item[0].grp_idx = list.item[1].grp_idx - 1;
                        };
                    };
                    // remove the last item of the array, to always keep the same number of items in the Array
                    list.item.pop();
                };
            };
        } else {
            // scroll to do (no new item to add at top, but tocut index to decrease)
            list.tocut--;
        };
    } else {
        if(list.tocut>group.nbrows) {
            list.tocut--;
        } else {
            // on n'est pas sur le premier id, on peut en ajouter un au tableau item!
            var first_item_group_key = list.hlist[list.item[0].id];
            var first_item_gridx = list.item[0].gridx;
            
            if(first_item_gridx > 0) {
                if(first_item_gridx == 1) {
                    var prev_item_id = first_item_id - 1;
                    var prev_item_gridx = 0;
                } else {
                    var prev_item_id = first_item_id;
                    var prev_item_gridx = first_item_gridx - 1;
                };
            } else {
                var prev_item_id = first_item_id - 1;
                if(list.hlist[prev_item_id] != first_item_group_key) {
                    if(group.nbrows>0) {
                        prev_item_id = first_item_id;
                        prev_item_gridx = group.nbrows;
                    } else {
                        prev_item_gridx = 0;
                    };
                } else {
                    prev_item_gridx = 0;
                };
            };
            // add the next item (new one) to the array
            list.item.unshift(new item(prev_item_id, 0, prev_item_gridx));
            // set group index value of the new item
            if(prev_item_gridx>0) {
                list.item[0].grp_idx = 0;
            } else {
                if(list.item[1].gridx>0) {
                    set_grp_idx_first();
                } else {
                    list.item[0].grp_idx = list.item[1].grp_idx - 1;
                };
            };
            // remove the last item of the array, to always keep the same number of items in the Array
            if(list.item.length - list.tocut > list.nbvis+1+group.nbrows) {
                list.item.pop();
            };
        };
    };
    
    var len = list.item.length;
    for(i=0;i<len;i++) {
        list.item[i].idx = i;
        list.item[i].defaulty = toolbar.h + i * row.h;
        list.item[i].y = list.item[i].defaulty - (list.tocut * row.h);
    };
           
    setcursory();
};

//=================================================// Playlist load
function refresh_spv(pls, force) {
    
    var nbvis = Math.ceil((wh-toolbar.h)/row.h);
    var mid_nbvis = Math.round(nbvis / 2) - 1;
    
    g_tooltip.Text="";
    
    reset_cover_timers();
             
    // test if center focus item required   
    if(!force && list.item.length>0) {
        var vis_min_idx = list.item[list.tocut].id;
        var delta2max = (list.tocut+list.nbvis) - 1;
        if(delta2max<list.item.length) {
            vis_max_idx = (list.item[delta2max].gridx==0) ? list.item[delta2max].id : (list.item[delta2max].id - 1);
        } else {
            vis_max_idx = list.item[list.item.length-1].id;
        };
        if(list.focus_id>=vis_min_idx && list.focus_id<=vis_max_idx) {
            if(button_up.timerID && list.focus_id==0 && list.item[list.tocut].gridx!=1) {
                
            } else {
                return true;
            };
        };
    };
    
    var m;
    var focus_idx = 0;
    list.tocut = 0;

    // RAZ actual list
    list.item.splice(0, list.item.length);
    
    if(list.total<=0) return true;
    
    var r = list.focus_id - list.nbvis;
    if(r<=0) {
        r = 0;
        var previous_group_key = null;
    } else {
        var previous_group_key = list.hlist[r-1];
    };
    
    var i = r;
    var k = 0;

    while(i < list.total && k<=((group.nbrows>0?(list.nbvis*group.nbrows):list.nbvis)*2)) {
        list.item.push(new item(i, k, 0));
        if(group.nbrows>0) {
            if(list.hlist[i] != previous_group_key) {
                list.item[k].gridx = 1;
                list.item[k].update_infos();
                k++;
                for(var g=1;g<group.nbrows;g++) {
                    list.item.push(new item(i, k, g+1));
                    k++;
                };
                list.item.push(new item(i, k, 0));
            };
        };
        if(list.item[k].id == list.focus_id) focus_idx = k;
        previous_group_key = list.hlist[i];
        k++;
        i++;
    };
    
    // calc value of list.tocut
    if(list.item.length<=list.nbvis) {
        list.tocut = 0;
    } else {
        list.tocut = focus_idx - mid_nbvis;
        if(list.tocut<=0) {
            list.tocut = 0;
        };
        if(focus_idx+mid_nbvis+1>list.item.length-1) {
            list.tocut = list.item.length - list.nbvis;
        };
    };
    
    // affect group index of each track of each group in list.item[]
    set_grp_idx_all();

    if(vscrollbar.show) {
        if(list.item.length<=list.nbvis) vscrollbar.visible = false; else vscrollbar.visible=true;
    } else {
        vscrollbar.visible = false;
    };
      
    var ratio = list.nbvis / list.total_with_gh;
    if(ratio>1) ratio = 1;
    cursor.h = Math.round(ratio * vscrollbar.h);
    // boundaries for cursor height
    if(cursor.h>vscrollbar.h) cursor.h = vscrollbar.h;
    if(cursor.h<cursor.default_h) cursor.h = cursor.default_h;
    // redraw cursor image
    set_scroller();
    // set cursor position
    setcursory();

};

function set_grp_idx_all() {
    
    if(list.item.length<=0) return true;
    
    if(group.nbrows>0) {
        var id = list.item[0].id;
        var key1 = list.hlist[id];
        var key2 = null;
        var grp_idx = 0;
        if(list.item[0].gridx==0) {
            while(id>0) {
                key2 = list.hlist[id-1];
                if(key2 != key1) {
                    id = 0;
                } else {
                    grp_idx++;
                };
                id--;
            };
        };
        id = list.item[0].id;
        for(var i=0; i < list.item.length; i++) {
            if(list.item[i].gridx==0) {
                list.item[i].grp_idx = grp_idx;
                grp_idx++;
            } else {
                list.item[i].grp_idx = 0;
                grp_idx = 0;
            };
        };
    } else {
        for(var i=0; i < list.item.length; i++) {
            list.item[i].grp_idx = list.item[i].id;
        };
    };
};

function set_grp_idx_first() {
    
    if(list.item.length<=0) return true;
    
    if(group.nbrows>0) {
        var id = list.item[0].id;
        var key1 = list.hlist[id];
        var key2 = null;
        var grp_idx = 0;
        if(list.item[0].gridx==0) {
            while(id>0) {
                key2 = list.hlist[id-1];
                if(key2 != key1) {
                    id = 0;
                } else {
                    grp_idx++;
                };
                id--;
            };
            list.item[0].grp_idx = grp_idx;
        } else {
            list.item[0].grp_idx = 0;
        };
    } else {
        for(var i=0; i < list.item.length; i++) {
            list.item[i].grp_idx = list.item[i].id;
        };
    };
};

//=================================================// Offset calculations
function setcursory() {
    if(list.item.length<=list.nbvis) {
        cursor.y = vscrollbar.y;
    } else if(list.item.length>list.tocut){      
        var first_id = list.item[list.tocut].id;
        if(list.item[list.tocut].gridx == 0) {
            var ratio = (first_id + ((list.hlist[first_id]-0) * group.nbrows)) / (list.total_with_gh-list.nbvis);
        } else {
            var ratio = (first_id + ((list.hlist[first_id]-0) * group.nbrows) - (group.nbrows+1-list.item[list.tocut].gridx)  ) / (list.total_with_gh-list.nbvis);
        };
        if(ratio<0) ratio = 0;
        if(ratio>1) ratio = 1;
        cursor.y = vscrollbar.y + Math.round((vscrollbar.h-cursor.h) * ratio);
    };
};

function init_active_pls() {
    var temp_key1;
    var temp_key2;
    var gh_count = 0;
    var empty = 0;
    var count = 0;
    var grp_length = 0;
    var metadb;
       
    //var d1 = new Date();
    //var t1 = d1.getSeconds()*1000 + d1.getMilliseconds();
    //fb.trace("avant="+t1);
    
    list.hlist.splice(0, list.hlist.length);
    list.empty.splice(0, list.empty.length);
    list.groups.splice(0, list.groups.length);
    
    if(list.handlelist) list.handlelist.Dispose();
    list.handlelist = plman.GetPlaylistItems(plman.ActivePlaylist);
    list.total = list.handlelist.Count;
        
    if(group.nbrows>0) {
        for (var i = 0; i < list.total; i++) {
            metadb = list.handlelist.Item(i);
            temp_key2 = tf_group_key.EvalWithMetadb(metadb);
            if(temp_key1 != temp_key2){
                if(i>0) {
                    list.groups.push(count);
                };
                //list.groups.push(list.collapse);
                if(i>0 && count<group.min_item_per_group) {
                    empty += (group.min_item_per_group - count);
                };
                count = 0;
                //grp_length = 0;
                gh_count++;
                temp_key1 = temp_key2;
            };
            count++;
            //grp_length += metadb.Length;
            list.hlist.push(gh_count);
            list.empty.push(empty);
            // on last item
            if(i == list.total-1) {
                list.groups.push(count);
            };
        };
    } else {
        for (var i = 0; i < list.total; i++) {
            list.hlist.push(0);
            list.empty.push(0);
        };
    };
    list.total_gh = gh_count;
    list.total_with_gh = list.total + (list.total_gh * group.nbrows);
    
    //var d2 = new Date();
    //var t2 = d2.getSeconds()*1000 + d2.getMilliseconds();
    //fb.trace("pl old apres="+t2+" ==> delta = "+Math.round(t2-t1)+" /list.hlist.length="+list.hlist.length);
};

//=================================================// Colour & Font Callbacks
function on_font_changed() {
    get_font();
    columns.duration_w = 0;
    columns.bitrate_w = 0;
    refresh_spv(plman.ActivePlaylist, true);
    window.Repaint();
};

function on_colors_changed() {
    get_colors();
    init_icons();
    redraw_stub_images();
    init_vscrollbar_buttons();
    set_scroller();
    g_image_cache = new image_cache;
    CollectGarbage();
    window.Repaint();
};

//=================================================// Init
function on_init() {   
    tf_group_key = fb.TitleFormat(group.key);
};
on_init();

//=================================================// OnSize
function on_size() {
    if (!window.Width || !window.Height) return;
    
    window.DlgCode = DLGC_WANTALLKEYS;
    
    bool_on_size = true;
    
    if(g_instancetype == 0) { // CUI
        window.MinWidth = 390;
        window.MinHeight = 100;  
    } else if(g_instancetype == 1) { // DUI
        window.MinWidth = 390;
        window.MinHeight = 100;
    };
    
    ww = window.Width;
    wh = window.Height;
    
    if(wh<100) wh = 100;
    
    // set wallpaper
    panel.wallpaper_img = FormatWP(gdi.Image(panel.wallpaper_path), ww, wh);
    
    get_font();
    get_colors();
    init_icons();
    
    recalc_datas();
    redraw_stub_images();
       
    // only on first launch
    if(list.first_launch) {
        list.first_launch = false;
        on_playlist_switch();
    } else {
        // if just a window resize, refresh list.item and repaint :)
        refresh_spv(plman.ActivePlaylist, true);
        vscrollbar.w = vscrollbar.visible?vscrollbar.default_w:0;
        window.Repaint();
    }
};

//=================================================// OnPaint
function on_paint(gr) {
        
    // default background
    if(panel.opacity>=255) {
        gr.FillSolidRect(0, 0, ww, wh, g_backcolor);
    } else {
        if(panel.show_wallpaper) {
            if(panel.wallpaper_img) {
                gr.FillSolidRect(0, 0, ww, wh, g_backcolor);
                gr.DrawImage(panel.wallpaper_img, 0, 0, ww, wh, 0, 0, panel.wallpaper_img.Width, panel.wallpaper_img.Height, 0, 255-panel.opacity);
            } else {
                gr.FillSolidRect(0, 0, ww, wh, RGBA(g_backcolor_R, g_backcolor_G, g_backcolor_B, panel.opacity));
            };
        } else {
            gr.FillSolidRect(0, 0, ww, wh, RGBA(g_backcolor_R, g_backcolor_G, g_backcolor_B, panel.opacity));
        };    
    };

    // draw items
    if(list.total>0){
        g_playing_item_y = null;
        var draw_limit = list.tocut+list.nbvis+group.nbrows+1;
        if(draw_limit>list.item.length) draw_limit = list.item.length;
        for(var idx=list.tocut;idx<draw_limit;idx++) {
            list.item[idx].draw(gr, list.item[idx].id, idx);
        };
    } else {
        vscrollbar.visible = false;
        vscrollbar.w = 0;

        if(fb.PlaylistCount>0) {
            var text_top = fb.GetPlaylistName(plman.ActivePlaylist);
            var text_bot = "This playlist is empty";
        } else {
            var text_top = "Br3tt's WSH Playlist Viewer";
            var text_bot = "Create a playlist to start!";
        };
        // if empty playlist, display text info
        gr.SetTextRenderingHint(5);
        gr.DrawString(text_top, gdi.Font("tahoma", 17, 0), g_textcolor&0x40ffffff, 0, toolbar.h-20, ww, wh, cc_stringformat);
        gr.DrawString(text_bot, gdi.Font("tahoma", 13, 0), g_textcolor&0x40ffffff, 0, toolbar.h+20, ww, wh, cc_stringformat);
        gr.FillGradRect(40, toolbar.h+Math.floor(wh/2), ww-80, 1, 0, 0, g_textcolor&0x40ffffff, 0.5);

    };
    
    // draw toolbar
    if(!toolbar.state && !toolbar.timerID1) {
        // draw marker to indicate toolbar expandable
        gr.DrawLine(Math.floor((ww-vscrollbar.w)/2)-3, 2, Math.floor((ww-vscrollbar.w)/2)+3, 2, 1.0, g_textcolor&0x44ffffff);
        gr.DrawLine(Math.floor((ww-vscrollbar.w)/2)-2, 3, Math.floor((ww-vscrollbar.w)/2)+0, 5, 1.0, g_textcolor&0x44ffffff);
        gr.DrawLine(Math.floor((ww-vscrollbar.w)/2)+2, 3, Math.floor((ww-vscrollbar.w)/2)+1, 4, 1.0, g_textcolor&0x44ffffff);
    }
    if(toolbar.state || toolbar.timerID1) {
        gr.SetSmoothingMode(2);
        gr.FillRoundRect(09, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar.w-20 + 2, Math.abs(toolbar.collapsed_y) + 10 + 1, 6, 6, RGBA(0,0,0,60));
        gr.FillRoundRect(10, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar.w-20, Math.abs(toolbar.collapsed_y) + 10, 5, 5, RGBA(0,0,0,190));
        gr.DrawRoundRect(11, (toolbar.collapsed_y + toolbar.delta) - 10, ww-vscrollbar.w-20-2, Math.abs(toolbar.collapsed_y) + 10-1, 4, 4, 1.0, RGBA(250,250,250,40));
        gr.SetSmoothingMode(0);
        // draw toolbar buttons
        for(i=0;i<toolbar.buttons.length;i++) {
            switch (i) {
             case 0:
                toolbar.buttons[i].draw(gr, 16, (toolbar.collapsed_y + toolbar.delta) + 3, 255);
                break;
             case 1:
                toolbar.buttons[i].draw(gr, ww-vscrollbar.w-30-15, (toolbar.collapsed_y + toolbar.delta) + 3, 255);
                break;
            };
        };
    };

    // draw vscrollbar
    if(vscrollbar.visible && vscrollbar.show) {
        // draw scrollbar background
        try {
            vscrollbar.theme.SetPartAndStateId(6, 1);
            vscrollbar.theme.DrawThemeBackground(gr, ww-vscrollbar.w, 0, vscrollbar.w, wh);
        } catch(e) {
            //gr.FillGradRect(ww-vscrollbar.w, 0, vscrollbar.w, wh, 0, RGBA(0,0,0,10), RGBA(255,255,255,5), 0.5);
            gr.FillSolidRect(ww-vscrollbar.w, 0, 1, wh, RGBA(0,0,0,20));
        };
        
        // draw cursor
        cursor.bt.draw(gr, ww-vscrollbar.w, cursor.y, 255);
        
        try {
            vscrollbar.theme.SetPartAndStateId(9, 1);
            vscrollbar.theme.DrawThemeBackground(gr, ww-vscrollbar.w, cursor.y, cursor.w, cursor.h);
        } catch(e) {};
        
        // draw scrollbar buttons (up/down)
        for(i=0;i<vscrollbar.arr_buttons.length;i++) {
            switch (i) {
             case 0:
                vscrollbar.arr_buttons[i].draw(gr, ww-vscrollbar.w, button_up.y, 255);
                break;
             case 1:
                vscrollbar.arr_buttons[i].draw(gr, ww-vscrollbar.w, button_down.y, 255);
                break;
            };
        };
        
        if(cursor.drag) {
            vscrollbar.letter = list.item[list.tocut].group_key.substring(0,1).toUpperCase();
            cursor.popup && gr.DrawImage(cursor.popup, ww-vscrollbar.w-cursor.popup.Width, cursor.y+Math.floor(cursor.h/2)-Math.floor(cursor.popup.Height/2), cursor.popup.Width, cursor.popup.Height, 0, 0, cursor.popup.Width, cursor.popup.Height, 0, 155);
            cursor.popup && gr.GdiDrawText(vscrollbar.letter, gdi.Font("segoe ui", 14, 0), g_backcolor, ww-vscrollbar.w-cursor.popup.Width, cursor.y+Math.floor(cursor.h/2)-Math.floor(cursor.popup.Height/2), cursor.popup.Width-5, cursor.popup.Height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
        };
    };
    
    if(panel.show_shadow_border) {
        // vertical left borders (Sunken effect)
        gr.FillSolidRect(0, toolbar.h-1, 1, wh+1, RGBA(0,0,0,30));
        gr.FillSolidRect(1, toolbar.h-1, 1, wh+1, RGBA(0,0,0,15));
        gr.FillSolidRect(2, toolbar.h-1, 1, wh+1, RGBA(0,0,0,5));
        // and the right one, only if scrollbar is hidden
        if(!vscrollbar.visible || !vscrollbar.show) {
            gr.FillSolidRect(ww-vscrollbar.w-1, toolbar.h-1, 1, wh+1, RGBA(0,0,0,30));
            gr.FillSolidRect(ww-vscrollbar.w-2, toolbar.h-1, 1, wh+1, RGBA(0,0,0,15));
            gr.FillSolidRect(ww-vscrollbar.w-3, toolbar.h-1, 1, wh+1, RGBA(0,0,0,5));
        } else {
            gr.FillSolidRect(ww-vscrollbar.w-1, toolbar.h-1, 1, wh+1, RGBA(0,0,0,10));
            gr.FillSolidRect(ww-vscrollbar.w-2, toolbar.h-1, 1, wh+1, RGBA(0,0,0,5));
        };
        // top border
        gr.FillSolidRect(0, 0, ww-vscrollbar.w, 1, RGBA(0,0,0,30));
        gr.FillSolidRect(1, 1, ww-vscrollbar.w, 1, RGBA(0,0,0,15));
        gr.FillSolidRect(2, 2, ww-vscrollbar.w, 1, RGBA(0,0,0,5));
        // bot border
        gr.FillSolidRect(0, wh-1, ww-vscrollbar.w, 1, RGBA(0,0,0,30));
        gr.FillSolidRect(1, wh-2, ww-vscrollbar.w, 1, RGBA(0,0,0,15));
        gr.FillSolidRect(2, wh-3, ww-vscrollbar.w, 1, RGBA(0,0,0,5));
    };

    // Incremental Search Tooltip
    if(g_search_string.length>0) {
        gr.SetSmoothingMode(2);
        var tt_x = Math.floor(((ww-vscrollbar.w) / 2) - (((g_search_string.length*13)+(10*2)) / 2));
        var tt_y = Math.floor((wh/2) - 30);
        var tt_w = Math.round((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        gr.FillRoundRect(tt_x, tt_y, tt_w, tt_h, 5, 5, RGBA(0,0,0,150));
        gr.DrawRoundRect(tt_x, tt_y, tt_w, tt_h, 5, 5, 2.0, RGBA(255,255,255,200));
        gr.DrawRoundRect(tt_x+2, tt_y+2, tt_w-4, tt_h-4, 3, 3, 1.0, RGBA(0,0,0,150));
        gr.GdiDrawText(g_search_string, incsearch_font_big, RGB(0,0,0), tt_x+1, tt_y+1 , tt_w , tt_h, DT_CENTER | DT_NOPREFIX | DT_CALCRECT | DT_VCENTER);
        gr.GdiDrawText(g_search_string, incsearch_font_big, list.inc_search_noresult?RGB(255,75,75):RGB(250,250,250), tt_x, tt_y , tt_w , tt_h, DT_CENTER | DT_NOPREFIX | DT_CALCRECT | DT_VCENTER);
    };
    
};

//=================================================// Mouse Callbacks
function on_mouse_lbtn_down(x, y) {

    g_drag = true;
    
    bool_on_size = false;
    
    var act_pls = plman.ActivePlaylist;
    
    // check toolbar buttons
    if(toolbar.state) {
        for(var j=0;j<toolbar.buttons.length;j++) {
            toolbar.buttons[j].checkstate("down", x, y);
        };
    };
    if(y>toolbar.delta) {
        // check items
        var len = list.item.length;
        row.buttons_hover = false;
        for(var i=0;i<len;i++) {
            list.item[i].checkstate("down", x, y, i);
        };
    };
    
    // check scrollbar
    if(vscrollbar.visible && vscrollbar.show) {
        if(cursor.bt.checkstate("down", x, y)==ButtonStates.down) {
            cursor.drag = true;
            cursor.grap_y = y - cursor.y;
            cursor.last_y = cursor.y;
        };
        if(vscrollbar.hover && !cursor.drag) {
            vscrollbar.step = list.nbvis;
            if(y<cursor.y) {
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(vscrollbar.step);
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        on_mouse_wheel(vscrollbar.step);
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            if(vscrollbar.hover) {
                                if(mouse_x>ww-vscrollbar.w && cursor.y > mouse_y) {
                                    on_mouse_wheel(vscrollbar.step);
                                };
                            };
                        }, scrollbarbt.timer2_value+30);
                    }, scrollbarbt.timer1_value);
                };
            } else {
                if(!list.buttonclicked) {
                    list.buttonclicked = true;
                    on_mouse_wheel(-1*vscrollbar.step);
                    scrollbarbt.timerID1 = window.SetTimeout(function () {
                        on_mouse_wheel(-1*vscrollbar.step);
                        scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                        scrollbarbt.timerID1 = false;
                        scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                        scrollbarbt.timerID2 = window.SetInterval(function () {
                            if(vscrollbar.hover) {
                                if(mouse_x>ww-vscrollbar.w && cursor.y+cursor.h < mouse_y) {
                                    on_mouse_wheel(-1*vscrollbar.step);
                                };
                            };
                        }, scrollbarbt.timer2_value+30);
                    }, scrollbarbt.timer1_value);
                };
            };
        };
        // check other vscrollbar buttons
        for(i=0;i<vscrollbar.arr_buttons.length;i++) {
            switch(i) {
             case 0:
                if(vscrollbar.arr_buttons[i].checkstate("down", x, y)==ButtonStates.down) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        scrollup_spv(act_pls, 1);
                        window.Repaint();
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            reset_cover_timers();
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                scrollup_spv(act_pls, 1);
                                window.Repaint();
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                };
                break;
             case 1:
                if(vscrollbar.arr_buttons[i].checkstate("down", x, y)==ButtonStates.down) {
                    if(!list.buttonclicked) {
                        list.buttonclicked = true;
                        scrolldown_spv(act_pls, 1);
                        window.Repaint();
                        scrollbarbt.timerID1 = window.SetTimeout(function () {
                            reset_cover_timers();
                            scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                            scrollbarbt.timerID1 = false;
                            scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                            scrollbarbt.timerID2 = window.SetInterval(function () {
                                scrolldown_spv(act_pls, 1);
                                window.Repaint();
                            }, scrollbarbt.timer2_value);
                        }, scrollbarbt.timer1_value);
                    };
                };
                break;
            };
        };
    };
};

function on_mouse_lbtn_dblclk(x, y, mask) {

    if(y<toolbar.delta) {
        ShowNowPlaying();
    } else if(x<ww-vscrollbar.w) {
        var len = list.item.length;
        row.buttons_hover = false;
        for(var i=0;i<len;i++) {
            list.item[i].checkstate("dblclk", x, y, i);
        };
    } else {
        on_mouse_lbtn_down(x, y);
    };
};

function on_mouse_lbtn_up(x, y) {
    
    vscrollbar.step = vscrollbar.default_step;

    // scrollbar button up and down RESET
    list.buttonclicked = false;
    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
    scrollbarbt.timerID1 = false;
    scrollbarbt.timerID2 && window.ClearTimeout(scrollbarbt.timerID2);
    scrollbarbt.timerID2 = false;

    // check toolbar buttons
    if(toolbar.state) {
        for(var j=0;j<toolbar.buttons.length;j++) {
            switch(j) {
                case 0:
                    if(toolbar.buttons[j].checkstate("up", x, y)==ButtonStates.hover) {
                        g_menu_displayed = true;
                        settings_menu(x, y);
                    };
                    break;
                case 1:
                    if(toolbar.buttons[j].checkstate("up", x, y)==ButtonStates.hover) {
                        g_menu_displayed = true;
                        sort_group_menu(x, y);
                    };
                    break;
            };
        };
    };

    if(list.total>0) {
      
        // check scrollbar buttons
        cursor.bt.checkstate("up", x, y);
        for(i=0;i<vscrollbar.arr_buttons.length;i++) {
            vscrollbar.arr_buttons[i].checkstate("up", x, y);
        };
        
        if(cursor.drag) {
            window.RepaintRect(ww-vscrollbar.w-cursor.popup.Width-5, 0, cursor.popup.Width+vscrollbar.w+5, wh);
            cursor.drag = false;
            //setcursory();
        } else {
            // check items
            var len = list.item.length;
            row.buttons_hover = false;
            for(i=0;i<len;i++) {
                list.item[i].checkstate("up", x, y, i);
            };
        };
        window.Repaint();
    };


    // Drop items after a drag'n drop outside the playlist (e.g. to a WSH playlist tab manager panel)
    if(dragndrop.drag_out) {
        if(!panel.ishover) {
            window.NotifyOthers("WSH_playlist_drag_drop", list.metadblist_selection);
            dragndrop.drag_out = false;
        };
    };
    // Drop items after a drag'n drop inside the panel playlist
    if(dragndrop.drag_in) {
        if(panel.ishover && dragndrop.drag_id>=0 && dragndrop.drop_id>=0){
            var nb_selected_items = list.metadblist_selection.Count;
            if(dragndrop.drop_id > dragndrop.drag_id) {
                // on pointe sur le dernier item de la selection si on move vers le bas
                var new_drag_pos = list.handlelist.Find(list.metadblist_selection.item(nb_selected_items-1));
            } else {
                // on pointe sur le 1er item de la selection si on move vers le haut
                var new_drag_pos = list.handlelist.Find(list.metadblist_selection.item(0));
            };
            var move_delta = dragndrop.drop_id - new_drag_pos;
            plman.MovePlaylistSelection(plman.ActivePlaylist, move_delta);
        };
    };
    dragndrop.drag_id = -1;
    dragndrop.drop_id = -1;
    dragndrop.drag_in = false;
    dragndrop.drag_out = false;
    dragndrop.timerID && window.ClearTimeout(dragndrop.timerID);
    dragndrop.timerID = false;
    window.SetCursor(IDC_ARROW);
    
    g_drag = false;
    
    // toolbar collapse if mouse out after a lbtn up
    if(!toolbar.lock) {
        if(y>30 || x<10 || x>ww-vscrollbar.w-10) {
            if(toolbar.delta==0) {
                toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                toolbar.timerID_on = false;
            };
            if(toolbar.state) {
                if(!toolbar.timerID_off) {
                    if(toolbar.delta == toolbar.collapsed_y*-1) {
                        toolbar.timerID_off = window.SetTimeout(function() {
                            if(!toolbar.timerID2) {
                                toolbar.timerID2 = window.SetInterval(function() {
                                    toolbar.delta -= toolbar.step;
                                    if(toolbar.delta <= 0) {
                                        toolbar.delta = 0;
                                        toolbar.state = false;
                                        window.ClearInterval(toolbar.timerID2);
                                        toolbar.timerID2 = false;
                                    };
                                    window.RepaintRect(0, 0, ww, 30);
                                }, 30);
                            } ;
                            toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                            toolbar.timerID_off = false;
                        }, 400);
                    };
                };   
            };
        };
    };
};

function on_mouse_rbtn_down(x, y) {
    
    bool_on_size = false;
    
    var len = list.item.length;
    row.buttons_hover = false;
    for(var i=0;i<len;i++) {
        if(list.item[i].checkstate("right", x, y, i)==-1) break;
    };
};

function on_mouse_rbtn_up(x, y) {
    if(!utils.IsKeyPressed(VK_SHIFT)) {
        return true;
    };
};

function on_mouse_move(x, y) {
    var txt = "";
    show_tooltip = false;
    
    if(x==mouse_x && y==mouse_y) return true;
    
    var act_pls = plman.ActivePlaylist;
    
    panel.ishover = (x>=0 && x<=ww && y>=0 && y<=wh);
    if(dragndrop.enabled && (dragndrop.drag_in || dragndrop.drag_out)) window.SetCursor(IDC_HELP); else window.SetCursor(IDC_ARROW);

    if(y>toolbar.delta) {
        var len = list.item.length;
        var move_limit = list.tocut+list.nbvis+group.nbrows+1;
        if(move_limit>len) move_limit = len;
        row.buttons_hover = false;
        for(var j=list.tocut;j<move_limit;j++) {
            list.item[j].checkstate("move", x, y, j);
            if(list.item[j].ishover && x>columns.title_x && x<columns.title_x+columns.title_w) {
                if(group.nbrows==0 || (columns.title==1 && list.item[j].artist!=list.item[j].albumartist) || columns.title==2) {
                    txt = list.item[j].title+" "+panel.tag_separator+" "+list.item[j].artist;
                } else {
                    txt = list.item[j].title;
                };
                if(txt) {
                    if(txt.length>0 && list.item[j].tooltip && !g_tooltip_timer) {
                        show_tooltip = true;
                    }
                };
                if(g_tooltip.Text != txt) {     
                    g_tooltip.Deactivate();
                    g_tooltip.TrackActivate = true;
                    g_tooltip.Text = txt ? txt : "";
                    g_tooltip.TrackPosition(columns.title_x-6, list.item[j].y+Math.floor(row.h/2)-(18/2));
                };
            };
        };
    } else {
        // check toolbar buttons
        if(toolbar.state) {
            for(j=0;j<toolbar.buttons.length;j++) {
                toolbar.buttons[j].checkstate("move", x, y);
            };
        };
    };

    if(show_tooltip) {
        g_tooltip.Activate();
        g_tooltip.TrackActivate = true;
    } else {
        g_tooltip.Deactivate();
        g_tooltip.TrackActivate = false;
        g_tooltip.Text="";
    }
    
    if(list.item.length>0 && vscrollbar.visible && vscrollbar.show) {
        vscrollbar.hover = (x>=ww-vscrollbar.w && x<=ww && y>=vscrollbar.y && y<=vscrollbar.y+vscrollbar.h);
        cursor.hover = (x>=cursor.x && x<=cursor.x+cursor.w && y>=cursor.y && y<=cursor.y+cursor.h);
        // check buttons
        cursor.bt.checkstate("move", x, y);
               
        for(var i=0;i<vscrollbar.arr_buttons.length;i++) {
            vscrollbar.arr_buttons[i].checkstate("move", x, y);
        };
        if(cursor.drag && mouse_y!=y) {
            reset_cover_timers();
            cursor.y = y - cursor.grap_y;
            // check boundaries
            if(cursor.y<vscrollbar.y) cursor.y = vscrollbar.y;
            if(cursor.y>vscrollbar.y+vscrollbar.h-cursor.h) cursor.y = vscrollbar.y+vscrollbar.h-cursor.h;
            if(!cursor.timerID) {
                cursor.timerID = window.SetTimeout(function() {
                    refresh_spv_cursor(act_pls);
                    window.Repaint();
                    cursor.timerID && window.ClearTimeout(cursor.timerID);
                    cursor.timerID = false;
                }, 30);
            };
        };
    };
    
    show_tooltip = false;
    
    if(dragndrop.drag_in) {
        if(y<toolbar.h && y > toolbar.h-row.h) {
            if(!list.buttonclicked) {
                list.buttonclicked = true;
                scrollbarbt.timerID1 = window.SetInterval(function () {
                    reset_cover_timers();
                    for(i=0;i<list.mousewheel_scrollstep;i++) {
                        scrollup_spv(act_pls, 1);
                    };
                    window.Repaint();
                }, 100);
            };
        } else if(y>wh && y < wh+row.h) {
            if(!list.buttonclicked) {
                list.buttonclicked = true;
                scrollbarbt.timerID1 = window.SetInterval(function () {
                    reset_cover_timers();
                    for(i=0;i<list.mousewheel_scrollstep;i++) {
                        scrolldown_spv(act_pls, 1);
                    };
                    window.Repaint();
                }, 100);
            };
        } else {
            scrollbarbt.timerID1 && window.ClearInterval(scrollbarbt.timerID1);
            scrollbarbt.timerID1 = false;
            list.buttonclicked = false;
            if(Math.floor((y-toolbar.h)/row.h)!=Math.floor((mouse_y-toolbar.h)/row.h)) {
                if(!dragndrop.timerID) {
                    dragndrop.timerID = window.SetTimeout(function() {
                        window.Repaint();
                        dragndrop.timerID && window.ClearTimeout(dragndrop.timerID);
                        dragndrop.timerID = false;
                    }, 30);
                };
            };
        };
    };
    
    // hide/show toolbar
    if(!toolbar.lock && !g_drag) {
        if(y>=0 && y<=15 && x>10 && x<ww-vscrollbar.w-10) {
            if(!row.buttons_hover && !dragndrop.drag_in && !dragndrop.drag_out) {
                if(toolbar.delta==toolbar.collapsed_y*-1) {
                    toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                    toolbar.timerID_off = false;
                };
                if(!toolbar.timerID_on) {
                    if(toolbar.delta==0) {
                        toolbar.timerID_on = window.SetTimeout(function() {
                            toolbar.timerID2 && window.ClearInterval(toolbar.timerID2);
                            toolbar.timerID2 = false;
                            if(!toolbar.timerID1) {
                                toolbar.timerID1 = window.SetInterval(function() {
                                    toolbar.delta += toolbar.step;
                                    if(toolbar.collapsed_y + toolbar.delta >= 0) {
                                        toolbar.delta = toolbar.collapsed_y*-1;
                                        toolbar.state = true;
                                        window.ClearInterval(toolbar.timerID1);
                                        toolbar.timerID1 = false;
                                    };
                                    window.RepaintRect(0, 0, ww, 30);
                                }, 30);
                            };
                            toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                            toolbar.timerID_on = false;
                        }, 400);
                    } else if(toolbar.timerID2) {
                        toolbar.timerID2 && window.ClearInterval(toolbar.timerID2);
                        toolbar.timerID2 = false;
                        if(!toolbar.timerID1) {
                            toolbar.timerID1 = window.SetInterval(function() {
                                toolbar.delta += toolbar.step;
                                if(toolbar.collapsed_y + toolbar.delta >= 0) {
                                    toolbar.delta = toolbar.collapsed_y*-1;
                                    toolbar.state = true;
                                    window.ClearInterval(toolbar.timerID1);
                                    toolbar.timerID1 = false;
                                };
                                window.RepaintRect(0, 0, ww, 30);
                            }, 30);
                        };
                    };
                };
            };
        } else if(y>30 || x<10 || x>ww-vscrollbar.w-10) {
            if(toolbar.delta==0) {
                toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
                toolbar.timerID_on = false;
            };
            if(toolbar.state) {
                if(!toolbar.timerID_off) {
                    if(toolbar.delta == toolbar.collapsed_y*-1) {
                        toolbar.timerID_off = window.SetTimeout(function() {
                            if(!toolbar.timerID2) {
                                toolbar.timerID2 = window.SetInterval(function() {
                                    toolbar.delta -= toolbar.step;
                                    if(toolbar.delta <= 0) {
                                        toolbar.delta = 0;
                                        toolbar.state = false;
                                        window.ClearInterval(toolbar.timerID2);
                                        toolbar.timerID2 = false;
                                    };
                                    window.RepaintRect(0, 0, ww, 30);
                                }, 30);
                            } ;
                            toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                            toolbar.timerID_off = false;
                        }, 400);
                    };
                };   
            };
        };
    };
   
    mouse_x = x;
    mouse_y = y;
};

function on_mouse_wheel(delta) {
    
    g_tooltip.Text="";
     
    reset_cover_timers();
    var act_pls = plman.ActivePlaylist;
    var abs_delta = Math.abs(delta);
    if(abs_delta==1) {
        if(delta>0) {
            for(var i=0;i<list.mousewheel_scrollstep;i++) {
                scrollup_spv(act_pls, 1);
            };
            window.Repaint();
        } else {
            for(var i=0;i<list.mousewheel_scrollstep;i++) {
                scrolldown_spv(act_pls, 1);
            };
            window.Repaint();
        };
    } else if(delta>0) {
        for(i=0;i<delta;i++) {
            scrollup_spv(act_pls, 1);
        };
        window.Repaint();
    } else {
        for(i=0;i<abs_delta;i++) {
            scrolldown_spv(act_pls, 1);
        };
        window.Repaint();
    };
};

function on_mouse_leave() {

    // check buttons
    if(list.total>0) {
        cursor.bt.checkstate("leave", 0, 0);
    };
    for(var i in vscrollbar.arr_buttons) {
        vscrollbar.arr_buttons[i].checkstate("leave", 0, 0);
    };
    for(var j in toolbar.buttons) {
        toolbar.buttons[j].checkstate("leave", 0, 0);
    };

    var len = list.item.length;
    row.buttons_hover = false;
    for(i=0;i<len;i++) {
        list.item[i].checkstate("leave", 0, 0, i);
    };

    // toolbar is to hide if visible or amorced
    if(toolbar.delta==0) {
        toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
        toolbar.timerID_on = false;
    };
    if(!toolbar.lock && !g_drag) {
        if(!g_menu_displayed) {
            if(!toolbar.timerID_off) {
                toolbar.timerID_off = window.SetTimeout(function() {
                    if(!toolbar.timerID2) {
                        toolbar.timerID2 = window.SetInterval(function() {
                            toolbar.delta -= toolbar.step;
                            if(toolbar.delta <= 0) {
                                toolbar.delta = 0;
                                toolbar.state = false;
                                window.ClearInterval(toolbar.timerID2);
                                toolbar.timerID2 = false;
                            };
                            window.RepaintRect(0, 0, ww, 30);
                        }, 30);
                    } ;
                    toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                    toolbar.timerID_off = false;
                }, 400);
            };   
        };
    };
    
    window.Repaint();
};

//=================================================// Callbacks

function refresh_playlist_content() {
    init_active_pls();
    var act_pls = plman.ActivePlaylist;
    list.focus_id = plman.GetPlaylistFocusItemIndex(act_pls);
    refresh_spv(act_pls, true);
    vscrollbar.w = vscrollbar.visible?vscrollbar.default_w:0;
    window.Repaint();
};

function on_playlist_switch() {
    if(isQueuePlaylistActive()) {
        ShowPlaylistQueue(0);
    } else {
        // test if there is an active playlist focused (may happen whenyou delete a playlist from pl manager)
        var act_pls = plman.ActivePlaylist;
        var pls_count = plman.PlaylistCount;
        if(act_pls < 0 || act_pls > pls_count) {
            if(pls_count>0) {
                act_pls = 0;
                plman.ActivePlaylist = 0;
            };
        };
        refresh_playlist_content();
    };
};

function on_playlist_items_added(playlist_idx) {
    if(playlist_idx==plman.ActivePlaylist) {
        // timer to avoid freeze due to many tracks added at the same time, with this tweaks, refresh will be done when last item added only!
        if(g_add_items_timerID) {
            g_add_items_timerID && window.ClearTimeout(g_add_items_timerID);
            g_add_items_timerID = false;
        } else {
            g_add_items_timerID = window.SetTimeout(function() {
                refresh_playlist_content();
                plman.SetActivePlaylistContext();
                g_add_items_timerID && window.ClearTimeout(g_add_items_timerID);
                g_add_items_timerID = false;
            }, 250);
        };
    };
};

function on_playlist_items_removed(playlist_idx, new_count) {
    if(playlist_idx==plman.ActivePlaylist) {
        refresh_playlist_content();
    };
    plman.SetActivePlaylistContext();
};

function on_playlist_items_reordered(playlist_idx) {
    if(playlist_idx==plman.ActivePlaylist) {
        refresh_playlist_content();
    };
};

function on_selection_changed(metadb) {
};

function on_playlist_items_selection_change() {
    window.Repaint();
};

function on_item_focus_change(playlist, from, to) {
    if(!ww || !wh) return true;
    if(to<0) { // after a remove item in playlist!
        return true;
    };
    if(playlist!=plman.ActivePlaylist) { // case of the item played was from the queue but was the last queued so now queue is empty
        return true;
    };
    list.focus_id = to;
    plman.SetActivePlaylistContext();
    refresh_spv(plman.ActivePlaylist, bool_on_size);
    bool_on_size = false;
    window.Repaint();
};

function on_metadb_changed(metadb_or_metadbs, fromhook) {
    var len = list.item.length;
    for(var i=0;i<len;i++) {
        list.item[i].update_infos();
    };
    window.Repaint();
};

function on_focus(is_focused) {
    if(is_focused) {
        plman.SetActivePlaylistContext();
    } else {
        g_tooltip.Deactivate();
        g_tooltip.TrackActivate = false;
        g_tooltip.Text="";
        g_tooltip_timer && window.ClearTimeout(g_tooltip_timer);
        g_tooltip_timer = window.SetTimeout(function() {
            g_tooltip_timer && window.ClearTimeout(g_tooltip_timer);
            g_tooltip_timer = false;
        }, 500);
    };
};

//=================================================// Keyboard Callbacks
function on_key_up(vkey) {
    vscrollbar.step = vscrollbar.default_step;
    // scroll keys up and down RESET (step and timers)
    list.keypressed = false;
    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
    scrollbarbt.timerID1 = false;
    scrollbarbt.timerID2 && window.ClearTimeout(scrollbarbt.timerID2);
    scrollbarbt.timerID2 = false;
    if(vkey==VK_SHIFT) {
        list.SHIFT_start_id = null;
        list.SHIFT_count = 0;
    };
};

function on_key_down(vkey) {
    
    if(dragndrop.drag_in) return true;
    
    var mask = GetKeyboardMask();
    var act_pls = plman.ActivePlaylist;
    
    if (mask == KMask.none) {
        switch (vkey) {
        case VK_SHIFT:
            list.SHIFT_count = 0;
            break;
        case VK_BACK:
            if(g_search_string.length>0) {
                var tt_x = ((ww-vscrollbar.w) / 2) - (((g_search_string.length*13)+(10*2)) / 2);
                var tt_y = (wh/2) - 30;
                var tt_w = ((g_search_string.length*13)+(10*2));
                var tt_h = 60;
                g_search_string = g_search_string.substring(0, g_search_string.length-1);
                window.RepaintRect(0, tt_y-2, ww-vscrollbar.w, tt_h+4);
                clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
                incsearch_timer && window.ClearTimeout(incsearch_timer);
                incsearch_timer = window.SetTimeout(function () {
                    IncrementalSearch();
                    incsearch_timer = false;
                }, 400);
            };
            break;
        case VK_ESCAPE:
        case 222:
            var tt_x = ((ww-vscrollbar.w) / 2) - (((g_search_string.length*13)+(10*2)) / 2);
            var tt_y = (wh/2) - 30;
            var tt_w = ((g_search_string.length*13)+(10*2));
            var tt_h = 60;
            g_search_string = "";
            window.RepaintRect(0, tt_y-2, ww-vscrollbar.w, tt_h+4);
            break;
        case VK_UP:
            var new_focus_id = 0;
            if(!list.keypressed) {
                list.keypressed = true;
                reset_cover_timers();
                new_focus_id = (list.focus_id>0)?list.focus_id-1:0;
                plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                plman.ClearPlaylistSelection(act_pls);
                plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                scrollbarbt.timerID1 = window.SetTimeout(function () {
                    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                    scrollbarbt.timerID1 = false;
                    scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                    scrollbarbt.timerID2 = window.SetInterval(function () {
                        new_focus_id = (list.focus_id>0)?list.focus_id-1:0;
                        plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                    }, scrollbarbt.timer2_value+5);
                }, scrollbarbt.timer1_value);
            }
            break;
        case VK_DOWN:
            var new_focus_id = 0;
            if(!list.keypressed) {
                list.keypressed = true;
                reset_cover_timers();
                new_focus_id = (list.focus_id<list.total-1)?list.focus_id+1:list.total-1;
                plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                plman.ClearPlaylistSelection(act_pls);
                plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                scrollbarbt.timerID1 = window.SetTimeout(function () {
                    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                    scrollbarbt.timerID1 = false;
                    scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                    scrollbarbt.timerID2 = window.SetInterval(function () {
                        new_focus_id = (list.focus_id<list.total-1)?list.focus_id+1:list.total-1;
                        plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                    }, scrollbarbt.timer2_value+5);
                }, scrollbarbt.timer1_value);
            };
            break;
        case VK_PGUP:
            var delta = 0;
            var step = 0;
            var new_focus_id = 0;
            if(!list.keypressed) {
                list.keypressed = true;
                reset_cover_timers();
                delta = list.tocut;
                step = list.focus_id - list.item[delta].id;
                new_focus_id = (list.focus_id-step-1>0)?list.focus_id-step-1:0;
                list.focus_id = new_focus_id;
                plman.ClearPlaylistSelection(act_pls);
                plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                scrollbarbt.timerID1 = window.SetTimeout(function () {
                    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                    scrollbarbt.timerID1 = false;
                    scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                    scrollbarbt.timerID2 = window.SetInterval(function () {
                        delta = list.tocut;
                        step = list.focus_id - list.item[delta].id;
                        new_focus_id = (list.focus_id-step-1>0)?list.focus_id-step-1:0;
                        plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                    }, scrollbarbt.timer2_value+30);
                }, scrollbarbt.timer1_value);
            };
            break;
        case VK_PGDN:
            var delta = 0;
            var step = 0;
            var new_focus_id = 0;
            if(!list.keypressed) {
                list.keypressed = true;
                reset_cover_timers();
                delta = (list.tocut+list.nbvis<list.item.length)?list.tocut+list.nbvis:list.item.length-1;
                step = list.item[delta].id - list.focus_id;
                new_focus_id = (list.focus_id<list.total-1-step)?list.focus_id+step:list.total-1;
                list.focus_id = new_focus_id;
                plman.ClearPlaylistSelection(act_pls);
                plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                scrollbarbt.timerID1 = window.SetTimeout(function () {
                    scrollbarbt.timerID1 && window.ClearTimeout(scrollbarbt.timerID1);
                    scrollbarbt.timerID1 = false;
                    scrollbarbt.timerID2 && window.ClearInterval(scrollbarbt.timerID2);
                    scrollbarbt.timerID2 = window.SetInterval(function () {
                        delta = (list.tocut+list.nbvis<list.item.length)?list.tocut+list.nbvis:list.item.length-1;
                        step = list.item[delta].id - list.focus_id;
                        new_focus_id = (list.focus_id<list.total-1-step)?list.focus_id+step:list.total-1;
                        plman.SetPlaylistFocusItem(act_pls, new_focus_id);
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, new_focus_id, true);
                    }, scrollbarbt.timer2_value+30);
                }, scrollbarbt.timer1_value);
            };
            break;
        case VK_RETURN:
            // play focus item
            if(!isQueuePlaylistActive()) {
                plman.ExecutePlaylistDefaultAction(act_pls, list.focus_id);
            };
            break;
        case VK_END:
            plman.SetPlaylistFocusItem(act_pls, list.total-1);
            plman.ClearPlaylistSelection(act_pls);
            plman.SetPlaylistSelectionSingle(act_pls, list.total-1, true);
            break;
        case VK_HOME:
            plman.SetPlaylistFocusItem(act_pls, 0);
            plman.ClearPlaylistSelection(act_pls);
            plman.SetPlaylistSelectionSingle(act_pls, 0, true);
            break;
        case VK_DELETE:
            if(!fb.IsAutoPlaylist(act_pls)) {
                if(isQueuePlaylistActive()) {
                    var affected_items = Array();
                    var first_focus_id = null;
                    var next_focus_id = null;
                    for(var k=0; k<list.total; k++) {
                        if(plman.IsPlaylistItemSelected(act_pls, k)) {
                            affected_items.push(k);
                            if(first_focus_id==null) fist_focus_id = k;
                            next_focus_id = k + 1;
                        };
                    };
                    if(next_focus_id>=list.total) {
                        next_focus_id = fist_focus_id;
                    };
                    if(next_focus_id!=null) {
                        plman.SetPlaylistFocusItem(act_pls, next_focus_id);
                        plman.SetPlaylistSelectionSingle(act_pls, next_focus_id, true);
                    };
                    plman.RemoveItemsFromPlaybackQueue(affected_items);
                } else {
                    plman.RemovePlaylistSelection(act_pls, false);
                };
                plman.SetPlaylistSelectionSingle(act_pls, plman.GetPlaylistFocusItemIndex(act_pls), true);
            };
            break;
        };
    } else {
        switch(mask) {
            case KMask.shift:
                if(vkey==VK_UP) { // SHIFT + KEY UP
                    if(list.SHIFT_count==0) {
                        if(list.SHIFT_start_id==null) {
                            list.SHIFT_start_id = list.focus_id;
                        };
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                        if(list.focus_id>0) {
                            list.SHIFT_count--;
                            list.focus_id--;
                            plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                            plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                        };
                    } else if(list.SHIFT_count<0) {
                        if(list.focus_id>0) {
                            list.SHIFT_count--;
                            list.focus_id--;
                            plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                            plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                        };
                    } else {
                        plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, false);
                        list.SHIFT_count--;
                        list.focus_id--;
                        plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                    };
                };
                if(vkey==VK_DOWN) { // SHIFT + KEY DOWN
                    if(list.SHIFT_count==0) {
                        if(list.SHIFT_start_id==null) {
                            list.SHIFT_start_id = list.focus_id;
                        };
                        plman.ClearPlaylistSelection(act_pls);
                        plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                        if(list.focus_id<list.total-1) {
                            list.SHIFT_count++;
                            list.focus_id++;
                            plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                            plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                        };
                    } else if(list.SHIFT_count>0) {
                        if(list.focus_id<list.total-1) {
                            list.SHIFT_count++;
                            list.focus_id++;
                            plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, true);
                            plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                        };
                    } else {
                        plman.SetPlaylistSelectionSingle(act_pls, list.focus_id, false);
                        list.SHIFT_count++;
                        list.focus_id++;
                        plman.SetPlaylistFocusItem(act_pls, list.focus_id);
                    };
                };
                break;
            case KMask.ctrl:
                if(vkey==65) { // CTRL+A
                    fb.RunMainMenuCommand("Edit/Select all");
                    window.Repaint();
                };
                if(vkey==67) { // CTRL+C
                    clipboard.selection = plman.GetPlaylistSelectedItems(plman.ActivePlaylist);
                };
                if(vkey==86) { // CTRL+V
                    // insert the clipboard selection (handles) after the current position in the active playlist
                    if(clipboard.selection) {
                        if(clipboard.selection.Count>0) {
                            try {
                                if(list.total>0) {
                                    plman.InsertPlaylistItems(plman.ActivePlaylist, list.focus_id+1, clipboard.selection);
                                } else {
                                    plman.InsertPlaylistItems(plman.ActivePlaylist, 0, clipboard.selection);
                                };
                            } catch(e) {
                                fb.trace("WSH Playlist WARNING: Clipboard can't be paste, invalid clipboard content.");
                            };
                        };
                    };
                };
                if(vkey==70) { // CTRL+F
                    fb.RunMainMenuCommand("Edit/Search");
                };
                if(vkey==78) { // CTRL+N
                    fb.RunMainMenuCommand("File/New playlist");
                };
                if(vkey==79) { // CTRL+O
                    fb.RunMainMenuCommand("File/Open...");
                };
                if(vkey==80) { // CTRL+P
                    fb.RunMainMenuCommand("File/Preferences");
                };
                if(vkey==83) { // CTRL+S
                    fb.RunMainMenuCommand("File/Save playlist...");
                };
                break;
            case KMask.alt:
                if(vkey==65) { // ALT+A
                    fb.RunMainMenuCommand("View/Always on Top");
                };
                break;
        };
    };
};

function on_char(code) {
    if(list.total>0) {
        var tt_x = ((ww-vscrollbar.w) / 2) - (((g_search_string.length*13)+(10*2)) / 2);
        var tt_y = (wh/2) - 30;
        var tt_w = ((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        if(code==32 && g_search_string.length==0) return true; // SPACE Char not allowed on 1st char
        if(g_search_string.length<=20 && tt_w<=ww-vscrollbar.w-20) {
            if (code > 31) {
                g_search_string = g_search_string + String.fromCharCode(code).toUpperCase();
                window.RepaintRect(0, tt_y-2, ww, tt_h+4);
                clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
                clear_incsearch_timer = false;
                incsearch_timer && window.ClearTimeout(incsearch_timer);
                incsearch_timer = window.SetTimeout(function () {
                    IncrementalSearch();
                    window.ClearTimeout(incsearch_timer);
                    incsearch_timer = false;
                }, 400);
            };
        };
    };
};

//=================================================// Playback Callbacks
function on_playback_new_track(info) {
    g_seconds = 0;
    g_metadb = fb.GetNowPlaying();
    window.Repaint();
};

function on_playback_stop(reason) {
    if(reason==0) { // on user Stop
        g_metadb = fb.GetFocusItem();
        on_metadb_changed();
    };
    g_seconds = 0;
};

function on_playback_pause(state){
};

function on_playback_seek(time) {
    on_playback_time(time);
};

function on_playback_time(time) {
    // refresh now playing track in the playlist (play icon + time elapsed/remaining)
    g_seconds = time;
    if(g_playing_item_y!=null && plman.PlayingPlaylist==plman.ActivePlaylist) {
        if(g_playing_item_y>=0-row.h && g_playing_item_y<=wh+row.h) {
            if(g_playing_item_y<0) {
                g_playing_item_y = 0;
            };
            if(g_playing_item_y>wh-row.h) {
                g_playing_item_y = wh-row.h;
            };
            window.RepaintRect(0, g_playing_item_y, ww-vscrollbar.w, row.h);
        };
    };
    
    // -------------------------------------------------------------------------------/
    // Statistics TAGs Engine (v1.0 by Br3tt)
    // Update the TAGs below after 50% time played :
    // <FIRST_PLAYED>, <LAST_PLAYED>, <PLAY_COUNTER> (<PLAY_COUNT> replaced if found)
    // -------------------------------------------------------------------------------/
    if(time <= 1) {
        stats.updated = false;
        stats.metadb = fb.GetNowPlaying();
        stats.path_prefix = stats.metadb ? stats.metadb.rawpath.substring(0,4) : "";
        stats.taggable_file = (stats.path_prefix == "file" || stats.path_prefix== "cdda");
    };
    if(stats.metadb && stats.taggable_file && fb.IsMetadbInMediaLibrary(stats.metadb)) {
        if(time <= 1) {
            var total_seconds = stats.tf_length_seconds.Eval();
            stats.time_elapsed = Math.floor(time);
            if(total_seconds >= 10) {
                stats.limit = total_seconds - 5;
                stats.delay = Math.floor(total_seconds / 2);
            } else {
                stats.limit = total_seconds - 1;
                stats.delay = 2;
            };
            if(stats.delay < 0) stats.delay = 0;
            
        } else if(stats.time_elapsed > 0) {
            stats.time_elapsed++;
        };
               
        if(stats.time_elapsed >= stats.delay && time <= stats.limit) {
            stats.time_elapsed = 0;

            var new_play_counter;
            var old_play_count, old_play_counter;
            
            old_play_count = stats.tf_play_count.Eval();
            old_play_counter = stats.tf_play_counter.Eval();

            var timestamp = getTimestamp();

            if(old_play_count >= 0 && old_play_counter == "?") {
                new_play_counter = Math.floor(old_play_count) + 1;
            } else if(old_play_counter=="?") {
                new_play_counter = 1;
            } else {
                new_play_counter = Math.floor(old_play_counter) + 1;
            };
            
            var firstplayed_ts = stats.tf_first_played.Eval();

            // UPDATE TAGs
            if(stats.enabled && !stats.foo_playcount && !stats.updated) {
                if(firstplayed_ts != "?") {
                    var bool = stats.metadb.UpdateFileInfoSimple("LAST_PLAYED", timestamp, "PLAY_COUNTER", new_play_counter, "PLAY_COUNT", "");
                } else {
                    var bool = stats.metadb.UpdateFileInfoSimple("FIRST_PLAYED", timestamp, "LAST_PLAYED", timestamp, "PLAY_COUNTER", new_play_counter, "PLAY_COUNT", "");
                };
                stats.updated = true;
                // report to console
                fb.trace("WSH: Statistics updated to file at : " + fb.PlaybackTime + ".");
            };
        };
    };
};

//=================================================// Font & Colors
function get_font() {
	if (g_instancetype == 0) {
		g_font = window.GetFontCUI(FontTypeCUI.items, "{82196D79-69BC-4041-8E2A-E3B4406BB6FC}");
		g_font_headers = window.GetFontCUI(FontTypeCUI.labels, "{C0D3B76C-324D-46D3-BB3C-E81C7D3BCB85}");
	} else if (g_instancetype == 1) {
		g_font = window.GetFontDUI(FontTypeDUI.playlists);
		g_font_headers = window.GetFontDUI(FontTypeDUI.tabs);
	};
    if(g_font_guifx_found) {
        rating_font = gdi.Font("guifx v2 transports", 17, 0);
        del_rating_font = gdi.Font("guifx v2 transports", 13, 0);
        mood_font = gdi.Font("guifx v2 transports", 16, 0);
    } else {
        rating_font = gdi.Font("tahoma", 22, 0);
        del_rating_font = gdi.Font("tahoma", 22, 0);
        mood_font = gdi.Font("tahoma", 16, 1);
    };
};

function get_colors() {
	if (g_instancetype == 0) {
		g_textcolor = window.GetColorCUI(ColorTypeCUI.text);
		g_textcolor_sel = window.GetColorCUI(ColorTypeCUI.selection_text);
		g_textcolor_hl = window.GetColorCUI(ColorTypeCUI.active_item_frame);
		g_backcolor = window.GetColorCUI(ColorTypeCUI.background);
		g_backcolor_sel = window.GetColorCUI(ColorTypeCUI.selection_background)
	} else if (g_instancetype == 1) {
		g_textcolor = window.GetColorDUI(ColorTypeDUI.text);
		g_textcolor_sel = window.GetColorDUI(ColorTypeDUI.selection);
		g_textcolor_hl = window.GetColorDUI(ColorTypeDUI.highlight);
		g_backcolor = window.GetColorDUI(ColorTypeDUI.background);
		g_backcolor_sel = g_textcolor_sel
	};
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);

    // Custom colors set in Properties of the panel
    if(panel.custom_colors) {
        try{
            if(panel.custom_textcolor.length>0) g_textcolor = eval(panel.custom_textcolor);
            if(panel.custom_textcolor_selection.length>0) {
                g_textcolor_sel = eval(panel.custom_textcolor_selection);
                g_backcolor_sel = g_textcolor_sel;
            };
            if(panel.custom_backcolor.length>0) g_backcolor = eval(panel.custom_backcolor);
            if(panel.custom_textcolor_highlight.length>0) g_textcolor_hl = eval(panel.custom_textcolor_highlight);
        } catch(e) {};
    };

	g_backcolor_R = getRed(g_backcolor);
	g_backcolor_G = getGreen(g_backcolor);
	g_backcolor_B = getBlue(g_backcolor)
};

//=================================================// Images (general)
function set_scroller() {
    var gb;
    
    try {
        cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
    } catch(e) {
        cursor.h = cursor.default_h;
        cursor.img_normal = gdi.CreateImage(cursor.w, cursor.h);
    };
    
    gb = cursor.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(3, 1);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        gb.FillRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, g_textcolor&0x44ffffff);
        gb.DrawRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, 1.0, g_textcolor&0x44ffffff);
        gb.SetSmoothingMode(0);
    };
    cursor.img_normal.ReleaseGraphics(gb);

    cursor.img_hover = gdi.CreateImage(cursor.w, cursor.h);
    gb = cursor.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(3, 2);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, cursor.w, cursor.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        gb.FillRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, g_textcolor&0x88ffffff);
        gb.DrawRoundRect(3, 0, cursor.w-6, cursor.h-1, 1, 1, 1.0, g_textcolor&0x88ffffff);
        gb.SetSmoothingMode(0);
    };
    cursor.img_hover.ReleaseGraphics(gb);
    cursor.bt = new button(cursor.img_normal, cursor.img_hover, cursor.img_hover);
};

function init_vscrollbar_buttons() {
    var i, gb;

    cursor.popup = gdi.CreateImage(27, 22);
    gb = cursor.popup.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillRoundRect(0,0,22-1,22-1,3,3,g_textcolor);
    gb.DrawRoundRect(0,0,22-1,22-1,3,3,1.0,RGBA(0,0,0,150));
    var points = Array(22-2,7, 22-2+6,11, 22-2,22-7);
    gb.FillPolygon(g_textcolor, 0, points);
    gb.DrawPolygon(RGBA(0,0,0,150), 1.0, points);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(22-4,6,3,22-10,g_textcolor);
    cursor.popup.ReleaseGraphics(gb);
    
    button_up.img_normal = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 1);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor&0x44ffffff);
    };
    button_up.img_normal.ReleaseGraphics(gb);

    button_up.img_hover = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 2);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor&0x88ffffff);
    };
    button_up.img_hover.ReleaseGraphics(gb);

    button_up.img_down = gdi.CreateImage(button_up.w, button_up.h);
    gb = button_up.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 3);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_up.w, button_up.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, 10, mid_x+0, 5, 2.0, g_textcolor);
        gb.DrawLine(mid_x+0, 6, mid_x+3, 10, 2.0, g_textcolor);
    };
    button_up.img_down.ReleaseGraphics(gb);

    button_down.img_normal = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_normal.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 5);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor&0x44ffffff);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor&0x44ffffff);
    };
    button_down.img_normal.ReleaseGraphics(gb);

    button_down.img_hover = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_hover.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 6);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor&0x88ffffff);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor&0x88ffffff);
    };
    button_down.img_hover.ReleaseGraphics(gb);

    button_down.img_down = gdi.CreateImage(button_down.w, button_down.h);
    gb = button_down.img_down.GetGraphics();
    // Draw Themed Scrollbar (lg/col)
    try {
        vscrollbar.theme.SetPartAndStateId(1, 7);
        vscrollbar.theme.DrawThemeBackground(gb, 0, 0, button_down.w, button_down.h);
    } catch(e) {
        gb.SetSmoothingMode(2);
        var mid_x = Math.round(button_up.w/2);
        gb.DrawLine(mid_x-4, button_down.h-11, mid_x+0, button_down.h-6, 2.0, g_textcolor);
        gb.DrawLine(mid_x+0, button_down.h-7, mid_x+3, button_down.h-11, 2.0, g_textcolor);
    };
    button_down.img_down.ReleaseGraphics(gb);

    vscrollbar.arr_buttons.splice(0, vscrollbar.arr_buttons.length);
    for(i=0;i<vscrollbar.button_total;i++) {
        switch(i) {
         case 0:
            vscrollbar.arr_buttons.push(new button(button_up.img_normal, button_up.img_hover, button_up.img_down));
            break;
         case 1:
            vscrollbar.arr_buttons.push(new button(button_down.img_normal, button_down.img_hover, button_down.img_down));
            break;            
        };
    };
};

//=================================================// Init Icons and Images (no_cover ...)
function init_icons() {
    var i;
    var gb;
    var gui_font = gdi.Font("guifx v2 transports", 15, 0);
    
    glass_reflect_img = draw_glass_reflect(120, 120);
       
    playicon_off = gdi.CreateImage(20, row.h);
    gb = playicon_off.GetGraphics();
    gb.SetSmoothingMode(2);
    var x1 = 0;
    var y1 = Math.floor(row.h/2) - 6;
    var x2 = 12;
    var y2 = Math.floor(row.h/2);
    var x3 = 0;
    var y3 = Math.floor(row.h/2) + 6;
    var points = Array(x1, y1, x2, y2, x3, y3);
    gb.FillPolygon(RGB(255,255,255), 0, points);
    gb.DrawPolygon(g_textcolor, 1.0, points);
    gb.SetSmoothingMode(0);
    playicon_off.ReleaseGraphics(gb);

    playicon_on = gdi.CreateImage(20, row.h);
    gb = playicon_on.GetGraphics();
    gb.SetSmoothingMode(2);
    var x1 = 0;
    var y1 = Math.floor(row.h/2) - 6;
    var x2 = 12;
    var y2 = Math.floor(row.h/2);
    var x3 = 0;
    var y3 = Math.floor(row.h/2) + 6;
    var points = Array(x1, y1, x2, y2, x3, y3);    gb.FillPolygon(g_backcolor, 0, points);
    //gb.FillPolygon(RGB(255,255,255), 0, points);
    gb.FillPolygon(g_textcolor_sel, 0, points);
    gb.DrawPolygon(g_textcolor, 1.0, points);
    gb.SetSmoothingMode(0);
    playicon_on.ReleaseGraphics(gb);
    
    // singleline group header icon 
    singleline_group_header_icon = gdi.CreateImage(18, 16);
    gb = singleline_group_header_icon.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(1,2,12,12,1.0,g_textcolor_hl&0x99ffffff);
    gb.FillEllipse(3,4,8,8,g_textcolor&0x55ffffff);
    singleline_group_header_icon.ReleaseGraphics(gb);
  
    // drag_n_drop markers around line of insert
    icon_arrow_left = gdi.CreateImage(8, 8);
    gb = icon_arrow_left.GetGraphics();
    gb.SetSmoothingMode(0);
    gb.DrawLine(0, 0, 0, 7, 1.0, g_textcolor);
    gb.DrawLine(1, 1, 1, 7-1, 1.0, g_textcolor);
    gb.DrawLine(2, 2, 2, 7-2, 1.0, g_textcolor);
    gb.DrawLine(3, 3, 3, 7-3, 1.0, g_textcolor);
    icon_arrow_left.ReleaseGraphics(gb);

    nocover = gdi.CreateImage(200, 200);
    gb = nocover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.SetTextRenderingHint(3);
    gui_font = gdi.Font("Segoe UI", 108, 1);
    gb.DrawString("NO", gui_font, g_textcolor&0x25ffffff, 0, 0, 200, 110, cc_stringformat);
    gui_font = gdi.Font("Segoe UI", 48, 1);
    gb.DrawString("COVER", gui_font, g_textcolor&0x20ffffff, 1, 70, 200, 110, cc_stringformat);
    gb.FillSolidRect(24, 155, 152, 20, g_textcolor&0x15ffffff);
    nocover.ReleaseGraphics(gb);
    
    noartist = gdi.CreateImage(200, 200);
    gb = noartist.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gb.FillEllipse(100-90/2,110,150,300,g_textcolor&0x25ffffff);
    gb.FillEllipse(100-90/2,25,90,90,g_textcolor&0x25ffffff);
    noartist.ReleaseGraphics(gb);

    streamcover = gdi.CreateImage(200, 200);
    gb = streamcover.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillSolidRect(0,0,200,200,g_textcolor);
    gb.FillGradRect(0,0,200,200,90,g_backcolor&0xbbffffff,g_backcolor,1.0);
    gui_font = gdi.Font("Segoe UI", 42, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("stream", gui_font, g_backcolor, 1, 2, 200, 190, cc_stringformat);
    gb.DrawString("stream", gui_font, g_textcolor&0x99ffffff, 1, 0, 200, 190, cc_stringformat);
    streamcover.ReleaseGraphics(gb);

    // Toolbar buttons
    
    // Settings Menu button
    bt_settings_off = gdi.CreateImage(30, 20);
    gb = bt_settings_off.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(150,150,150), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(140,140,140));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,200));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,80));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(140,140,140));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(140,140,140));
    bt_settings_off.ReleaseGraphics(gb);

    bt_settings_ov = gdi.CreateImage(30, 20);
    gb = bt_settings_ov.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(190,190,190), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,220));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,140));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(180,180,180));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(180,180,180));
    bt_settings_ov.ReleaseGraphics(gb);
    
    bt_settings_on = gdi.CreateImage(30, 20);
    gb = bt_settings_on.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(230,230,230), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,240));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,160));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(220,220,220));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(220,220,220));
    bt_settings_on.ReleaseGraphics(gb);

    // Sort/group Menu button
    bt_sort_off = gdi.CreateImage(30, 20);
    gb = bt_sort_off.GetGraphics();
    gui_font = gdi.Font("Tahoma", 15, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("Az", gui_font, RGB(140,140,140), 0, -2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(140,140,140));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(140,140,140));
    bt_sort_off.ReleaseGraphics(gb);

    bt_sort_ov = gdi.CreateImage(30, 20);
    gb = bt_sort_ov.GetGraphics();
    gui_font = gdi.Font("Tahoma", 15, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("Az", gui_font, RGB(180,180,180), 0, -2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(180,180,180));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(180,180,180));
    bt_sort_ov.ReleaseGraphics(gb);
    
    bt_sort_on = gdi.CreateImage(30, 20);
    gb = bt_sort_on.GetGraphics();
    gui_font = gdi.Font("Tahoma", 15, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("Az", gui_font, RGB(220,220,220), 0, -2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(220,220,220));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(220,220,220));
    bt_sort_on.ReleaseGraphics(gb);

    toolbar.buttons.splice(0, toolbar.buttons.length);
    for(i=0;i<2;i++) {
        switch(i) {
         case 0:
            toolbar.buttons.push(new button(bt_settings_off, bt_settings_ov, bt_settings_on));
            break;
         case 1:
            toolbar.buttons.push(new button(bt_sort_off, bt_sort_ov, bt_sort_on));
            break;            
        };
    };
};

function recalc_datas() {
    
    if(toolbar.lock) {
        toolbar.delta = toolbar.collapsed_y*-1;
        toolbar.state = true;
    };
       
    if(panel.nogroupheader) {
        group.nbrows = 0;
    } else {
        group.nbrows = group.nbrows_default;
    };
    
    list.nbvis = (((wh-toolbar.h)/row.h) == Math.ceil((wh-toolbar.h)/row.h)) ? Math.ceil((wh-toolbar.h)/row.h) : Math.ceil(((wh-toolbar.h)/row.h)-1);
    
    if(panel.themed) {
        vscrollbar.theme = window.CreateThemeManager("scrollbar");
        list.theme = window.CreateThemeManager("listview");
    } else {
        vscrollbar.theme = false;
        list.theme = false;
    };
    init_vscrollbar_buttons();
  
    button_up.y = 0;
    button_down.y = wh - button_down.h;
    vscrollbar.y = button_up.h;
    vscrollbar.h = wh - button_up.h - button_down.h;
    cursor.x = ww-vscrollbar.w;
    cursor.y = vscrollbar.y;
    
    if(cover.show) {
        cover.w = group.nbrows*row.h;
    } else {
        cover.w = 0;
    };
    if(cover.w>row.h) {
        cover.visible = true;
        cover.h = cover.w;
        cover.nbrows = Math.ceil(cover.w/row.h);
    } else {
        cover.visible = false;
        cover.h = cover.w;
        cover.nbrows = Math.ceil(cover.w/row.h);
    };
};

function redraw_stub_images() {
    nocover_img = FormatCover(nocover, (cover.w-cover.margin*2), (cover.h-cover.margin*2));
    noartist_img = FormatCover(noartist, (cover.w-cover.margin*2), (cover.h-cover.margin*2));
    streamcover_img = FormatCover(streamcover, (cover.w-cover.margin*2), (cover.h-cover.margin*2));
};

function SelectGroupItems(start_id) {
    var count = 0;
    var affectedItems = Array();
    
    if(!utils.IsKeyPressed(VK_CONTROL)) {
        plman.ClearPlaylistSelection(plman.ActivePlaylist);
    };

    for(var i = start_id; i < list.total; i++) {
        if(list.hlist[i] != list.hlist[start_id]) {
            break;
        } else {
            affectedItems.push(i);
        };
        count++;
        if(count>9999) break;
    };
    plman.SetPlaylistSelection(plman.ActivePlaylist, affectedItems, true);
    plman.SetPlaylistFocusItem(plman.ActivePlaylist, start_id);
    CollectGarbage();
};

function SelectAtoB(start_id, end_id) {

    var affectedItems = Array();
    
    if(list.SHIFT_start_id==null) {
        list.SHIFT_start_id = start_id;
    };
    
    plman.ClearPlaylistSelection(plman.ActivePlaylist);
    
    var previous_focus_id = list.focus_id;
    
    if(start_id<end_id) {
        var deb = start_id;
        var fin = end_id;
    } else {
        var deb = end_id;
        var fin = start_id;        
    };

    for(var i=deb;i<=fin;i++) {
        affectedItems.push(i);
    };
    plman.SetPlaylistSelection(plman.ActivePlaylist, affectedItems, true);
    
    plman.SetPlaylistFocusItem(plman.ActivePlaylist, end_id);
    
    if(affectedItems.length>1) {
        if(end_id > previous_focus_id) {
            var delta = end_id - previous_focus_id;
            list.SHIFT_count += delta;
        } else {
            var delta = previous_focus_id - end_id;
            list.SHIFT_count -= delta;
        };
    };
    
    window.Repaint();
};

function ShowNowPlaying() {
    if(fb.IsPlaying) {
        if(plman.PlayingPlaylist!=plman.ActivePlaylist) {
            plman.ActivePlaylist = plman.PlayingPlaylist;
        };
        if(plman.PlaylistItemCount(plman.PlayingPlaylist)==0 || !fb.GetFocusItem(false)) return true;
        plman.ClearPlaylistSelection(plman.ActivePlaylist);
        list.nowplaying = plman.GetPlayingItemLocation();
        var pid = list.nowplaying.PlaylistItemIndex;
        plman.SetPlaylistFocusItem(plman.ActivePlaylist, pid);
        plman.SetPlaylistSelectionSingle(plman.ActivePlaylist, pid, true);
        if(pid>=0 && pid<list.total) {
            refresh_spv(plman.ActivePlaylist, false);
        };
    } else {
        plman.ClearPlaylistSelection(plman.ActivePlaylist);
        var pid = plman.GetPlaylistFocusItemIndex(plman.ActivePlaylist);
        plman.SetPlaylistFocusItem(plman.ActivePlaylist, pid);
        plman.SetPlaylistSelectionSingle(plman.ActivePlaylist, pid, true);
        if(pid>=0 && pid<list.total) {
            refresh_spv(plman.ActivePlaylist, false);
        };
    };
};

function ShowSelectedItem(pid) {
    if(list.total==0 || !fb.GetFocusItem(false)) return true;
    if(pid<0) {
        pid = plman.GetPlaylistFocusItemIndex(plman.ActivePlaylist);
    };
    plman.ClearPlaylistSelection(plman.ActivePlaylist);
    plman.SetPlaylistFocusItem(plman.ActivePlaylist, pid);
    plman.SetPlaylistSelectionSingle(plman.ActivePlaylist, pid, true);
    refresh_spv(plman.ActivePlaylist);
};

function IncrementalSearch() {
    var count=0;
    var albumartist;
    var chr;
    var gstart;
    var pid = -1;
    
    // exit if no search string in cache
    if(g_search_string.length<=0) return true;
    
    // 1st char of the search string
    var first_chr = g_search_string.substring(0,1);  
    var len = g_search_string.length;
    
    // which start point for the search
    if(list.total>1000) {
        albumartist = tf_albumartist.EvalWithMetadb(list.handlelist.Item(Math.floor(list.total/2)));
        chr = albumartist.substring(0,1);
        if(first_chr.charCodeAt(first_chr) > chr.charCodeAt(chr)) {
            gstart = Math.floor(list.total/2);
        } else {
            gstart = 0;
        };
    } else {
        gstart = 0;
    };

    var format_str = "";
    for(var i=gstart;i<list.total;i++) {
        albumartist = tf_albumartist.EvalWithMetadb(list.handlelist.Item(i));
        format_str = albumartist.substring(0,len).toUpperCase();
        if(format_str==g_search_string) {
            pid = i;
            break;
        };
    };
    
    if(pid>=0) { // found!
        ShowSelectedItem(pid);
    } else {
        list.inc_search_noresult = true;
        window.Repaint();
    };
    
    clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
    clear_incsearch_timer = window.SetInterval(function () {
        // reset incremental search string after 1 seconds without any key pressed
        var tt_x = ((ww-vscrollbar.w) / 2) - (((g_search_string.length*13)+(10*2)) / 2);
        var tt_y = (wh/2) - 30;
        var tt_w = ((g_search_string.length*13)+(10*2));
        var tt_h = 60;
        g_search_string = "";
        window.RepaintRect(0, tt_y-2, ww-vscrollbar.w, tt_h+4);
        clear_incsearch_timer && window.ClearInterval(clear_incsearch_timer);
        clear_incsearch_timer = false;
        list.inc_search_noresult = false;
    }, 1000);
};


//=================================================// Item Context Menu
function new_context_menu(x, y, id, array_id) {
             
    var _menu = window.CreatePopupMenu();
    var Context = fb.CreateContextMenuManager();
    
    var _child01 = window.CreatePopupMenu();
    var _child02 = window.CreatePopupMenu();
    
    list.metadblist_selection = plman.GetPlaylistSelectedItems(plman.ActivePlaylist);
    Context.InitContext(list.metadblist_selection);
    Context.BuildMenu(_menu, 1, -1);
   
    _child01.AppendTo(_menu, MF_STRING, "Selection...");
    _child01.AppendMenuItem((fb.IsAutoPlaylist(plman.ActivePlaylist) || isQueuePlaylistActive())?MF_DISABLED|MF_GRAYED:MF_STRING, 1000, "Remove");
    _child02.AppendTo(_child01, MF_STRING, "Send to...");
    _child02.AppendMenuItem(MF_STRING, 2000, "a New playlist...");
    if(plman.PlaylistCount>1) {
        _child02.AppendMenuItem(MF_SEPARATOR, 0, "");
    };
    var pl_count = plman.PlaylistCount;
    for(var i=0;i<pl_count;i++) {
        if(i!=plman.ActivePlaylist && !fb.IsAutoPlaylist(i)) {
            _child02.AppendMenuItem(MF_STRING, 2001+i, plman.GetPlaylistName(i));
        };
    };

    var ret = _menu.TrackPopupMenu(x, y);
    if(ret<800) {
        Context.ExecuteByID(ret - 1);
    } else if(ret<1000) {
        switch (ret) {
        case 880:
        
            break;
        };
    } else {
        switch (ret) {
        case 1000:
            plman.RemovePlaylistSelection(plman.ActivePlaylist, false);
            break;
        case 2000:
            fb.RunMainMenuCommand("File/New playlist");
            plman.InsertPlaylistItems(plman.PlaylistCount-1, 0, list.metadblist_selection, false);
            break;
        default:
            var insert_index = plman.PlaylistItemCount(ret-2001);
            plman.InsertPlaylistItems((ret-2001), insert_index, list.metadblist_selection, false);
        };
    };
    _child01.Dispose();
    _child02.Dispose();
    _menu.Dispose();
    return true;
};

function sort_group_menu(x, y) {
    var idx;
    var _menu = window.CreatePopupMenu();
    var _sort = window.CreatePopupMenu();
    var _groupby = window.CreatePopupMenu();
   
    _sort.AppendTo(_menu, MF_STRING, "Sort");
    _sort.AppendMenuItem(MF_STRING, 100, "Sort by album");
    _sort.AppendMenuItem(MF_STRING, 110, "Sort by artist");
    _sort.AppendMenuItem(MF_STRING, 120, "Sort by file path");
    _sort.AppendMenuItem(MF_STRING, 130, "Sort by date");
    _sort.AppendMenuItem(MF_STRING, 140, "Sort by genre");
    _sort.AppendMenuItem(MF_STRING, 150, "Randomize");
    _sort.AppendMenuItem(MF_STRING, 160, "Reverse");
    _groupby.AppendTo(_menu, MF_STRING, "Group/Sort");
    _groupby.AppendMenuItem(MF_STRING, 200, "Group/Sort by album");
    _groupby.AppendMenuItem(MF_STRING, 201, "Group/Sort by artist");
    _groupby.AppendMenuItem(MF_STRING, 202, "Group/Sort by file path");
    idx = _menu.TrackPopupMenu(x, y);
    switch(idx) {
        case 100:
            plman.SortByFormat(plman.ActivePlaylist, sort_pattern_album, false);
            break;
        case 110:
            plman.SortByFormat(plman.ActivePlaylist, sort_pattern_artist, false);
            break;
        case 120:
            plman.SortByFormat(plman.ActivePlaylist, sort_pattern_path, false);
            break;
        case 130:
            plman.SortByFormat(plman.ActivePlaylist, sort_pattern_date, false);
            break;
        case 140:
            plman.SortByFormat(plman.ActivePlaylist, sort_pattern_genre, false);
            break;
        case 150:
            plman.SortByFormat(plman.ActivePlaylist, "", false);
            break;
        case 160:
            fb.RunMainMenuCommand("Edit/Sort/Reverse");
            break;
        case 200:
            group.type = 0;
            window.SetProperty("SYSTEM.group.type", group.type);
            group.key = group_pattern_album;
            window.SetProperty("SYSTEM.group Key", group.key);
            tf_group_key = fb.TitleFormat(group.key);
            //
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            plman.SortByFormat(plman.ActivePlaylist, "%album artist% | %date% | %album% | %discnumber% | %tracknumber% | %title%", false);
            break;
        case 201:
            group.type = 1;
            window.SetProperty("SYSTEM.group.type", group.type);
            group.key = group_pattern_artist;
            window.SetProperty("SYSTEM.group Key", group.key);
            tf_group_key = fb.TitleFormat(group.key);
            //
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            plman.SortByFormat(plman.ActivePlaylist, "%artist% | %date% | %album% | %discnumber% | %tracknumber% | %title%", false);
            break;
        case 202:
            group.type = 2;
            window.SetProperty("SYSTEM.group.type", group.type);
            group.key = group_pattern_path;
            window.SetProperty("SYSTEM.group Key", group.key);
            tf_group_key = fb.TitleFormat(group.key);
            //
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            plman.SortByFormat(plman.ActivePlaylist, "%path%", false);
            break;
        default:

    };
    _sort.Dispose();
    _groupby.Dispose();
    _menu.Dispose();
    g_menu_displayed = false;
    // collapse toolbar
    if(!toolbar.lock) {
        if(toolbar.delta==0) {
            toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
            toolbar.timerID_on = false;
        };
        if(toolbar.state) {
            if(!toolbar.timerID_off) {
                if(toolbar.delta == toolbar.collapsed_y*-1) {
                    toolbar.timerID_off = window.SetTimeout(function() {
                        if(!toolbar.timerID2) {
                            toolbar.timerID2 = window.SetInterval(function() {
                                toolbar.delta -= toolbar.step;
                                if(toolbar.delta <= 0) {
                                    toolbar.delta = 0;
                                    toolbar.state = false;
                                    window.ClearInterval(toolbar.timerID2);
                                    toolbar.timerID2 = false;
                                };
                                window.RepaintRect(0, 0, ww, 30);
                            }, 30);
                        } ;
                        toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                        toolbar.timerID_off = false;
                    }, 400);
                };
            };   
        };
    };
    return true;
};

function settings_menu(x, y) {
    var idx;
    var _menu = window.CreatePopupMenu();
    var _columns = window.CreatePopupMenu();
    var _appearance = window.CreatePopupMenu();
    
    _menu.AppendMenuItem(MF_STRING, 1, "Lock Toolbar");
    _menu.CheckMenuItem(1, toolbar.lock?1:0);
    _menu.AppendMenuSeparator();
    
    _appearance.AppendTo(_menu, MF_STRING, "Appearance");
    _appearance.AppendMenuItem(MF_STRING, 100, "Use Themed Style");
    _appearance.CheckMenuItem(100, panel.themed?1:0);
    _appearance.AppendMenuItem(MF_STRING, 110, "Use Custom Colors");
    _appearance.CheckMenuItem(110, panel.custom_colors?1:0);
    _appearance.AppendMenuItem(MF_STRING, 120, "No Group Header");
    _appearance.CheckMenuItem(120, panel.nogroupheader?1:0);
    _appearance.AppendMenuItem(MF_STRING, 130, "Light Shadow Border (sunken effect)");
    _appearance.CheckMenuItem(130, panel.show_shadow_border?1:0);
    _appearance.AppendMenuItem(MF_STRING, 140, "Show Scrollbar");
    _appearance.CheckMenuItem(140, vscrollbar.show?1:0);

    _columns.AppendTo(_menu, MF_STRING, "Columns");
    _columns.AppendMenuItem(MF_STRING, 200, "Play Icon");
    _columns.CheckMenuItem(200, columns.playicon?1:0);
    _columns.AppendMenuItem(MF_STRING, 210, "Track Number");
    _columns.CheckMenuItem(210, columns.tracknumber?1:0);
    _columns.AppendMenuSeparator();
    _columns.AppendMenuItem(MF_STRING, 330, "Title");
    _columns.AppendMenuItem(MF_STRING, 331, "Title (Smart)");
    _columns.AppendMenuItem(MF_STRING, 332, "Title / Artist");
    _columns.CheckMenuRadioItem(330, 332, columns.title+330);
    _columns.AppendMenuSeparator();
    _columns.AppendMenuItem(MF_STRING, 300, "Playcount");
    _columns.CheckMenuItem(300, columns.playcount?1:0);
    _columns.AppendMenuItem(MF_STRING, 310, "Rating");
    _columns.CheckMenuItem(310, columns.rating?1:0);
    _columns.AppendMenuItem(MF_STRING, 320, "Love Track");
    _columns.CheckMenuItem(320, columns.mood?1:0);
    _columns.AppendMenuItem(MF_STRING, 340, "Bitrate");
    _columns.CheckMenuItem(340, columns.bitrate?1:0);
    
    _menu.AppendMenuSeparator();
    _menu.AppendMenuItem(fb.IsPlaying?MF_STRING:MF_GRAYED|MF_DISABLED, 6, "Show Now Playing");
    _menu.AppendMenuItem(plman.IsPlaybackQueueActive()?MF_STRING:MF_GRAYED|MF_DISABLED, 7, "Show Queue Playlist");
    _menu.AppendMenuItem((cover.show && list.total>0 && group.nbrows>1)?MF_STRING:MF_DISABLED|MF_GRAYED, 8, "Refresh Covers");
    _menu.AppendMenuSeparator();
    if(!stats.foo_playcount) {
        _menu.AppendMenuItem(MF_STRING, 10, "Enable Playback Statistics");
        _menu.CheckMenuItem(10, stats.enabled?1:0);
        _menu.AppendMenuSeparator();
    };
    _menu.AppendMenuItem(MF_STRING, 20, "Properties");
    _menu.AppendMenuItem(MF_STRING, 21, "Configure...");
    idx = _menu.TrackPopupMenu(x, y);
    
    switch(idx) {
        case 1:
            toolbar.lock = !toolbar.lock;
            window.SetProperty("SYSTEM.toolbar.lock", toolbar.lock);
            break;
        case 6:
            if(plman.ActivePlaylist != plman.PlayingPlaylist) {
                if(list.handlelist) list.handlelist.Dispose();
                list.handlelist = plman.GetPlaylistItems(fb.PlayingPlaylist);
                list.total = list.handlelist.Count;
                plman.ActivePlaylist = plman.PlayingPlaylist;
            } else {
                ShowNowPlaying();
                window.Repaint();
            };
            break;
        case 7:
            ShowPlaylistQueue(0);
            break;
        case 8:
            redraw_stub_images();
            g_image_cache = new image_cache;
            CollectGarbage();
            refresh_playlist_content();
            break;
        case 10:
            stats.enabled = !stats.enabled;
            window.SetProperty("SYSTEM.statistics.enabled", stats.enabled);
            break;
        case 20:
            window.ShowProperties();
            break;
        case 21:
            window.ShowConfigure();
            break;
        case 100:
            panel.themed = !panel.themed;
            window.SetProperty("SYSTEM.panel.themed", panel.themed);
            if(panel.themed) {
                panel.theme = window.CreateThemeManager("scrollbar");
            } else {
                panel.theme = false;
            };
            recalc_datas();
            init_icons();
            set_scroller();
            window.Repaint();
            break;
        case 110:
            panel.custom_colors = !panel.custom_colors;
            window.SetProperty("SYSTEM.panel.custom.colors", panel.custom_colors);
            on_colors_changed();
            break;
        case 120:
            panel.nogroupheader = !panel.nogroupheader;
            window.SetProperty("SYSTEM.no.group.header", panel.nogroupheader);
            recalc_datas();
            redraw_stub_images();
            refresh_playlist_content();
            break;
        case 130:
            panel.show_shadow_border = !panel.show_shadow_border;
            window.SetProperty("SYSTEM.shadow.border.enabled", panel.show_shadow_border);
            window.Repaint();
            break;
        case 140:
            vscrollbar.show = !vscrollbar.show;
            window.SetProperty("SYSTEM.vscrollbar.visible", vscrollbar.show);
            if(list.item.length>list.nbvis) {
                if(vscrollbar.show) {
                    vscrollbar.visible = true;
                } else {
                    vscrollbar.visible = false;
                };
            } else {
                vscrollbar.visible = false;
            };
            refresh_playlist_content();
            break;
        case 200:
            columns.playicon = !columns.playicon;
            window.SetProperty("SYSTEM.columns.playicon.enabled", columns.playicon);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 210:
            columns.tracknumber = !columns.tracknumber;
            window.SetProperty("SYSTEM.columns.tracknumber.enabled", columns.tracknumber);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 300:
            columns.playcount = !columns.playcount;
            window.SetProperty("SYSTEM.columns.playcount.enabled", columns.playcount);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 310:
            columns.duration_w = 0;
            columns.bitrate_w = 0;
            columns.rating = !columns.rating;
            window.SetProperty("SYSTEM.columns.rating.enabled", columns.rating);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 320:
            columns.duration_w = 0;
            columns.bitrate_w = 0;
            columns.mood = !columns.mood;
            window.SetProperty("SYSTEM.columns.mood.enabled", columns.mood);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 340:
            columns.duration_w = 0;
            columns.bitrate_w = 0;
            columns.bitrate = !columns.bitrate;
            window.SetProperty("SYSTEM.columns.bitrate.enabled", columns.bitrate);
            refresh_spv(plman.ActivePlaylist, true);
            break;
        case 330:
        case 331:
        case 332:
            columns.title = idx - 330;
            window.SetProperty("SYSTEM.columns.title.pattern", columns.title);
            window.Repaint();
            break;
        default:

    };
    _appearance.Dispose();
    _columns.Dispose();
    _menu.Dispose();
    g_menu_displayed = false;
    // collapse toolbar
    if(!toolbar.lock) {
        if(toolbar.delta==0) {
            toolbar.timerID_on && window.ClearTimeout(toolbar.timerID_on);
            toolbar.timerID_on = false;
        };
        if(toolbar.state) {
            if(!toolbar.timerID_off) {
                if(toolbar.delta == toolbar.collapsed_y*-1) {
                    toolbar.timerID_off = window.SetTimeout(function() {
                        if(!toolbar.timerID2) {
                            toolbar.timerID2 = window.SetInterval(function() {
                                toolbar.delta -= toolbar.step;
                                if(toolbar.delta <= 0) {
                                    toolbar.delta = 0;
                                    toolbar.state = false;
                                    window.ClearInterval(toolbar.timerID2);
                                    toolbar.timerID2 = false;
                                };
                                window.RepaintRect(0, 0, ww, 30);
                            }, 30);
                        } ;
                        toolbar.timerID_off && window.ClearTimeout(toolbar.timerID_off);
                        toolbar.timerID_off = false;
                    }, 400);
                };
            };   
        };
    };
    return true;
};

//=================================================// Drag'n'Drop Callbacks
var wsh_dragging = false;

function on_drag_enter() {
    wsh_dragging = true;
};

function on_drag_leave() {
    wsh_dragging = false;
};

function on_drag_over(action, x, y, mask) {
    on_mouse_move(x, y);
};

function on_drag_drop(action, x, y, mask) {
    wsh_dragging = false;
    // We are going to process the dropped items to a playlist
    action.ToPlaylist();
    action.Playlist = plman.ActivePlaylist;
    action.ToSelect = false;
};

//=================================================// Queue Playlist features

function on_playback_queue_changed(origin) {
    if(isQueuePlaylistActive()) {
        ShowPlaylistQueue(0);
    } else {
        SetPlaylistQueue();
    };
};

function isQueuePlaylistActive() {
    var queue_pl_idx = isQueuePlaylistPresent();
    if(queue_pl_idx<0) {
        return false;
    } else if(plman.ActivePlaylist == queue_pl_idx) {
        return true;
    };
};

function isQueuePlaylistPresent() {
    for(var i=0; i<plman.PlaylistCount; i++) {
        if(plman.GetPlaylistName(i)=="Queue Content") return i;
    };
    return -1;    
};

function SetPlaylistQueue() {
    var total_pl = plman.PlaylistCount;
    var queue_pl_idx = isQueuePlaylistPresent();
    if(queue_pl_idx<0) {
        return true;
    } else {
        var total_in_pls = plman.PlaylistItemCount(queue_pl_idx);
        if(total_in_pls > 0) {
            var affected_items = Array();
            for(var i=0; i<total_in_pls; i++) {
                affected_items.push(i);
            };
            plman.SetPlaylistSelection(queue_pl_idx, affected_items, true);
            plman.RemovePlaylistSelection(queue_pl_idx);
        };
    };
    var queue_total = plman.GetPlaybackQueueCount();
    var vbarr = plman.GetPlaybackQueueContents();
    var arr = vbarr.toArray();
    var q_handlelist = plman.GetPlaylistSelectedItems(queue_pl_idx);
    q_handlelist.RemoveAll();
    for(var j=0; j<queue_total; j++) {
        q_handlelist.Add(arr[j].Handle);
    };
    plman.InsertPlaylistItems(queue_pl_idx, j, q_handlelist, false);
};

function ShowPlaylistQueue(focus_id) {
    var total_pl = plman.PlaylistCount;
    var queue_pl_idx = isQueuePlaylistPresent();
    if(queue_pl_idx<0) {
        plman.CreatePlaylist(total_pl, "Queue Content");
        queue_pl_idx = total_pl;
        plman.ActivePlaylist = queue_pl_idx;
    } else {
        plman.ActivePlaylist = queue_pl_idx;
        fb.ClearPlaylist();
    };
    var queue_total = plman.GetPlaybackQueueCount();
    var vbarr = plman.GetPlaybackQueueContents();
    var arr = vbarr.toArray();
    var q_handlelist = plman.GetPlaylistSelectedItems(queue_pl_idx);
    q_handlelist.RemoveAll();
    for(var i=0; i<queue_total; i++) {
        q_handlelist.Add(arr[i].Handle);
    };
    plman.InsertPlaylistItems(queue_pl_idx, i, q_handlelist, false);
    plman.SetPlaylistFocusItem(queue_pl_idx, focus_id);
}; `   ��������0Ԑ�1��E�v�0���nlj�6�O�7d{�]�&  �  `  {    #!X�iI@��;ᏴS       toggle     ,          �����������������  �   ;  �     JScript�  var COLOR_BTNFACE = 15;
var toggle = window.GetProperty("toggle", false);
var ww = 0, wh = 0;
var COLOR_BTNFACE = 15;
var g_syscolor = 0;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
    if(toggle) {
        window.MinWidth = 242;
        window.MaxWidth = 242;
    } else {
        window.MinWidth = 1;
        window.MaxWidth = 1;
    };
    window.MinHeight = 4;
    window.MaxHeight = 4;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_mouse_lbtn_up(x, y) {
    toggle = !toggle;
    window.SetProperty("toggle", toggle);
    if(toggle) {
        window.MinWidth = 242;
        window.MaxWidth = 242;
    } else {
        window.MinWidth = 1;
        window.MaxWidth = 1;
    };
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_notify_data(name, info) {
    switch(name) {
        case "right_pane":
            toggle = !toggle;
            window.SetProperty("toggle", toggle);
            if(toggle) {
                window.MinWidth = 242;
                window.MaxWidth = 242;
            } else {
                window.MinWidth = 1;
                window.MaxWidth = 1;
            };
            break;
    }
}

function on_mouse_rbtn_up(x, y) {
    return true;
} 0Ԑ�1��E�v�0���nlj�6�O�7d{�]�&(  i  =  {    ���z�I�M%�܅�N       ,          �����������������   �   �       JScript�  var ww = 0, wh = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_mouse_rbtn_up(x, y) {
    return true;
} ���.hx�L�w��H�30Ԑ�1��E�v�0��	  (  }&  �M�?7�N���~��P�m�S�@���뉡=�  �  &                       ����            �      "S e g o e   U I                                                       ���     ��� ���         2   �            
                                                  �                                              P                  �A< #U} ��� ����            �          M S   S h e l l   D l g                                         �   [Artist: %artist%]$crlf()
Title: %title%$crlf()
[Album: %album%]$crlf()
%playback_time%[ / %length%]$crlf()
[%search_state%][%search_progress%'%']����            �          M S   S h e l l   D l g                                                                   �@       ) y�΄ǐ��q[������@��      `   ��������{    ���z�I�M%�܅�N       ,          �����������������   �   �       JScript�  var ww = 0, wh = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;

function get_colors() {
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
}

function on_paint(gr) {
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_mouse_rbtn_up(x, y) {
    return true;
} `   ����   `      ����`   ��������`   ��������`   ��������{   k����#J��[ ���:      ,          ����������������J  �   �  �     JScript // ==PREPROCESSOR==
// @name "WSH Controls"
// @version "1.0.0"
// @author "Br3tt aka Falstaff >> http://br3tt.deviantart.com"
// @feature "dragdrop"
// @import "%fb2k_profile_path%themes\fooRazor\scripts\WSHcommon.js"
// ==/PREPROCESSOR==

// images
var bt_play_off, bt_play_ov, bt_play_on;
var bt_pbo_off;
var bt_pbo_hov;
var bt_pbo_on;
var pbo_sac;
var pbo_sac_ov;
var pbo_sac_on;
var pbo_normal;
var pbo_normal_ov;
var pbo_normal_on;
var pbo_repeat_playlist;
var pbo_repeat_playlist_ov;
var pbo_repeat_playlist_on;
var pbo_repeat;
var pbo_repeat_ov;
var pbo_repeat_on;
var pbo_random;
var pbo_random_ov;
var pbo_random_on;
var pbo_shuffle;
var pbo_shuffle_ov;
var pbo_shuffle_on;
var pbo_shuffle_album;
var pbo_shuffle_album_ov;
var pbo_shuffle_album_on;
var pbo_shuffle_folder;
var pbo_shuffle_folder_ov;
var pbo_shuffle_folder_on;

// Seekbar Object
seekbar = function (x, y, w, h, pad_left, pad_right) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.seekstart = pad_left;
    this.seekend = pad_right;
    this.timer = false;
    
    this.update = function (x, y, w, h, pad_left, pad_right) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.seekstart = pad_left;
        this.seekend = pad_right;
    };
    
    this.draw = function (gr, pos, alpha) {
        gr.FillGradRect(this.x, this.y, pos, this.h, 90, g_textcolor_sel&0x33ffffff, g_textcolor_sel&0xddffffff, 0.5);
    };

    this.repaint = function () {
        window.RepaintRect(this.x, this.y, this.w, this.h);
    };
    
    this.checkstate = function (event, x, y) {
        this.ishover = (x > this.x && x < this.x + this.w - 1 && y > this.y && y < this.y + this.h - 1);
        this.old = this.state;
        switch (event) {
         case "down":

            break;
         case "up":

            break;
         case "right":

             break;
         case "move":
            this.ishover = (x>this.x && x<this.x+this.w && y>this.y-4 && y<this.y+g_seekbar.h+4);
            break;
         case "leave":

            break;
        };
        //if(this.state!=this.old) this.repaint();
        return this.ishover;
    };
};

// Globals
var g_instancetype = window.InstanceType;
var g_font = null;
var custom_font = gdi.Font("Segoe UI", 11, 0);
var ww = 0, wh = 0;
var mouse_x, mouse_y;
var g_metadb = false;
var g_trackinfo_height;
var g_textcolor = 0, g_textcolor_hl = 0;
var g_backcolor = 0;
var g_syscolor = 0;
var COLOR_BTNFACE = 15;
var g_seekbar = null;
var pad_y = 0;
var g_pad_left = 0;
var g_pad_right = 0;
var g_drag = 0;
var g_drag_seek = 0;
var g_stopped = false;
var g_randomize = false;
var hand = false;

// volume vars
var v_drag = 0;
var v_drag_hov = 0;
var volpos = 0;
var volstart = 0;
var volhov_x = 0;
var w2 = 60;
var vol_y = 20;

panel = {
    buttons: Array()
};

//=================================================// Title Formating
var tf_artist = fb.TitleFormat("$if(%length%,%artist%,'Stream')");
var tf_title = fb.TitleFormat("%title%");
var tf_len = fb.Titleformat("[%length%]");
var tf_elap = fb.TitleFormat("%playback_time%");
var tf_remain = fb.TitleFormat("%playback_time_remaining%");
var tf_len_seconds = fb.Titleformat("%length_seconds%");
var g_artist;
var g_title;
var g_separator = fb.TitleFormat(" $char(9679) ").Eval(true);
var g_len = "0:00";
var g_elap = "0:00";
var g_remain;
var g_drag_time;

function get_font() {
    if (g_instancetype == 0) { // CUI
        g_font = window.GetFontCUI(FontTypeCUI.items);
    } else if (g_instancetype == 1) { // DUI
        g_font = window.GetFontDUI(FontTypeDUI.defaults);
    } else {
        // None
    }
}
get_font();

function get_colors() {
    if (g_instancetype == 0) { // CUI
        g_textcolor = window.GetColorCUI(ColorTypeCUI.text);
        g_textcolor_hl = window.GetColorCUI(ColorTypeCUI.text);
        g_textcolor_sel = window.GetColorCUI(ColorTypeCUI.selection_text);
        g_backcolor = window.GetColorCUI(ColorTypeCUI.background);
    } else if (g_instancetype == 1) { // DUI
        g_textcolor = window.GetColorDUI(ColorTypeDUI.text);
        g_textcolor_hl = window.GetColorDUI(ColorTypeDUI.highlight);
        g_textcolor_sel = window.GetColorDUI(ColorTypeDUI.selection);
        g_backcolor = window.GetColorDUI(ColorTypeDUI.background);
    } else {
        // None
    };
    g_syscolor = utils.GetSysColor(COLOR_BTNFACE);
}
get_colors();

// START
function on_size() {
    ww = window.Width;
    wh = window.Height;
    
    if(!ww || !wh) return true;
    
    g_trackinfo_height = wh>50?24:0;
    
    window.MinHeight = 72;
    window.MaxHeight = 72;
    
    g_pad_left = 1;
    g_pad_right = 1;
    pad_y = wh-g_trackinfo_height-7;
    if(!g_seekbar) {
        g_seekbar = new seekbar(g_pad_left, pad_y, ww-g_pad_left-g_pad_right, 6);
    } else {
        g_seekbar.update(g_pad_left, pad_y, ww-g_pad_left-g_pad_right, 6);
    }
    
    // set volume
    volstart = ww - 72;

    init_icons();
    check_buttons();
    on_item_focus_change();
}

function on_paint(gr) {
    
    // Fill default system bg color
    gr.FillSolidRect(0, 0, ww, wh, g_syscolor);
    
    // Draw background (rounded at its top)
    // ====================================
    gr.SetSmoothingMode(2);
    gr.FillRoundRect(-1, 0, ww+1, wh*2, 10, 10, RGB(5, 5, 5));
    // draw shiny effect
    var mid_x = Math.floor(ww/2);
    var delta_w = Math.floor(mid_x/3*2);
    gr.FillGradRect(mid_x-delta_w, 0, ww-delta_w*1, wh, 0, 0, RGBA(255,255,255,70), 0.5);
    gr.FillGradRect(mid_x-delta_w, 0, ww-delta_w*1, wh, 90, 0, RGBA(5, 5, 5, 255), 1.0);
    gr.FillGradRect(mid_x-delta_w, 0, ww-delta_w*1, wh, 90, 0, RGBA(5, 5, 5, 200), 1.0);
    // Finalize background with borders (rounded at its top)
    gr.DrawRoundRect(-1, 0, ww+1, wh*2, 10, 10, 1.0, RGB(35, 35, 40));
    gr.DrawRoundRect(0, 1, ww-1, wh*2, 9, 9, 1.0, RGB(20, 20, 20));
    gr.SetSmoothingMode(0);
    gr.FillGradRect(0, 0, 1, wh, 90, 0, RGBA(250, 250, 250, 10), 1.0);
    gr.FillGradRect(ww-1, 0, 1, wh, 90, 0, RGBA(250, 250, 250, 10), 1.0);
    // Draw gradient white line at its top
    gr.FillGradRect(70, 1, ww-140, 1, 0, 0, RGBA(250, 250, 250, 150), 0.5);
    // Draw seekbar area at bottom MINUS track info height
    gr.FillGradRect(-90, wh-g_trackinfo_height-9, ww+180, 1, 0, 0, RGB(30, 30, 30), 0.5);
    gr.FillSolidRect(1, wh-g_trackinfo_height-8, ww-2, 7, RGB(30,30,30));
    gr.FillGradRect(1, wh-g_trackinfo_height-8, ww-2, 6, 90, RGB(10, 10, 10), RGB(30,30,30), 1.0);
    gr.DrawLine(1, wh-g_trackinfo_height-8, ww-2, wh-g_trackinfo_height-8, 1.0, RGB(0, 0, 0));
    gr.DrawLine(1, wh-g_trackinfo_height-1, ww-2, wh-g_trackinfo_height-1, 1.0, RGBA(0, 0, 0, 20));
    // Draw TrackInfo Area (full bottom of the panel)
    gr.FillGradRect(1, wh-g_trackinfo_height, ww-2, g_trackinfo_height, 0, 0, RGB(40, 40, 40), 0.5);
    gr.FillGradRect(1, wh-g_trackinfo_height, ww-2, g_trackinfo_height, 90, 0, RGB(5, 5, 5), 1.0);
    gr.FillGradRect(0, wh-g_trackinfo_height, ww, 1, 0, 0, RGB(40, 40, 40), 0.5);
    gr.FillGradRect(-90, wh-g_trackinfo_height, ww+180, 1, 0, 0, RGBA(250, 250, 250,20), 0.5);
    // ===
    gr.SetSmoothingMode(2);
    gr.DrawRoundRect(0, 1, ww-1, wh*2, 8, 8, 1.0, RGBA(250, 250, 250, 20));
    gr.SetSmoothingMode(0);
    gr.DrawLine(1, wh-1, ww-2, wh-1, 1.0, RGBA(250, 250, 250, 35));

    // Draw seekbar
    // ============
    if(fb.PlaybackLength>0) {
        if(g_drag) {
            pos = g_seekbar.w * g_drag_seek;
        } else {
            pos = g_seekbar.w * (fb.PlaybackTime / fb.PlaybackLength);
        }
    } else {
        pos = 0;
    }
    // stop at the end if track time is corrupted
    pos = pos<0?0:pos;
    g_seekbar.draw(gr, pos, 175);
    
    // Draw playback buttons
    // =====================
    for(var i=0; i<panel.buttons.length; i++) {
        switch(i) {
            case 0: // Play
                panel.buttons[i].draw(gr, Math.floor((ww/2)-(panel.buttons[i].img[0].Width/2)), 6, 255);
                break;
            case 1: // Prev
                panel.buttons[i].draw(gr, Math.floor((ww/2)-(panel.buttons[0].img[0].Width/2)-7-panel.buttons[i].img[0].Width), 10, 255);
                break;
            case 2: // Next
                panel.buttons[i].draw(gr, Math.floor((ww/2)+(panel.buttons[0].img[0].Width/2)+7), 10, 255);
                break;
            case 3: // Toggle left pane
                panel.buttons[i].draw(gr, 8, 13, 255);
                break;
            case 4: // Toggle right pane
                panel.buttons[i].draw(gr, 42, 13, 255);
                break;
            case 5: // Toggle coverflow
                panel.buttons[i].draw(gr, 25, 13, 255);
                break;
            case 6: // PBO
                panel.buttons[i].draw(gr, 60, 12, 255);
                break;
            case 7: // PBO list
                panel.buttons[i].draw(gr, 86, 12, 255);
                break;
            case 8: // Mute
                panel.buttons[i].draw(gr, ww-108, 13, 255);
                break;
        }
    }
    
    // Draw Times info
    g_elap = Format_hms(g_elap, g_len.length);
    var g_elap_width = gr.CalcTextWidth(g_elap, g_font);
    gr.GdiDrawText(g_elap, g_font, RGB(210,210,210), 5, wh-g_trackinfo_height, g_elap_width, g_trackinfo_height, DT_LEFT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);   
    gr.FillGradRect(5+g_elap_width+5, wh-g_trackinfo_height+2, 1, g_trackinfo_height-4, 90, 0, RGBA(250,250,250,40), 0.5);
    gr.FillGradRect(5+g_elap_width+7, wh-g_trackinfo_height+4, 1, g_trackinfo_height-8, 90, 0, RGBA(250,250,250,30), 0.5);
    gr.FillGradRect(5+g_elap_width+9, wh-g_trackinfo_height+6, 1, g_trackinfo_height-12, 90, 0, RGBA(250,250,250,20), 0.5);
    var g_len_width = gr.CalcTextWidth(g_len, g_font);
    gr.GdiDrawText(g_len, g_font, RGB(210,210,210), ww-5-g_len_width, wh-g_trackinfo_height, g_len_width, g_trackinfo_height, DT_RIGHT | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
    gr.FillGradRect(ww-5-g_len_width-6, wh-g_trackinfo_height+2, 1, g_trackinfo_height-4, 90, 0, RGBA(250,250,250,40), 0.5);
    gr.FillGradRect(ww-5-g_len_width-8, wh-g_trackinfo_height+4, 1, g_trackinfo_height-8, 90, 0, RGBA(250,250,250,30), 0.5);
    gr.FillGradRect(ww-5-g_len_width-10, wh-g_trackinfo_height+6, 1, g_trackinfo_height-12, 90, 0, RGBA(250,250,250,20), 0.5);

    // Draw Now Playing Track Infos
    // ============================
    var trackinfo_x = g_elap_width+18;
    var trackinfo_w = ww - trackinfo_x - (g_elap_width+18);
    gr.GdiDrawText(g_title+g_separator+g_artist, g_font, RGB(0,0,0), trackinfo_x-1, wh-g_trackinfo_height-1, trackinfo_w, g_trackinfo_height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
    gr.GdiDrawText(g_title+g_separator+g_artist, g_font, RGB(0,0,0), trackinfo_x, wh-g_trackinfo_height-1, trackinfo_w, g_trackinfo_height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
    gr.GdiDrawText(g_title+g_separator+g_artist, g_font, RGB(0,0,0), trackinfo_x+1, wh-g_trackinfo_height-1, trackinfo_w, g_trackinfo_height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);
    gr.GdiDrawText(g_title+g_separator+g_artist, g_font, RGB(210,210,210), trackinfo_x, wh-g_trackinfo_height, trackinfo_w, g_trackinfo_height, DT_CENTER | DT_CALCRECT | DT_VCENTER | DT_END_ELLIPSIS | DT_NOPREFIX);

    // Draw volume
    // ===========
    volpos = vol2pos(fb.Volume);

    // background
    gr.DrawRoundRect(volstart-1, vol_y-2, w2+2, 7, 2, 2, 1.0, RGBA(250,250,250,40));
    // active area
    gr.FillSolidRect(volstart+1, vol_y+0, volpos-1, 4, g_textcolor_sel&0x66ffffff);
    gr.FillSolidRect(volstart+1, vol_y+1, volpos-1, 2, g_textcolor_sel&0x99ffffff);

}

function on_mouse_lbtn_down(x, y, mask) {
    // test seekbar drag
    if(x>g_seekbar.x && x<g_seekbar.x+g_seekbar.w && y>g_seekbar.y-4 && y<g_seekbar.y+g_seekbar.h+4) {
	    if(fb.IsPlaying && fb.PlaybackLength) g_drag = true;
        g_drag_seek = (x>g_seekbar.x && x<(g_seekbar.x+g_seekbar.w)) ? ((x-g_seekbar.x)/g_seekbar.w) : (x<=g_seekbar.x) ? 0: 1;
    }
        
    // if volume click (hover true)
    if(v_drag_hov) {
        v_drag = true;
        on_mouse_move(x, y);
    } else {
        v_drag = false;
    }
    
    // buttons
    for(var i=0; i<panel.buttons.length; i++) {
        panel.buttons[i].checkstate("down", x, y);
    };
    
    window.Repaint();
};

function on_mouse_lbtn_up(x, y, mask) {
	// Seekbar
	if(g_drag && g_seekbar.ishover) {
        g_drag_seek = (x>g_seekbar.x && x<(g_seekbar.x+g_seekbar.w)) ? ((x-g_seekbar.x)/g_seekbar.w) : (x<=g_seekbar.x) ? 0: 1;
		fb.PlaybackTime = fb.PlaybackLength * g_drag_seek;
        g_elap = tf_elap.Eval(true);
        g_drag = false;
	} else {
        g_drag = false;
    }
    
    // buttons
    for(var i=0; i<panel.buttons.length; i++) {
        switch(i) {
            case 0:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    if(g_stopped) {
                        g_stopped = false;
                    } else {
                        fb.PlayOrPause();
                    }
                    panel.buttons[i].state = ButtonStates.hover;
                }
                break;
            case 1:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    if(g_randomize) {
                        g_randomize = false;
                    } else {
                        fb.Prev();
                    }
                    panel.buttons[i].state = ButtonStates.hover;
                }
                break;
            case 2:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    if(g_randomize) {
                        g_randomize = false;
                    } else {
                        fb.Next();
                    }
                    panel.buttons[i].state = ButtonStates.hover;
                }
                break;
            case 3:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    window.NotifyOthers("left_pane", "");
                };
                break;
            case 4:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    window.NotifyOthers("right_pane", "");
                };
                break;
            case 5:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    window.NotifyOthers("coverflow_pane", "");
                };
                break;
            case 6:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    if(!fb.StopAfterCurrent) {
                        fb.PlaybackOrder = (fb.PlaybackOrder>5)?0:fb.PlaybackOrder+1;
                        if(fb.PlaybackOrder==0) {
                            fb.RunMainMenuCommand("Playback/Stop After Current");
                        }
                    } else {
                        // removing Stop After Current
                        fb.RunMainMenuCommand("Playback/Stop After Current");
                    }
                    panel.buttons[i].state = ButtonStates.hover;
                };
                break;
            case 7:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    show_pbo_context_menu(95, 21);
                    panel.buttons[i].state = ButtonStates.hover;
                };
                break;
            case 8:
                if(panel.buttons[i].checkstate("up", x, y)==ButtonStates.hover) {
                    fb.VolumeMute();
                    panel.buttons[i].state = ButtonStates.hover;
                };
                break;
        };
    };
    
    v_drag = false;
    
	window.Repaint();
};

function on_mouse_lbtn_dblclk(x, y) {
    // Stop
    if(fb.IsPlaying) {
        if(panel.buttons[0].state==ButtonStates.hover) {
            fb.Stop();
            g_stopped = true;
        };
    };
    // Play Random
    if(panel.buttons[1].state==ButtonStates.hover || panel.buttons[2].state==ButtonStates.hover) {
        fb.Random();
        g_randomize = true;
    };
};

function on_mouse_move(x, y) {
    
    hand = false;

    // Seekbar Seeker
    hand = g_seekbar.checkstate("move", x, y);
    if(g_drag) {       
        g_drag_seek = (x>g_seekbar.x && x<(g_seekbar.x+g_seekbar.w)) ? ((x-g_seekbar.x)/g_seekbar.w) : (x<=g_seekbar.x) ? 0: 1;
        g_seekbar.repaint();
    }
    
    // vol hover?
    var tmp = v_drag_hov;
    if(x>volstart && x<volstart+w2 && y>vol_y-3 && y<vol_y+7) {
        v_drag_hov = true;
        hand = true;
    } else {
        v_drag_hov = false;
    }
    if(tmp!=v_drag_hov) window.Repaint();

	// Volume Seeker
	if(v_drag) {
        var v = pos2vol(x-volstart);
        if(v<=-100) v = -100;
        if(v>=0) v = 0;
		fb.Volume = v;
	}
    
    // buttons
    for(var i=0; i<panel.buttons.length; i++) {
        if(panel.buttons[i].checkstate("move", x, y)==ButtonStates.hover) hand = true;
    };
    
    // Mouse Cursor
    window.SetCursor(hand? IDC_HAND : IDC_ARROW);
    
    mouse_x = x;
    mouse_y = y;
}

function on_mouse_leave() {
    // buttons
    for(var i=0; i<panel.buttons.length; i++) {
        panel.buttons[i].checkstate("leave", 0, 0);
    };
    
    window.Repaint();
}


function on_mouse_wheel(delta) {
    if(v_drag_hov) {
        if(delta>0) {
            volpos = volpos<volstart+w2 ? volpos+2 : volpos;
        } else {
            volpos = volpos<=0 ? volpos : volpos-2;
        }
        var v = pos2vol(volpos);
        if(v<=-100) v = -100;
        if(v>=0) v = 0;
		fb.Volume = v;
        window.Repaint();
    }
}

function on_font_changed() {
    get_font();
    window.Repaint();
}

function on_colors_changed() {
    get_colors();
    window.Repaint();
}

function on_volume_change(val) {
    window.Repaint();
}

//=================================================// Playback Callbacks

function on_playback_starting(cmd, is_paused) {
    g_seekbar.timer && window.ClearInterval(g_seekbar.timer);
    g_seekbar.timer = window.SetInterval(function() {
        g_seekbar.repaint();
    }, 150);
}

function on_playback_new_track(info) {
    check_buttons();
    on_item_focus_change();
    g_elap = "0:00";
}   

function on_playback_stop(reason) {
    if(reason==0) {
        // on user Stop
        check_buttons();
        on_item_focus_change();
        g_elap = "0:00";
    }
    g_seekbar.timer && window.ClearInterval(g_seekbar.timer);
    g_seekbar.timer = false;
}

function on_playback_pause(state) {
    check_buttons();
    window.Repaint();
}

function on_playback_time(time) {
    
    if(!g_seekbar.timer) {
        g_seekbar.timer = window.SetInterval(function() {
            g_seekbar.repaint();
        }, 125);
    };
    
    g_elap = tf_elap.Eval(true);
    window.RepaintRect(0, wh-25, 65, 24);
}

function on_playback_seek(time) {
}

//=================================================// Events
function on_selection_changed(metadb) {
}

function on_playlist_switch() {
    on_item_focus_change();
};

function on_item_focus_change() {
    if(g_metadb) {
        window.UnwatchMetadb();
    };

    g_metadb = fb.IsPlaying?fb.GetNowPlaying():fb.PlaylistItemCount(fb.ActivePlaylist)>0?fb.GetFocusItem():false;

    if(g_metadb) {
        on_metadb_changed();
        window.WatchMetadb(g_metadb);
    };
};

function on_metadb_changed() {
    if(g_metadb) {
        g_artist = tf_artist.EvalWithMetadb(g_metadb);
        g_title = tf_title.EvalWithMetadb(g_metadb);
        g_len = tf_len.Eval(true);
    };
    window.Repaint();
};

function on_playlist_stop_after_current_changed(state) {
    check_buttons();
    window.Repaint();
}

function on_playback_order_changed(new_order_index) {
    check_buttons();
    window.Repaint();
}

//=================================================// Init Icons and Images (no_cover ...)
function init_icons() {
    var i;
    var gb;
    var gui_font = gdi.Font("guifx v2 transports", 15, 0);
    var off_color = RGB(150,150,150);
    var hov_color = RGB(200,200,200);
    var on_colour = g_textcolor_sel;
    var shadow_color = RGB(0,0,0);

    // --- pbo list bt ---

    bt_pbolist_off = gdi.CreateImage(12, 21);
    gb = bt_pbolist_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(-4, 1, 15, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(-4, 1, 15, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(0, 1, 1, 17, RGBA(10,10,15,255));
    gb.FillSolidRect(1, 2, 1, 15, RGBA(40,40,40,255));
    //
    gb.FillSolidRect(4, 10, 5, 1, shadow_color);
    gb.FillSolidRect(5, 11, 3, 1, shadow_color);
    gb.FillSolidRect(6, 12, 1, 1, shadow_color);
    gb.FillSolidRect(4, 09, 5, 1, off_color);
    gb.FillSolidRect(5, 10, 3, 1, off_color);
    gb.FillSolidRect(6, 11, 1, 1, off_color);
    bt_pbolist_off.ReleaseGraphics(gb);

    bt_pbolist_hov = gdi.CreateImage(12, 21);
    gb = bt_pbolist_hov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(-4, 1, 15, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(-4, 1, 15, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(0, 1, 1, 17, RGBA(10,10,15,255));
    gb.FillSolidRect(1, 2, 1, 15, RGBA(40,40,40,255));
    //
    gb.FillSolidRect(4, 10, 5, 1, shadow_color);
    gb.FillSolidRect(5, 11, 3, 1, shadow_color);
    gb.FillSolidRect(6, 12, 1, 1, shadow_color);
    gb.FillSolidRect(4, 09, 5, 1, hov_color);
    gb.FillSolidRect(5, 10, 3, 1, hov_color);
    gb.FillSolidRect(6, 11, 1, 1, hov_color);
    bt_pbolist_hov.ReleaseGraphics(gb);

    bt_pbolist_on = gdi.CreateImage(12, 21);
    gb = bt_pbolist_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(-4, 1, 15, 16, 90, 0, RGBA(250,250,250,25), 1.0);
    gb.DrawRoundRect(-4, 1, 15, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(0, 1, 1, 17, RGBA(10,10,15,255));
    gb.FillSolidRect(1, 2, 1, 15, RGBA(40,40,40,255));
    //
    gb.FillSolidRect(4, 10, 5, 1, on_colour);
    gb.FillSolidRect(5, 11, 3, 1, on_colour);
    gb.FillSolidRect(6, 12, 1, 1, on_colour);
    bt_pbolist_on.ReleaseGraphics(gb);

    // --- pbo bg ---

    bt_pbo_off = gdi.CreateImage(26, 21);
    gb = bt_pbo_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(1, 1, 28, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(1, 1, 28, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(25, 2, 1, 15, RGBA(40,40,40,255));
    bt_pbo_off.ReleaseGraphics(gb);

    bt_pbo_hov = gdi.CreateImage(26, 21);
    gb = bt_pbo_hov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(1, 1, 28, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(1, 1, 28, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(25, 2, 1, 15, RGBA(40,40,40,255));
    bt_pbo_hov.ReleaseGraphics(gb);

    bt_pbo_on = gdi.CreateImage(26, 21);
    gb = bt_pbo_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(1, 1, 28, 16, 90, 0, RGBA(250,250,250,25), 1.0);
    gb.DrawRoundRect(1, 1, 28, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(25, 2, 1, 15, RGBA(40,40,40,255));
    bt_pbo_on.ReleaseGraphics(gb);

    // --- pbo img ---
    
    pbo_sac = gdi.CreateImage(26, 21);
    gb = pbo_sac.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 9, 1, shadow_color);
    gb.FillSolidRect(12, 8, 1, 5, shadow_color);
    gb.FillSolidRect(13, 9, 1, 3, shadow_color);
    gb.FillSolidRect(16, 8, 5, 5, shadow_color);
    gb.FillSolidRect(6, 9, 9, 1, off_color);
    gb.FillSolidRect(12, 7, 1, 5, off_color);
    gb.FillSolidRect(13, 8, 1, 3, off_color);
    gb.FillSolidRect(16, 7, 5, 5, off_color);
    pbo_sac.ReleaseGraphics(gb);

    pbo_sac_ov = gdi.CreateImage(26, 21);
    gb = pbo_sac_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 9, 1, shadow_color);
    gb.FillSolidRect(12, 8, 1, 5, shadow_color);
    gb.FillSolidRect(13, 9, 1, 3, shadow_color);
    gb.FillSolidRect(16, 8, 5, 5, shadow_color);
    gb.FillSolidRect(6, 9, 9, 1, hov_color);
    gb.FillSolidRect(12, 7, 1, 5, hov_color);
    gb.FillSolidRect(13, 8, 1, 3, hov_color);
    gb.FillSolidRect(16, 7, 5, 5, hov_color);
    pbo_sac_ov.ReleaseGraphics(gb);

    pbo_sac_on = gdi.CreateImage(26, 21);
    gb = pbo_sac_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 9, 1, on_colour);
    gb.FillSolidRect(12, 8, 1, 5, on_colour);
    gb.FillSolidRect(13, 9, 1, 3, on_colour);
    gb.FillSolidRect(16, 8, 5, 5, on_colour);
    pbo_sac_on.ReleaseGraphics(gb);


    pbo_normal = gdi.CreateImage(26, 21);
    gb = pbo_normal.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 15, 1, shadow_color);
    gb.FillSolidRect(18, 8, 1, 5, shadow_color);
    gb.FillSolidRect(19, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 9, 15, 1, off_color);
    gb.FillSolidRect(18, 7, 1, 5, off_color);
    gb.FillSolidRect(19, 8, 1, 3, off_color);
    pbo_normal.ReleaseGraphics(gb);

    pbo_normal_ov = gdi.CreateImage(26, 21);
    gb = pbo_normal_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 15, 1, shadow_color);
    gb.FillSolidRect(18, 8, 1, 5, shadow_color);
    gb.FillSolidRect(19, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 9, 15, 1, hov_color);
    gb.FillSolidRect(18, 7, 1, 5, hov_color);
    gb.FillSolidRect(19, 8, 1, 3, hov_color);
    pbo_normal_ov.ReleaseGraphics(gb);

    pbo_normal_on = gdi.CreateImage(26, 21);
    gb = pbo_normal_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 10, 15, 1, on_colour);
    gb.FillSolidRect(18, 8, 1, 5, on_colour);
    gb.FillSolidRect(19, 9, 1, 3, on_colour);
    pbo_normal_on.ReleaseGraphics(gb);


    pbo_repeat_playlist = gdi.CreateImage(26, 21);
    gb = pbo_repeat_playlist.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 11, 3, 1, shadow_color);
    gb.FillSolidRect(15, 7, 6, 1, shadow_color);
    gb.FillSolidRect(6, 14, 15, 1, shadow_color);
    gb.FillSolidRect(5, 12, 1, 2, shadow_color);
    gb.FillSolidRect(21, 8, 1, 6, shadow_color);
    gb.FillSolidRect(17, 5, 1, 5, shadow_color);
    gb.FillSolidRect(16, 6, 1, 3, shadow_color);
    gb.FillSolidRect(10, 7, 4, 1, shadow_color);
    gb.FillSolidRect(10, 9, 4, 1, shadow_color);
    gb.FillSolidRect(10, 11, 4, 1, shadow_color);
    gb.FillSolidRect(6, 10, 3, 1, off_color);
    gb.FillSolidRect(15, 6, 6, 1, off_color);
    gb.FillSolidRect(6, 13, 15, 1, off_color);
    gb.FillSolidRect(5, 11, 1, 2, off_color);
    gb.FillSolidRect(21, 7, 1, 6, off_color);
    gb.FillSolidRect(17, 4, 1, 5, off_color);
    gb.FillSolidRect(16, 5, 1, 3, off_color);
    gb.FillSolidRect(10, 6, 4, 1, off_color);
    gb.FillSolidRect(10, 8, 4, 1, off_color);
    gb.FillSolidRect(10, 10, 4, 1, off_color);
    pbo_repeat_playlist.ReleaseGraphics(gb);
    
    pbo_repeat_playlist_ov = gdi.CreateImage(26, 21);
    gb = pbo_repeat_playlist_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 11, 3, 1, shadow_color);
    gb.FillSolidRect(15, 7, 6, 1, shadow_color);
    gb.FillSolidRect(6, 14, 15, 1, shadow_color);
    gb.FillSolidRect(5, 12, 1, 2, shadow_color);
    gb.FillSolidRect(21, 8, 1, 6, shadow_color);
    gb.FillSolidRect(17, 5, 1, 5, shadow_color);
    gb.FillSolidRect(16, 6, 1, 3, shadow_color);
    gb.FillSolidRect(10, 7, 4, 1, shadow_color);
    gb.FillSolidRect(10, 9, 4, 1, shadow_color);
    gb.FillSolidRect(10, 11, 4, 1, shadow_color);
    gb.FillSolidRect(6, 10, 3, 1, hov_color);
    gb.FillSolidRect(15, 6, 6, 1, hov_color);
    gb.FillSolidRect(6, 13, 15, 1, hov_color);
    gb.FillSolidRect(5, 11, 1, 2, hov_color);
    gb.FillSolidRect(21, 7, 1, 6, hov_color);
    gb.FillSolidRect(17, 4, 1, 5, hov_color);
    gb.FillSolidRect(16, 5, 1, 3, hov_color);
    gb.FillSolidRect(10, 6, 4, 1, hov_color);
    gb.FillSolidRect(10, 8, 4, 1, hov_color);
    gb.FillSolidRect(10, 10, 4, 1, hov_color); 
    pbo_repeat_playlist_ov.ReleaseGraphics(gb);
    
    pbo_repeat_playlist_on = gdi.CreateImage(26, 21);
    gb = pbo_repeat_playlist_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 11, 3, 1, on_colour);
    gb.FillSolidRect(15, 7, 6, 1, on_colour);
    gb.FillSolidRect(6, 14, 15, 1, on_colour);
    gb.FillSolidRect(5, 12, 1, 2, on_colour);
    gb.FillSolidRect(21, 8, 1, 6, on_colour);
    gb.FillSolidRect(17, 5, 1, 5, on_colour);
    gb.FillSolidRect(16, 6, 1, 3, on_colour);
    gb.FillSolidRect(10, 7, 4, 1, on_colour);
    gb.FillSolidRect(10, 9, 4, 1, on_colour);
    gb.FillSolidRect(10, 11, 4, 1, on_colour);
    pbo_repeat_playlist_on.ReleaseGraphics(gb);


    pbo_repeat = gdi.CreateImage(26, 21);
    gb = pbo_repeat.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, shadow_color);
    gb.FillSolidRect(13, 7, 8, 1, shadow_color);
    gb.FillSolidRect(6, 14, 15, 1, shadow_color);
    gb.FillSolidRect(5, 8, 1, 6, shadow_color);
    gb.FillSolidRect(21, 8, 1, 6, shadow_color);
    gb.FillSolidRect(15, 5, 1, 5, shadow_color);
    gb.FillSolidRect(14, 6, 1, 3, shadow_color);
    gb.FillSolidRect(11, 6, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 6, 1, off_color);
    gb.FillSolidRect(13, 6, 8, 1, off_color);
    gb.FillSolidRect(6, 13, 15, 1, off_color);
    gb.FillSolidRect(5, 7, 1, 6, off_color);
    gb.FillSolidRect(21, 7, 1, 6, off_color);
    gb.FillSolidRect(15, 4, 1, 5, off_color);
    gb.FillSolidRect(14, 5, 1, 3, off_color);
    gb.FillSolidRect(11, 5, 1, 3, off_color);
    pbo_repeat.ReleaseGraphics(gb);
    
    pbo_repeat_ov = gdi.CreateImage(26, 21);
    gb = pbo_repeat_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, shadow_color);
    gb.FillSolidRect(13, 7, 8, 1, shadow_color);
    gb.FillSolidRect(6, 14, 15, 1, shadow_color);
    gb.FillSolidRect(5, 8, 1, 6, shadow_color);
    gb.FillSolidRect(21, 8, 1, 6, shadow_color);
    gb.FillSolidRect(15, 5, 1, 5, shadow_color);
    gb.FillSolidRect(14, 6, 1, 3, shadow_color);
    gb.FillSolidRect(11, 6, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 6, 1, hov_color);
    gb.FillSolidRect(13, 6, 8, 1, hov_color);
    gb.FillSolidRect(6, 13, 15, 1, hov_color);
    gb.FillSolidRect(5, 7, 1, 6, hov_color);
    gb.FillSolidRect(21, 7, 1, 6, hov_color);
    gb.FillSolidRect(15, 4, 1, 5, hov_color);
    gb.FillSolidRect(14, 5, 1, 3, hov_color);
    gb.FillSolidRect(11, 5, 1, 3, hov_color);
    pbo_repeat_ov.ReleaseGraphics(gb);
    
    pbo_repeat_on = gdi.CreateImage(26, 21);
    gb = pbo_repeat_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, on_colour);
    gb.FillSolidRect(13, 7, 8, 1, on_colour);
    gb.FillSolidRect(6, 14, 15, 1, on_colour);
    gb.FillSolidRect(5, 8, 1, 6, on_colour);
    gb.FillSolidRect(21, 8, 1, 6, on_colour);
    gb.FillSolidRect(15, 5, 1, 5, on_colour);
    gb.FillSolidRect(14, 6, 1, 3, on_colour);
    gb.FillSolidRect(11, 6, 1, 3, on_colour);
    pbo_repeat_on.ReleaseGraphics(gb);


    pbo_random = gdi.CreateImage(26, 21);
    gb = pbo_random.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("RND", gui_font, shadow_color, 0, 4, 27, 12, ct_stringformat);
    gb.DrawString("RND", gui_font, off_color, 0, 3, 27, 12, ct_stringformat);
    pbo_random.ReleaseGraphics(gb);
    
    pbo_random_ov = gdi.CreateImage(26, 21);
    gb = pbo_random_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("RND", gui_font, shadow_color, 0, 4, 27, 12, ct_stringformat);
    gb.DrawString("RND", gui_font, hov_color, 0, 3, 27, 12, ct_stringformat);
    pbo_random_ov.ReleaseGraphics(gb);
    
    pbo_random_on = gdi.CreateImage(26, 21);
    gb = pbo_random_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(5);
    gb.DrawString("RND", gui_font, on_colour, 0, 4, 27, 12, ct_stringformat);
    pbo_random_on.ReleaseGraphics(gb);


    pbo_shuffle = gdi.CreateImage(26, 21);
    gb = pbo_shuffle.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, shadow_color);
    gb.FillSolidRect(15, 7, 7, 1, shadow_color);
    gb.FillSolidRect(6, 13, 6, 1, shadow_color);
    gb.FillSolidRect(15, 13, 7, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(12, 8, 1, 1, shadow_color);
    gb.FillSolidRect(12, 12, 1, 1, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(13, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 6, 1, off_color);
    gb.FillSolidRect(15, 6, 7, 1, off_color);
    gb.FillSolidRect(6, 12, 6, 1, off_color);
    gb.FillSolidRect(15, 12, 7, 1, off_color);
    gb.FillSolidRect(19, 4, 1, 5, off_color);
    gb.FillSolidRect(19, 10, 1, 5, off_color);
    gb.FillSolidRect(20, 5, 1, 3, off_color);
    gb.FillSolidRect(20, 11, 1, 3, off_color);
    gb.FillSolidRect(12, 7, 1, 1, off_color);
    gb.FillSolidRect(12, 11, 1, 1, off_color);
    gb.FillSolidRect(14, 7, 1, 1, off_color);
    gb.FillSolidRect(14, 11, 1, 1, off_color);
    gb.FillSolidRect(13, 8, 1, 3, off_color);
    pbo_shuffle.ReleaseGraphics(gb);
    
    pbo_shuffle_ov = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, shadow_color);
    gb.FillSolidRect(15, 7, 7, 1, shadow_color);
    gb.FillSolidRect(6, 13, 6, 1, shadow_color);
    gb.FillSolidRect(15, 13, 7, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(12, 8, 1, 1, shadow_color);
    gb.FillSolidRect(12, 12, 1, 1, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(13, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 6, 1, hov_color);
    gb.FillSolidRect(15, 6, 7, 1, hov_color);
    gb.FillSolidRect(6, 12, 6, 1, hov_color);
    gb.FillSolidRect(15, 12, 7, 1, hov_color);
    gb.FillSolidRect(19, 4, 1, 5, hov_color);
    gb.FillSolidRect(19, 10, 1, 5, hov_color);
    gb.FillSolidRect(20, 5, 1, 3, hov_color);
    gb.FillSolidRect(20, 11, 1, 3, hov_color);
    gb.FillSolidRect(12, 7, 1, 1, hov_color);
    gb.FillSolidRect(12, 11, 1, 1, hov_color);
    gb.FillSolidRect(14, 7, 1, 1, hov_color);
    gb.FillSolidRect(14, 11, 1, 1, hov_color);
    gb.FillSolidRect(13, 8, 1, 3, hov_color);
    pbo_shuffle_ov.ReleaseGraphics(gb);
    
    pbo_shuffle_on = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(6, 7, 6, 1, on_colour);
    gb.FillSolidRect(15, 7, 7, 1, on_colour);
    gb.FillSolidRect(6, 13, 6, 1, on_colour);
    gb.FillSolidRect(15, 13, 7, 1, on_colour);
    gb.FillSolidRect(19, 5, 1, 5, on_colour);
    gb.FillSolidRect(19, 11, 1, 5, on_colour);
    gb.FillSolidRect(20, 6, 1, 3, on_colour);
    gb.FillSolidRect(20, 12, 1, 3, on_colour);
    gb.FillSolidRect(12, 8, 1, 1, on_colour);
    gb.FillSolidRect(12, 12, 1, 1, on_colour);
    gb.FillSolidRect(14, 8, 1, 1, on_colour);
    gb.FillSolidRect(14, 12, 1, 1, on_colour);
    gb.FillSolidRect(13, 9, 1, 3, on_colour);
    pbo_shuffle_on.ReleaseGraphics(gb);


    pbo_shuffle_album = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_album.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, shadow_color);
    gb.FillSolidRect(17, 7, 5, 1, shadow_color);
    gb.FillSolidRect(12, 13, 2, 1, shadow_color);
    gb.FillSolidRect(17, 13, 5, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(16, 8, 1, 1, shadow_color);
    gb.FillSolidRect(16, 12, 1, 1, shadow_color);
    gb.FillSolidRect(15, 9, 1, 3, shadow_color);
    gb.FillSolidRect(5, 7, 1, 1, shadow_color);
    gb.FillSolidRect(5, 9, 1, 1, shadow_color);
    gb.FillSolidRect(5, 11, 1, 1, shadow_color);
    gb.FillSolidRect(5, 13, 1, 1, shadow_color);
    gb.FillSolidRect(7, 7, 4, 1, shadow_color);
    gb.FillSolidRect(7, 9, 4, 1, shadow_color);
    gb.FillSolidRect(7, 11, 4, 1, shadow_color);
    gb.FillSolidRect(7, 13, 4, 1, shadow_color);
    gb.FillSolidRect(12, 6, 2, 1, off_color);
    gb.FillSolidRect(17, 6, 5, 1, off_color);
    gb.FillSolidRect(12, 12, 2, 1, off_color);
    gb.FillSolidRect(17, 12, 5, 1, off_color);
    gb.FillSolidRect(19, 4, 1, 5, off_color);
    gb.FillSolidRect(19, 10, 1, 5, off_color);
    gb.FillSolidRect(20, 5, 1, 3, off_color);
    gb.FillSolidRect(20, 11, 1, 3, off_color);
    gb.FillSolidRect(14, 7, 1, 1, off_color);
    gb.FillSolidRect(14, 11, 1, 1, off_color);
    gb.FillSolidRect(16, 7, 1, 1, off_color);
    gb.FillSolidRect(16, 11, 1, 1, off_color);
    gb.FillSolidRect(15, 8, 1, 3, off_color);
    gb.FillSolidRect(5, 6, 1, 1, off_color);
    gb.FillSolidRect(5, 8, 1, 1, off_color);
    gb.FillSolidRect(5, 10, 1, 1, off_color);
    gb.FillSolidRect(5, 12, 1, 1, off_color);
    gb.FillSolidRect(7, 6, 4, 1, off_color);
    gb.FillSolidRect(7, 8, 4, 1, off_color);
    gb.FillSolidRect(7, 10, 4, 1, off_color);
    gb.FillSolidRect(7, 12, 4, 1, off_color);
    pbo_shuffle_album.ReleaseGraphics(gb);
    
    pbo_shuffle_album_ov = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_album_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, shadow_color);
    gb.FillSolidRect(17, 7, 5, 1, shadow_color);
    gb.FillSolidRect(12, 13, 2, 1, shadow_color);
    gb.FillSolidRect(17, 13, 5, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(16, 8, 1, 1, shadow_color);
    gb.FillSolidRect(16, 12, 1, 1, shadow_color);
    gb.FillSolidRect(15, 9, 1, 3, shadow_color);
    gb.FillSolidRect(5, 7, 1, 1, shadow_color);
    gb.FillSolidRect(5, 9, 1, 1, shadow_color);
    gb.FillSolidRect(5, 11, 1, 1, shadow_color);
    gb.FillSolidRect(5, 13, 1, 1, shadow_color);
    gb.FillSolidRect(7, 7, 4, 1, shadow_color);
    gb.FillSolidRect(7, 9, 4, 1, shadow_color);
    gb.FillSolidRect(7, 11, 4, 1, shadow_color);
    gb.FillSolidRect(7, 13, 4, 1, shadow_color);
    gb.FillSolidRect(12, 6, 2, 1, hov_color);
    gb.FillSolidRect(17, 6, 5, 1, hov_color);
    gb.FillSolidRect(12, 12, 2, 1, hov_color);
    gb.FillSolidRect(17, 12, 5, 1, hov_color);
    gb.FillSolidRect(19, 4, 1, 5, hov_color);
    gb.FillSolidRect(19, 10, 1, 5, hov_color);
    gb.FillSolidRect(20, 5, 1, 3, hov_color);
    gb.FillSolidRect(20, 11, 1, 3, hov_color);
    gb.FillSolidRect(14, 7, 1, 1, hov_color);
    gb.FillSolidRect(14, 11, 1, 1, hov_color);
    gb.FillSolidRect(16, 7, 1, 1, hov_color);
    gb.FillSolidRect(16, 11, 1, 1, hov_color);
    gb.FillSolidRect(15, 8, 1, 3, hov_color);
    gb.FillSolidRect(5, 6, 1, 1, hov_color);
    gb.FillSolidRect(5, 8, 1, 1, hov_color);
    gb.FillSolidRect(5, 10, 1, 1, hov_color);
    gb.FillSolidRect(5, 12, 1, 1, hov_color);
    gb.FillSolidRect(7, 6, 4, 1, hov_color);
    gb.FillSolidRect(7, 8, 4, 1, hov_color);
    gb.FillSolidRect(7, 10, 4, 1, hov_color);
    gb.FillSolidRect(7, 12, 4, 1, hov_color);
    pbo_shuffle_album_ov.ReleaseGraphics(gb);
    
    pbo_shuffle_album_on = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_album_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, on_colour);
    gb.FillSolidRect(17, 7, 5, 1, on_colour);
    gb.FillSolidRect(12, 13, 2, 1, on_colour);
    gb.FillSolidRect(17, 13, 5, 1, on_colour);
    gb.FillSolidRect(19, 5, 1, 5, on_colour);
    gb.FillSolidRect(19, 11, 1, 5, on_colour);
    gb.FillSolidRect(20, 6, 1, 3, on_colour);
    gb.FillSolidRect(20, 12, 1, 3, on_colour);
    gb.FillSolidRect(14, 8, 1, 1, on_colour);
    gb.FillSolidRect(14, 12, 1, 1, on_colour);
    gb.FillSolidRect(16, 8, 1, 1, on_colour);
    gb.FillSolidRect(16, 12, 1, 1, on_colour);
    gb.FillSolidRect(15, 9, 1, 3, on_colour);
    gb.FillSolidRect(5, 7, 1, 1, on_colour);
    gb.FillSolidRect(5, 9, 1, 1, on_colour);
    gb.FillSolidRect(5, 11, 1, 1, on_colour);
    gb.FillSolidRect(5, 13, 1, 1, on_colour);
    gb.FillSolidRect(7, 7, 4, 1, on_colour);
    gb.FillSolidRect(7, 9, 4, 1, on_colour);
    gb.FillSolidRect(7, 11, 4, 1, on_colour);
    gb.FillSolidRect(7, 13, 4, 1, on_colour);
    pbo_shuffle_album_on.ReleaseGraphics(gb);


    pbo_shuffle_folder = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_folder.GetGraphics();
    gb.DrawImage(bt_pbo_off, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, shadow_color);
    gb.FillSolidRect(17, 7, 5, 1, shadow_color);
    gb.FillSolidRect(12, 13, 2, 1, shadow_color);
    gb.FillSolidRect(17, 13, 5, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(16, 8, 1, 1, shadow_color);
    gb.FillSolidRect(16, 12, 1, 1, shadow_color);
    gb.FillSolidRect(15, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 2, 1, shadow_color);
    gb.FillSolidRect(6, 11, 2, 1, shadow_color);
    gb.FillSolidRect(6, 7, 5, 3, shadow_color);
    gb.FillSolidRect(6, 12, 5, 3, shadow_color);
    gb.FillSolidRect(12, 6, 2, 1, off_color);
    gb.FillSolidRect(17, 6, 5, 1, off_color);
    gb.FillSolidRect(12, 12, 2, 1, off_color);
    gb.FillSolidRect(17, 12, 5, 1, off_color);
    gb.FillSolidRect(19, 4, 1, 5, off_color);
    gb.FillSolidRect(19, 10, 1, 5, off_color);
    gb.FillSolidRect(20, 5, 1, 3, off_color);
    gb.FillSolidRect(20, 11, 1, 3, off_color);
    gb.FillSolidRect(14, 7, 1, 1, off_color);
    gb.FillSolidRect(14, 11, 1, 1, off_color);
    gb.FillSolidRect(16, 7, 1, 1, off_color);
    gb.FillSolidRect(16, 11, 1, 1, off_color);
    gb.FillSolidRect(15, 8, 1, 3, off_color);
    gb.FillSolidRect(6, 5, 2, 1, off_color);
    gb.FillSolidRect(6, 10, 2, 1, off_color);
    gb.FillSolidRect(6, 6, 5, 3, off_color);
    gb.FillSolidRect(6, 11, 5, 3, off_color);    
    pbo_shuffle_folder.ReleaseGraphics(gb);
    
    pbo_shuffle_folder_ov = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_folder_ov.GetGraphics();
    gb.DrawImage(bt_pbo_hov, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, shadow_color);
    gb.FillSolidRect(17, 7, 5, 1, shadow_color);
    gb.FillSolidRect(12, 13, 2, 1, shadow_color);
    gb.FillSolidRect(17, 13, 5, 1, shadow_color);
    gb.FillSolidRect(19, 5, 1, 5, shadow_color);
    gb.FillSolidRect(19, 11, 1, 5, shadow_color);
    gb.FillSolidRect(20, 6, 1, 3, shadow_color);
    gb.FillSolidRect(20, 12, 1, 3, shadow_color);
    gb.FillSolidRect(14, 8, 1, 1, shadow_color);
    gb.FillSolidRect(14, 12, 1, 1, shadow_color);
    gb.FillSolidRect(16, 8, 1, 1, shadow_color);
    gb.FillSolidRect(16, 12, 1, 1, shadow_color);
    gb.FillSolidRect(15, 9, 1, 3, shadow_color);
    gb.FillSolidRect(6, 6, 2, 1, shadow_color);
    gb.FillSolidRect(6, 11, 2, 1, shadow_color);
    gb.FillSolidRect(6, 7, 5, 3, shadow_color);
    gb.FillSolidRect(6, 12, 5, 3, shadow_color);
    gb.FillSolidRect(12, 6, 2, 1, hov_color);
    gb.FillSolidRect(17, 6, 5, 1, hov_color);
    gb.FillSolidRect(12, 12, 2, 1, hov_color);
    gb.FillSolidRect(17, 12, 5, 1, hov_color);
    gb.FillSolidRect(19, 4, 1, 5, hov_color);
    gb.FillSolidRect(19, 10, 1, 5, hov_color);
    gb.FillSolidRect(20, 5, 1, 3, hov_color);
    gb.FillSolidRect(20, 11, 1, 3, hov_color);
    gb.FillSolidRect(14, 7, 1, 1, hov_color);
    gb.FillSolidRect(14, 11, 1, 1, hov_color);
    gb.FillSolidRect(16, 7, 1, 1, hov_color);
    gb.FillSolidRect(16, 11, 1, 1, hov_color);
    gb.FillSolidRect(15, 8, 1, 3, hov_color);
    gb.FillSolidRect(6, 5, 2, 1, hov_color);
    gb.FillSolidRect(6, 10, 2, 1, hov_color);
    gb.FillSolidRect(6, 6, 5, 3, hov_color);
    gb.FillSolidRect(6, 11, 5, 3, hov_color);
    pbo_shuffle_folder_ov.ReleaseGraphics(gb);
    
    pbo_shuffle_folder_on = gdi.CreateImage(26, 21);
    gb = pbo_shuffle_folder_on.GetGraphics();
    gb.DrawImage(bt_pbo_on, 0, 0, 27, 21, 0, 0, 27, 21, 0, 255);
    gb.FillSolidRect(12, 7, 2, 1, on_colour);
    gb.FillSolidRect(17, 7, 5, 1, on_colour);
    gb.FillSolidRect(12, 13, 2, 1, on_colour);
    gb.FillSolidRect(17, 13, 5, 1, on_colour);
    gb.FillSolidRect(19, 5, 1, 5, on_colour);
    gb.FillSolidRect(19, 11, 1, 5, on_colour);
    gb.FillSolidRect(20, 6, 1, 3, on_colour);
    gb.FillSolidRect(20, 12, 1, 3, on_colour);
    gb.FillSolidRect(14, 8, 1, 1, on_colour);
    gb.FillSolidRect(14, 12, 1, 1, on_colour);
    gb.FillSolidRect(16, 8, 1, 1, on_colour);
    gb.FillSolidRect(16, 12, 1, 1, on_colour);
    gb.FillSolidRect(15, 9, 1, 3, on_colour);
    gb.FillSolidRect(6, 6, 2, 1, on_colour);
    gb.FillSolidRect(6, 11, 2, 1, on_colour);
    gb.FillSolidRect(6, 7, 5, 3, on_colour);
    gb.FillSolidRect(6, 12, 5, 3, on_colour); 
    pbo_shuffle_folder_on.ReleaseGraphics(gb);
       
    // Settings Menu button
    bt_settings_off = gdi.CreateImage(30, 20);
    gb = bt_settings_off.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(150,150,150), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(140,140,140));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,200));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,80));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(140,140,140));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(140,140,140));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(140,140,140));
    bt_settings_off.ReleaseGraphics(gb);

    bt_settings_ov = gdi.CreateImage(30, 20);
    gb = bt_settings_ov.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(190,190,190), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,220));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,140));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(180,180,180));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(180,180,180));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(180,180,180));
    bt_settings_ov.ReleaseGraphics(gb);
    
    bt_settings_on = gdi.CreateImage(30, 20);
    gb = bt_settings_on.GetGraphics();
    gui_font = gdi.Font("Tahoma", 28, 1);
    gb.SetTextRenderingHint(3);
    gb.DrawString("*", gui_font, RGB(230,230,230), 0, 2, 20, 20, lc_stringformat);
    gb.SetSmoothingMode(2);
    gb.FillEllipse(2,3,12,10,RGB(180,180,180));
    gb.DrawEllipse(5,5,6,6,2.0,RGBA(0,0,0,240));
    gb.DrawEllipse(2,3,12,10,1.0,RGBA(0,0,0,160));
    gb.SetSmoothingMode(0);
    gb.DrawLine(16+8-4, 8-2+2, 16+8+4, 8-2+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-3, 8-1+2, 16+8+3, 8-1+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-2, 8-0+2, 16+8+2, 8-0+2, 1.0, RGB(220,220,220));
    gb.DrawLine(16+8-1, 8+1+2, 16+8+1, 8+1+2, 1.0, RGB(220,220,220));
    gb.FillSolidRect(16+8-0, 8+2+2, 1, 1, RGB(220,220,220));
    bt_settings_on.ReleaseGraphics(gb);

    // Playback buttons
    bt_play_off = gdi.CreateImage(30, 30);
    gb = bt_play_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,220));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    var points1s = Array(10, 7, 23, 14, 10, 21);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(11, 8, 21, 14, 11, 20);
    gb.FillPolygon(RGBA(250,250,250,220), 0, points1);
    gb.SetSmoothingMode(0);
    bt_play_off.ReleaseGraphics(gb);

    bt_play_ov = gdi.CreateImage(30, 30);
    gb = bt_play_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,255));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    var points1s = Array(10, 7, 23, 14, 10, 21);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(11, 8, 21, 14, 11, 20);
    gb.FillPolygon(RGBA(250,250,250,255), 0, points1);
    gb.SetSmoothingMode(0);
    bt_play_ov.ReleaseGraphics(gb);
    
    bt_play_on = gdi.CreateImage(30, 30);
    gb = bt_play_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,170));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    var points1s = Array(10, 7, 23, 14, 10, 21);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(11, 8, 21, 14, 11, 20);
    gb.FillPolygon(RGBA(250,250,250,170), 0, points1);
    gb.SetSmoothingMode(0);
    bt_play_on.ReleaseGraphics(gb);

    bt_pause_off = gdi.CreateImage(30, 30);
    gb = bt_pause_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,220));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(9, 8, 12, 13, RGBA(0,0,0,200));
    gb.FillSolidRect(10, 9, 4, 11, RGBA(250,250,250,220));
    gb.FillSolidRect(16, 9, 4, 11, RGBA(250,250,250,220));
    gb.SetSmoothingMode(0);
    bt_pause_off.ReleaseGraphics(gb);

    bt_pause_ov = gdi.CreateImage(30, 30);
    gb = bt_pause_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,255));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(9, 8, 12, 13, RGBA(0,0,0,200));
    gb.FillSolidRect(10, 9, 4, 11, RGBA(250,250,250,255));
    gb.FillSolidRect(16, 9, 4, 11, RGBA(250,250,250,255));
    gb.SetSmoothingMode(0);
    bt_pause_ov.ReleaseGraphics(gb);

    bt_pause_on = gdi.CreateImage(30, 30);
    gb = bt_pause_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.DrawEllipse(0,0,29,29,1.0,RGBA(0,0,0,100));
    gb.DrawEllipse(2,2,25,25,2.0,RGBA(250,250,250,170));
    gb.DrawEllipse(4,4,21,21,1.0,RGBA(0,0,0,100));
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(9, 8, 12, 13, RGBA(0,0,0,200));
    gb.FillSolidRect(10, 9, 4, 11, RGBA(250,250,250,170));
    gb.FillSolidRect(16, 9, 4, 11, RGBA(250,250,250,170));
    gb.SetSmoothingMode(0);
    bt_pause_on.ReleaseGraphics(gb);

    bt_next_off = gdi.CreateImage(28, 18);
    gb = bt_next_off.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(0, 2, 12, 10, 0, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(1, 4, 11, 10, 1, 16);
    gb.FillPolygon(RGBA(250,250,250,220), 0, points1);
    var points2s = Array(10, 2, 22, 10, 10, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(11, 4, 21, 10, 11, 16);
    gb.FillPolygon(RGBA(250,250,250,220), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(21, 3, 5, 15, RGBA(0,0,0,150));
    gb.FillSolidRect(22, 4, 3, 13, RGBA(250,250,250,200));
    bt_next_off.ReleaseGraphics(gb);

    bt_next_ov = gdi.CreateImage(28, 17);
    gb = bt_next_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(0, 2, 12, 10, 0, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(1, 4, 11, 10, 1, 16);
    gb.FillPolygon(RGBA(250,250,250,255), 0, points1);
    var points2s = Array(10, 2, 22, 10, 10, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(11, 4, 21, 10, 11, 16);
    gb.FillPolygon(RGBA(250,250,250,255), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(21, 3, 5, 15, RGBA(0,0,0,150));
    gb.FillSolidRect(22, 4, 3, 13, RGBA(250,250,250,235));
    bt_next_ov.ReleaseGraphics(gb);

    bt_next_on = gdi.CreateImage(28, 17);
    gb = bt_next_on.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(0, 2, 12, 10, 0, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(1, 4, 11, 10, 1, 16);
    gb.FillPolygon(RGBA(250,250,250,170), 0, points1);
    var points2s = Array(10, 2, 22, 10, 10, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(11, 4, 21, 10, 11, 16);
    gb.FillPolygon(RGBA(250,250,250,170), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(21, 3, 5, 15, RGBA(0,0,0,150));
    gb.FillSolidRect(22, 4, 3, 13, RGBA(250,250,250,150));
    bt_next_on.ReleaseGraphics(gb);

    bt_prev_off = gdi.CreateImage(28, 18);
    gb = bt_prev_off.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(27, 2, 15, 10, 27, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(26, 4, 16, 10, 26, 16);
    gb.FillPolygon(RGBA(250,250,250,220), 0, points1);
    var points2s = Array(17, 2, 5, 10, 17, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(16, 4, 6, 10, 16, 16);
    gb.FillPolygon(RGBA(250,250,250,220), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(2, 3, 5, 15, RGBA(0,0,0,120));
    gb.FillSolidRect(3, 4, 3, 13, RGBA(250,250,250,200));
    bt_prev_off.ReleaseGraphics(gb);

    bt_prev_ov = gdi.CreateImage(28, 17);
    gb = bt_prev_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(27, 2, 15, 10, 27, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(26, 4, 16, 10, 26, 16);
    gb.FillPolygon(RGBA(250,250,250,255), 0, points1);
    var points2s = Array(17, 2, 5, 10, 17, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(16, 4, 6, 10, 16, 16);
    gb.FillPolygon(RGBA(250,250,250,255), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(2, 3, 5, 15, RGBA(0,0,0,120));
    gb.FillSolidRect(3, 4, 3, 13, RGBA(250,250,250,235));
    bt_prev_ov.ReleaseGraphics(gb);

    bt_prev_on = gdi.CreateImage(28, 17);
    gb = bt_prev_on.GetGraphics();
    gb.SetSmoothingMode(2);
    var points1s = Array(27, 2, 15, 10, 27, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points1s);
    var points1 = Array(26, 4, 16, 10, 26, 16);
    gb.FillPolygon(RGBA(250,250,250,170), 0, points1);
    var points2s = Array(17, 2, 5, 10, 17, 18);
    gb.FillPolygon(RGBA(0,0,0,200), 0, points2s);
    var points2 = Array(16, 4, 6, 10, 16, 16);
    gb.FillPolygon(RGBA(250,250,250,170), 0, points2);
    gb.SetSmoothingMode(0);
    gb.FillSolidRect(2, 3, 5, 15, RGBA(0,0,0,120));
    gb.FillSolidRect(3, 4, 3, 13, RGBA(250,250,250,150));
    bt_prev_on.ReleaseGraphics(gb);
    
    // pane buttons
    
    bt_left_off = gdi.CreateImage(15, 17);
    gb = bt_left_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("L", gui_font, RGB(0,0,0), 0, 1, 17, 16, cc_stringformat);
    gb.DrawString("L", gui_font, off_color, 0, 0, 17, 16, cc_stringformat);
    bt_left_off.ReleaseGraphics(gb);

    bt_left_ov = gdi.CreateImage(15, 17);
    gb = bt_left_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("L", gui_font, RGB(0,0,0), 0, 1, 17, 16, cc_stringformat);
    gb.DrawString("L", gui_font, hov_color, 0, 0, 17, 16, cc_stringformat);
    bt_left_ov.ReleaseGraphics(gb);

    bt_left_on = gdi.CreateImage(15, 17);
    gb = bt_left_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 1.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("L", gui_font, g_textcolor_sel, 0, 1, 17, 16, cc_stringformat);
    bt_left_on.ReleaseGraphics(gb);

    bt_right_off = gdi.CreateImage(15, 17);
    gb = bt_right_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("R", gui_font, RGB(0,0,0), 0, 1, 16, 16, cc_stringformat);
    gb.DrawString("R", gui_font, off_color, 0, 0, 16, 16, cc_stringformat);
    bt_right_off.ReleaseGraphics(gb);

    bt_right_ov = gdi.CreateImage(15, 17);
    gb = bt_right_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("R", gui_font, RGB(0,0,0), 0, 1, 16, 16, cc_stringformat);
    gb.DrawString("R", gui_font, hov_color, 0, 0, 16, 16, cc_stringformat);
    bt_right_ov.ReleaseGraphics(gb);

    bt_right_on = gdi.CreateImage(15, 17);
    gb = bt_right_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 1.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("R", gui_font, g_textcolor_sel, 0, 1, 16, 16, cc_stringformat);
    bt_right_on.ReleaseGraphics(gb);
    
    bt_center_off = gdi.CreateImage(15, 17);
    gb = bt_center_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("C", gui_font, RGB(0,0,0), 0, 1, 15, 16, cc_stringformat);
    gb.DrawString("C", gui_font, off_color, 0, 0, 15, 16, cc_stringformat);
    bt_center_off.ReleaseGraphics(gb);

    bt_center_ov = gdi.CreateImage(15, 17);
    gb = bt_center_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 0.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("C", gui_font, RGB(0,0,0), 0, 1, 15, 16, cc_stringformat);
    gb.DrawString("C", gui_font, hov_color, 0, 0, 15, 16, cc_stringformat);
    bt_center_ov.ReleaseGraphics(gb);

    bt_center_on = gdi.CreateImage(15, 17);
    gb = bt_center_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 0, 14, 16, 90, 0, RGBA(250,250,250,25), 1.0);
    gb.DrawRoundRect(0, 0, 14, 16, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("Tahoma", 10, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("C", gui_font, g_textcolor_sel, 0, 1, 15, 16, cc_stringformat);
    bt_center_on.ReleaseGraphics(gb);

    bt_mute_off = gdi.CreateImage(31, 17);
    gb = bt_mute_off.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 1, 30, 15, 90, 0, RGBA(250,250,250,30), 0.0);
    gb.DrawRoundRect(0, 1, 30, 15, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("MUTE", gui_font, RGB(0,0,0), 0, 1, 31, 16, cc_stringformat);
    gb.DrawString("MUTE", gui_font, off_color, 0, 0, 31, 16, cc_stringformat);
    bt_mute_off.ReleaseGraphics(gb);

    bt_mute_ov = gdi.CreateImage(31, 17);
    gb = bt_mute_ov.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 1, 30, 15, 90, 0, RGBA(250,250,250,30), 0.0);
    gb.DrawRoundRect(0, 1, 30, 15, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("MUTE", gui_font, RGB(0,0,0), 0, 1, 31, 16, cc_stringformat);
    gb.DrawString("MUTE", gui_font, hov_color, 0, 0, 31, 16, cc_stringformat);
    bt_mute_ov.ReleaseGraphics(gb);

    bt_mute_on = gdi.CreateImage(31, 17);
    gb = bt_mute_on.GetGraphics();
    gb.SetSmoothingMode(2);
    gb.FillGradRect(0, 1, 30, 15, 90, 0, RGBA(250,250,250,30), 1.0);
    gb.DrawRoundRect(0, 1, 30, 15, 3, 3, 1.0, RGB(50,50,50));
    gb.SetSmoothingMode(0);
    gui_font = gdi.Font("uni 05_53", 8, 0);
    gb.SetTextRenderingHint(3);
    gb.DrawString("MUTE", gui_font, RGB(0,0,0), 0, 1, 31, 16, cc_stringformat);
    gb.DrawString("MUTE", gui_font, g_textcolor_sel, 0, 0, 31, 16, cc_stringformat);
    bt_mute_on.ReleaseGraphics(gb);

    panel.buttons.splice(0, panel.buttons.length);
    for(i=0;i<9;i++) {
        switch(i) {
         case 0:
            panel.buttons.push(new button(bt_pause_off, bt_play_ov, bt_play_on));
            break;
         case 1:
            panel.buttons.push(new button(bt_prev_off, bt_prev_ov, bt_prev_on));
            break;
         case 2:
            panel.buttons.push(new button(bt_next_off, bt_next_ov, bt_next_on));
            break;
         case 3:
            panel.buttons.push(new button(bt_left_off, bt_left_ov, bt_left_on));
            break;
         case 4:
            panel.buttons.push(new button(bt_right_off, bt_right_ov, bt_right_on));
            break;
         case 5:
            panel.buttons.push(new button(bt_center_off, bt_center_ov, bt_center_on));
            break;
         case 6:
            panel.buttons.push(new button(bt_pbo_off, bt_pbo_hov, bt_pbo_on));
            break;
         case 7:
            panel.buttons.push(new button(bt_pbolist_off, bt_pbolist_hov, bt_pbolist_on));
            break;
         case 8:
            panel.buttons.push(new button(bt_mute_off, bt_mute_ov, bt_mute_on));
            break;
        };
    };
    
};

function check_buttons() {
    for(i=0;i<3;i++) {
        switch(i) {
         case 0:
            if(!fb.IsPlaying || fb.IsPaused) {
                panel.buttons[0].update(bt_play_off, bt_play_ov, bt_play_on);
            } else if(fb.IsPlaying) {
                panel.buttons[0].update(bt_pause_off, bt_pause_ov, bt_pause_on);
            }
            break;
        };
    };

    // Update Playback Order Button
    if(fb.StopAfterCurrent) {
        panel.buttons[6].update(pbo_sac, pbo_sac_ov, pbo_sac_on);
    } else {
        switch(fb.PlaybackOrder) {
            case 0:
                panel.buttons[6].update(pbo_normal, pbo_normal_ov, pbo_normal_on);
                break;
            case 1:
                panel.buttons[6].update(pbo_repeat_playlist, pbo_repeat_playlist_ov, pbo_repeat_playlist_on);
                break;
            case 2:
                panel.buttons[6].update(pbo_repeat, pbo_repeat_ov, pbo_repeat_on);
                break;
            case 3:
                panel.buttons[6].update(pbo_random, pbo_random_ov, pbo_random_on);
                break;
            case 4:
                panel.buttons[6].update(pbo_shuffle, pbo_shuffle_ov, pbo_shuffle_on);
                break;
            case 5:
                panel.buttons[6].update(pbo_shuffle_album, pbo_shuffle_album_ov, pbo_shuffle_album_on);
                break;
            case 6:
                panel.buttons[6].update(pbo_shuffle_folder, pbo_shuffle_folder_ov, pbo_shuffle_folder_on);
                break;
        };
    };

};

//=================================================// Volume Tools
function pos2vol(pos) {
    return (50 * Math.log(0.99 * (pos/w2<0?0:pos/w2) + 0.01) / Math.LN10);
}

function vol2pos(v){
    return (Math.round(((Math.pow(10, v / 50) - 0.01) / 0.99)*w2));
}

//=======================================================================/ Time formatting tools

//Time formatting secondes -> 0:00
function TimeFmt(t){
	var zpad = function(n){
	var str = n.toString();
		return (str.length<2) ? "0"+str : str;
	}
	var h = Math.floor(t/3600); t-=h*3600;
	var m = Math.floor(t/60); t-=m*60;
	var s = Math.floor(t);
	if(h>0) return h.toString()+":"+zpad(m)+":"+zpad(s);
	return m.toString()+":"+zpad(s);
}

function Format_hms(t, len) {
    if (t) {
        switch(len) {
            case 4:
                var hms = t;
                break;
            case 5:
                switch (t.length) {
                    case 4:
                        var hms = "0" + t;
                        break;
                    case 5:
                        var hms = t;
                        break;
                };
                break;
            case 7:
                switch (t.length) {
                    case 4:
                        var hms = "0:0" + t;
                        break;
                    case 5:
                        var hms = "0:" + t;
                        break;
                    case 7:
                        var hms = t;
                        break;
                };
                break;
            case 8:
                switch (t.length) {
                    case 4:
                        var hms = "00:0" + t;
                        break;
                    case 5:
                        var hms = "00:" + t;
                        break;
                    case 7:
                        var hms = "0" + t;
                        break;
                    case 8:
                        var hms = t;
                        break;
                };
                break;
        };
    } else {
        switch(len) {
            case 4:
                var hms = "0:00";
                break;
            case 5:
                var hms = "00:00";
                break;
            case 7:
                var hms = "0:00:00";
                break;
            case 8:
                var hms = "00:00:00";
                break;
        };
    };
    return hms;
};

//=======================================================================/ Menu(s)

function show_pbo_context_menu(x, y) {
    var MF_SEPARATOR = 0x00000800;
    var MF_STRING = 0x00000000;
    var idx;
    
    var _menu = window.CreatePopupMenu();
    var pbo = fb.PlaybackOrder;
    _menu.AppendMenuItem(MF_STRING, 1, "Default");
    _menu.AppendMenuItem(MF_STRING, 2, "Repeat Playlist");
    _menu.AppendMenuItem(MF_STRING, 3, "Repeat Track");
    _menu.AppendMenuItem(MF_STRING, 4, "Random");
    _menu.AppendMenuItem(MF_STRING, 5, "Shuffle Tracks");
    _menu.AppendMenuItem(MF_STRING, 6, "Shuffle Albums");
    _menu.AppendMenuItem(MF_STRING, 7, "Shuffle Folders");
    _menu.AppendMenuItem(MF_SEPARATOR, 0, "");
    _menu.AppendMenuItem(MF_STRING, 8, "Stop After Current");
    _menu.CheckMenuRadioItem(1, 7, pbo+1);
    _menu.CheckMenuItem(8, fb.StopAfterCurrent?1:0);
    idx = _menu.TrackPopupMenu(x, y);
    switch(idx) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
            pbo = idx-1;
            fb.PlaybackOrder=pbo;
            break;
        case 8:
            fb.RunMainMenuCommand("Playback/Stop After Current");
            check_buttons();
            break;
    }
    _menu.Dispose();
    
    return true;
}

function on_mouse_rbtn_up(x, y) {
    return true;
} `   ������������B��%gq��     �nlj�6�O�7d{�]�&   Splitter (left/right)m�S�@���뉡=�   Lyrics Show Panel v3�Y�y�S@��;[
�Vf   Playlist Organizer0Ԑ�1��E�v�0��   WSH Panel Mod�M�?7�N���~��P�   Biography View���`E�Q��T�   Quicksearch���.hx�L�w��H�3   Splitter (top/bottom)W��w/�@�MR}at*7   �Ht��.�XF뽗   �,��O��9���P   �   �   UD Digi Kyokasho NK-R��Y���H���[�b-T   �䛭$����ǹx�   ��]��oA�-��1������ �@���C�;�2n5'   B���j>:B�fe��u���� k���
~�F����@�� 