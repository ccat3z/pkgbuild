# Maintainer: CountStarlight <countstarlight@gmail.com>

pkgname=deepin-wine-qq
pkgver=9.3.2.26869
qq_installer=PCQQ2020
deepinqqver=9.1.8deepin0
pkgrel=1
pkgdesc="Tencent QQ (com.qq.im) on Deepin Wine For Archlinux"
arch=("x86_64")
url="http://im.qq.com/"
license=('custom')
depends=('p7zip' 'wine' 'wine-mono' 'wine_gecko' 'xorg-xwininfo' 'wqy-microhei' 'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libpulse' 'lib32-openal' 'lib32-mpg123' 'lib32-gnutls')
conflicts=('deepin-qq-im' 'deepin.com.qq.im')
install="deepin-wine-qq.install"
_mirror="https://mirrors.ustc.edu.cn/deepin"
source=("$_mirror/pool/non-free/d/deepin.com.qq.im/deepin.com.qq.im_${deepinqqver}_i386.deb"
  "${qq_installer}-${pkgver}.exe::https://down.qq.com/qqweb/PCQQ/PCQQ_EXE/${qq_installer}.exe"
  "run.sh"
  "reg.patch")
md5sums=('d35bd4abfd1ac4c5e71c7fbc5282ccbd'
  'be60d96dd24b5f2c47c957513b10cd7a'
  '0137e8353accd854e6bc6eb6a05344ba'
  '0e6c4358a4914ef8be6f4abc8423a69a')

build() {
  msg "Extracting DPKG package ..."
  mkdir -p "${srcdir}/dpkgdir"
  tar -xvf data.tar.xz -C "${srcdir}/dpkgdir"
  sed "s/\(Categories.*$\)/\1Network;/" -i "${srcdir}/dpkgdir/usr/share/applications/deepin.com.qq.im.desktop"
  msg "Extracting Deepin Wine QQ archive ..."
  7z x -aoa "${srcdir}/dpkgdir/opt/deepinwine/apps/Deepin-QQ/files.7z" -o"${srcdir}/deepinqqdir"
  msg "Removing original outdated QQ directory ..."
  rm -r "${srcdir}/deepinqqdir/drive_c/Program Files/Tencent/QQ"
  msg "Patching reg files ..."
  patch -p1 -d "${srcdir}/deepinqqdir/" < "${srcdir}/reg.patch"
  msg "Creating font file link ..."
  ln -sf "/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc" "${srcdir}/deepinqqdir/drive_c/windows/Fonts/wqy-microhei.ttc"
  msg "Repackaging app archive ..."
  7z a -t7z -r "${srcdir}/files.7z" "${srcdir}/deepinqqdir/*"
}

package() {
  msg "Preparing icons ..."
  install -d "${pkgdir}/usr/share"
  cp -a ${srcdir}/dpkgdir/usr/share/* "${pkgdir}/usr/share/"
  msg "Copying QQ to /opt/deepinwine/apps/Deepin-QQ ..."
  install -d "${pkgdir}/opt/deepinwine/apps/Deepin-QQ"
  install -m644 "${srcdir}/files.7z" "${pkgdir}/opt/deepinwine/apps/Deepin-QQ/"
  install -m644 "${srcdir}/reg.patch" "${pkgdir}/opt/deepinwine/apps/Deepin-QQ/"
  install -m755 "${srcdir}/run.sh" "${pkgdir}/opt/deepinwine/apps/Deepin-QQ/"
  install -m644 "${srcdir}/${qq_installer}-${pkgver}.exe" "${pkgdir}/opt/deepinwine/apps/Deepin-QQ/"
}
