## 使用说明
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
catkin_make
```

4. 刷新ROS环境变量
```
# USER_NAME替换为自己的用户名，用zsh的是...../setup.zsh
source /home/USER_NAME/Swarm_ws/devel/setup.bash
# 或者把这句话加在~/.bashrc（或者~/.zshrc），然后重开一个终端，就不用每次都执行上面这句了
```

5. 开发
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