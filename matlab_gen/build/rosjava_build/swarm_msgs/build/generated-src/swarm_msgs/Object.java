package swarm_msgs;

public interface Object extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Object";
  static final java.lang.String _DEFINITION = "std_msgs/UInt32 id\nstd_msgs/UInt32 type\nswarm_msgs/BBox2d bbox2d\nswarm_msgs/BBox3d bbox3d\ngeometry_msgs/Point32 direction";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  std_msgs.UInt32 getId();
  void setId(std_msgs.UInt32 value);
  std_msgs.UInt32 getType();
  void setType(std_msgs.UInt32 value);
  swarm_msgs.BBox2d getBbox2d();
  void setBbox2d(swarm_msgs.BBox2d value);
  swarm_msgs.BBox3d getBbox3d();
  void setBbox3d(swarm_msgs.BBox3d value);
  geometry_msgs.Point32 getDirection();
  void setDirection(geometry_msgs.Point32 value);
}
