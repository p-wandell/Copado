/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class DeliveredMessage implements fferpcore.Navigable {
    global DeliveredMessage() {

    }
    global abstract String getBody();
    global abstract String getCorrelationId();
    global virtual Object getDeserializedBody() {
        return null;
    }
    global virtual String getMessageType() {
        return null;
    }
    global virtual Object getValue(fferpcore.Path path) {
        return null;
    }
    global abstract Boolean hasResponse();
    global abstract void respondError(fferpcore.ErpErrorBody param0);
    global virtual void respondFiltered() {

    }
    global abstract void respondSuccess();
}
