## 配置
1. 创建工作空间
``` 
mkdir ~/Swarm_ws
cd ~/Swarm_ws
```

2. 下载本仓库及子模块
```
git clone https://github.com/KennethYangle/Swarm_ws.git
mv Swarm_ws src
cd src
git submodule init
git submodule update
```

3. 编译
```
cd ..
catkin_make
```

4. 刷新ROS环境变量
```
# USER_NAME替换为自己的用户名，用zsh的是...../setup.zsh
source /home/USER_NAME/Swarm_ws/devel/setup.bash
# 或者把这句话加在~/.bashrc（或者~/.zshrc），然后重开一个终端，就不用每次都执行上面这句了
```

5. 替换RflySim配置文件
在Windows电脑下，把`rflysim-config`文件夹内容拷到PX4PSP对应路径下。其中`oldfactory_HITL.bat`和`oldfactory_SITL.bat`是硬件在环和软件在环仿真快速启动脚本，`client_ue4_broadcast.py`是加入小球和传图脚本。根据RflySim说明文档，修改其中的IP地址。




## 使用
1. 在Windows电脑下运行`oldfactory_SITL.bat`或者`oldfactory_HITL.bat`。加入小球、传图需要运行`client_ue4_broadcast.py`。其中传图需要把`client_ue4_broadcast.py`内注释打开，对电脑性能要求高，待测试。
```
若Linux环境为VMware虚拟机，需要在Windows电脑下将需要将oldfactory_SITL.bat第39行修改为
SET IS_BROADCAST=IP_Virtual
其中IP_Virtual为虚拟机ip地址
虚拟机网络适配器需采用 桥接模式（自动），选中 复制物理网络连接状态
```

2. 在Linux下运行。接收各种需要的消息
```
# 终端1。其中IP为Windows电脑的IP地址
roslaunch mavros px4.launch fcu_url:="udp://:20101@IP:20100"

# 终端2[可选]。运行后得到图像话题，可以后续操作
roslaunch rflysim_ros_pkg cameras.launch
```

3. 打开MATLAB和Simulink，开始Simulink仿真。可以在Windows或Linux电脑，注意需要自行判断ROSCORE的IP。
```
rosinit("IP_Virtual")
```
4. 在QgroundControl中手动解锁、起飞

5. 执行任务
```
# 终端3。注意需要为offboard.py添加可执行权限
rosrun decision offboard.py
```

6. 聚焦第5步弹出窗口，按a键进入offboard模式，执行第一个航路点。




## 开发
```
# 开发前获取最新版本
git pull
# 可选，更新子模块
git submodule update
# 开发过程中，可以回到~/Swarm_ws/src目录下，提交代码
git add .
git commit -m "say something"
# 开发完成后，上传代码
git push
```

