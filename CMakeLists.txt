cmake_minimum_required(VERSION 3.10) # CMake install : https://cmake.org/download/
project(LANGUAGES CXX)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# FreeType 配置
set(FREETYPE_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/freetype/include/freetype2")
set(FREETYPE_LIBRARIES "${CMAKE_CURRENT_SOURCE_DIR}/freetype/lib/libfreetype.a")

# Qt 配置
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "C:/Qt/5.15.2/mingw81_64") # Qt Kit Dir
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# 查找 Qt 组件
find_package(Qt5 COMPONENTS 
    Core
    Gui
    Widgets
    Network
    REQUIRED
)

# 源文件列表
set(SOURCES
    src/main.cpp
    src/mainwindow.cpp
    src/agent.cpp
    src/agent_control.cpp
    src/agent_hazardidentification.cpp
    src/agent_move.cpp
    src/agent_perception.cpp
    src/agent_recognition.cpp
    src/agent_riskevaluation.cpp
    src/agent_route_management.cpp
    src/caldistributethread.cpp
    src/configwindow.cpp
    src/eventmanager.cpp
    src/gltransform3d.cpp
    src/graphiccanvas.cpp
    src/logoutputthread.cpp
    src/networkdrivecheck.cpp
    src/randomgenerator.cpp
    src/road.cpp
    src/road_path_calc.cpp
    src/scenario.cpp
    src/simulationmanager.cpp
    src/systemthread.cpp
    src/systemthread_FEcommand.cpp
    src/system_snapshot.cpp
    src/trafficsignal.cpp
    src/udpthread.cpp
    src/vehicle.cpp
)

# 头文件列表
set(HEADERS
    src/mainwindow.h
    src/agent.h
    src/caldistributethread.h
    src/configwindow.h
    src/gltransform3d.h
    src/graphiccanvas.h
    src/logoutputthread.h
    src/networkdrivecheck.h
    src/randomgenerator.h
    src/road.h
    src/simulationmanager.h
    src/systemthread.h
    src/trafficsignal.h
    src/udpthread.h
    src/vehicle.h
)

# 资源文件
set(RESOURCES
    src/resim_resource.qrc
    src/resim.rc
)

# 编译选项
if(MSVC)
    add_compile_options(/utf-8)
else()
    add_compile_options(-Wall -Wextra)
    # 禁用未使用参数警告
    add_compile_options(-Wno-unused-parameter)
    # 禁用函数类型转换警告
    add_compile_options(-Wno-cast-function-type)
endif()

# 包含目录
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${FREETYPE_INCLUDE_DIRS}
)

# 可执行文件
add_executable(${PROJECT_NAME}
    WIN32 # If you need a terminal for debug, please comment this statement 
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
) 

# 链接库
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Widgets
    Qt5::Network
    mpr
    ${FREETYPE_LIBRARIES}
)

# 安装配置
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)