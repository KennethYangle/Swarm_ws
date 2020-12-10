#!/usr/bin/env python
# coding=utf-8

import rospy
from mavros_msgs.msg import State
from mavros_msgs.srv import CommandBool, SetMode
from geometry_msgs.msg import PoseStamped, TwistStamped
from sensor_msgs.msg import Imu, NavSatFix
# from std_msgs import Float64  Float64MultiArray  UInt64
from std_msgs.msg import Float64
from std_msgs.msg import UInt64
from std_msgs.msg import String
from rflysim_ros_pkg.msg import Obj

import time
import math
import numpy as np

# keyboard input
import threading
import tkinter


class Px4Controller:

    def __init__(self):
        self.imu = None
        self.gps = None
        self.local_pose = None
        self.current_state = None
        self.current_heading = None
        self.local_enu_position = None

        self.arm_state = False
        self.offboard_state = False
        self.received_imu = False
        self.frame = "BODY"
        self.imu_rate = np.array([0, 0, 0])

        self.state = None
        self.mavros_state = State()
        self.command = TwistStamped()
        self.drone_state = UInt64()
        # self.drone_state = String()
        self.mav_pos = np.array([0, 0, 0])
        self.mav_vel = np.array([0, 0, 0])
        self.cmd_vel = np.array([0, 0, 0])
        self.mav_yaw = 0
        self.cmd_yaw = 0
        self.mav_roll = 0
        self.mav_pitch = 0
        self.mav_R = np.zeros((3, 3))
        # 第一个任务起始点位置
        self.initial_pos = np.array([147, -8 - 5, 4])
        # 搜索点位置
        self.search_pos = np.array([[150, 3, 4],
                                    [180, 4.5, 4],
                                    [244, 1.2, 4],
                                    [244, 20, 4],
                                    [160, 18, 4],
                                    [170, 11, 4]])
        self.search_point = 0
        self.target_pos = np.array([200, 10, 4])

        self.dis_initial_pos = 2
        self.dis_search_pos = 1
        self.dis_target_pos = 1

        self.P_pos = 0.8
        self.P_yaw = 0.5
        self.pos_vel_sat = 5
        self.yaw_sat = 0.8
        '''
        ros subscribers   /balance_force  /ttc_mean
        '''
        self.local_pose_sub = rospy.Subscriber(
            "/mavros/local_position/pose", PoseStamped, self.local_pose_callback)
        self.mavros_sub = rospy.Subscriber(
            "/mavros/state", State, self.mavros_state_callback)
        self.gps_sub = rospy.Subscriber(
            "/mavros/global_position/global", NavSatFix, self.gps_callback)
        self.imu_sub = rospy.Subscriber(
            "/mavros/imu/data", Imu, self.imu_callback)
        self.mav_sub = rospy.Subscriber(
            "mavros/local_position/velocity_local", TwistStamped, self.mav_vel_cb)
        self.drone_state_sub = rospy.Subscriber(
            'drone_1/state', UInt64, self.drone_state_cb)
        # self.imu_sub = rospy.Subscriber("mavros/imu/data", Imu, self.mav_vel_cb)

        self.is_offboard = False
        self.is_start, self.is_tunnel, self.is_trapezoid, self.is_search = False, False, False, False

        '''
        ros publishers
        '''
        self.vel_pub = rospy.Publisher(
            'mavros/setpoint_velocity/cmd_vel', TwistStamped, queue_size=10)
        # self.drone_state_pub = rospy.Publisher('drone_1/state', String, queue_size=10)
        self.drone_state_pub = rospy.Publisher(
            'drone_1/state', UInt64, queue_size=10)
        self.task_takeoff = 10
        self.task_out_search = 20
        self.task_recognize_door = 30
        self.task_pass_through = 40
        self.task_in_search = 50
        self.task_recognize_target = 60
        self.task_attack = 70
        self.task_finish = 80
        '''
        caes1:"task_takeoff"
        caes2:"task_out_search"
        caes3:"task_recognize_door"
        caes4:"task_pass_through"
        caes5:"task_in_search"
        caes6:"task_recognize_target"
        caes7:"task_attack"
        caes8:"task_finish"
        '''
        '''
        ros services
        '''
        self.armService = rospy.ServiceProxy('/mavros/cmd/arming', CommandBool)
        self.flightModeService = rospy.ServiceProxy(
            '/mavros/set_mode', SetMode)

        print("Px4 Controller Initialized!")

    def start(self):
        rospy.init_node("offboard_node")
        rate = rospy.Rate(20)

        obj_pub = rospy.Publisher(
            "ue4_ros/obj", Obj, queue_size=10)
        # type_pub = rospy.Publisher(
        #     "ue4_ros/obj/vehicle_type", UInt64, queue_size=10)
        # id_pub = rospy.Publisher(
        #     "ue4_ros/obj/vehicle_id", UInt64, queue_size=10)

        obj_msg = Obj()
        # type_msg = UInt64()
        # id_msg = UInt64()

        while(not self.mavros_state.connected):
            print(self.mavros_state.connected)
            rate.sleep()

        for i in range(10):
            self.vel_pub.publish(self.command)
            self.drone_state.data == self.task_takeoff
            self.drone_state_pub.publish(self.drone_state)
            rate.sleep()

        self.offboard_state = SetMode()
        self.offboard_state.custom_mode = "OFFBOARD"
        self.arm_state = CommandBool()
        self.arm_state.value = True

        start_time = rospy.Time.now()
        '''
        main ROS thread
        '''
        self.drone_state.data == self.task_takeoff
        cnt = -1
        obj_msg.position.x = 0
        obj_msg.position.y = 3
        obj_msg.position.z = 2
        obj_msg.angule.x = 0
        obj_msg.angule.y = 0
        obj_msg.angule.z = 0
        obj_msg.type = 30
        obj_msg.id = 100
        while (rospy.is_shutdown() is False):
            cnt += 1
            # self.record_stast()
            # self.drone_state_pub.publish(self.drone_state)
            print("self.mav_yaw: {}".format(self.mav_yaw))
            self.state_pub()
            if self.is_offboard == False:
                if self.mavros_state.mode == "OFFBOARD":
                    resp1 = self.flightModeService(0, "POSCTL")
                if cnt % 10 == 0:
                    print("Enter MANUAL mode")
                rate.sleep()
                # start_yaw = self.mav_yaw
                continue
            else:
                if self.mavros_state.mode != "OFFBOARD":
                    resp1 = self.flightModeService(
                        0, self.offboard_state.custom_mode)
                    if resp1.mode_sent:
                        print("Offboard enabled")
                    start_time = rospy.Time.now()
            # cmd_control = self.state_control(self.drone_state.data)
            # self.cmd_vel = np.array(
            #     [cmd_control[0], cmd_control[1], cmd_control[2]])
            # self.cmd_yaw = cmd_control[3]
            self.cmd_vel = np.array([0, 0, 0])
            des_pos = np.array([10, 0, 3])
            self.cmd_yaw = 0.1
            if self.is_start == True:
                self.cmd_vel = self.pos_control(
                    des_pos, self.mav_pos, self.P_pos, 1)
                # self.cmd_vel = np.array([0, 0, 0])
                # self.cmd_vel[0] = 1
                self.cmd_yaw = 0.1
                obj_msg.position.x = obj_msg.position.x + 0.05
                # obj_msg.angule.x = obj_msg.angule.x + 0.05

            # if (self.drone_state.data == self.task_takeoff or self.drone_state.data == self.task_in_search or
            #     self.drone_state.data == self.task_recognize_target or self.drone_state.data == self.task_attack or
            #     self.drone_state.data == self.task_finish or self.drone_state.data == 0):
            #     self.command.twist.linear.x = self.cmd_vel[0]
            #     self.command.twist.linear.y = self.cmd_vel[1]
            #     self.command.twist.linear.z = self.cmd_vel[2]
            #     self.command.twist.angular.z = self.cmd_yaw
            #     self.vel_pub.publish(self.command)
            # print("mav_pos: {}".format(self.mav_pos))
            self.command.twist.linear.x = self.cmd_vel[0]
            self.command.twist.linear.y = self.cmd_vel[1]
            self.command.twist.linear.z = self.cmd_vel[2]
            self.vel_pub.publish(self.command)
            obj_pub.publish(obj_msg)
            # type_pub.publish(type_msg)
            # id_pub.publish(id_msg)
            rate.sleep()

    def local_pose_callback(self, msg):
        self.local_pose = msg
        self.local_enu_position = msg
        # self.mav_pos = [msg.pose.position.x, msg.pose.position.y, msg.pose.position.z]
        self.mav_pos = np.array(
            [msg.pose.position.x, msg.pose.position.y, msg.pose.position.z])
        q0, q1, q2, q3 = msg.pose.orientation.w, msg.pose.orientation.x, msg.pose.orientation.y, msg.pose.orientation.z
        self.mav_yaw = math.atan2(2*(q0*q3+q1*q2), 1-2*(q2*q2+q3*q3))
        self.mav_pitch = math.asin(2*(q0*q2 - q1*q3))
        self.mav_roll = math.atan2(2*(q0*q1+q2*q3), 1-2*(q1*q1 + q2*q2))
        R_ae = np.array([[q0**2+q1**2-q2**2-q3**2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2)],
                         [2*(q1*q2+q0*q3), q0**2-q1**2 +
                             q2**2-q3**2, 2*(q2*q3-q0*q1)],
                         [2*(q1*q3-q0*q2), 2*(q2*q3+q0*q1), q0**2-q1**2-q2**2+q3**2]])
        R_ba = np.array([[0, 1, 0], [-1, 0, 0], [0, 0, 1]])
        self.mav_R = R_ae.dot(R_ba)  # 机体坐标系  x————向右  y————向前   z————向上

    def mav_vel_cb(self, msg):
        self.mav_vel = np.array(
            [msg.twist.linear.x, msg.twist.linear.y, msg.twist.linear.z])
    # mav_vel = [msg.twist.linear.x, msg.twist.linear.y, msg.twist.linear.z]

    def drone_state_cb(self, msg):
        self.drone_state = msg

    def read_kbd_input(self):
        win = tkinter.Tk()
        frame = tkinter.Frame(win, width=200, height=120)
        frame.bind("<Key>", self.call)
        frame.focus_set()
        frame.pack()
        win.mainloop()

    # def record_stast(self):
    #     if self.is_start == True:
    #         print("start_pos: {}".format(self.mav_pos))
    #     elif self.is_tunnel == True:
    #         print("tunnel_pos: {}".format(self.mav_pos))
    #     elif self.is_trapezoid == True:
    #         print("trapezoid_pos: {}".format(self.mav_pos))
    #     elif self.is_search == True:
    #         print("search_pos: {}".format(self.mav_pos))

    def call(self, event):
        k = event.keysym
        if k == "a":
            self.is_offboard = True
        elif k == "b":
            self.is_start = True
        elif k == "c":
            self.is_start = False
            # self.drone_state.data = "task_takeoff"
        elif k == "d":
            self.drone_state.data = self.task_in_search
        # elif k == "c":
        #     self.drone_state.data = "task_pass_through"
        # elif k == "d":
        #     self.drone_state.data = "task_in_search"
        elif k == "e":
            self.drone_state.data = self.task_attack
        elif k == "f":
            self.drone_state.data = self.task_finish
        # elif k == "g":
        #     self.drone_state.data = "task_finish"
        time.sleep(0.02)

    def state_pub(self):
        # 管道外搜索，判断水平距离是否小于一定值
        dis_initial = self.dis_pos(self.initial_pos, self.mav_pos)
        # 房间内搜索，判断水平距离是否小于一定值
        dis_search = self.dis_pos(self.search_pos[5], self.mav_pos)
        # 终点位置，判断水平距离是否小于一定值
        dis_target = self.dis_pos(self.target_pos, self.mav_pos)
        if (self.drone_state.data == self.task_takeoff or self.drone_state.data == 0) and dis_initial > self.dis_initial_pos:
            self.drone_state.data = self.task_takeoff
        elif self.drone_state.data == self.task_takeoff and dis_initial < self.dis_initial_pos:
            self.drone_state.data = self.task_out_search
            # self.drone_state_pub.publish(self.drone_state)
        elif self.drone_state.data == self.task_in_search and dis_search < self.dis_search_pos:
            self.drone_state.data = self.task_recognize_target
            # self.drone_state_pub.publish(self.drone_state)
        elif self.drone_state.data == self.task_recognize_target:
            self.drone_state.data = self.task_attack
            # self.drone_state_pub.publish(self.drone_state)
        elif self.drone_state.data == self.task_attack and dis_target < self.dis_target_pos:
            self.drone_state.data = self.task_finish
        # else:
        #     self.drone_state.data = "task_takeoff"
            # self.drone_state_pub.publish(self.drone_state)
        # print("state pub is ok")
        # print("dis_initial: {}".format(dis_initial))
        self.drone_state_pub.publish(self.drone_state)

    def state_control(self, state):
        if state == self.task_takeoff:
            state_cmd_vel = self.pos_control(
                self.initial_pos, self.mav_pos, self.P_pos, self.pos_vel_sat)
            state_cmd_yaw = self.yaw_control(
                self.initial_pos, self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif state == self.task_in_search:
            cmd_search = self.search()
            state_cmd_vel = [cmd_search[0], cmd_search[1], cmd_search[2]]
            state_cmd_yaw = cmd_search[3]
        elif state == self.task_recognize_target:
            state_cmd_vel = np.array([0, 0, 0])
            state_cmd_yaw = 0
        elif state == self.task_attack:
            state_cmd_vel = self.pos_control(
                self.target_pos, self.mav_pos, self.P_pos, self.pos_vel_sat)
            state_cmd_yaw = self.yaw_control(
                self.target_pos, self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif state == self.task_finish:
            state_cmd_vel = np.array([0, 0, -1])
            state_cmd_yaw = 0
        else:
            state_cmd_vel = np.array([0, 0, 0])
            state_cmd_yaw = 0

        return [state_cmd_vel[0], state_cmd_vel[1], state_cmd_vel[2], state_cmd_yaw]

    # 期望位置，反馈位置，位置比例系数，速读限幅

    def pos_control(self, target_pos, feb_pos, kp, sat_vel):
        err_pos = target_pos - feb_pos
        cmd_pos_vel = self.sat(kp * err_pos, sat_vel)
        # cmd_pos_vel[2] =
        return [cmd_pos_vel[0], cmd_pos_vel[1], cmd_pos_vel[2]]

    def dis_pos(self, desire_pos, feb_pos):
        # dis = desire_pos - feb_pos
        dis_xy = math.sqrt((desire_pos[0] - feb_pos[0]) * (desire_pos[0] - feb_pos[0]) + (
            desire_pos[1] - feb_pos[1]) * (desire_pos[1] - feb_pos[1]))
        return dis_xy

    # 期望位置，反馈位置，反馈角度，偏航角控制比例系数，角速度限幅
    def yaw_control(self, target_pos, feb_pos, feb_yaw, kp_yaw, sat_yaw):
        # 机头指向目标点的位置
        desire_yaw = math.atan2(
            target_pos[1] - feb_pos[1], target_pos[0] - feb_pos[0])
        dlt_yaw = self.minAngleDiff(desire_yaw, self.mav_yaw)
        cmd_yaw = self.Saturation(kp_yaw * dlt_yaw, sat_yaw, -sat_yaw)
        return cmd_yaw

    def search(self):
        # for i in range(5):
        #     if self.dis_pos(self.search_pos[i], self.mav_pos) > 1 and self.search_point == 0:
        if self.dis_pos(self.search_pos[0], self.mav_pos) > 1 and self.search_point == 0:
            search_cmd_vel = self.pos_control(
                self.search_pos[0], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[0], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[0], self.mav_pos) < 1 and self.search_point == 0:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 1
        elif self.dis_pos(self.search_pos[1], self.mav_pos) > 1 and self.search_point == 1:
            search_cmd_vel = self.pos_control(
                self.search_pos[1], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[1], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[1], self.mav_pos) < 1 and self.search_point == 1:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 2
        elif self.dis_pos(self.search_pos[2], self.mav_pos) > 1 and self.search_point == 2:
            search_cmd_vel = self.pos_control(
                self.search_pos[2], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[2], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[2], self.mav_pos) < 1 and self.search_point == 2:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 3
        elif self.dis_pos(self.search_pos[3], self.mav_pos) > 1 and self.search_point == 3:
            search_cmd_vel = self.pos_control(
                self.search_pos[3], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[3], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[3], self.mav_pos) < 1 and self.search_point == 3:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 4
        elif self.dis_pos(self.search_pos[4], self.mav_pos) > 1 and self.search_point == 4:
            search_cmd_vel = self.pos_control(
                self.search_pos[4], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[4], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[4], self.mav_pos) < 1 and self.search_point == 4:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 5
        elif self.dis_pos(self.search_pos[5], self.mav_pos) > 1 and self.search_point == 5:
            search_cmd_vel = self.pos_control(
                self.search_pos[5], self.mav_pos, self.P_pos, self.pos_vel_sat)
            search_cmd_yaw = self.yaw_control(
                self.search_pos[5], self.mav_pos, self.mav_yaw, self.P_yaw, self.yaw_sat)
        elif self.dis_pos(self.search_pos[5], self.mav_pos) < 1 and self.search_point == 5:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0
            self.search_point = 6
        else:
            search_cmd_vel = np.array([0, 0, 0])
            search_cmd_yaw = 0

        return [search_cmd_vel[0], search_cmd_vel[1], search_cmd_vel[2], search_cmd_yaw]


    def minAngleDiff(self, a, b):
        diff = a - b
        if diff < 0:
            diff += 2*np.pi
        if diff < np.pi:
            return diff
        else:
            return diff - 2*np.pi

    def sat(self, a, maxv):
        n = np.linalg.norm(a)
        if n > maxv:
            return a/n*maxv
        else:
            return a

    def SatIntegral(self, a, up, down):
        for i in range(len(a)):
            if a[i] > up:
                a[i] = up
            elif a[i] < down:
                a[i] = down
        return a

    def Saturation(self, a, up, down):
        if a > up:
            a = up
        elif a < down:
            a = down
        return a

    def mavros_state_callback(self, msg):
        self.mavros_state = msg

    def imu_callback(self, msg):
        global global_imu, current_heading
        self.imu = msg
        self.imu_rate = np.array(
            [msg.angular_velocity.x, msg.angular_velocity.y, msg.angular_velocity.z])
        self.current_heading = self.q2yaw(self.imu.orientation)
        self.received_imu = True

    def gps_callback(self, msg):
        self.gps = msg

    def q2yaw(self, q):
        q0, q1, q2, q3 = q.w, q.x, q.y, q.z
        math.atan2(2*(q0*q3+q1*q2), 1-2*(q2*q2+q3*q3))

    def arm(self):
        if self.armService(True):
            return True
        else:
            print("Vehicle arming failed!")
            return False

    def disarm(self):
        if self.armService(False):
            return True
        else:
            print("Vehicle disarming failed!")
            return False

    def offboard(self):
        if self.flightModeService(custom_mode='OFFBOARD'):
            return True
        else:
            print("Vechile Offboard failed")
            return False


if __name__ == '__main__':
    con = Px4Controller()
    # con.read_kbd_input()
    # threading.Thread(target=con.read_kbd_input, args=())
    inputThread = threading.Thread(target=con.read_kbd_input)
    inputThread.start()
    con.start()
