set(PROJECT_NAME Cminpack)
set(VERSION 1.1.3)
set(BUILD_CONFIG "debug release")

ExternalProject_Add(
   ${PROJECT_NAME}-${VERSION}
   URL http://devernay.free.fr/hacks/cminpack/cminpack-${VERSION}.tar.gz
   PATCH_COMMAND "${PATCH_EXECUTABLE}" -p0 -N -t < "${CMAKE_CURRENT_SOURCE_DIR}/cpack-${VERSION}.patch"
   CMAKE_ARGS -DUSE_FPIC:BOOL=ON -DSHARED_LIBS:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)
