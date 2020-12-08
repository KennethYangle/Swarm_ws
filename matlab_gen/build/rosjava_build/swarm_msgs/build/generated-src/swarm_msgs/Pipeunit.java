package swarm_msgs;

public interface Pipeunit extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Pipeunit";
  static final java.lang.String _DEFINITION = "geometry_msgs/Point32 middle\ngeometry_msgs/Point32 left\ngeometry_msgs/Point32 right\ngeometry_msgs/Point32 bottom\ngeometry_msgs/Point32 up";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  geometry_msgs.Point32 getMiddle();
  void setMiddle(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getLeft();
  void setLeft(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getRight();
  void setRight(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getBottom();
  void setBottom(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getUp();
  void setUp(geometry_msgs.Point32 value);
}
