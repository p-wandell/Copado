/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Path2 {
    global Path2(fferpcore.Path2.Element rootElement) {

    }
    global Boolean equals(Object other) {
        return null;
    }
    global fferpcore.Path2.Element getFirstElement() {
        return null;
    }
    global fferpcore.Path2.TargetType getTargetType() {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
    global Boolean isDeletedItem() {
        return null;
    }
    global override String toString() {
        return null;
    }
global interface Element {
    String getElementAsString();
    fferpcore.Path2.Element getNextPathElement();
    String getPathElementKey();
    fferpcore.Path2.ElementType getPathElementType();
    Boolean isDeletedItem();
}
global enum ElementType {CHILDREN, FIELD, LISTINDEX, LOOKUP}
global interface IndexElement extends fferpcore.Path2.Element {
    Integer getPathElementIndex();
}
global enum TargetType {FIELD, LOOKUP, RECORD, RECORD_LIST}
}
