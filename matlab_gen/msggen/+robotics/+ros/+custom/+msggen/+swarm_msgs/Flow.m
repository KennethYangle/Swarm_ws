classdef Flow < robotics.ros.Message
    %Flow MATLAB implementation of swarm_msgs/Flow
    %   This class was automatically generated by
    %   robotics.ros.msg.internal.gen.MessageClassGenerator.
    
    %   Copyright 2014-2020 The MathWorks, Inc.
    
    %#ok<*INUSD>
    
    properties (Constant)
        MessageType = 'swarm_msgs/Flow' % The ROS message type
    end
    
    properties (Constant, Hidden)
        MD5Checksum = '79fa41eef8222b0d54643e39a163027b' % The MD5 Checksum of the message definition
    end
    
    properties (Access = protected)
        JavaMessage % The Java message object
    end
    
    properties (Constant, Access = protected)
        SwarmMsgsFlowpixelClass = robotics.ros.msg.internal.MessageFactory.getClassForType('swarm_msgs/Flowpixel') % Dispatch to MATLAB class for message type swarm_msgs/Flowpixel
    end
    
    properties (Dependent)
        Pixels
    end
    
    properties (Access = protected)
        Cache = struct('Pixels', []) % The cache for fast data access
    end
    
    properties (Constant, Hidden)
        PropertyList = {'Pixels'} % List of non-constant message properties
        ROSPropertyList = {'pixels'} % List of non-constant ROS message properties
    end
    
    methods
        function obj = Flow(msg)
            %Flow Construct the message object Flow
            import com.mathworks.toolbox.robotics.ros.message.MessageInfo;
            
            % Support default constructor
            if nargin == 0
                obj.JavaMessage = obj.createNewJavaMessage;
                return;
            end
            
            % Construct appropriate empty array
            if isempty(msg)
                obj = obj.empty(0,1);
                return;
            end
            
            % Make scalar construction fast
            if isscalar(msg)
                % Check for correct input class
                if ~MessageInfo.compareTypes(msg(1), obj.MessageType)
                    error(message('robotics:ros:message:NoTypeMatch', obj.MessageType, ...
                        char(MessageInfo.getType(msg(1))) ));
                end
                obj.JavaMessage = msg(1);
                return;
            end
            
            % Check that this is a vector of scalar messages. Since this
            % is an object array, use arrayfun to verify.
            if ~all(arrayfun(@isscalar, msg))
                error(message('robotics:ros:message:MessageArraySizeError'));
            end
            
            % Check that all messages in the array have the correct type
            if ~all(arrayfun(@(x) MessageInfo.compareTypes(x, obj.MessageType), msg))
                error(message('robotics:ros:message:NoTypeMatchArray', obj.MessageType));
            end
            
            % Construct array of objects if necessary
            objType = class(obj);
            for i = 1:length(msg)
                obj(i,1) = feval(objType, msg(i)); %#ok<AGROW>
            end
        end
        
        function pixels = get.Pixels(obj)
            %get.Pixels Get the value for property Pixels
            if isempty(obj.Cache.Pixels)
                javaArray = obj.JavaMessage.getPixels;
                array = obj.readJavaArray(javaArray, obj.SwarmMsgsFlowpixelClass);
                obj.Cache.Pixels = feval(obj.SwarmMsgsFlowpixelClass, array);
            end
            pixels = obj.Cache.Pixels;
        end
        
        function set.Pixels(obj, pixels)
            %set.Pixels Set the value for property Pixels
            if ~isvector(pixels) && isempty(pixels)
                % Allow empty [] input
                pixels = feval([obj.SwarmMsgsFlowpixelClass '.empty'], 0, 1);
            end
            
            validateattributes(pixels, {obj.SwarmMsgsFlowpixelClass}, {'vector'}, 'Flow', 'Pixels');
            
            javaArray = obj.JavaMessage.getPixels;
            array = obj.writeJavaArray(pixels, javaArray, obj.SwarmMsgsFlowpixelClass);
            obj.JavaMessage.setPixels(array);
            
            % Update cache if necessary
            if ~isempty(obj.Cache.Pixels)
                obj.Cache.Pixels = [];
                obj.Cache.Pixels = obj.Pixels;
            end
        end
    end
    
    methods (Access = protected)
        function resetCache(obj)
            %resetCache Resets any cached properties
            obj.Cache.Pixels = [];
        end
        
        function cpObj = copyElement(obj)
            %copyElement Implements deep copy behavior for message
            
            % Call default copy method for shallow copy
            cpObj = copyElement@robotics.ros.Message(obj);
            
            % Clear any existing cached properties
            cpObj.resetCache;
            
            % Create a new Java message object
            cpObj.JavaMessage = obj.createNewJavaMessage;
            
            % Recursively copy compound properties
            cpObj.Pixels = copy(obj.Pixels);
        end
        
        function reload(obj, strObj)
            %reload Called by loadobj to assign properties
            PixelsCell = arrayfun(@(x) feval([obj.SwarmMsgsFlowpixelClass '.loadobj'], x), strObj.Pixels, 'UniformOutput', false);
            obj.Pixels = vertcat(PixelsCell{:});
        end
    end
    
    methods (Access = ?robotics.ros.Message)
        function strObj = saveobj(obj)
            %saveobj Implements saving of message to MAT file
            
            % Return an empty element if object array is empty
            if isempty(obj)
                strObj = struct.empty;
                return
            end
            
            strObj.Pixels = arrayfun(@(x) saveobj(x), obj.Pixels);
        end
    end
    
    methods (Static, Access = {?matlab.unittest.TestCase, ?robotics.ros.Message})
        function obj = loadobj(strObj)
            %loadobj Implements loading of message from MAT file
            
            % Return an empty object array if the structure element is not defined
            if isempty(strObj)
                obj = robotics.ros.custom.msggen.swarm_msgs.Flow.empty(0,1);
                return
            end
            
            % Create an empty message object
            obj = robotics.ros.custom.msggen.swarm_msgs.Flow;
            obj.reload(strObj);
        end
    end
end
