classdef CustomMsgConsts
    %CustomMsgConsts This class stores all message types
    %   The message types are constant properties, which in turn resolve
    %   to the strings of the actual types.
    
    %   Copyright 2014-2020 The MathWorks, Inc.
    
    properties (Constant)
        swarm_msgs_BBox2d = 'swarm_msgs/BBox2d'
        swarm_msgs_BBox3d = 'swarm_msgs/BBox3d'
        swarm_msgs_Detector = 'swarm_msgs/Detector'
        swarm_msgs_Flow = 'swarm_msgs/Flow'
        swarm_msgs_Flowpixel = 'swarm_msgs/Flowpixel'
        swarm_msgs_Object = 'swarm_msgs/Object'
        swarm_msgs_Pipeline = 'swarm_msgs/Pipeline'
        swarm_msgs_Pipeunit = 'swarm_msgs/Pipeunit'
    end
    
    methods (Static, Hidden)
        function messageList = getMessageList
            %getMessageList Generate a cell array with all message types.
            %   The list will be sorted alphabetically.
            
            persistent msgList
            if isempty(msgList)
                msgList = cell(8, 1);
                msgList{1} = 'swarm_msgs/BBox2d';
                msgList{2} = 'swarm_msgs/BBox3d';
                msgList{3} = 'swarm_msgs/Detector';
                msgList{4} = 'swarm_msgs/Flow';
                msgList{5} = 'swarm_msgs/Flowpixel';
                msgList{6} = 'swarm_msgs/Object';
                msgList{7} = 'swarm_msgs/Pipeline';
                msgList{8} = 'swarm_msgs/Pipeunit';
            end
            
            messageList = msgList;
        end
        
        function serviceList = getServiceList
            %getServiceList Generate a cell array with all service types.
            %   The list will be sorted alphabetically.
            
            persistent svcList
            if isempty(svcList)
                svcList = cell(0, 1);
            end
            
            % The message list was already sorted, so don't need to sort
            % again.
            serviceList = svcList;
        end
        
        function actionList = getActionList
            %getActionList Generate a cell array with all action types.
            %   The list will be sorted alphabetically.
            
            persistent actList
            if isempty(actList)
                actList = cell(0, 1);
            end
            
            % The message list was already sorted, so don't need to sort
            % again.
            actionList = actList;
        end
    end
end
