#!/usr/bin/env python
#coding=utf-8

import rospy
from mavros_msgs.msg import State
from mavros_msgs.srv import CommandBool, SetMode
from geometry_msgs.msg import PoseStamped, TwistStamped
from sensor_msgs.msg import Imu, NavSatFix
# from std_msgs import Float64  Float64MultiArray  UInt64
from std_msgs.msg import Float64
from std_msgs.msg import UInt64
from std_msgs.msg import String
import time
import math
import numpy as np

#keyboard input
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
        # self.drone_state = UInt64()
        self.drone_state = String()
        self.mav_pos = np.array([0, 0, 0])
        self.mav_vel = np.array([0, 0, 0])
        self.cmd_vel = np.array([0, 0, 0])
        self.cmd_body_vel = np.array([0, 0, 0])
        self.cmd_force_vel = np.array([0, 0, 0])
        self.ttc = 0
        self.cmd_pos_vel = np.array([0, 0, 0])
        self.mav_yaw = 0
        self.cmd_yaw = 0
        self.mav_roll = 0
        self.mav_pitch = 0
        self.mav_R = np.zeros((3,3))
        self.desire_pos = np.array([20, 30, 0])

        '''
        ros subscribers   /balance_force  /ttc_mean
        '''
        self.local_pose_sub = rospy.Subscriber("/mavros/local_position/pose", PoseStamped, self.local_pose_callback)
        self.mavros_sub = rospy.Subscriber("/mavros/state", State, self.mavros_state_callback)
        self.gps_sub = rospy.Subscriber("/mavros/global_position/global", NavSatFix, self.gps_callback)
        self.imu_sub = rospy.Subscriber("/mavros/imu/data", Imu, self.imu_callback)
        self.mav_sub = rospy.Subscriber("mavros/local_position/velocity_local", TwistStamped, self.mav_vel_cb)
        # self.imu_sub = rospy.Subscriber("mavros/imu/data", Imu, self.mav_vel_cb)

        self.is_offboard = False
        self.is_start, self.is_tunnel, self.is_door, self.is_search, self.is_window = False, False, False, False, False
        
        self.P_pos = 0.1
        self.P_yaw = 0.1
        self.P_heigh = 0.5
        self.start_height = 0 
        self.distance = 0 

        '''
        ros publishers
        '''
        self.vel_pub = rospy.Publisher('mavros/setpoint_velocity/cmd_vel', TwistStamped, queue_size=10)
        self.drone_state_pub = rospy.Publisher('drone_i/state', String, queue_size=10)
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
        self.flightModeService = rospy.ServiceProxy('/mavros/set_mode', SetMode)

        print("Px4 Controller Initialized!")


    def start(self):
        rospy.init_node("offboard_node")
        rate = rospy.Rate(20)

        while(not self.mavros_state.connected):
            print(self.mavros_state.connected)
            rate.sleep()

        for i in range(10):
            self.vel_pub.publish(self.command)
            rate.sleep()
        
        self.offboard_state = SetMode()
        self.offboard_state.custom_mode = "OFFBOARD"
        self.arm_state = CommandBool()
        self.arm_state.value = True

        start_time = rospy.Time.now()
        '''
        main ROS thread
        '''
        
        cnt = -1
        while (rospy.is_shutdown() is False):
            cnt += 1
            self.record_stast()
            self.drone_state_pub.publish(self.drone_state)
            if self.is_offboard == False:
                if self.mavros_state.mode == "OFFBOARD":
                    resp1 = self.flightModeService(0, "POSCTL")
                if cnt % 10 == 0:
                    print("Enter MANUAL mode")
                rate.sleep()
                # self.start_height = self.mav_pos[2]
                continue
            else:
                if self.mavros_state.mode != "OFFBOARD":
                    resp1 = self.flightModeService( 0,self.offboard_state.custom_mode )
                    if resp1.mode_sent:
                        print("Offboard enabled")
                    start_time = rospy.Time.now()
                
            
            self.command.twist.linear.x = self.cmd_vel[0]
            self.command.twist.linear.y = self.cmd_vel[1]
            self.command.twist.linear.z = self.cmd_vel[2]
            self.command.twist.angular.z = self.cmd_yaw
            self.vel_pub.publish(self.command)
            rate.sleep()
 
    def mav_state(self):
        print("force: {}".format(10))
    
    def local_pose_callback(self, msg):
        self.local_pose = msg
        self.local_enu_position = msg
        self.mav_pos = [msg.pose.position.x, msg.pose.position.y, msg.pose.position.z]
        # self.mav_pos = np.array([msg.pose.position.x, msg.pose.position.y, msg.pose.position.z])
        q0, q1, q2, q3 = msg.pose.orientation.w, msg.pose.orientation.x, msg.pose.orientation.y, msg.pose.orientation.z
        self.mav_yaw = math.atan2(2*(q0*q3+q1*q2), 1-2*(q2*q2+q3*q3))
        self.mav_pitch = math.asin(2*(q0*q2 - q1*q3))
        self.mav_roll = math.atan2(2*(q0*q1+q2*q3), 1-2*(q1*q1 + q2*q2))
        R_ae = np.array([[q0**2+q1**2-q2**2-q3**2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2)],
                          [2*(q1*q2+q0*q3), q0**2-q1**2+q2**2-q3**2, 2*(q2*q3-q0*q1)],
                          [2*(q1*q3-q0*q2), 2*(q2*q3+q0*q1), q0**2-q1**2-q2**2+q3**2]])
        R_ba = np.array([[0,1,0], [-1,0,0], [0,0,1]])
        self.mav_R = R_ae.dot(R_ba)  #机体坐标系  x————向右  y————向前   z————向上

    def mav_vel_cb(self, msg):
        self.mav_vel = np.array([msg.twist.linear.x, msg.twist.linear.y, msg.twist.linear.z])
    # mav_vel = [msg.twist.linear.x, msg.twist.linear.y, msg.twist.linear.z]
    
    def read_kbd_input(self):
        win = tkinter.Tk()
        frame = tkinter.Frame(win,width=200,height=120)
        frame.bind("<Key>",self.call)
        frame.focus_set()
        frame.pack()
        win.mainloop()

    def record_stast(self):
        if self.is_start == True:
            print("start_pos: {}".format(self.mav_pos))
        elif self.is_tunnel == True:
            print("tunnel_pos: {}".format(self.mav_pos))
        elif self.is_door == True:
            print("door_pos: {}".format(self.mav_pos))
        elif self.is_search == True:
            print("search_pos: {}".format(self.mav_pos))
        elif self.is_window == True:
            print("window_pos: {}".format(self.mav_pos))


    def call(self, event):
        k = event.keysym
        if k == "a":
            self.is_start = True
            self.is_tunnel = False
            self.is_door = False
            self.is_window = False
            self.is_search = False
            self.drone_state.data = "task_takeoff"
        elif k == "b":
            self.is_start = False
            self.is_tunnel = True
            self.is_door = False
            self.is_window = False
            self.is_search = False
            self.drone_state.data = "task_out_search"
        elif k == "c":
            self.is_start = False
            self.is_tunnel = False
            self.is_door = True
            self.is_window = False
            self.is_search = False
            self.drone_state.data = "task_pass_through"
        elif k == "d":
            self.is_start = False
            self.is_tunnel = False
            self.is_door = False
            self.is_window = True
            self.is_search = False
            self.drone_state.data = "task_in_search"
        elif k == "e":
            self.is_start = False
            self.is_tunnel = False
            self.is_door = False
            self.is_window = False
            self.is_search = True
            self.drone_state.data = "task_recognize"
        elif k == "f":
            self.is_start = False
            self.is_tunnel = False
            self.is_door = False
            self.is_window = False
            self.is_search = False
            self.drone_state.data = "task_attack"
        elif k == "g":
            self.drone_state.data = "task_finish"
        time.sleep(0.02)

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
        self.imu_rate = np.array([msg.angular_velocity.x, msg.angular_velocity.y, msg.angular_velocity.z])
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
