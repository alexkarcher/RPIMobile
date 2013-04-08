#!/bin/sh

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "rsync -rp ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -rp "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename $1 .xcdatamodeld`.momd"
      ;;
    *)
      echo "cp -R ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      cp -R "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
      ;;
  esac
}
install_resource 'ABCalendarPicker/ABCalendarPicker/GradientBar.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TileDisabledSelected.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TileNormal.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TilePattern.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TileSelected.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TileToday.png'
install_resource 'ABCalendarPicker/ABCalendarPicker/TileTodaySelected.png'
install_resource 'CKCalendar/Source/resources/left_arrow.png'
install_resource 'CKCalendar/Source/resources/left_arrow@2x.png'
install_resource 'CKCalendar/Source/resources/right_arrow.png'
install_resource 'CKCalendar/Source/resources/right_arrow@2x.png'
install_resource 'ISRefreshControl/ISRefreshControl/Images/ISRefresgControlIcon.png'
install_resource 'ISRefreshControl/ISRefreshControl/Images/ISRefresgControlIcon@2x.png'
install_resource 'MFSideMenu/MFSideMenuDemo/MFSideMenu/back-arrow.png'
install_resource 'MFSideMenu/MFSideMenuDemo/MFSideMenu/back-arrow@2x.png'
install_resource 'MFSideMenu/MFSideMenuDemo/MFSideMenu/menu-icon.png'
install_resource 'MFSideMenu/MFSideMenuDemo/MFSideMenu/menu-icon@2x.png'
install_resource 'MKHorizMenu/MKHorizMenu/ButtonSelected.png'
install_resource 'MKHorizMenu/MKHorizMenu/MenuBar.png'
install_resource 'MKHorizMenu/MKHorizMenu/MenuBar@2x.png'
install_resource 'MTLocation/Resources/GoogleBadge.png'
install_resource 'MTLocation/Resources/GoogleBadge@2x.png'
install_resource 'MTLocation/Resources/HeadingAngleLarge.png'
install_resource 'MTLocation/Resources/HeadingAngleLarge@2x.png'
install_resource 'MTLocation/Resources/HeadingAngleMedium.png'
install_resource 'MTLocation/Resources/HeadingAngleMedium@2x.png'
install_resource 'MTLocation/Resources/HeadingAngleSmall.png'
install_resource 'MTLocation/Resources/HeadingAngleSmall@2x.png'
install_resource 'MTLocation/Resources/LocateMeButton.png'
install_resource 'MTLocation/Resources/LocateMeButton@2x.png'
install_resource 'MTLocation/Resources/LocateMeButtonTrackingPressed.png'
install_resource 'MTLocation/Resources/LocateMeButtonTrackingPressed@2x.png'
install_resource 'MTLocation/Resources/Location.png'
install_resource 'MTLocation/Resources/Location@2x.png'
install_resource 'MTLocation/Resources/LocationHeading.png'
install_resource 'MTLocation/Resources/LocationHeading@2x.png'
install_resource 'SVWebViewController/SVWebViewController/SVWebViewController.bundle'
