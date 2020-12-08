package swarm_msgs;

public interface Pipeline extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Pipeline";
  static final java.lang.String _DEFINITION = "std_msgs/UInt32 pipetype     # 10: curve pipe, 20: trapezoid pipe\nswarm_msgs/Pipeunit[] units";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  std_msgs.UInt32 getPipetype();
  void setPipetype(std_msgs.UInt32 value);
  java.util.List<swarm_msgs.Pipeunit> getUnits();
  void setUnits(java.util.List<swarm_msgs.Pipeunit> value);
}
