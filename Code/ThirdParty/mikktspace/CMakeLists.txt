cs_cmake_init()



# Get the name of this folder as the project name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

cs_create_target(STATIC_LIBRARY ${PROJECT_NAME} NO_CS_PREFIX)

if(CS_CMAKE_COMPILER_MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /wd4456)
endif()
