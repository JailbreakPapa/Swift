# #####################################
# ## CS_include_CSExport()
# #####################################

macro(CS_include_CSExport)
	# Create a modified version of the CSExport.cmake file,
	# where the absolute paths to the original locations are replaced
	# with the absolute paths to this installation
	set(EXP_FILE "${CS_OUTPUT_DIRECTORY_DLL}/CSExport.cmake")
	set(IMP_FILE "${CMAKE_BINARY_DIR}/CSExport.cmake")
	set(EXPINFO_FILE "${CS_OUTPUT_DIRECTORY_DLL}/CSExportInfo.cmake")

	# read the file that contains the original paths
	include(${EXPINFO_FILE})

	# read the CSExport file into a string
	file(READ ${EXP_FILE} IMP_CONTENT)

	# replace the original paths with our paths
	string(REPLACE ${EXPINP_OUTPUT_DIRECTORY_DLL} ${CS_OUTPUT_DIRECTORY_DLL} IMP_CONTENT "${IMP_CONTENT}")
	string(REPLACE ${EXPINP_OUTPUT_DIRECTORY_LIB} ${CS_OUTPUT_DIRECTORY_LIB} IMP_CONTENT "${IMP_CONTENT}")
	string(REPLACE ${EXPINP_SOURCE_DIR} ${CS_SDK_DIR} IMP_CONTENT "${IMP_CONTENT}")

	# write the modified CSExport file to disk
	file(WRITE ${IMP_FILE} "${IMP_CONTENT}")

	# include the modified file, so that the CMake targets become known
	include(${IMP_FILE})
endmacro()

# #####################################
# ## CS_configure_external_project()
# #####################################
macro(CS_configure_external_project)

	if (CS_SDK_DIR STREQUAL "")
		file(RELATIVE_PATH CS_SUBMODULE_PREFIX_PATH ${CMAKE_SOURCE_DIR} ${CS_SDK_DIR})
	else()
		set(CS_SUBMODULE_PREFIX_PATH "")
	endif()
	
	set_property(GLOBAL PROPERTY CS_SUBMODULE_PREFIX_PATH ${CS_SUBMODULE_PREFIX_PATH})

	if(CS_SUBMODULE_PREFIX_PATH STREQUAL "")
		set(CS_SUBMODULE_MODE FALSE)
	else()
		set(CS_SUBMODULE_MODE TRUE)
	endif()

	set_property(GLOBAL PROPERTY CS_SUBMODULE_MODE ${CS_SUBMODULE_MODE})

	CS_build_filter_init()

	CS_set_build_types()
endmacro()