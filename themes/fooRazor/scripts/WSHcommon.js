//=================================================// General declarations
SM_CXVSCROLL = 2;
SM_CYHSCROLL = 3;
DLGC_WANTARROWS = 0x0001;
DLGC_WANTALLKEYS = 0x0004;
// }}
// Use with MenuManager() 
// {{
MF_STRING = 0x00000000;
MF_SEPARATOR = 0x00000800;
MF_GRAYED = 0x00000001;
MF_DISABLED = 0x00000002;
MF_POPUP = 0x00000010;
// }}
// Used in window.SetCursor()
// {{
IDC_ARROW = 32512;
IDC_IBEAM = 32513;
IDC_WAIT = 32514;
IDC_CROSS = 32515;
IDC_UPARROW = 32516;
IDC_SIZE = 32640;
IDC_ICON = 32641;
IDC_SIZENWSE = 32642;
IDC_SIZENESW = 32643;
IDC_SIZEWE = 32644;
IDC_SIZENS = 32645;
IDC_SIZEALL = 32646;
IDC_NO = 32648;
IDC_APPSTARTING = 32650;
IDC_HAND = 32649;
IDC_HELP = 32651;
// }}
// Use with GdiDrawText() 
// {{
var DT_LEFT = 0x00000000;
var DT_RIGHT = 0x00000002;
var DT_TOP = 0x00000000;
var DT_CENTER = 0x00000001;
var DT_VCENTER = 0x00000004;
var DT_WORDBREAK = 0x00000010;
var DT_SINGLELINE = 0x00000020;
var DT_CALCRECT = 0x00000400;
var DT_NOPREFIX = 0x00000800;
var DT_EDITCONTROL = 0x00002000;
var DT_END_ELLIPSIS = 0x00008000;
// }}
// Keyboard Flags & Tools
// {{
var VK_BACK = 0x08;
var VK_RETURN = 0x0D;
var VK_SHIFT = 0x10;
var VK_CONTROL = 0x11;
var VK_ALT = 0x12;
var VK_ESCAPE = 0x1B;
var VK_PGUP = 0x21;
var VK_PGDN = 0x22;
var VK_END = 0x23;
var VK_HOME = 0x24;
var VK_LEFT = 0x25;
var VK_UP = 0x26;
var VK_RIGHT = 0x27;
var VK_DOWN = 0x28;
var VK_INSERT = 0x2D;
var VK_DELETE = 0x2E;
var VK_SPACEBAR = 0x20;
var KMask = {
    none: 0,
    ctrl: 1,
    shift: 2,
    ctrlshift: 3,
    ctrlalt: 4,
    ctrlaltshift: 5,
    alt: 6
};
function GetKeyboardMask() {
    var c = utils.IsKeyPressed(VK_CONTROL) ? true : false;
    var a = utils.IsKeyPressed(VK_ALT) ? true : false;
    var s = utils.IsKeyPressed(VK_SHIFT) ? true : false;
    var ret = KMask.none;
    if (c && !a && !s) ret = KMask.ctrl;
    if (!c && !a && s) ret = KMask.shift;
    if (c && !a && s) ret = KMask.ctrlshift;
    if (c && a && !s) ret = KMask.ctrlalt;
    if (c && a && s) ret = KMask.ctrlaltshift;
    if (!c && a && !s) ret = KMask.alt;
    return ret;
};
// }}
// {{
// Used in window.GetColorCUI()
ColorTypeCUI = {
    text: 0,
    selection_text: 1,
    inactive_selection_text: 2,
    background: 3,
    selection_background: 4,
    inactive_selection_background: 5,
    active_item_frame: 6
};
// Used in window.GetFontCUI()
FontTypeCUI = {
    items: 0,
    labels: 1
};
// Used in window.GetColorDUI()
ColorTypeDUI = {
    text: 0,
    background: 1,
    highlight: 2,
    selection: 3
};
// Used in window.GetFontDUI()
FontTypeDUI = {
    defaults: 0,
    tabs: 1,
    lists: 2,
    playlists: 3,
    statusbar: 4,
    console: 5
};
//}}
// {{
// Used in gr.DrawString()
function StringFormat() {
    var h_align = 0,
    v_align = 0,
    trimming = 0,
    flags = 0;
    switch (arguments.length) {
        case 3:
        trimming = arguments[2];
        case 2:
        v_align = arguments[1];
        case 1:
        h_align = arguments[0];
        break;
        default:
        return 0;
    };
    return ((h_align << 28) | (v_align << 24) | (trimming << 20) | flags);
};
StringAlignment = {
    Near: 0,
    Centre: 1,
    Far: 2
};
var lt_stringformat = StringFormat(StringAlignment.Near, StringAlignment.Near);
var ct_stringformat = StringFormat(StringAlignment.Centre, StringAlignment.Near);
var rt_stringformat = StringFormat(StringAlignment.Far, StringAlignment.Near);
var lc_stringformat = StringFormat(StringAlignment.Near, StringAlignment.Centre);
var cc_stringformat = StringFormat(StringAlignment.Centre, StringAlignment.Centre);
var rc_stringformat = StringFormat(StringAlignment.Far, StringAlignment.Centre);
var lb_stringformat = StringFormat(StringAlignment.Near, StringAlignment.Far);
var cb_stringformat = StringFormat(StringAlignment.Centre, StringAlignment.Far);
var rb_stringformat = StringFormat(StringAlignment.Far, StringAlignment.Far);
//}}
// {{
// Used in utils.GetAlbumArt()
AlbumArtId = {
	front: 0,
	back: 1,
	disc: 2,
	icon: 3,
	artist: 4
};
//}}
// {{
// Used everywhere!
function RGB(r, g, b) {
    return (0xff000000 | (r << 16) | (g << 8) | (b));
};
function RGBA(r, g, b, a) {
    return ((a << 24) | (r << 16) | (g << 8) | (b));
};
function getAlpha(color) {
    return ((color >> 24) & 0xff);
}

function getRed(color) {
    return ((color >> 16) & 0xff);
}

function getGreen(color) {
    return ((color >> 8) & 0xff);
}

function getBlue(color) {
    return (color & 0xff);
}
function num(strg, nb) {
    var i;
    var str = strg.toString();
    var k = nb - str.length;
    if (k > 0) {
        for (i=0;i<k;i++) {
            str = "0" + str;
        };
    };
    return str.toString();
};
//Time formatting secondes -> 0:00
function TimeFromSeconds(t){
    var zpad = function(n){
    var str = n.toString();
        return (str.length<2) ? "0"+str : str;
    };
    var h = Math.floor(t/3600); t-=h*3600;
    var m = Math.floor(t/60); t-=m*60;
    var s = Math.floor(t);
    if(h>0) return h.toString()+":"+zpad(m)+":"+zpad(s);
    return m.toString()+":"+zpad(s);
};
function TrackType(trkpath) {
    var taggable;
    var type;
    switch (trkpath) {
        case "file":
        taggable = 1;
        type = 0;
        break;
        case "cdda":
        taggable = 1;
        type = 1;
        break;
        case "FOO_":
        taggable = 0;
        type = 2;
        break;
        case "http":
        taggable = 0;
        type = 3;
        break;
        case "mms:":
        taggable = 0;
        type = 3;
        break;
        case "unpa":
        taggable = 0;
        type = 4;
        break;
        default:
        taggable = 0;
        type = 5;
    };
    return type;
};
function replaceAll(str, search, repl) {
    while (str.indexOf(search) != -1) {
        str = str.replace(search, repl);
    };
    return str;
};
function removeAccents(str) {
    /*
    var norm = new Array('À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë',
    'Ì','Í','Î','Ï', 'Ð','Ñ','Ò','Ó','Ô','Õ','Ö','Ø','Ù','Ú','Û','Ü','Ý',
    'Þ','ß');
    var spec = new Array('A','A','A','A','A','A','AE','C','E','E','E','E',
    'I','I','I','I', 'D','N','O','O','O','O','O','O','U','U','U','U','Y',
    'b','SS');
    for (var i = 0; i < spec.length; i++) {
        str = replaceAll(str, norm[i], spec[i]);
    };
    */
    return str;
};
//}}

//=================================================// Button object
ButtonStates = {normal: 0, hover: 1, down: 2};
button = function (normal, hover, down) {
    this.img = Array(normal, hover, down);
    this.w = this.img[0].Width;
    this.h = this.img[0].Height;
    this.state = ButtonStates.normal;
    this.update = function (normal, hover, down) {
        this.img = Array(normal, hover, down);
    };
    this.draw = function (gr, x, y, alpha) {
        this.x = x;
        this.y = y;
        this.img[this.state] && gr.DrawImage(this.img[this.state], this.x, this.y, this.w, this.h, 0, 0, this.w, this.h, 0, alpha);
    };
    this.display_context_menu = function (x, y, id) {};
    this.repaint = function () {
        window.RepaintRect(this.x, this.y, this.w, this.h);
    };
    this.checkstate = function (event, x, y) {
        this.ishover = (x > this.x && x < this.x + this.w - 1 && y > this.y && y < this.y + this.h - 1);
        this.old = this.state;
        switch (event) {
         case "down":
            switch(this.state) {
             case ButtonStates.normal:
             case ButtonStates.hover:
                this.state = this.ishover ? ButtonStates.down : ButtonStates.normal;
                break;
            };
            break;
         case "up":
            this.state = this.ishover ? ButtonStates.hover : ButtonStates.normal;
            break;
         case "right":
             if(this.ishover) this.display_context_menu(x, y, id);
             break;
         case "move":
            switch(this.state) {
             case ButtonStates.normal:
             case ButtonStates.hover:
                this.state = this.ishover ? ButtonStates.hover : ButtonStates.normal;
                break;
            };
            break;
         case "leave":
            this.state = this.isdown ? ButtonStates.down : ButtonStates.normal;
            break;
        };
        if(this.state!=this.old) this.repaint();
        return this.state;
    };
};

//=================================================// Tools (general)
function get_system_scrollbar_width() {
    var tmp = utils.GetSystemMetrics(SM_CXVSCROLL);
    return tmp;
};

function get_system_scrollbar_height() {
    var tmp = utils.GetSystemMetrics(SM_CYHSCROLL);
    return tmp;
};

String.prototype.repeat = function(num) {
    if(num>=0 && num<=5) {
        var g = Math.round(num);
    } else {
        return "";
    };
    return new Array(g+1).join(this);
};

function getTimestamp() {
    var d, s1, s2, s3, hh, min, sec, timestamp;
    d = new Date();
    s1 = d.getFullYear();
    s2 = (d.getMonth() + 1);
    s3 = d.getDate();
    hh = d.getHours();
    min = d.getMinutes();
    sec = d.getSeconds();
    if(s3.length == 1) s3 = "0" + s3;
    timestamp = s1 + ((s2 < 10) ? "-0" : "-") + s2 + ((s3 < 10) ? "-0" : "-" ) + s3 + ((hh < 10) ? " 0" : " ") + hh + ((min < 10) ? ":0" : ":") + min + ((sec < 10) ? ":0" : ":") + sec;
    return timestamp;
};
