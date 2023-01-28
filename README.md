# Swift

Swift is a vulkan based 3D-Renderer, made for exploring the studies of Computer Graphics.

Its not fully fleged. its mainly a showcase of my studies/findings that some-person could use to learn CG!

Build System Is ezEngine's CMake Scripts.

A 3D-Editor is here to use for viewing samples.

This Project Is Under The MIT & Apache-2.0 License. I Recommend using the MIT License.

# Software Needed

It is recommended that you have clang(for linux/mac) and visual studio 2022 & msvc 2022(for windows). gcc support is being worked on(TM), But it should work as well.

# QT Building Notes

For building qt, it is a little different/inconsistent to build the valve fork of qt. we are planning to find a fix for this problem.


# Recommended Build Instructions

For now, you should first,

1: Click SetupKuraQT.bat, and let the bat file run.

2: if you are on windows, go to your search, and type: x64 Native Tools Command Prompt for VS 2022. (MAKE SURE TO OPEN AS A ADMIN.)/ If on linux, open your clang installation within cmd and redirect to the qt installation.

3: cd/redirect to the qt installation.

4: in the command prompt, type build.bat and then let it run. (DO NOT CLOSE THE PATH. REBUILDS WILL FAIL IF IT IS IN THE PROCESS OF LINKING. IF IT FAILS, CLEAN THE BUILD DIRECTORY WITHIN QT.)

# NOTES

I Plan on updating the qt installation to 6.2 LTS. im making sure that all the old features are replaced. 
