# find the folder in which Embree is located

# early out, if this target has been created before
if(TARGET CSEmbree::CSEmbree)
	return()
endif()

find_path(CS_EMBREE_DIR include/embree3/rtcore.h
	PATHS
	${CMAKE_SOURCE_DIR}/Code/ThirdParty/embree
)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(EMBREE_LIB_PATH "${CS_EMBREE_DIR}/vc141win64")
else()
	set(EMBREE_LIB_PATH "${CS_EMBREE_DIR}/vc141win32")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CSEmbree DEFAULT_MSG CS_EMBREE_DIR)

if(CSEMBREE_FOUND)
	add_library(CSEmbree::CSEmbree SHARED IMPORTED)
	set_target_properties(CSEmbree::CSEmbree PROPERTIES IMPORTED_LOCATION "${EMBREE_LIB_PATH}/embree3.dll")
	set_target_properties(CSEmbree::CSEmbree PROPERTIES IMPORTED_IMPLIB "${EMBREE_LIB_PATH}/embree3.lib")
	set_target_properties(CSEmbree::CSEmbree PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_EMBREE_DIR}/include")
endif()

mark_as_advanced(FORCE CS_EMBREE_DIR)

unset(EMBREE_LIB_PATH)
