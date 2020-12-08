package swarm_msgs;

public interface BBox3d extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/BBox3d";
  static final java.lang.String _DEFINITION = "geometry_msgs/Point32 left_front_bottom\ngeometry_msgs/Point32 right_back_top";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  geometry_msgs.Point32 getLeftFrontBottom();
  void setLeftFrontBottom(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getRightBackTop();
  void setRightBackTop(geometry_msgs.Point32 value);
}
