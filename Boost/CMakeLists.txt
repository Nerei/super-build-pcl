set(PROJECT_NAME Boost)
set(VERSION 1.48.0)
set(BUILD_CONFIG release)

if(BUILD_INSTALLERS)
    set(CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ep_base}/Install/${PROJECT_NAME})
	set(${PROJECT_NAME}_root_cmake -DBOOST_ROOT=${ep_base}/Install/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
else()
    set(CMAKE_ARGS)
	# this applies only for Windows
	set(${PROJECT_NAME}_root_cmake -DBOOST_ROOT=${INSTALL_PREFIX}/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
endif()

# do we build the mpi boost module?
find_package(MPI QUIET)
if(MPI_FOUND)
  set(BOOST_BUILD_PROJECTS system*thread*date_time*filesystem*serialization*mpi CACHE STRING "* seperated Boost modules to be built")
else(MPI_FOND)
  set(BOOST_BUILD_PROJECTS system*thread*date_time*filesystem*serialization CACHE STRING "* seperated Boost modules to be built")
endif(MPI_FOUND)

pcl_ExternalProject_Add(
   ${PROJECT_NAME}
   URL http://gitorious.org/boost/cmake/archive-tarball/cmake-${VERSION}
   URL_FILENAME boost-cmake-${VERSION}.tar.gz
   PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cpack-${VERSION}.patch"
   LIST_SEPARATOR *
   CMAKE_ARGS -DLIBPREFIX:STRING=lib -DENABLE_STATIC_RUNTIME:BOOL=OFF -DWITH_PYTHON:BOOL=OFF -DBUILD_PROJECTS=${BOOST_BUILD_PROJECTS} ${CMAKE_ARGS}
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)
