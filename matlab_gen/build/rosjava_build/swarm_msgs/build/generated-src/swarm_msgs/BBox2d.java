package swarm_msgs;

public interface BBox2d extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/BBox2d";
  static final java.lang.String _DEFINITION = "geometry_msgs/Point32 left_bottom\ngeometry_msgs/Point32 right_top";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  geometry_msgs.Point32 getLeftBottom();
  void setLeftBottom(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getRightTop();
  void setRightTop(geometry_msgs.Point32 value);
}
