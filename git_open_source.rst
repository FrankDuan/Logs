
osx快捷键：
Command ⌘  Option ⌥  Caps Lock ⇪ Shift ⇧ Control ⌃

2016年3月21日，git培训：

http password:
YXpejAAawZJkIk50u3rQ7hPF17l82wsSKbz9F1Y8nw

老是连接不上gerrit原因是需要执行如下操作

git remote add gerrit https://duankebo@review.openstack.org:443/openstack/dragonflow.git

duanfrankdeMBP:specs duan$ git review
fatal: remote error:
ICLA contributor agreement requires current contact information.

pip install failed, can use mirror address:
cd
mkdir .pip
vim pip.conf
添加如下内容：
[global]
index-url =http://pypi.douban.com/simple
[install]
trusted-host=pypi.douban.com

if there is “permission denied” error, use chmod a+w to fix.

*** rebase a branch
1. git checkout master
2. git pull
3. git checkout your_branch
4. git rebase -i master
5. solve the conflict
6. git add solved_file
7. git rebase —continue
8. git commit -a —amend
9. git review

*** git review problem
git rebase -i master
That command will show a list of each commit, as such:
pick fb554f5 This is commit 1
pick 2bd1903 This is commit 2
pick d987ebf This is commit 3
Edit the summary shown to you by the rebase command, leaving the commit you want to be the main commit as "pick" and changing all subsequent "pick" commands as "squash":
pick fb554f5 This is commit 1
squash 2bd1903 This is commit 2
squash d987ebf This is commit 3
python单元测试
如何执行单个测试用例：tox -e py27 dragonflow.tests.unit.test_topology.TestTopology.test_vm_port_online
 单元测试如何进行ut，运行ut时，日志在什么地方？
UT失败时，会将日志和控制台的输出打印出来。

ubuntu上如何访问vbox共享的目录
sudo mount -t vboxsf share_name /home/duan/code

tls error when git clone
error: gnutls_handshake() failed: A TLS packet with unexpected length was received. while accessing ...
fatal: HTTP request failed
Got reason of the problem, it was gnutls package. It's working weird behind a proxy. But openssl is working fine even in weak network. So workaround is that we should compile git with openssl. To do this, run the following commands:
sudo apt-get install build-essential fakeroot dpkg-dev
mkdir ~/git-openssl
cd ~/git-openssl
sudo apt-get source git
sudo apt-get build-dep git
sudo apt-get install libcurl4-openssl-dev
sudo dpkg-source -x git_1.7.9.5-1.dsc
cd git_1.7.9.5 8.
Then, edit debian/control file (run the command: gksu gedit debian/control) and replace all instances of libcurl4-gnutls-dev with libcurl4-openssl-dev
sudo dpkg-buildpackage -rfakeroot -b
(if it's failing on test, you can remove the line TEST=test from the file debian/rules)
sudo dpkg -i ../git_1.7.9.5-1_i386.deb
devstack机器重启后如何启动服务？
devstack本身就是为了测试openstack，所以不保存状态。重启后需要重新运行unstack.sh 和stack.sh
tox fullstack shell 的含义
exec 3>&1
status=$(exec 4>&1 >&3; ( python setup.py testr --slowest --testr-args="--subunit $TESTRARGS"; echo $? >&4 ) | $(dirname $0)/subunit-trace.py -f) && exit $status
exec <file
将file中的内容作为exec的标准输入
exec >file
将file中的内容作为标准写出
exec 3<file
将file读入到fd3中
sort <&3
fd3中读入的内容被分类
exec 4>file
将写入fd4中的内容写入file中
ls >&4
Ls将不会有显示，直接写入fd4中了，即上面的file中
exec 5<&4
创建fd4的拷贝fd5
exec 3<&-
关闭fd3
$#表示包括$0在内的命令行参数的个数。在Shell中，脚本名称本身是$0，剩下的依次是$0、$1、$2…、${10}、${11}，等等。$*表示整个参数列表，不包括$0，也就是说不包括文件名的参数列表。
$? 最后运行的命令的结束代码（返回值）
exec 3>&1 创建fd3，fd3输出到标准输出（屏幕）
运行fullstack失败， run_subunit_content 引用前未赋值
</p>
running testr
WARNING: No route found for IPv6 destination :: (no default route?)
local variable 'run_subunit_content' referenced before assignment

原因：.testrepository files are unreadable.

开发环境的建立（windows）
1. git clone https://github.com/openstack/dragonflow.git
2. 设置环境变量
3. git remote add gerrit https://duankebo:YXpejAAawZJkIk50u3rQ7hPF17l82wsSKbz9F1Y8nw@review.openstack.org/openstack/dragonflow.git

开发环境的建立（ubuntu）
tox的安装，需要先删除ubuntu自带的tox，apt-get remove python-tox
需要升级pip, pip install -U pip

从gerrit上取补丁然后更新的方法
1. 先拷贝review页面上的git fetch …的地址</p>
2. 在本地的git库上从上面地址里取代码
3. git checkout -b branch名称

  设置远程分支：
1. 在github上创建分支
2. 在本地库上设置remote, git remote add mine https://github.com/FrankDuan/df_code.git
3.    push修改到远程分支， git push mine test:master  mine为remote库，test为本地分支，master为远程分支
4.    从远程分支pull修改, git pull 远程主机名 远程分支名：本地分支名
5.    设置跟踪远程分支：git branch --track 本地分支名 远程主机名/远程分支名
  设置remote的用户名，密码
git remote set-url mine  https://FrankDuan:Linux365@github.com/FrankDuan/df_code.git

git  your branch and "origin/master" hae diverged, and have x and x different commits each

git pull 时出现non-fast-forward error
git pull mine master:private
From https://github.com/frankduan/dragonflow
 ! [rejected]        master     -> private  (non-fast-forward)
