cmake_minimum_required(VERSION 3.17)
project(AD_TP_Classes)

# Build the Google tests
set(GOOGLETEST_PATH lib/googletest-master)
add_subdirectory(${GOOGLETEST_PATH})

# Add the source files of each TP class
file(GLOB TP1_FILES CONFIGURE_DEPENDS "TP1/*.cpp")
#file(GLOB TP2_FILES CONFIGURE_DEPENDS "TP2/*.cpp")
file(GLOB TP3_FILES CONFIGURE_DEPENDS "TP3/*.cpp")
file(GLOB TP4_FILES CONFIGURE_DEPENDS "TP4/*.cpp")
file(GLOB TP8_FILES CONFIGURE_DEPENDS "TP8/*.cpp")
#...

add_executable(TP1 main.cpp ${TP1_FILES} TP8/ex1.cpp)
#add_executable(TP2 main.cpp ${TP2_FILES})
add_executable(TP3 main.cpp ${TP3_FILES})
add_executable(TP4 main.cpp ${TP4_FILES} TP4/QuantasDepois.cpp TP4/QuantasDepois.h TP4/qtsdps.cpp)
add_executable(TP8 TP8/ex1.cpp)
#...

target_link_libraries(TP1 gtest_main gmock_main)
#target_link_libraries(TP2 gtest_main gmock_main)
target_link_libraries(TP3 gtest_main gmock_main)
target_link_libraries(TP4 gtest_main gmock_main)
target_link_libraries(TP8 gtest_main gmock_main)
#...