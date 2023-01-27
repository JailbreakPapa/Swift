# ACL
set (CS_ACL_SUPPORT ON CACHE BOOL "Animation Compression Library Support. This is needed if your using ChaosAnimation.")
mark_as_advanced(FORCE CS_ACL_SUPPORT)

macro(CS_requires_acl)
CS_requires(CS_ACL_SUPPORT)
CS_requires_one_of(CS_CMAKE_PLATFORM_LINUX_CACHE, CS_CMAKE_PLATFORM_WINDOWS_DESKTOP)
endmacro()