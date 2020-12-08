package swarm_msgs;

public interface Flow extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Flow";
  static final java.lang.String _DEFINITION = "swarm_msgs/Flowpixel[] pixels";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  java.util.List<swarm_msgs.Flowpixel> getPixels();
  void setPixels(java.util.List<swarm_msgs.Flowpixel> value);
}
