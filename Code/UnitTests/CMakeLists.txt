# Unit Tests Will Be Re-written under butler-test.

set (cs_BUILD_UNITTESTS ON CACHE BOOL "Whether unit-test projects should be added to the solution")

cs_requires(cs_BUILD_UNITTESTS)

cs_add_all_subdirs()