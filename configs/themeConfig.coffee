
module.exports = {

defaultPackInfo: {
    wallpaper: {
        "wallpaper-hd": {
            capital: "Wallpaper"
            src: "/default_theme/wallpaper/wallpaper.jpg"
        }
        "wallpaper": {
            capital: "Wallpaper"
            src: "/default_theme/wallpaper/wallpaper.jpg"
            link: [ 'wallpaper', 'wallpaper-hd' ]
        }
    }

    app_icon: {
        "Browser": {
            capital: "Browser"
            src: "/default_theme/app_icon/com_android_browser_com_android_browser_browseractivity.png"
        }
        "Calculator": {
            capital: "Calculator"
            src: "/default_theme/app_icon/com_android_calculator2_com_android_calculator2_calculator.png"
        }
        "Calendar": {
            capital: "Calendar"
            src: "/default_theme/app_icon/com_android_calendar_com_android_calendar_allinoneactivity.png"
        }
        "Camera": {
            capital: "Camera"
            src: "/default_theme/app_icon/com_android_camera_com_android_camera_camera.png"
        }
        "Phone": {
            capital: "Phone"
            src: "/default_theme/app_icon/com_android_contacts_com_android_contacts_activities_dialtactsactivity.png"
        }
        "Contacts": {
            capital: "Contacts"
            src: "/default_theme/app_icon/com_android_contacts_com_android_contacts_activities_peopleactivity.png"
        }
        "Clock": {
            capital: "Clock"
            src: "/default_theme/app_icon/com_android_deskclock_com_android_deskclock_deskclock.png"
        }
        "Email": {
            capital: "Email"
            src: "/default_theme/app_icon/com_android_email_com_android_email_activity_welcome.png"
        }
        "Gallery": {
            capital: "Gallery"
            src: "/default_theme/app_icon/com_android_gallery3d_com_android_gallery3d_app_gallery.png"
        }
        "Messages": {
            capital: "Messages"
            src: "/default_theme/app_icon/com_android_mms_com_android_mms_ui_conversationlist.png"
        }
        "Music": {
            capital: "Music"
            src: "/default_theme/app_icon/com_android_music_com_android_music_musicbrowseractivity.png"
        }
        "Video": {
            capital: "Video"
            src: "/default_theme/app_icon/com_android_music_com_android_music_videobrowseractivity.png"
        }
        "Download": {
            capital: "Downloads"
            src: "/default_theme/app_icon/com_android_providers_downloads_ui_com_android_providers_downloads_ui_downloadlist.png"
        }
        "Search": {
            capital: "Search"
            src: "/default_theme/app_icon/com_android_quicksearchbox_com_android_quicksearchbox_searchactivity.png"
        }
        "Settings": {
            capital: "Settings"
            src: "/default_theme/app_icon/com_android_settings_com_android_settings_settings.png"
        }
        "Maps": {
            capital: "Maps"
            src: "/default_theme/app_icon/com_google_android_apps_maps_com_google_android_maps_mapsactivity.png"
        }
        "Feedback": {
            capital: "Feedback"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_clauncher_userfeedback.png"
        }
        "Beautify": {
            capital: "Beautify Center"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_beauty_center_beautycenterentrance.png"
        }
        "Boutique": {
            capital: "Boutique Center"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_boutique_centerentrance.png"
        }
        "LatestInstalled": {
            capital: "Recent install"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_clauncher_latestinstalled_latestinstalledactivity.png"
        }
        "LatestUsed": {
            capital: "Recent use"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_clauncher_latestused_latestusedactivity.png"
        }
        "Launcher": {
            capital: "CLauncher"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_clauncher_launcher.png"
        }
        "Optimize": {
            capital: "Optimization Center"
            src: "/default_theme/app_icon/com_cyou_cma_clauncher_com_cyou_cma_opti_center_opticenteractivity.png"
        }
        "LockScreen": {
            capital: "LockScreen"
            src: "/default_theme/app_icon/com_cyou_cma_clockscreen_com_cyou_cma_clockscreen_activity_splashactivity.png"
        }
    }

    customize: {
        "customize_mat": {
            capital: "Icon Base"
            src: "/default_theme/customize_mat/default_customize_mat.png"
        }
        "customize_mask": {
            capital: "Icon Shape"
            link: [ 'customize', 'customize_mat' ]
            src: "/default_theme/customize_mat/default_customize_mask.png"
        }
        "customize_icon": {
            capital: "Theme Icon"
            src: "/default_theme/customize_mat/default_customize_icon.png"
        }
    }

    dock_icon: {
        "ic_allapps": {
            capital: "Apps"
            src: "/default_theme/dock_icon/ic_allapps.png"
            link: [ 'dock_icon', 'ic_allapps_pressed' ]
        }
        "ic_allapps_pressed": {
            capital: "Drawer(Pressed)"
            src: "/default_theme/dock_icon/ic_allapps_pressed.png"
        }
        "ic_dockbar_bg": {
            capital: "Dockbar Backgroud"
            src: "/default_theme/dock_icon/dockbg.png"
        }

        "ap_home": {
            capital: "Home"
            link: [ 'dock_icon', 'ap_home_pressed' ]
            src: "/default_theme/dock_icon/ap_home.png"
        }
        "ap_home_pressed": {
            capital: "Home(Pressed)"
            src: "/default_theme/dock_icon/ap_home.png"
        }
        "ap_menu": {
            capital: "Menu"
            link: [ 'dock_icon', 'ap_menu_pressed' ]
            src: "/default_theme/dock_icon/ap_menu.png"
        }
        "ap_menu_pressed": {
            capital: "Menu(Pressed)"
            src: "/default_theme/dock_icon/ap_menu.png"
        }
        "ap_search": {
            capital: "Search"
            link: [ 'dock_icon', 'ap_search_pressed' ]
            src: "/default_theme/dock_icon/ap_search.png"
        }
        "ap_search_pressed": {
            capital: "Search(Pressed)"
            src: "/default_theme/dock_icon/ap_search.png"
        }
    }
    "cma_widget" : {
        "ic_flashlight_on": {
            capital: "FlashOn"
            src: "/default_theme/cma_widget/ic_flashlight_on.png"
        }
        "ic_flashlight_off": {
            capital: "FlashOff"
            src: "/default_theme/cma_widget/ic_flashlight_off.png"
        },
        "ic_widget_all_apps": {
            capital: "All Apps"
            src: "/default_theme/cma_widget/ic_widget_all_apps.png"
        },
        "ic_widget_diy_theme": {
            capital: "DIY Themes"
            src: "/default_theme/cma_widget/ic_widget_diy_theme.png"
        }
    }

  }
}
