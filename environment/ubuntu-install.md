### 不知道为什么我总是能够把ubuntu玩脱, 所以写了这个备忘录, 方便ubuntu重装之后的设置

## Anaconda
[中科大镜像](http://mirrors.ustc.edu.cn/anaconda/archive/)

## Chrome
```
sudo wget http://www.linuxidc.com/files/repo/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
sudo apt-get update
sudo apt-get install google-chrome-stable
```

## Shadowsocks-Qt5
```
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5 
```
Ubuntu 18.04 LTS 暂时不支持, 所以在执行完第一行后要编辑`/etc/apt/sources.list.d/hzwhuang-ubuntu-ss-qt5-bionic.list`文件, 将`bionic`(18.04版本代号)改成`xenial`(16.04版本代号).

## Sublime
```
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text
```

## MongoDB & Robo3T
```
sudo apt-get install mongodb
```
MongoDB的可视化软件[Robo 3T(Robomongo)](https://robomongo.org/download)

## MySQL & MySQL Workbench
参考: [MySQL官网](https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/)
`MySQL Workbench`也在同一页面
```
sudo dpkg -i /PATH/version-specific-package-name.deb
sudo apt-get update
sudo apt-get install mysql-server
sudo apt-get install mysql-workbench-community
```

## psensor, tmux, glances
```python
sudo apt-get install psensor # 温度监控
sudo apt-get install tmux 
pip install glances # 替代htop的系统监控
pip install mycli # 带语法高亮、自动补全的 MySQL 命令行客户端工具
```
