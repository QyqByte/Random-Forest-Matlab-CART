classdef treeNode < handle

   properties
      Data
   end
   properties(SetAccess = private)
      LowerSetNode
      HigherSetNode
   end
    
   methods
      function node = treeNode(Data)
      % Constructor
         if nargin > 0
            node.Data = Data;
         end
      end
      
      function setLower(newNode, node)
      % Connecting childNode
         node.LowerSetNode = newNode;
      end
      
      function setHigher(newNode, node)
      % Connecting childNode
         node.HigherSetNode = newNode;
      end
      
      function setData(node,info)
         node.Data = info;
      end

      function disp(node)
      % 
         disp('Data of the node')
         disp(node.Data)
      end
   end % methods
end % classdef