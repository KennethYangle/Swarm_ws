#!/usr/bin/env python
# coding=utf-8

import rospy
import os
import argparse
import json
import numpy as np
from swarm_msgs.msg import Pipeline, Pipeunit
from mavros_msgs.msg import State
from mavros_msgs.srv import CommandBool, SetMode
from geometry_msgs.msg import PoseStamped, TwistStamped
from sensor_msgs.msg import Imu, NavSatFix
from geometry_msgs.msg import Point32


class Decision:
    def __init__(self):
        self.pipe_pub = rospy.Publisher('decision_info', Pipeline , queue_size=10)
        self.rate = rospy.Rate(1)

    def worker(self):
        a = Pipeline()
        a.pipetype.data = 10
        u = Pipeunit()
        u.middle = Point32(10,20,30)
        u.left = Point32(0,20,30)
        u.right = Point32(20,20,30)
        while not rospy.is_shutdown():
            a.units.append(u)
            print(a)
            self.pipe_pub.publish(a)
            self.rate.sleep()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--play', default=os.path.join(os.path.expanduser('~'),"Swarm_ws/src/decision/scenarios","play.json"), help='play file path')
    args = parser.parse_args()
    print(args)
    play_file = open(args.play)
    play = json.load(play_file)
    print(json.dumps(play))

    rospy.init_node('decision_node', anonymous=True)
    dd = Decision()
    dd.worker()