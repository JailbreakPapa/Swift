cs_cmake_init()
cs_requires_acl()

# Get the name of this folder as the project name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

file(GLOB_RECURSE SRC_FILES "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/*.cc" "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/*.inl" "${CMAKE_CURRENT_SOURCE_DIR}/*.txt" "${CMAKE_CURRENT_SOURCE_DIR}/*.cmake")

cs_create_target(SHARED_LIBRARY ${PROJECT_NAME} NO_WARNINGS_AS_ERRORS ENABLE_RTTI NO_DEBUG MANUAL_SOURCE_FILES "${SRC_FILES}")

function(cl_link_target_acl TARGET_NAME)

	cl_requires_acl()

	target_link_libraries(${TARGET_NAME} PRIVATE acl)

endfunction()

target_include_directories(${PROJECT_NAME} PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")

target_include_directories(${PROJECT_NAME} 
PRIVATE
${CMAKE_CURRENT_SOURCE_DIR}/compression/${SRC_FILES}
${CMAKE_CURRENT_SOURCE_DIR}/core/${SRC_FILES}
${CMAKE_CURRENT_SOURCE_DIR}/math/${SRC_FILES}
${CMAKE_CURRENT_SOURCE_DIR}/decompression/${SRC_FILES}
${CMAKE_CURRENT_SOURCE_DIR}/io/${SRC_FILES}
)