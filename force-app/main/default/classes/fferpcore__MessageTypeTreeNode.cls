/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class MessageTypeTreeNode {
    global static String DEFAULT_RETENTION;
    global MessageTypeTreeNode() {

    }
    global abstract List<fferpcore.MessageTypeTreeNode> getChildren();
    global abstract String getDescription();
    global abstract String getDeveloperName();
    global abstract List<fferpcore.MessageTypeTreeNode.EndPoint> getEndPoints();
    global virtual Id getId() {
        return null;
    }
    global abstract String getName();
    global abstract String getRetention();
    global abstract Boolean hasEndpoints();
    global abstract Boolean isInheritRetention();
    global abstract void setProductCanPublish(String param0, Boolean param1);
    global abstract void setProductCanSubscribe(String param0, Boolean param1);
global abstract class EndPoint {
    global EndPoint() {

    }
    global virtual Id getId() {
        return null;
    }
    global virtual String getIdentifier() {
        return null;
    }
    global abstract String getProductDeveloperName();
    global virtual String getProductProxy() {
        return null;
    }
    global abstract Boolean isEnabled();
    global abstract Boolean isPublication();
    global abstract void setEnabled(Boolean param0);
}
}
