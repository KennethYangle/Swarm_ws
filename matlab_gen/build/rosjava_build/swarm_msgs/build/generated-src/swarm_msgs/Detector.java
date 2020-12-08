package swarm_msgs;

public interface Detector extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "swarm_msgs/Detector";
  static final java.lang.String _DEFINITION = "swarm_msgs/Object[] objects";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  java.util.List<swarm_msgs.Object> getObjects();
  void setObjects(java.util.List<swarm_msgs.Object> value);
}
