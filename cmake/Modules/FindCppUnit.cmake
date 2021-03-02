# http://www.cmake.org/pipermail/cmake/2006-October/011446.html
# Modified to use pkg config and use standard var names

#
# Find the CppUnit includes and library
#
# This module defines
# cppunit_INCLUDE_DIR, where to find tiff.h, etc.
# cppunit_LIBRARIES, the libraries to link against to use CppUnit.
# cppunit_FOUND, If false, do not try to use CppUnit.

find_package(PkgConfig QUIET)
pkg_check_modules(PC_cppunit QUIET cppunit)

FIND_PATH(cppunit_INCLUDE_DIRS
    NAMES cppunit/TestCase.h
    HINTS ${PC_cppunit_INCLUDE_DIR}
    ${CMAKE_INSTALL_PREFIX}/include
    PATHS
    /usr/local/include
    /usr/include
)

FIND_LIBRARY(cppunit_LIBRARIES
    NAMES cppunit
    HINTS ${PC_cppunit_LIBDIR}
    ${CMAKE_INSTALL_PREFIX}/lib
    ${CMAKE_INSTALL_PREFIX}/lib64
    PATHS
    ${cppunit_INCLUDE_DIRS}/../lib
    /usr/local/lib
    /usr/lib
)

LIST(APPEND cppunit_LIBRARIES ${CMAKE_DL_LIBS})

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(cppunit DEFAULT_MSG cppunit_LIBRARIES cppunit_INCLUDE_DIRS)
MARK_AS_ADVANCED(cppunit_LIBRARIES cppunit_INCLUDE_DIRS)
