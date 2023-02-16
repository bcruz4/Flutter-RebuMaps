# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-src"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-build"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/tmp"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src"
  "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
)

set(configSubDirs Debug;Release;MinSizeRel;RelWithDebInfo)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "E:/Cursos/Flutter/Flutter Maps/rebu_maps/build/windows/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp/${subDir}")
endforeach()
