cs_cmake_init()
cs_requires_ea()

# Get the name of this folder as the project name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

file(GLOB_RECURSE SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/EA/EASTL/Source/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/EA/EABase/Include/Common/EABase/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/EA/EASTL/Include/EASTL/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/EA/EASTL/Include/EASTL/bonus/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/EA/EASTL/Include/EASTL/internal/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/*.inl" "${CMAKE_CURRENT_SOURCE_DIR}/*.txt" "${CMAKE_CURRENT_SOURCE_DIR}/*.cmake")

cs_create_target(SHARED_LIBRARY ${PROJECT_NAME} NO_WARNINGS_AS_ERRORS ENABLE_RTTI NO_DEBUG)

function(cl_link_target_ea TARGET_NAME)

	cl_requires_ea()

	target_link_libraries(${TARGET_NAME} PRIVATE ea)

endfunction()

target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/EASTL/Include" "${CMAKE_CURRENT_SOURCE_DIR}/EABase/include/common")