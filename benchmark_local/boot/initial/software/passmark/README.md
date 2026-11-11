Downloaded from the
[PassMark](https://www.passmark.com/products/pt_linux/download.php) website

To run `PerformanceTest_Linux_x86-64` on Ubuntu 24.04, it may be necessary to
download these two packages,

```
wget https://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.3-2_amd64.deb
wget https://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2_amd64.deb
```

and install:

```
sudo apt install ./libncurses5_6.3-2_amd64.deb
sudo apt install ./libtinfo5_6.3-2_amd64.deb
```

The PassMark [FAQ](https://www.passmark.com/support/pt_linux_faq.php) page has
related entries with similar instructions.
