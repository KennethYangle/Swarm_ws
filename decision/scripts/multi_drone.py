#!/usr/bin/env python
# coding=utf-8

import rospy
import os
import argparse
import json
import numpy as np
from swarm_msgs.msg import Pipeline, Pipeunit
from mavros_msgs.msg import State
from mavros_msgs.srv import CommandBool, SetMode, CommandTOL
from geometry_msgs.msg import PoseStamped, TwistStamped, Point32
from sensor_msgs.msg import Imu, NavSatFix
from std_msgs.msg import UInt64
# from geographic_msgs.msg import GeoPointStamped


class Px4Controller:
    def __init__(self, mav_id, mav_num):
        self.arm_state = False
        self.offboard_state = False
        self.state = None
        self.command = TwistStamped()
        self.start_point = PoseStamped()
        self.start_point.pose.position.z = 4
        self.mav_id = mav_id
        self.mav_num = mav_num
        # self.original_pos = GeoPointStamped()
        '''
        ros publishers
        '''
        self.vel_pub = rospy.Publisher('/uav%s/mavros/setpoint_velocity/cmd_vel'%(self.mav_id), TwistStamped, queue_size=10)
        self.pos_pub = rospy.Publisher('/uav%s/mavros/setpoint_position/local'%(self.mav_id), PoseStamped, queue_size=10)
        '''
        ros services
        '''
        self.armService = rospy.ServiceProxy('/uav%s/mavros/cmd/arming'%(self.mav_id), CommandBool)
        self.flightModeService = rospy.ServiceProxy('/uav%s/mavros/set_mode'%(self.mav_id), SetMode)
        self.takeoffService = rospy.ServiceProxy('/uav%s/mavros/cmd/takeoff'%(self.mav_id), CommandTOL)
        print("Px4 Controller Initialized!")

    def start(self):
        rate = rospy.Rate(20)

        for _ in range(10):
            self.vel_pub.publish(self.command)
            self.arm_state = self.arm()
            self.offboard_state = self.offboard()
            rate.sleep()

        for _ in range(100):
            self.pos_pub.publish(self.start_point)
            rate.sleep()

        self.start_point.pose.position.x = 113
        self.start_point.pose.position.y = 1.7
        self.start_point.pose.position.z = 4
        for _ in range(300):
            self.pos_pub.publish(self.start_point)
            rate.sleep()

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

    def takeoff(self):
        if self.takeoffService(altitude=3):
            return True
        else:
            print("Vechile Takeoff failed")
            return False

def drone_state_cb(msg):
    global drone_state
    drone_state = msg.data


if __name__ == '__main__':
    rospy.init_node('decision_node', anonymous=True)
    # rospy.init_node('decision_node')
    param_id = rospy.get_param("~mav_id")
    param_num = rospy.get_param("~mav_num")
    px4 = Px4Controller(param_id,param_num)
    px4.start()
    print("Finish")