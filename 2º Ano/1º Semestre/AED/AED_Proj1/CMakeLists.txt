cmake_minimum_required(VERSION 3.21)
project(aed_proj1)

set(CMAKE_CXX_STANDARD 14)

add_executable(aed_proj1 Tests/main.cpp Tests/avião.cpp Tests/avião.h Tests/voo.cpp Tests/voo.h Tests/serviço.cpp Tests/serviço.h Tests/bagagens.cpp Tests/bagagens.h Tests/carrinhoTransporte.cpp Tests/carrinhoTransporte.h Tests/bilhete.cpp Tests/bilhete.h)
