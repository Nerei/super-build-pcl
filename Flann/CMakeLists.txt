set(PROJECT_NAME Flann)
set(VERSION 1.7.1)
set(BUILD_CONFIG "debug release")

if(BUILD_INSTALLERS)
    set(CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ep_base}/Install/${PROJECT_NAME})
	set(${PROJECT_NAME}_root_cmake -DFLANN_ROOT=${ep_base}/Install/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
else()
    set(CMAKE_ARGS)	
	# this applies only for Windows
	set(${PROJECT_NAME}_root_cmake -DFLANN_ROOT=${INSTALL_PREFIX}/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
endif()

pcl_ExternalProject_Add(
   ${PROJECT_NAME}
   URL http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-${VERSION}-src.zip
   PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cpack-${VERSION}.patch"
   CMAKE_ARGS ${CMAKE_ARGS} -DBUILD_C_BINDINGS:BOOL=ON -DBUILD_PYTHON_BINDINGS:BOOL=OFF -DBUILD_MATLAB_BINDINGS:BOOL=OFF 
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)
