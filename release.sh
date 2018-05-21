#!/bin/bash

rootDir="$(pwd)"
pkgDir="${rootDir}/pkg"

set +x
rm -rf "${pkgDir}"
mkdir -p "${pkgDir}"

NOW="$(date -u +%Y%m%dT%H%M%S)"

function build() {
  os=$1
  arch=$2

  if [ "${os}" == 'windows' ]
  then
    extension='.exe'
  fi

  name="protolock${extension}"

  tmpDir="${pkgDir}/tmp/${os}_${arch}"
  mkdir -p "${tmpDir}"
  GOOS="${os}" GOARCH="${arch}" go build -o "${tmpDir}/${name}" cmd/protolock/main.go
  (
    cd "${tmpDir}"

    cp -p "${rootDir}"/{LICENSE,README.md} .

    distDir="${pkgDir}/distributions"
    mkdir -p "${distDir}"
    tar cpzf "${distDir}/protolock.${NOW}.${os}-${arch}.tgz" "${name}" LICENSE README.md
  )
}

for os in darwin linux windows
do
  build "${os}" amd64
done
