// Autogenerated AST node
package org.python.antlr.ast;
import org.python.antlr.PythonTree;
import org.python.antlr.ListWrapper;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import java.io.DataOutputStream;
import java.io.IOException;

public class keywordType extends PythonTree {
    private String arg;
    public String getInternalArg() {
        return arg;
    }
    public Object getArg() {
        return arg;
    }
    public void setArg(Object arg) {
        this.arg = (String)arg;
    }

    private exprType value;
    public exprType getInternalValue() {
        return value;
    }
    public Object getValue() {
        return value;
    }
    public void setValue(Object value) {
        this.value = (exprType)value;
    }


    private final static String[] fields = new String[] {"arg", "value"};
    public String[] get_fields() { return fields; }

    public keywordType(String arg, exprType value) {
        this.arg = arg;
        this.value = value;
        addChild(value);
    }

    public keywordType(Token token, String arg, exprType value) {
        super(token);
        this.arg = arg;
        this.value = value;
        addChild(value);
    }

    public keywordType(Integer ttype, Token token, String arg, exprType value) {
        super(ttype, token);
        this.arg = arg;
        this.value = value;
        addChild(value);
    }

    public keywordType(PythonTree tree, String arg, exprType value) {
        super(tree);
        this.arg = arg;
        this.value = value;
        addChild(value);
    }

    public String toString() {
        return "keyword";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("keyword(");
        sb.append("arg=");
        sb.append(dumpThis(arg));
        sb.append(",");
        sb.append("value=");
        sb.append(dumpThis(value));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        traverse(visitor);
        return null;
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (value != null)
            value.accept(visitor);
    }

}
