cmake_minimum_required(VERSION 3.14)

project(cutefish-texteditor LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick REQUIRED)
find_package(KF5SyntaxHighlighting)

set(PROJECT_SOURCES
        src/main.cpp
        src/documenthandler.cpp
        src/highlightmodel.cpp
        src/texteditor.cpp
        qml.qrc
)

add_executable(cutefish-texteditor
  ${PROJECT_SOURCES}
)

target_link_libraries(cutefish-texteditor
  PRIVATE
  Qt5::Core
  Qt5::Quick
  KF5::SyntaxHighlighting
  )

# Let go of comments when adding internationalized files
# file(GLOB TS_FILES translations/*.ts)
# qt5_create_translation(QM_FILES ${TS_FILES})
# add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
# add_dependencies(${PROJECT_NAME} translations)
# install(FILES ${QM_FILES} DESTINATION /usr/share/cutefish-texteditor/translations)


install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES
    cutefish-editor.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
