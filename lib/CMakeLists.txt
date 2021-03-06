# Copyright 2011,2012 Free Software Foundation, Inc.
#
# This file is part of GNU Radio
#
# GNU Radio is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3, or (at your option)
# any later version.
#
# GNU Radio is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Radio; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.

########################################################################
# Setup library
########################################################################
include(GrPlatform) #define LIB_SUFFIX

# include_directories(${Boost_INCLUDE_DIR})
# link_directories(${Boost_LIBRARY_DIRS})

list(APPEND NTSC_sources
    decoder_c_impl.cc
    video_stream_converter_c_impl.cc
    transmitter_c_impl.cc
)

set(NTSC_sources "${NTSC_sources}" PARENT_SCOPE)
if(NOT NTSC_sources)
	MESSAGE(STATUS "No C++ sources... skipping lib/")
	return()
endif(NOT NTSC_sources)

add_library(gnuradio-NTSC SHARED ${NTSC_sources})
target_include_directories(gnuradio-NTSC PRIVATE "${PROJECT_SOURCE_DIR}/include")
target_link_libraries(gnuradio-NTSC gnuradio::gnuradio-runtime gnuradio::gnuradio-blocks gnuradio::gnuradio-fft gnuradio::gnuradio-filter Volk::volk)
set_target_properties(gnuradio-NTSC PROPERTIES DEFINE_SYMBOL "gnuradio_NTSC_EXPORTS")

if(APPLE)
    set_target_properties(gnuradio-NTSC PROPERTIES
        INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib"
    )
endif(APPLE)

########################################################################
# Install built library files
########################################################################
include(GrMiscUtils)
# set(VERSION 1)
# set(LIBVER 1)
GR_LIBRARY_FOO(gnuradio-NTSC)

########################################################################
# Print summary
########################################################################
message(STATUS "Using install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "Building for version: ${VERSION} / ${LIBVER}")

########################################################################
# Build and register unit test
########################################################################
find_package(cppunit REQUIRED)

include(GrTest)

include_directories(${cppunit_INCLUDE_DIRS})

list(APPEND test_NTSC_sources
    ${CMAKE_CURRENT_SOURCE_DIR}/test_NTSC.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/qa_NTSC.cc
)

add_executable(test-NTSC ${test_NTSC_sources})

target_link_libraries(
  test-NTSC
  ${GNURADIO_RUNTIME_LIBRARIES}
  ${Boost_LIBRARIES}
  ${cppunit_LIBRARIES}
  gnuradio-NTSC
)

GR_ADD_TEST(test_NTSC test-NTSC)
