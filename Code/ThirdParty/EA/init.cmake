# EASTL & EABase

set (CS_EA_SUPPORT ON CACHE BOOL "Support EASTL & EABase. This is the default STL used within Swift. set to OFF if you want to use your own.")
mark_as_advanced(CS_EA_SUPPORT)

macro(cs_requires_ea)
cs_requires(CS_EA_SUPPORT)
CS_requires_one_of(CS_CMAKE_PLATFORM_LINUX_CACHE, CS_CMAKE_PLATFORM_WINDOWS_DESKTOP)
endmacro()