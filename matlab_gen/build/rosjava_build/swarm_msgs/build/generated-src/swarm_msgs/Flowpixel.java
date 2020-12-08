package swarm_msgs;

public interface Flowpixel extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Flowpixel";
  static final java.lang.String _DEFINITION = "geometry_msgs/Point32 start_point\ngeometry_msgs/Point32 direction";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  geometry_msgs.Point32 getStartPoint();
  void setStartPoint(geometry_msgs.Point32 value);
  geometry_msgs.Point32 getDirection();
  void setDirection(geometry_msgs.Point32 value);
}
