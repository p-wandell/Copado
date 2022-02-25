import { LightningElement, api } from 'lwc';

export default class GoogleCalendarApp extends LightningElement {
    @api title = '';

    @api cardOn = false;

    @api URL = '';

    @api username = '';

    @api mode = 'Month';

    @api propWeekStart = '';
    @api weekStart = '';

    @api propTitle = false;
    @api showTitle = "";

    @api propNav = false;
    @api showNav = "";

    @api propDate = false;
    @api showDate = "";

    @api propPrint = false;
    @api showPrint = "";

    @api propTabs = false;
    @api showTabs = "";

    @api propCalendars = false;
    @api showCalendars = "";

    @api propTZ = false;
    @api showTZ = "";

    @api height = '100%';
    @api width = '100%';

    @api bgColor = '23ffffff';

    @api propLanguage = '';
    @api language = '';

    @api propTZBuilder = '';
    @api TZ = '';

    @api propLanguageCommunity = '';

    @api titleOn = false;

    handleStuff() {
        if(this.propTitle === false) {
            this.showTitle = "0";
        }
        else {
            this.showTitle = "1";
        }
        if(this.propNav === false) {
            this.showNav = "0";
        }
        else {
            this.showNav = "1";
        }
        if(this.propDate === false) {
            this.showDate = "0";
        }
        else {
            this.showDate = "1";
        }
        if(this.propPrint === false) {
            this.showPrint = "0";
        }
        else {
            this.showPrint = "1";
        }
        if(this.propTabs === false) {
            this.showTabs = "0";
        }
        else {
            this.showTabs = "1";
        }
        if(this.propCalendars === false) {
            this.showCalendars = "0";
        }
        else {
            this.showCalendars = "1";
        }
        if(this.propTZ === false) {
            this.showTZ = "0";
        }
        else {
            this.showTZ = "1";
        }

        if(this.propWeekStart === "Sunday") {
            this.weekStart = "1";
        }
        if(this.propWeekStart === "Monday") {
            this.weekStart = "2";
        }
        if(this.propWeekStart === "Tuesday") {
            this.weekStart = "3";
        }
        if(this.propWeekStart === "Wednesday") {
            this.weekStart = "4";
        }
        if(this.propWeekStart === "Thursday") {
            this.weekStart = "5";
        }
        if(this.propWeekStart === "Friday") {
            this.weekStart = "6";
        }
        if(this.propWeekStart === "Saturday") {
            this.weekStart = "7";
        }

        if(this.propLanguage === "Afrikaans" || this.propLanguageCommunity.toLocaleLowerCase() === "af") {
            this.language = "af";
        }
        if(this.propLanguage === "azərbaycan" || this.propLanguageCommunity.toLocaleLowerCase() === "az") {
            this.language = "az";
        }
        if(this.propLanguage === "Bahasa Indonesia" || this.propLanguageCommunity.toLocaleLowerCase() === "id") {
            this.language = "id";
        }
        if(this.propLanguage === "Català" || this.propLanguageCommunity.toLocaleLowerCase() === "ca") {
            this.language = "ca";
        }
        if(this.propLanguage === "Cymraeg" || this.propLanguageCommunity.toLocaleLowerCase() === "cy") {
            this.language = "cy";
        }
        if(this.propLanguage === "Dansk" || this.propLanguageCommunity.toLocaleLowerCase() === "da") {
            this.language = "da";
        }
        if(this.propLanguage === "Deutsch" || this.propLanguageCommunity.toLocaleLowerCase() === "de") {
            this.language = "de";
        }
        if(this.propLanguage === "English (UK)" || this.propLanguageCommunity.toLocaleLowerCase() === "en_gb") {
            this.language = "en_GB";
        }
        if(this.propLanguage === "English (US)" || this.propLanguageCommunity.toLocaleLowerCase() === "en") {
            this.language = "en";
        }
        if(this.propLanguage === "Español" || this.propLanguageCommunity.toLocaleLowerCase() === "es") {
            this.language = "es";
        }
        if(this.propLanguage === "Español (Latinoamérica)" || this.propLanguageCommunity.toLocaleLowerCase() === "es_419") {
            this.language = "es_419";
        }
        if(this.propLanguage === "eskara" || this.propLanguageCommunity.toLocaleLowerCase() === "eu") {
            this.language = "eu";
        }
        if(this.propLanguage === "Filipino" || this.propLanguageCommunity.toLocaleLowerCase() === "fil") {
            this.language = "fil";
        }
        if(this.propLanguage === "Français" || this.propLanguageCommunity.toLocaleLowerCase() === "fr") {
            this.language = "fr";
        }
        if(this.propLanguage === "Français (Canada)" || this.propLanguageCommunity.toLocaleLowerCase() === "fr_ca") {
            this.language = "fr_CA";
        }
        if(this.propLanguage === "galego" || this.propLanguageCommunity.toLocaleLowerCase() === "gl") {
            this.language = "gl";
        }
        if(this.propLanguage === "Hrvatski" || this.propLanguageCommunity.toLocaleLowerCase() === "hr") {
            this.language = "hr";
        }
        if(this.propLanguage === "isiZulu" || this.propLanguageCommunity.toLocaleLowerCase() === "zu") {
            this.language = "zu";
        }
        if(this.propLanguage === "Italiano" || this.propLanguageCommunity.toLocaleLowerCase() === "it") {
            this.language = "it";
        }
        if(this.propLanguage === "Kiswahili" || this.propLanguageCommunity.toLocaleLowerCase() === "sw") {
            this.language = "sw";
        }
        if(this.propLanguage === "Latviešu" || this.propLanguageCommunity.toLocaleLowerCase() === "lv") {
            this.language = "lv";
        }
        if(this.propLanguage === "Lietuvių" || this.propLanguageCommunity.toLocaleLowerCase() === "lt") {
            this.language = "lt";
        }
        if(this.propLanguage === "Magyar" || this.propLanguageCommunity.toLocaleLowerCase() === "hu") {
            this.language = "hu";
        }
        if(this.propLanguage === "Melayu" || this.propLanguageCommunity.toLocaleLowerCase() === "ms") {
            this.language = "ms";
        }
        if(this.propLanguage === "Nederlands" || this.propLanguageCommunity.toLocaleLowerCase() === "nl") {
            this.language = "nl";
        }
        if(this.propLanguage === "Norsk (bokmål)‎" || this.propLanguageCommunity.toLocaleLowerCase() === "no") {
            this.language = "no";
        }
        if(this.propLanguage === "Polski" || this.propLanguageCommunity.toLocaleLowerCase() === "pl") {
            this.language = "pl";
        }
        if(this.propLanguage === "Português (Brasil)‎" || this.propLanguageCommunity.toLocaleLowerCase() === "pt_br") {
            this.language = "pt_BR";
        }
        if(this.propLanguage === "Português (Portugal)" || this.propLanguageCommunity.toLocaleLowerCase() === "pt_pt") {
            this.language = "pt_PT";
        }
        if(this.propLanguage === "Română" || this.propLanguageCommunity.toLocaleLowerCase() === "ro") {
            this.language = "ro";
        }
        if(this.propLanguage === "Slovenčina" || this.propLanguageCommunity.toLocaleLowerCase() === "sk") {
            this.language = "sk";
        }
        if(this.propLanguage === "Slovenščina" || this.propLanguageCommunity.toLocaleLowerCase() === "sl") {
            this.language = "sl";
        }
        if(this.propLanguage === "Suomi" || this.propLanguageCommunity.toLocaleLowerCase() === "fi") {
            this.language = "fi";
        }
        if(this.propLanguage === "Svenska‎" || this.propLanguageCommunity.toLocaleLowerCase() === "sv") {
            this.language = "sv";
        }
        if(this.propLanguage === "Tiếng Việt" || this.propLanguageCommunity.toLocaleLowerCase() === "vi") {
            this.language = "vi";
        }
        if(this.propLanguage === "Türkçe‎" || this.propLanguageCommunity.toLocaleLowerCase() === "tr") {
            this.language = "tr";
        }
        if(this.propLanguage === "íslenska" || this.propLanguageCommunity.toLocaleLowerCase() === "is") {
            this.language = "is";
        }
        if(this.propLanguage === "Čeština" || this.propLanguageCommunity.toLocaleLowerCase() === "cs") {
            this.language = "cs";
        }
        if(this.propLanguage === "Ελληνικά" || this.propLanguageCommunity.toLocaleLowerCase() === "el") {
            this.language = "el";
        }
        if(this.propLanguage === "Български" || this.propLanguageCommunity.toLocaleLowerCase() === "bg") {
            this.language = "bg";
        }
        if(this.propLanguage === "монгол" || this.propLanguageCommunity.toLocaleLowerCase() === "mn") {
            this.language = "mn";
        }
        if(this.propLanguage === "Русский" || this.propLanguageCommunity.toLocaleLowerCase() === "ru") {
            this.language = "ru";
        }
        if(this.propLanguage === "Српски" || this.propLanguageCommunity.toLocaleLowerCase() === "sr") {
            this.language = "sr";
        }
        if(this.propLanguage === "Українська" || this.propLanguageCommunity.toLocaleLowerCase() === "uk") {
            this.language = "uk";
        }
        if(this.propLanguage === "Հայերեն" || this.propLanguageCommunity.toLocaleLowerCase() === "hy") {
            this.language = "hy";
        }
        if(this.propLanguage === "עברית" || this.propLanguageCommunity.toLocaleLowerCase() === "iw") {
            this.language = "iw";
        }
        if(this.propLanguage === "العربية" || this.propLanguageCommunity.toLocaleLowerCase() === "ar") {
            this.language = "ar";
        }
        if(this.propLanguage === "اُردُو‬" || this.propLanguageCommunity.toLocaleLowerCase() === "ur") {
            this.language = "ur";
        }
        if(this.propLanguage === "فارسی" || this.propLanguageCommunity.toLocaleLowerCase() === "fa") {
            this.language = "fa";
        }
        if(this.propLanguage === "नेपाली" || this.propLanguageCommunity.toLocaleLowerCase() === "ne") {
            this.language = "ne";
        }
        if(this.propLanguage === "मराठी" || this.propLanguageCommunity.toLocaleLowerCase() === "mr") {
            this.language = "mr";
        }
        if(this.propLanguage === "हिन्दी" || this.propLanguageCommunity.toLocaleLowerCase() === "hi") {
            this.language = "hi";
        }
        if(this.propLanguage === "বাংলা" || this.propLanguageCommunity.toLocaleLowerCase() === "bn") {
            this.language = "bn";
        }
        if(this.propLanguage === "ગુજરાતી" || this.propLanguageCommunity.toLocaleLowerCase() === "gu") {
            this.language = "gu";
        }
        if(this.propLanguage === "தமிழ்" || this.propLanguageCommunity.toLocaleLowerCase() === "ta") {
            this.language = "ta";
        }
        if(this.propLanguage === "తెలుగు" || this.propLanguageCommunity.toLocaleLowerCase() === "te") {
            this.language = "te";
        }
        if(this.propLanguage === "ಕನ್ನಡ" || this.propLanguageCommunity.toLocaleLowerCase() === "kn") {
            this.language = "kn";
        }
        if(this.propLanguage === "മലയാളം" || this.propLanguageCommunity.toLocaleLowerCase() === "ml") {
            this.language = "ml";
        }
        if(this.propLanguage === "සිංහල" || this.propLanguageCommunity.toLocaleLowerCase() === "si") {
            this.language = "si";
        }
        if(this.propLanguage === "ภาษาไทย" || this.propLanguageCommunity.toLocaleLowerCase() === "th") {
            this.language = "th";
        }
        if(this.propLanguage === "ລາວ" || this.propLanguageCommunity.toLocaleLowerCase() === "lo") {
            this.language = "lo";
        }
        if(this.propLanguage === "မြန်မာ" || this.propLanguageCommunity.toLocaleLowerCase() === "my") {
            this.language = "my";
        }
        if(this.propLanguage === "ქართული" || this.propLanguageCommunity.toLocaleLowerCase() === "ka") {
            this.language = "ka";
        }
        if(this.propLanguage === "አማርኛ" || this.propLanguageCommunity.toLocaleLowerCase() === "am") {
            this.language = "am";
        }
        if(this.propLanguage === "ខ្មែរ" || this.propLanguageCommunity.toLocaleLowerCase() === "km") {
            this.language = "km";
        }
        if(this.propLanguage === "中文 (香港)‎" || this.propLanguageCommunity.toLocaleLowerCase() === "zh_hk") {
            this.language = "zh_HK";
        }
        if(this.propLanguage === "中文 (简体‎)‎" || this.propLanguageCommunity.toLocaleLowerCase() === "zh_cn") {
            this.language = "zh_CN";
        }
        if(this.propLanguage === "中文 (繁體)‎" || this.propLanguageCommunity.toLocaleLowerCase() === "zh_tw") {
            this.language = "zh_TW";
        }
        if(this.propLanguage === "日本語" || this.propLanguageCommunity.toLocaleLowerCase() === "ja") {
            this.language = "ja";
        }
        if(this.propLanguage === "한국어" || this.propLanguageCommunity.toLocaleLowerCase() === "ko") {
            this.language = "ko";
        }

        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Kiritimati".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FKiritimati"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Enderbury".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FEnderbury"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Tongatapu".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FTongatapu"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Chatham".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FChatham"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Auckland".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FAuckland"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Fiji".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FFiji"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kamchatka".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKamchatka"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Norfolk".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FNorfolk"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Lord_Howe".toLocaleLowerCase()) {
            this.TZ = "Australia%2FLord_Howe"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Guadalcanal".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FGuadalcanal"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Adelaide".toLocaleLowerCase()) {
            this.TZ = "Australia%2FAdelaide"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Sydney".toLocaleLowerCase()) {
            this.TZ = "Australia2%FSydney"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Brisbane".toLocaleLowerCase()) {
            this.TZ = "Australia%2FBrisbane"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Darwin".toLocaleLowerCase()) {
            this.TZ = "Australia%2FDarwin"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Seoul".toLocaleLowerCase()) {
            this.TZ = "Asia%2FSeoul"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Tokyo".toLocaleLowerCase()) {
            this.TZ = "Asia%2FTokyo"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Hong_Kong".toLocaleLowerCase()) {
            this.TZ = "Asia%2FHong_Kong"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kuala_Lumpur".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKuala_Lumpur"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Manila".toLocaleLowerCase()) {
            this.TZ = "Asia%2FManila"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Shanghai".toLocaleLowerCase()) {
            this.TZ = "Asia%2FShanghai"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Singapore".toLocaleLowerCase()) {
            this.TZ = "Asia%2FSingapore"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Taipei".toLocaleLowerCase()) {
            this.TZ = "Asia%2FTaipei"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Australia/Perth".toLocaleLowerCase()) {
            this.TZ = "Australia%2FPerth"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Bangkok".toLocaleLowerCase()) {
            this.TZ = "Asia%2FBangkok"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Ho_Chi_Minh".toLocaleLowerCase()) {
            this.TZ = "Asia%2FHo_Chi_Minh"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Jakarta".toLocaleLowerCase()) {
            this.TZ = "Asia%2FJakarta"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Rangoon".toLocaleLowerCase()) {
            this.TZ = "Asia%2FRangoon"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Dhaka".toLocaleLowerCase()) {
            this.TZ = "Asia%2FDhaka"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kathmandu".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKathmandu"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Colombo".toLocaleLowerCase()) {
            this.TZ = "Asia%2FColombo"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kolkata".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKolkata"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Karachi".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKarachi"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Tashkent".toLocaleLowerCase()) {
            this.TZ = "Asia%2FTashkent"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Yekaterinburg".toLocaleLowerCase()) {
            this.TZ = "Asia%2FYekaterinburg"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kabul".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKabul"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Baku".toLocaleLowerCase()) {
            this.TZ = "Asia%2FBaku"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Dubai".toLocaleLowerCase()) {
            this.TZ = "Asia%2FDubai"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Tbilisi".toLocaleLowerCase()) {
            this.TZ = "Asia%2FTbilisi"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Yerevan".toLocaleLowerCase()) {
            this.TZ = "Asia%2FYerevan"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Tehran".toLocaleLowerCase()) {
            this.TZ = "Asia%2FTehran"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Africa/Nairobi".toLocaleLowerCase()) {
            this.TZ = "Africa%2FNairobi"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Baghdad".toLocaleLowerCase()) {
            this.TZ = "Asia%2FBaghdad"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Kuwait".toLocaleLowerCase()) {
            this.TZ = "Asia%2FKuwait"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Riyadh".toLocaleLowerCase()) {
            this.TZ = "Asia%2FRiyadh"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Minsk".toLocaleLowerCase()) {
            this.TZ = "Europe%2FMinsk"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Moscow".toLocaleLowerCase()) {
            this.TZ = "Europe%2FMoscow"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Africa/Cairo".toLocaleLowerCase()) {
            this.TZ = "Africa%2FCairo"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Beirut".toLocaleLowerCase()) {
            this.TZ = "Asia%2FBeirut"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Asia/Jerusalem".toLocaleLowerCase()) {
            this.TZ = "Asia%2FJerusalem"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Athens".toLocaleLowerCase()) {
            this.TZ = "Europe%2FAthens"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Bucharest".toLocaleLowerCase()) {
            this.TZ = "Europe%2FBucharest"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Helsinki".toLocaleLowerCase()) {
            this.TZ = "Europe%2FHelsinki"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Istanbul".toLocaleLowerCase()) {
            this.TZ = "Europe%2FIstanbul"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Africa/Johannesburg".toLocaleLowerCase()) {
            this.TZ = "Africa%2FJohannesburg"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Amsterdam".toLocaleLowerCase()) {
            this.TZ = "Europe%2FAmsterdam"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Berlin".toLocaleLowerCase()) {
            this.TZ = "Europe%2FBerlin"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Brussels".toLocaleLowerCase()) {
            this.TZ = "Europe%2FBrussels"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Paris".toLocaleLowerCase()) {
            this.TZ = "Europe%2FParis"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Prague".toLocaleLowerCase()) {
            this.TZ = "Europe%2FPrague"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Rome".toLocaleLowerCase()) {
            this.TZ = "Europe%2FRome"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Lisbon".toLocaleLowerCase()) {
            this.TZ = "Europe%2FLisbon"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Africa/Algiers".toLocaleLowerCase()) {
            this.TZ = "Africa%2FAlgiers"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/London".toLocaleLowerCase()) {
            this.TZ = "Europe%2FLondon"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Atlantic/Cape_Verde".toLocaleLowerCase()) {
            this.TZ = "Atlantic%2FCape_Verde"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Africa/Casablanca".toLocaleLowerCase()) {
            this.TZ = "Africa%2FCasablanca"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Europe/Dublin".toLocaleLowerCase()) {
            this.TZ = "Europe%2FDublin"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "GMT".toLocaleLowerCase()) {
            this.TZ = "Etc"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Scoresbysund".toLocaleLowerCase()) {
            this.TZ = "America%2FScoresbysund"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Atlantic/Azores".toLocaleLowerCase()) {
            this.TZ = "Atlantic%2FAzores"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Atlantic/South_Georgia".toLocaleLowerCase()) {
            this.TZ = "Atlantic%2FSouth_Georgia"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/St_Johns".toLocaleLowerCase()) {
            this.TZ = "America%2FSt_Johns"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Sao_Paulo".toLocaleLowerCase()) {
            this.TZ = "America%2FSao_Paulo"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Argentina/Buenos_Aires".toLocaleLowerCase()) {
            this.TZ = "America%2FArgentina%2FBuenos_Aires"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Santiago".toLocaleLowerCase()) {
            this.TZ = "America%2FSantiago"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Halifax".toLocaleLowerCase()) {
            this.TZ = "America%2FHalifax"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Puerto_Rico".toLocaleLowerCase()) {
            this.TZ = "America%2FPuerto_Rico"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Atlantic/Bermuda".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FKiritimati"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Caracas".toLocaleLowerCase()) {
            this.TZ = "Americ%2FCaracas"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Indiana/Indianapolis".toLocaleLowerCase()) {
            this.TZ = "America%2FIndiana%2FIndianapolis"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/New_York".toLocaleLowerCase()) {
            this.TZ = "America%2FNew_York"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Bogota".toLocaleLowerCase()) {
            this.TZ = "America%2FBogota"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Lima".toLocaleLowerCase()) {
            this.TZ = "America%2FLima"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Panama".toLocaleLowerCase()) {
            this.TZ = "America%2FPanama"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Mexico_City".toLocaleLowerCase()) {
            this.TZ = "America%2FMexico_City"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Chicago".toLocaleLowerCase()) {
            this.TZ = "America%2FChicago"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/El_Salvador".toLocaleLowerCase()) {
            this.TZ = "America%2FEl_Salvador"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Denver".toLocaleLowerCase()) {
            this.TZ = "America%2FDenver"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Mazatlan".toLocaleLowerCase()) {
            this.TZ = "America%2FMazatlan"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Phoenix".toLocaleLowerCase()) {
            this.TZ = "America%2FPhoenix"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Los_Angeles".toLocaleLowerCase()) {
            this.TZ = "America%2FLos_Angeles"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Tijuana".toLocaleLowerCase()) {
            this.TZ = "America%2FTijuana"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Pitcairn".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FPitcairn"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Anchorage".toLocaleLowerCase()) {
            this.TZ = "America%2FAnchorage"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Gambier".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FGambier"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "America/Adak".toLocaleLowerCase()) {
            this.TZ = "America%2FAdak"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Marquesas".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FMarquesas"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Honolulu".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FHonolulu"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Niue".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FNiue"
        }
        if(this.propTZBuilder.toLocaleLowerCase() === "Pacific/Pago_Pago".toLocaleLowerCase()) {
            this.TZ = "Pacific%2FPago_Pago"
        }

        if(this.title === "") {
            this.titleOn = false;
        }
        else {
            this.titleOn = true;
        }

        if (this.pagePosition === "Right") {
            this.pageRight=true;
        } 
        if (this.pagePosition === "Left") {
            this.pageLeft=true;
        }
        if (this.pagePosition === "Center") {
            this.pageCenter=true;
        }
    }

    @api pagePosition = "Right";

    get wrapperClass() {
        return `slds-text-align_${this.pagePosition.toLowerCase()}`;
      }

    makeURL() {
        this.URL = "https://calendar.google.com/calendar/embed?src=" + encodeURIComponent(this.username) + "&height=600&wkst=" + this.weekStart + "&bgcolor=%23ffffff&ctz=" + this.TZ + "&color=%23039BE5&color=%2333B679&color=%230B8043&color=%23F6BF26&showTitle=" + this.showTitle + "&showNav="+ this.showNav + "&showDate=" + this.showDate + "&showPrint=" + this.showPrint + "&showTabs=" + this.showTabs + "&showCalendars=" +this.showCalendars + "&showTz=" + this.showTZ + "&mode=" + this.mode + "&hl=" + this.language;
    }

    connectedCallback() {
        this.handleStuff();
        this.makeURL();
    }
}