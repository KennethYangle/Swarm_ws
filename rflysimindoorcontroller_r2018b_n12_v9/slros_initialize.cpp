#include "slros_initialize.h"

ros::NodeHandle * SLROSNodePtr;
const std::string SLROSNodeName = "RflysimIndoorController_r2018b_N12_V9";

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe1
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15722;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe10
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15853;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe11
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15957;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe12
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15958;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe13
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16063;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe14
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16064;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe15
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16065;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe16
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16066;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe17
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16067;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe18
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_16068;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe19
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16099;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe2
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15777;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe20
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16100;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe21
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16101;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe22
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16102;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe23
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16103;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe24
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_16104;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe3
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15947;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe4
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15948;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe5
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15834;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe6
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15835;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe7
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15949;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe8
SimulinkSubscriber<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Sub_RflysimIndoorController_r2018b_N12_V9_15956;

// For Block RflysimIndoorController_r2018b_N12_V9/Position, Yaw and Velocity/Subscribe9
SimulinkSubscriber<geometry_msgs::PoseStamped, SL_Bus_RflysimIndoorController_r_PoseStamped_lkfn12> Sub_RflysimIndoorController_r2018b_N12_V9_15852;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15717;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe1
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15920;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe10
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16037;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe11
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16038;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe2
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15921;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe3
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15922;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe4
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15833;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe5
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16033;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe6
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16034;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe7
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16035;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe8
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_15851;

// For Block RflysimIndoorController_r2018b_N12_V9/States/Subscribe9
SimulinkSubscriber<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Sub_RflysimIndoorController_r2018b_N12_V9_16036;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe1
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15932;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe10
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16019;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe11
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15854;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe12
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16020;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe2
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15933;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe3
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15807;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe4
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15934;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe5
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16015;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe6
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16016;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe7
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_15836;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe8
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16017;

// For Block RflysimIndoorController_r2018b_N12_V9/Subscribe9
SimulinkSubscriber<swarm_msgs::Pipeline, SL_Bus_RflysimIndoorController_r_Pipeline_6g4ty9> Sub_RflysimIndoorController_r2018b_N12_V9_16018;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15746;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_15747;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem1/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15870;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem1/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_15871;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem10/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16174;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem10/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16175;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem11/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16187;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem11/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16188;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem2/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15883;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem2/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_15884;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem3/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15973;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem3/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_15974;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem4/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15986;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem4/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_15987;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem5/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_15999;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem5/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16000;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem6/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16122;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem6/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16123;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem7/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16135;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem7/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16136;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem8/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16148;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem8/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16149;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem9/Publish
SimulinkPublisher<std_msgs::UInt64, SL_Bus_RflysimIndoorController_r_UInt64_3ehx7i> Pub_RflysimIndoorController_r2018b_N12_V9_16161;

// For Block RflysimIndoorController_r2018b_N12_V9/Subsystem9/Publish1
SimulinkPublisher<geometry_msgs::TwistStamped, SL_Bus_RflysimIndoorController_r_TwistStamped_qujgvy> Pub_RflysimIndoorController_r2018b_N12_V9_16162;

void slros_node_init(int argc, char** argv)
{
  ros::init(argc, argv, SLROSNodeName);
  SLROSNodePtr = new ros::NodeHandle();
}

