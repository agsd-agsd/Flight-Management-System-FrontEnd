cmake_minimum_required(VERSION 3.16)
project(QT_Project VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Network)

set(SOURCE_FILES
    main.cpp
    apiS/networkhandler.cpp
    animationS/CircularReveal.cpp
)

set(HEADER_FILES
    apiH/networkhandler.h
    animationH/CircularReveal.h
)

set(QML_FILES
    MainWindow.qml
    views/Login.qml
    views/Register.qml
    views/DashBoard.qml
    views/HomeView.qml
)

set(RESOURCES_FILES
    favicon.ico

    figures/avatar-agsd.jpg
    figures/bg.jpg
    figures/github.png
)

qt_add_executable(${PROJECT_NAME}
    ${SOURCE_FILES}
    ${HEADER_FILES}
)

qt_add_qml_module(${PROJECT_NAME}
    URI QT_Project
    VERSION 1.0
    RESOURCE_PREFIX /qt
    SOURCES ${SOURCE_FILES} ${HEADER_FILES}
    RESOURCES ${RESOURCES_FILES}
    QML_FILES ${QML_FILES}
    QML_FILES views/FlightInfo.qml
    QML_FILES views/TicketDetails.qml
    QML_FILES views/BuyTicketPage.qml
    QML_FILES views/MyFavoritesPage.qml
    QML_FILES views/OrdersView.qml
    QML_FILES views/AboutView.qml
    QML_FILES views/ProfileView.qml
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Network
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
