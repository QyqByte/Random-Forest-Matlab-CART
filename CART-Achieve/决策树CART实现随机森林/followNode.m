function [ output ] = followNode( node, testPoint)
if isempty(node.LowerSetNode);
    output = node.Data;
else
    criticalPoint = node.Data;
    if (testPoint(criticalPoint(3)) >= criticalPoint(2))
        output = followNode(node.HigherSetNode, testPoint);
    else
        output = followNode(node.LowerSetNode, testPoint);
    end
end
end