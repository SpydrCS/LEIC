cmake_minimum_required(VERSION 3.20)
project(feup_da_PackageDelivery)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/input")

add_executable(feup_da_PackageDelivery codigo/main.cpp
        codigo/ExpressDelivery.cpp codigo/ExpressDelivery.h codigo/NormalDelivery.cpp codigo/NormalDelivery.h
        codigo/Driver.cpp codigo/Driver.h codigo/Company.cpp codigo/Company.h codigo/LoadData.cpp codigo/LoadData.h
        codigo/Menu.cpp codigo/Menu.h)

