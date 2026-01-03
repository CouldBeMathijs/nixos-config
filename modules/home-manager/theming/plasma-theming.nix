{ lib, config, options, ... }:
{
        options = {
                plasma-theming.enable = lib.mkEnableOption "enable plasma-theming";
        };

        config = lib.mkIf config.plasma-theming.enable {
                # Set the plasma config to must be declarative
                programs.plasma.overrideConfig = true;
                programs.plasma = {
                        enable = true;
                        shortcuts = {
                                "KDE Keyboard Layout Switcher" = {
                                        "Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
                                        "Switch to Next Keyboard Layout" = "Meta+Alt+K";
                                };
                                kaccess."Toggle Screen Reader On and Off" = "Meta+Alt+S";
                                kmix = {
                                        decrease_microphone_volume = "Microphone Volume Down";
                                        decrease_volume = "Volume Down";
                                        decrease_volume_small = "Shift+Volume Down";
                                        increase_microphone_volume = "Microphone Volume Up";
                                        increase_volume = "Volume Up";
                                        increase_volume_small = "Shift+Volume Up";
                                        mic_mute = [
                                                "Microphone Mute"
                                                "Meta+Volume Mute"
                                        ];
                                        mute = "Volume Mute";
                                };
                                ksmserver = {
                                        "Halt Without Confirmation" = [ ];
                                        "Lock Session" = [
                                                "Meta+L"
                                                "Screensaver"
                                        ];
                                        "Log Out" = "Ctrl+Alt+Del";
                                        "Log Out Without Confirmation" = [ ];
                                        LogOut = [ ];
                                        Reboot = [ ];
                                        "Reboot Without Confirmation" = [ ];
                                        "Shut Down" = [ ];
                                };
                                kwin = {
                                        "Activate Window Demanding Attention" = "Meta+Ctrl+A";
                                        "Cycle Overview" = [ ];
                                        "Cycle Overview Opposite" = [ ];
                                        "Decrease Opacity" = [ ];
                                        "Edit Tiles" = "Meta+T";
                                        Expose = "Ctrl+F9";
                                        ExposeAll = [
                                                "Ctrl+F10"
                                                "Launch (C)"
                                        ];
                                        ExposeClass = "Ctrl+F7";
                                        ExposeClassCurrentDesktop = [ ];
                                        "Grid View" = "Meta+G";
                                        "Increase Opacity" = [ ];
                                        "Kill Window" = "Meta+Ctrl+Esc";
                                        "Move Tablet to Next Output" = [ ];
                                        MoveMouseToCenter = "Meta+F6";
                                        MoveMouseToFocus = "Meta+F5";
                                        MoveZoomDown = [ ];
                                        MoveZoomLeft = [ ];
                                        MoveZoomRight = [ ];
                                        MoveZoomUp = [ ];
                                        Overview = "Meta+W";
                                        "Setup Window Shortcut" = [ ];
                                        "Show Desktop" = "Meta+D";
                                        "Switch One Desktop Down" = "Meta+Ctrl+Down";
                                        "Switch One Desktop Up" = "Meta+Ctrl+Up";
                                        "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
                                        "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
                                        "Switch Window Down" = "Meta+Alt+Down";
                                        "Switch Window Left" = "Meta+Alt+Left";
                                        "Switch Window Right" = "Meta+Alt+Right";
                                        "Switch Window Up" = "Meta+Alt+Up";
                                        "Switch to Desktop 1" = "Ctrl+F1";
                                        "Switch to Desktop 10" = [ ];
                                        "Switch to Desktop 11" = [ ];
                                        "Switch to Desktop 12" = [ ];
                                        "Switch to Desktop 13" = [ ];
                                        "Switch to Desktop 14" = [ ];
                                        "Switch to Desktop 15" = [ ];
                                        "Switch to Desktop 16" = [ ];
                                        "Switch to Desktop 17" = [ ];
                                        "Switch to Desktop 18" = [ ];
                                        "Switch to Desktop 19" = [ ];
                                        "Switch to Desktop 2" = "Ctrl+F2";
                                        "Switch to Desktop 20" = [ ];
                                        "Switch to Desktop 3" = "Ctrl+F3";
                                        "Switch to Desktop 4" = "Ctrl+F4";
                                        "Switch to Desktop 5" = [ ];
                                        "Switch to Desktop 6" = [ ];
                                        "Switch to Desktop 7" = [ ];
                                        "Switch to Desktop 8" = [ ];
                                        "Switch to Desktop 9" = [ ];
                                        "Switch to Next Desktop" = [ ];
                                        "Switch to Next Screen" = [ ];
                                        "Switch to Previous Desktop" = [ ];
                                        "Switch to Previous Screen" = [ ];
                                        "Switch to Screen 0" = [ ];
                                        "Switch to Screen 1" = [ ];
                                        "Switch to Screen 2" = [ ];
                                        "Switch to Screen 3" = [ ];
                                        "Switch to Screen 4" = [ ];
                                        "Switch to Screen 5" = [ ];
                                        "Switch to Screen 6" = [ ];
                                        "Switch to Screen 7" = [ ];
                                        "Switch to Screen Above" = [ ];
                                        "Switch to Screen Below" = [ ];
                                        "Switch to Screen to the Left" = [ ];
                                        "Switch to Screen to the Right" = [ ];
                                        "Toggle Night Color" = [ ];
                                        "Toggle Window Raise/Lower" = [ ];
                                        "Walk Through Windows" = [
                                                "Meta+Tab"
                                                "Alt+Tab"
                                        ];
                                        "Walk Through Windows (Reverse)" = [
                                                "Meta+Shift+Tab"
                                                "Alt+Shift+Tab"
                                        ];
                                        "Walk Through Windows Alternative" = [ ];
                                        "Walk Through Windows Alternative (Reverse)" = [ ];
                                        "Walk Through Windows of Current Application" = [
                                                "Meta+`"
                                                "Alt+`"
                                        ];
                                        "Walk Through Windows of Current Application (Reverse)" = [
                                                "Meta+~"
                                                "Alt+~"
                                        ];
                                        "Walk Through Windows of Current Application Alternative" = [ ];
                                        "Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
                                        "Window Above Other Windows" = [ ];
                                        "Window Below Other Windows" = [ ];
                                        "Window Close" = "Alt+F4";
                                        "Window Custom Quick Tile Bottom" = [ ];
                                        "Window Custom Quick Tile Left" = [ ];
                                        "Window Custom Quick Tile Right" = [ ];
                                        "Window Custom Quick Tile Top" = [ ];
                                        "Window Fullscreen" = [ ];
                                        "Window Grow Horizontal" = [ ];
                                        "Window Grow Vertical" = [ ];
                                        "Window Lower" = [ ];
                                        "Window Maximize" = "Meta+PgUp";
                                        "Window Maximize Horizontal" = [ ];
                                        "Window Maximize Vertical" = [ ];
                                        "Window Minimize" = "Meta+PgDown";
                                        "Window Move" = [ ];
                                        "Window Move Center" = [ ];
                                        "Window No Border" = [ ];
                                        "Window On All Desktops" = [ ];
                                        "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
                                        "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
                                        "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
                                        "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
                                        "Window One Screen Down" = [ ];
                                        "Window One Screen Up" = [ ];
                                        "Window One Screen to the Left" = [ ];
                                        "Window One Screen to the Right" = [ ];
                                        "Window Operations Menu" = "Alt+F3";
                                        "Window Pack Down" = [ ];
                                        "Window Pack Left" = [ ];
                                        "Window Pack Right" = [ ];
                                        "Window Pack Up" = [ ];
                                        "Window Quick Tile Bottom" = "Meta+Down";
                                        "Window Quick Tile Bottom Left" = [ ];
                                        "Window Quick Tile Bottom Right" = [ ];
                                        "Window Quick Tile Left" = "Meta+Left";
                                        "Window Quick Tile Right" = "Meta+Right";
                                        "Window Quick Tile Top" = "Meta+Up";
                                        "Window Quick Tile Top Left" = [ ];
                                        "Window Quick Tile Top Right" = [ ];
                                        "Window Raise" = [ ];
                                        "Window Resize" = [ ];
                                        "Window Shrink Horizontal" = [ ];
                                        "Window Shrink Vertical" = [ ];
                                        "Window to Desktop 1" = [ ];
                                        "Window to Desktop 10" = [ ];
                                        "Window to Desktop 11" = [ ];
                                        "Window to Desktop 12" = [ ];
                                        "Window to Desktop 13" = [ ];
                                        "Window to Desktop 14" = [ ];
                                        "Window to Desktop 15" = [ ];
                                        "Window to Desktop 16" = [ ];
                                        "Window to Desktop 17" = [ ];
                                        "Window to Desktop 18" = [ ];
                                        "Window to Desktop 19" = [ ];
                                        "Window to Desktop 2" = [ ];
                                        "Window to Desktop 20" = [ ];
                                        "Window to Desktop 3" = [ ];
                                        "Window to Desktop 4" = [ ];
                                        "Window to Desktop 5" = [ ];
                                        "Window to Desktop 6" = [ ];
                                        "Window to Desktop 7" = [ ];
                                        "Window to Desktop 8" = [ ];
                                        "Window to Desktop 9" = [ ];
                                        "Window to Next Desktop" = [ ];
                                        "Window to Next Screen" = "Meta+Shift+Right";
                                        "Window to Previous Desktop" = [ ];
                                        "Window to Previous Screen" = "Meta+Shift+Left";
                                        "Window to Screen 0" = [ ];
                                        "Window to Screen 1" = [ ];
                                        "Window to Screen 2" = [ ];
                                        "Window to Screen 3" = [ ];
                                        "Window to Screen 4" = [ ];
                                        "Window to Screen 5" = [ ];
                                        "Window to Screen 6" = [ ];
                                        "Window to Screen 7" = [ ];
                                        disableInputCapture = "Meta+Shift+Esc";
                                        view_actual_size = "Meta+0";
                                        view_zoom_in = [
                                                "Meta++"
                                                "Meta+="
                                        ];
                                        view_zoom_out = "Meta+-";
                                };
                                mediacontrol = {
                                        mediavolumedown = [ ];
                                        mediavolumeup = [ ];
                                        nextmedia = "Media Next";
                                        pausemedia = "Media Pause";
                                        playmedia = [ ];
                                        playpausemedia = "Media Play";
                                        previousmedia = "Media Previous";
                                        stopmedia = "Media Stop";
                                };
                                org_kde_powerdevil = {
                                        "Decrease Keyboard Brightness" = "Keyboard Brightness Down";
                                        "Decrease Screen Brightness" = "Monitor Brightness Down";
                                        "Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
                                        Hibernate = "Hibernate";
                                        "Increase Keyboard Brightness" = "Keyboard Brightness Up";
                                        "Increase Screen Brightness" = "Monitor Brightness Up";
                                        "Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
                                        PowerDown = "Power Down";
                                        PowerOff = "Power Off";
                                        Sleep = "Sleep";
                                        "Toggle Keyboard Backlight" = "Keyboard Light On/Off";
                                        "Turn Off Screen" = [ ];
                                        powerProfile = [
                                                "Battery"
                                                "Meta+B"
                                        ];
                                };
                                plasmashell = {
                                        "Slideshow Wallpaper Next Image" = [ ];
                                        "activate application launcher" = [
                                                "Meta"
                                                "Alt+F1"
                                        ];
                                        "activate task manager entry 1" = "Meta+1";
                                        "activate task manager entry 10" = [ ];
                                        "activate task manager entry 2" = "Meta+2";
                                        "activate task manager entry 3" = "Meta+3";
                                        "activate task manager entry 4" = "Meta+4";
                                        "activate task manager entry 5" = "Meta+5";
                                        "activate task manager entry 6" = "Meta+6";
                                        "activate task manager entry 7" = "Meta+7";
                                        "activate task manager entry 8" = "Meta+8";
                                        "activate task manager entry 9" = "Meta+9";
                                        clear-history = [ ];
                                        clipboard_action = "Meta+Ctrl+X";
                                        cycle-panels = "Meta+Alt+P";
                                        cycleNextAction = [ ];
                                        cyclePrevAction = [ ];
                                        edit_clipboard = [ ];
                                        "manage activities" = "Meta+Q";
                                        "next activity" = "Meta+A";
                                        "previous activity" = "Meta+Shift+A";
                                        repeat_action = [ ];
                                        "show dashboard" = "Ctrl+F12";
                                        show-barcode = [ ];
                                        show-on-mouse-pos = "Meta+V";
                                        "switch to next activity" = [ ];
                                        "switch to previous activity" = [ ];
                                        "toggle do not disturb" = [ ];
                                };
                        };
                        configFile = {
                                dolphinrc = {
                                        General = {
                                                DoubleClickViewAction = "none";
                                                ViewPropsTimestamp = "2025,12,11,9,42,20.063";
                                        };
                                        "KFileDialog Settings" = {
                                                "Places Icons Auto-resize" = false;
                                                "Places Icons Static Size" = 22;
                                        };
                                };
                                katerc = {
                                        General = {
                                                "Allow Tab Scrolling" = true;
                                                "Auto Hide Tabs" = false;
                                                "Close After Last" = false;
                                                "Close documents with window" = true;
                                                "Cycle To First Tab" = true;
                                                "Days Meta Infos" = 30;
                                                "Diagnostics Limit" = 12000;
                                                "Diff Show Style" = 0;
                                                "Elide Tab Text" = false;
                                                "Enable Context ToolView" = false;
                                                "Expand Tabs" = false;
                                                "Icon size for left and right sidebar buttons" = 32;
                                                "Modified Notification" = false;
                                                "Mouse back button action" = 0;
                                                "Mouse forward button action" = 0;
                                                "Open New Tab To The Right Of Current" = false;
                                                "Output History Limit" = 100;
                                                "Output With Date" = false;
                                                PinnedDocuments = "";
                                                "Recent File List Entry Count" = 10;
                                                "Restore Window Configuration" = true;
                                                "SDI Mode" = false;
                                                "Save Meta Infos" = true;
                                                "Show Full Path in Title" = false;
                                                "Show Menu Bar" = true;
                                                "Show Status Bar" = true;
                                                "Show Symbol In Navigation Bar" = true;
                                                "Show Tab Bar" = true;
                                                "Show Tabs Close Button" = true;
                                                "Show Url Nav Bar" = true;
                                                "Show output view for message type" = 1;
                                                "Show text for left and right sidebar" = false;
                                                "Show welcome view for new window" = true;
                                                "Startup Session" = "manual";
                                                "Stash new unsaved files" = true;
                                                "Stash unsaved file changes" = false;
                                                "Sync section size with tab positions" = false;
                                                "Tab Double Click New Document" = true;
                                                "Tab Middle Click Close Document" = true;
                                                "Tabbar Tab Limit" = 0;
                                        };
                                        "KTextEditor Renderer" = {
                                                "Animate Bracket Matching" = false;
                                                "Auto Color Theme Selection" = true;
                                                "Color Theme" = "Breeze Dark";
                                                "Line Height Multiplier" = 1;
                                                "Show Indentation Lines" = false;
                                                "Show Whole Bracket Expression" = false;
                                                "Text Font" = "nasin-nanpa,26,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
                                                "Text Font Features" = "";
                                                "Word Wrap Marker" = false;
                                        };
                                        "KTextEditor View" = {
                                                "Allow Mark Menu" = true;
                                                "Auto Brackets" = true;
                                                "Auto Center Lines" = 0;
                                                "Auto Completion" = true;
                                                "Auto Completion Preselect First Entry" = true;
                                                "Backspace Remove Composed Characters" = false;
                                                "Bookmark Menu Sorting" = 0;
                                                "Bracket Match Preview" = false;
                                                "Chars To Enclose Selection" = "<>(){}[]'\"";
                                                "Cycle Through Bookmarks" = true;
                                                "Default Mark Type" = 1;
                                                "Disable current line highlight if inactive" = false;
                                                "Dynamic Word Wrap" = true;
                                                "Dynamic Word Wrap Align Indent" = 80;
                                                "Dynamic Word Wrap At Static Marker" = false;
                                                "Dynamic Word Wrap Indicators" = 1;
                                                "Dynamic Wrap not at word boundaries" = false;
                                                "Enable Accessibility" = true;
                                                "Enable Tab completion" = false;
                                                "Enter To Insert Completion" = true;
                                                "Fold First Line" = false;
                                                "Folding Bar" = true;
                                                "Folding Preview" = true;
                                                "Hide cursor if inactive" = false;
                                                "Icon Bar" = false;
                                                "Input Mode" = 0;
                                                "Keyword Completion" = true;
                                                "Line Modification" = true;
                                                "Line Numbers" = true;
                                                "Max Clipboard History Entries" = 20;
                                                "Maximum Search History Size" = 100;
                                                "Mouse Paste At Cursor Position" = false;
                                                "Multiple Cursor Modifier" = 134217728;
                                                "Persistent Selection" = false;
                                                "Scroll Bar Marks" = false;
                                                "Scroll Bar Mini Map All" = true;
                                                "Scroll Bar Mini Map Width" = 60;
                                                "Scroll Bar MiniMap" = true;
                                                "Scroll Bar Preview" = true;
                                                "Scroll Past End" = false;
                                                "Search/Replace Flags" = 140;
                                                "Shoe Line Ending Type in Statusbar" = false;
                                                "Show Documentation With Completion" = true;
                                                "Show File Encoding" = true;
                                                "Show Folding Icons On Hover Only" = true;
                                                "Show Line Count" = false;
                                                "Show Scrollbars" = 0;
                                                "Show Statusbar Dictionary" = true;
                                                "Show Statusbar Highlighting Mode" = true;
                                                "Show Statusbar Input Mode" = true;
                                                "Show Statusbar Line Column" = true;
                                                "Show Statusbar Tab Settings" = true;
                                                "Show Word Count" = false;
                                                "Smart Copy Cut" = true;
                                                "Statusbar Line Column Compact Mode" = true;
                                                "Text Drag And Drop" = true;
                                                "User Sets Of Chars To Enclose Selection" = "";
                                                "Vi Input Mode Steal Keys" = false;
                                                "Vi Relative Line Numbers" = false;
                                                "Word Completion" = true;
                                                "Word Completion Minimal Word Length" = 3;
                                                "Word Completion Remove Tail" = true;
                                        };
                                        Konsole = {
                                                AutoSyncronizeMode = 0;
                                                KonsoleEscKeyBehaviour = true;
                                                KonsoleEscKeyExceptions = "vi,vim,nvim,git";
                                                RemoveExtension = false;
                                                RunPrefix = "";
                                                SetEditor = false;
                                        };
                                        filetree = {
                                                editShade = "30,78,103";
                                                listMode = false;
                                                middleClickToClose = false;
                                                shadingEnabled = true;
                                                showCloseButton = false;
                                                showFullPathOnRoots = false;
                                                showToolbar = true;
                                                sortRole = 0;
                                                viewShade = "77,46,91";
                                        };
                                        lspclient = {
                                                AllowedServerCommandLines = "";
                                                AutoHover = true;
                                                AutoImport = true;
                                                BlockedServerCommandLines = "";
                                                CompletionDocumentation = true;
                                                CompletionParens = true;
                                                Diagnostics = true;
                                                FormatOnSave = false;
                                                HighlightGoto = true;
                                                HighlightSymbol = true;
                                                IncrementalSync = false;
                                                InlayHints = false;
                                                Messages = true;
                                                ReferencesDeclaration = true;
                                                SemanticHighlighting = true;
                                                ServerConfiguration = "";
                                                ShowCompletions = true;
                                                SignatureHelp = true;
                                                SymbolDetails = false;
                                                SymbolExpand = true;
                                                SymbolSort = false;
                                                SymbolTree = true;
                                                TypeFormatting = false;
                                        };
                                };
                                kded5rc.Module-device_automounter.autoload = false;
                                kdeglobals = {
                                        General = {
                                                AccentColor = "166,152,129";
                                                LastUsedCustomAccentColor = "166,152,129";
                                        };
                                        "KFileDialog Settings" = {
                                                "Allow Expansion" = false;
                                                "Automatically select filename extension" = true;
                                                "Breadcrumb Navigation" = true;
                                                "Decoration position" = 2;
                                                "Show Full Path" = false;
                                                "Show Inline Previews" = true;
                                                "Show Preview" = false;
                                                "Show Speedbar" = true;
                                                "Show hidden files" = false;
                                                "Sort by" = "Name";
                                                "Sort directories first" = true;
                                                "Sort hidden files last" = false;
                                                "Sort reversed" = false;
                                                "Speedbar Width" = 140;
                                                "View Style" = "DetailTree";
                                        };
                                        PreviewSettings = {
                                                EnableRemoteFolderThumbnail = false;
                                                MaximumRemoteSize = 0;
                                        };
                                        WM = {
                                                activeBackground = "39,44,49";
                                                activeBlend = "252,252,252";
                                                activeForeground = "252,252,252";
                                                inactiveBackground = "32,36,40";
                                                inactiveBlend = "161,169,177";
                                                inactiveForeground = "161,169,177";
                                        };
                                };
                                kiorc = {
                                        Confirmations = {
                                                ConfirmDelete = true;
                                                ConfirmEmptyTrash = true;
                                                ConfirmTrash = false;
                                        };
                                };
                                ksmserverrc.General.loginMode = "emptySession";
                                ksplashrc.KSplash.Theme = "Colourful-Ring-Splashscreen-Plasma6";
                                kwalletrc.Wallet."First Use" = false;
                                kwinrc = {
                                        NightColor = {
                                                Active = true;
                                                NightTemperature = 3200;
                                        };
                                        Plugins = {
                                                slidebackEnabled = true;
                                                wobblywindowsEnabled = true;
                                        };
                                        "org.kde.kdecoration2" = {
                                                ButtonsOnLeft = "XIAS";
                                                ButtonsOnRight = "HM";
                                        };
                                };
                                plasma-localerc.Formats.LANG = "en_US.UTF-8";
                                plasmarc.Wallpapers.usersWallpapers = "/home/mathijs/.dotfiles/images/bulbs.jpg";
                        };
                        dataFile = {
                                "kate/anonymous.katesession" = {
                                        "Kate Plugins" = {
                                                bookmarksplugin = false;
                                                cmaketoolsplugin = false;
                                                compilerexplorer = false;
                                                eslintplugin = false;
                                                externaltoolsplugin = true;
                                                formatplugin = false;
                                                katebacktracebrowserplugin = false;
                                                katebuildplugin = false;
                                                katecloseexceptplugin = false;
                                                katecolorpickerplugin = false;
                                                katectagsplugin = false;
                                                katefilebrowserplugin = false;
                                                katefiletreeplugin = true;
                                                kategdbplugin = false;
                                                kategitblameplugin = false;
                                                katekonsoleplugin = true;
                                                kateprojectplugin = true;
                                                katereplicodeplugin = false;
                                                katesearchplugin = true;
                                                katesnippetsplugin = false;
                                                katesqlplugin = false;
                                                katesymbolviewerplugin = false;
                                                katexmlcheckplugin = false;
                                                katexmltoolsplugin = false;
                                                keyboardmacrosplugin = false;
                                                ktexteditorpreviewplugin = false;
                                                latexcompletionplugin = false;
                                                lspclientplugin = true;
                                                openlinkplugin = false;
                                                rainbowparens = false;
                                                rbqlplugin = false;
                                                tabswitcherplugin = true;
                                                templateplugin = false;
                                                textfilterplugin = true;
                                        };
                                        "MainWindow0-Splitter 0" = {
                                                Children = "MainWindow0-ViewSpace 0";
                                                Orientation = 1;
                                                Sizes = 2515;
                                        };
                                        "MainWindow0-ViewSpace 0" = {
                                                "Active View" = 1;
                                                Count = 2;
                                                Documents = "0,1";
                                                "View 0" = 0;
                                                "View 1" = 1;
                                        };
                                        "MainWindow0-ViewSpace 0 0" = {
                                                CursorColumn = 1;
                                                CursorLine = 1;
                                        };
                                        "Plugin:katesearchplugin:MainWindow:0" = {
                                                BinaryFiles = false;
                                                CurrentExcludeFilter = "-1";
                                                CurrentFilter = "-1";
                                                ExcludeFilters = "";
                                                ExpandSearchResults = false;
                                                Filters = "";
                                                FollowSymLink = false;
                                                HiddenFiles = false;
                                                MatchCase = false;
                                                Place = 1;
                                                Recursive = true;
                                                Replaces = "";
                                                Search = "";
                                                SearchAsYouTypeAllProjects = true;
                                                SearchAsYouTypeCurrentFile = true;
                                                SearchAsYouTypeFolder = true;
                                                SearchAsYouTypeOpenFiles = true;
                                                SearchAsYouTypeProject = true;
                                                SearchDiskFiles = "";
                                                SearchDiskFiless = "";
                                                SizeLimit = 128;
                                                UseRegExp = false;
                                        };
                                };
                        };
                };

        };
}
