# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.20

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\JetBrains\CLion 2021.2.3\bin\cmake\win\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\JetBrains\CLion 2021.2.3\bin\cmake\win\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "C:\LEIC 2021_2022\DA\DA_TP_Classes"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug"

# Include any dependencies generated for this target.
include CMakeFiles/TP8.dir/depend.make
# Include the progress variables for this target.
include CMakeFiles/TP8.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/TP8.dir/flags.make

CMakeFiles/TP8.dir/TP8/ex1.cpp.obj: CMakeFiles/TP8.dir/flags.make
CMakeFiles/TP8.dir/TP8/ex1.cpp.obj: CMakeFiles/TP8.dir/includes_CXX.rsp
CMakeFiles/TP8.dir/TP8/ex1.cpp.obj: ../TP8/ex1.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug\CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/TP8.dir/TP8/ex1.cpp.obj"
	C:\PROGRA~1\MINGW-~1\X86_64~1.0-P\mingw64\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles\TP8.dir\TP8\ex1.cpp.obj -c "C:\LEIC 2021_2022\DA\DA_TP_Classes\TP8\ex1.cpp"

CMakeFiles/TP8.dir/TP8/ex1.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/TP8.dir/TP8/ex1.cpp.i"
	C:\PROGRA~1\MINGW-~1\X86_64~1.0-P\mingw64\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "C:\LEIC 2021_2022\DA\DA_TP_Classes\TP8\ex1.cpp" > CMakeFiles\TP8.dir\TP8\ex1.cpp.i

CMakeFiles/TP8.dir/TP8/ex1.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/TP8.dir/TP8/ex1.cpp.s"
	C:\PROGRA~1\MINGW-~1\X86_64~1.0-P\mingw64\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "C:\LEIC 2021_2022\DA\DA_TP_Classes\TP8\ex1.cpp" -o CMakeFiles\TP8.dir\TP8\ex1.cpp.s

# Object files for target TP8
TP8_OBJECTS = \
"CMakeFiles/TP8.dir/TP8/ex1.cpp.obj"

# External object files for target TP8
TP8_EXTERNAL_OBJECTS =

TP8.exe: CMakeFiles/TP8.dir/TP8/ex1.cpp.obj
TP8.exe: CMakeFiles/TP8.dir/build.make
TP8.exe: lib/libgtest_maind.a
TP8.exe: lib/libgmock_maind.a
TP8.exe: lib/libgmockd.a
TP8.exe: lib/libgtestd.a
TP8.exe: CMakeFiles/TP8.dir/linklibs.rsp
TP8.exe: CMakeFiles/TP8.dir/objects1.rsp
TP8.exe: CMakeFiles/TP8.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug\CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable TP8.exe"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\TP8.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/TP8.dir/build: TP8.exe
.PHONY : CMakeFiles/TP8.dir/build

CMakeFiles/TP8.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\TP8.dir\cmake_clean.cmake
.PHONY : CMakeFiles/TP8.dir/clean

CMakeFiles/TP8.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" "C:\LEIC 2021_2022\DA\DA_TP_Classes" "C:\LEIC 2021_2022\DA\DA_TP_Classes" "C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug" "C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug" "C:\LEIC 2021_2022\DA\DA_TP_Classes\cmake-build-debug\CMakeFiles\TP8.dir\DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/TP8.dir/depend
