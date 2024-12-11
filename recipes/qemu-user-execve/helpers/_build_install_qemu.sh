_build_install_qemu() {
  local build_dir=$1
  local install_dir=$2
  shift 2
  local qemu_args=("${@:-}")

  mkdir -p "${build_dir}"
  pushd "${build_dir}" || exit 1
    export PKG_CONFIG="${BUILD_PREFIX}/bin/pkg-config"
    export PKG_CONFIG_PATH="${BUILD_PREFIX}/lib/pkgconfig"
    export PKG_CONFIG_LIBDIR="${BUILD_PREFIX}/lib/pkgconfig"

    ${SRC_DIR}/qemu-source/configure \
      --prefix="${install_dir}" \
      "${qemu_args[@]}" \
      --enable-user \
      --enable-strip \
      > "${SRC_DIR}"/_configure-"${qemu_arch}".log 2>&1

    make -j"${CPU_COUNT}" > "${SRC_DIR}"/_make-"${qemu_arch}".log 2>&1
    make check > "${SRC_DIR}"/_check-"${qemu_arch}".log 2>&1
    make install > "${SRC_DIR}"/_install-"${qemu_arch}".log 2>&1

  popd || exit 1
}
