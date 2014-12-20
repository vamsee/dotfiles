import System.IO
-- import System.Exit
import XMonad
import XMonad.Actions.CycleWS
-- import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.SetWMName
-- import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
-- import qualified XMonad.StackSet as W

myManageHook = composeAll
   [ className =? "Iceweasel"     --> doShift "1"
   , className =? "Skype"         --> doShift "2"
   , className =? "Emacs"         --> doShift "3"
   , className =? "Terminator"    --> doShift "4"
   , className =? "Thunar"        --> doShift "5"
   , className =? "Pidgin"        --> doShift "6"
   , className =? "Xchat"         --> doShift "7"
   , className =? "Xfce4-notifyd" --> doIgnore
   , className =? "Mpv"           --> doFloat
   , isFullscreen                 --> doFullFloat
   , isDialog                     --> doCenterFloat
   ]

main = do
    statusBar <- spawnPipe myDzenStatus
    conkyBar <- spawnPipe myDzenConky

    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
        , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
        , terminal = "terminator"
        , logHook = myLogHook statusBar
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((mod4Mask, xK_Down), nextWS)
        , ((mod4Mask, xK_Up), prevWS)
        , ((mod4Mask, xK_Right), nextScreen)
        , ((mod4Mask, xK_Left), prevScreen)
        , ((mod4Mask .|. shiftMask, xK_s), spawn "dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop")
        -- XF86AudioMute
        , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")
        -- XF86AudioRaiseVolume
        , ((0, 0x1008ff13), spawn "amixer -q set Master 5%+")
        -- XF86AudioLowerVolume
        , ((0, 0x1008ff11), spawn "amixer -q set Master 5%-")
        -- XF86MonBrightnessUp
        , ((0, 0x1008ff02), spawn "xbacklight + 10")
        -- XF86MonBrightnessDown
        , ((0, 0x1008ff03), spawn "xbacklight - 10")
        ]

-- Forward the window information to the left dzen bar and format it
myLogHook h = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }

-- Left bar is 1000px wide, right one 500, rest is taken by trayer
myDzenStatus = "dzen2 -x '0' -w '1000' -ta 'l'" ++ myDzenStyle
myDzenConky  = "conky -c ~/.conkyrc | dzen2 -x '1000' -w '500' -ta 'r'" ++ myDzenStyle

-- Bar style 24px high and colors
myDzenStyle  = " -xs '1' -h '24' -y '-1' -fg '#777777' -bg '#222222'"

-- Very plain formatting, non-empty workspaces are highlighted,
-- urgent workspaces (e.g. active IM window) are highlighted in red
myDzenPP  = dzenPP
    { ppCurrent = dzenColor "#3399ff" "" . wrap " " " "
    , ppHidden  = dzenColor "#dddddd" "" . wrap " " " "
    , ppHiddenNoWindows = dzenColor "#777777" "" . wrap " " " "
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
    , ppSep     = "  "
    , ppTitle   = dzenColor "#ffffff" "" . wrap " " " "
    }
