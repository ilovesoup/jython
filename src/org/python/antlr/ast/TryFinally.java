// Autogenerated AST node
package org.python.antlr.ast;
import java.util.ArrayList;
import org.python.antlr.AstAdapter;
import org.python.antlr.PythonTree;
import org.python.antlr.ListWrapper;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import java.io.DataOutputStream;
import java.io.IOException;

public class TryFinally extends stmtType {
    private java.util.List<stmtType> body;
    public java.util.List<stmtType> getInternalBody() {
        return body;
    }
    public Object getBody() {
        return new ListWrapper(body);
    }
    public void setBody(Object body) {
        this.body = AstAdapter.to_stmtList(body);
    }

    private java.util.List<stmtType> finalbody;
    public java.util.List<stmtType> getInternalFinalbody() {
        return finalbody;
    }
    public Object getFinalbody() {
        return new ListWrapper(finalbody);
    }
    public void setFinalbody(Object finalbody) {
        this.finalbody = AstAdapter.to_stmtList(finalbody);
    }


    private final static String[] fields = new String[] {"body", "finalbody"};
    public String[] get_fields() { return fields; }

    public TryFinally() {}
    public TryFinally(Object body, Object finalbody) {
        setBody(body);
        setFinalbody(finalbody);
    }

    public TryFinally(Token token, java.util.List<stmtType> body,
    java.util.List<stmtType> finalbody) {
        super(token);
        this.body = body;
        if (body == null) {
            this.body = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.body) {
            addChild(t);
        }
        this.finalbody = finalbody;
        if (finalbody == null) {
            this.finalbody = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.finalbody) {
            addChild(t);
        }
    }

    public TryFinally(Integer ttype, Token token, java.util.List<stmtType>
    body, java.util.List<stmtType> finalbody) {
        super(ttype, token);
        this.body = body;
        if (body == null) {
            this.body = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.body) {
            addChild(t);
        }
        this.finalbody = finalbody;
        if (finalbody == null) {
            this.finalbody = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.finalbody) {
            addChild(t);
        }
    }

    public TryFinally(PythonTree tree, java.util.List<stmtType> body,
    java.util.List<stmtType> finalbody) {
        super(tree);
        this.body = body;
        if (body == null) {
            this.body = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.body) {
            addChild(t);
        }
        this.finalbody = finalbody;
        if (finalbody == null) {
            this.finalbody = new ArrayList<stmtType>();
        }
        for(PythonTree t : this.finalbody) {
            addChild(t);
        }
    }

    public String toString() {
        return "TryFinally";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("TryFinally(");
        sb.append("body=");
        sb.append(dumpThis(body));
        sb.append(",");
        sb.append("finalbody=");
        sb.append(dumpThis(finalbody));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitTryFinally(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (body != null) {
            for (PythonTree t : body) {
                if (t != null)
                    t.accept(visitor);
            }
        }
        if (finalbody != null) {
            for (PythonTree t : finalbody) {
                if (t != null)
                    t.accept(visitor);
            }
        }
    }

    private int lineno = -1;
    public int getLineno() {
        if (lineno != -1) {
            return lineno;
        }
        return getLine();
    }

    public void setLineno(int num) {
        lineno = num;
    }

    private int col_offset = -1;
    public int getCol_offset() {
        if (col_offset != -1) {
            return col_offset;
        }
        return getCharPositionInLine();
    }

    public void setCol_offset(int num) {
        col_offset = num;
    }

}
