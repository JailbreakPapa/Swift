# metapp

set (CS_METAPP_SUPPORT ON CACHE BOOL "Metapp support. This is needed for reflection. set off to use your own reflection library")
mark_as_advanced(FORCE CS_METAPP_SUPPORT)

macro(CS_requires_metapp)
CS_requires(CS_METAPP_SUPPORT)
CS_requires_one_of(CS_CMAKE_PLATFORM_LINUX_CACHE, CS_CMAKE_PLATFORM_WINDOWS_DESKTOP)
endmacro()