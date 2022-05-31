# config
## 装机必备
1. 换源 //替换apt的sources.list
2. 更新apt
```sh
sudo apt update && upgrade
```
3. 安装网卡驱动以及软件
```sh
sudo apt install firmware-iwlwifi
sudo apt install network-manger
sudo reboot
```
- pass
> 查看硬件：
```sh
lspci
lspci -vvv //想看更详细的信息
```
> 如果是Realtek网卡
```sh
sudo apt install firmware-realtek
```
> 如果是Atheros网卡
```sh
sudo apt install firmware-atheros
```
> 如果是Intel网卡
```sh
sudo apt install firmware-iwlwifi
```
> 列出库里所有的固件包
```sh
aptitude search ^firmware
```
> 看固件包的详细信息，比如：
```sh
apt show firmware-atheros
```
## vim个人配置
```
sudo apt install neovim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
### pyright的配置:
```sh
sudo apt install nodejs
sudo apt install npm
sudo npm install -g yarn
cd coc.nvim/
yarn install
yarn build
```
- 打开vim: ```CocInstall coc-pyright```

### ctags+taglist配置:
1. 安装```ctags```
- 下载压缩包
- <http://ctags.sourceforge.net/>
```sh
tar xzvf ctags-5.8.tag.gz
cd ctags-5.8
./configure
sudo make
sudo make install
```
2. 安装taglist 
- 下载压缩包
- <https://www.vim.org/scripts/script.php?script_id=273>
```
unzip taglist_45.zip -d ~/.vim/
```
- 启动vim ```:helptags .```
- 重启vim ```TlistToggle``` 来打开和关闭taglist窗口
- 修改```~/.vim/plugin/taglist.vim```文件，找到```if !exitsts(loaded_taglist)```这一行，并在其前面添加```let Tlist_Ctags_Cmd="/home/zgz/ctags-5.8/ctags"```
```
cd ctags-5.8/
./ctags -R *
ls -l tags  //查看是否有
```
vim输入 ```:TlistToggle```来打开侧面窗口 (或者直接:```Tlist```、```TlistOpen```也可以)

## vim 使用技巧
1. 基础（vim自带）
- 
- 
2. vim-visual-multi
- ctrl-n 选择单词（可以多选），inster模式下可同时编辑，q 可跳到下一个相同单词
- ctrl-up/down 垂直创建光标

3. taglist
- :Tlist 可打开/关闭列list

## Alacritty install
1. <https://github.com/alacritty/alacritty.git>
2. see INSTALL.md

## 输入法
```sh
sudo dpkg-reconfigure locales```

* [X] en_US.UTF-8 UTF-8
* [X] zh_CN.GB18030 GB18030
* [X] zh_CN.UTF-8 UTF-8

sudo apt install fcitx5 fcitx5-pinyin
fcitx5-configtool
sudo reboot
```
## GNOME install
1. 准备
```
sudo apt update && upgrade
sudo apt install tasksel
sudo tasksel install desktop gnome-desktop
```
2. 设置开机默认启动
```sh
sudo systemctl set-default graphical.target
sudo reboot
```
3. config
- gnome 插件 <https://extensions.gnome.org/>
- gnome theme <https://www.gnome-look.org>
4. Dingtalk install
- <https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_1.4.0.20425_amd64.deb>
```sh
sudo dpkg -i com.alibabainc.dingtalk_1.4.0.20425_amd64.deb
```
5. WeiChat install
```sh
wget -O- https://deepin-wine.i-m.dev/setup.sh | sh
sudo apt-get install com.qq.weixin.deepin
sudo reboot
```

## 格式转换
1. pdf F.docx       //docx -> pdf
2. xpdf file.pdf	//see:pdf
3. less F.pdf > F.md //pdf -> md		  
4. vim file.md       //eidte
5. pandoc F.md > F.html //转html后再用浏览器打印为pdf

## 常用命令
1. cht.sh markdown   //查看markdown教程
2. man +函数名    //查看教程
3. mv             //可修改文件名称
3. rename         //批量修改文件名
   eg：rename 's/screenshot-//' screenshot-20211020*   它的意思是:删除'screeshot-'针对所有'screenshot-20211020'的文件
4. cat .tmux.conf  //查看手册
5. git pull       //提取配置文件
6. sudo dpkg -i F.deb  //安装deb软件
7. sudo dpkg -r --purge F.deb   //连同配置文件一起删除
8. sudo apt-get remove --purge F.tar //连同配置文件一同
9. sudo snap install F.tgz   //按装压缩文件
10. sync          //立即拷贝文件
11. apt-cache search //查找文件
12. sudo alsactl init  //声卡初始化
13. tar zcf F.tgz F/    //把F打包成tgz压缩包
14. tar xf F.tgz        //解压文件
15. C+Win+P          //快速截屏 
16. C+M+P            //打印网页为pdf
17. 录屏
- 关闭tmux输入ttyrec开始. C+d 直到关闭录屏
- ttyplay ... 查看录屏  //‘1’开始
18. 投屏
- 手机投电脑: 
- sudo apt install scrcpy --fix-missing
- connect usb with myphone
- scrcpy
- scrcpy -S  //手机灭屏
- 电脑投屏：
- xrandr //查看连接情况
- xrandr --output ... --same-as ... --auto

19. type clash.sh      //查看clash.sh文件的位置

## FTP
1. nmap //扫描端口
2. nc -l $((100*256))  //起服务器
3. nc ip + ftp    //起连接
4. pasv   //后跟服务器给的端口号，自己在active mode
5. port   //后跟自己的端口号，自己在passive mode


## BitTorrent  //bit 下载  tcp
 install F.tgz   //安装压缩文件

## Sync To pan.baidu.com
1. sudo python3 -m pip install --upgrade pip
2. sudo pip3 install requests  //or pip3 install --user requests
3. sudo pip3 install bypy  //or pip3 install --user bypy
4. bypy info  //登录授权
5. 点击链接并输入验证码
- bypy upload  //上传当前目录下的文件到百度网盘
- bypy downdir  //把百度网盘的内容同步到本地
- bypy compare  //比较本地当前目录和云盘根目录，看是否一致，来判断是否同步成功

# OTHER
- 电量存储位置 cat /sys/class/power_supply/BAT0/capacity
- python包安装pip: <https://www.lfd.uci.edu/~gohlke/pythonlibs/>
- sudo fdisk -l  //查看磁盘分区
- curl -fLo ~/.vim/autoload/plug.vim --create-dirs <https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim>  //下载vim-plug
### U盘挂载
- sudo fdisk -l  //查看u盘位置
- sudo mount u盘位置 目标位置

## linux中文件的权限：
- d rwx rwx rwx
1. 第一个字心为文件的类型。文件类型包括：文件央(d)、普通文件(-)、连接文件(I)字符型文件(c)、块设备(b)。
2. 第二部分是用户的权限，也就是文件的所有者的权限。
3. 第三部分是用户所属组的权限，也就是与文件所有者同组的其他用户的权限。
4. 第四部分是其他用户的权限。
- (哪里为空证明没有这项权限)
- r:读取 W:写入 x:执行
- eg：d-wxr-xrw- //该文件是文件央，用户具有写入和执行的权限，用户所属组具有读取和执行的权限，其他用户具有读取和
写入的权限。
'''

## 修改文件权限方法：
1. chmod [[ugoa...] [+-=] [rwxXstugo...]] file
- [ugoa...] : u代表用户；g代表组；o代表其他用户；a代表上述所有
- [+-=]：+在现有的权限基础上增加新的权限；-在现有权限基础上移除权限；=将权限设置成后面的值
- [rwxXstugo...]：r读取文件权限；w写入文件权限；x执行文件权限；X如果对象是目录或者它已有执行权限，赋予执行权限；s运行时重新设置UID或GID；t保留文件或目录；u将权限设置为跟属主一样；g将权限设置为跟属组一样；o>将权限设置为跟其他用户一样
2. chmod 740 text_one  //将text_one的权限修改为-rwxr-----。
- r-->4,w-->2,x-->1,--->0.
