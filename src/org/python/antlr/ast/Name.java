// Autogenerated AST node
package org.python.antlr.ast;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import org.python.antlr.AST;
import org.python.antlr.PythonTree;
import org.python.antlr.adapter.AstAdapters;
import org.python.core.AstList;
import org.python.core.Py;
import org.python.core.PyObject;
import org.python.core.PyString;
import org.python.core.PyType;
import org.python.expose.ExposedGet;
import org.python.expose.ExposedMethod;
import org.python.expose.ExposedNew;
import org.python.expose.ExposedSet;
import org.python.expose.ExposedType;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;

@ExposedType(name = "_ast.Name", base = AST.class)
public class Name extends exprType implements Context {
public static final PyType TYPE = PyType.fromClass(Name.class);
    private String id;
    public String getInternalId() {
        return id;
    }
    @ExposedGet(name = "id")
    public PyObject getId() {
        if (id == null) return Py.None;
        return new PyString(id);
    }
    @ExposedSet(name = "id")
    public void setId(PyObject id) {
        this.id = AstAdapters.py2identifier(id);
    }

    private expr_contextType ctx;
    public expr_contextType getInternalCtx() {
        return ctx;
    }
    @ExposedGet(name = "ctx")
    public PyObject getCtx() {
        return AstAdapters.expr_context2py(ctx);
    }
    @ExposedSet(name = "ctx")
    public void setCtx(PyObject ctx) {
        this.ctx = AstAdapters.py2expr_context(ctx);
    }


    private final static PyString[] fields =
    new PyString[] {new PyString("id"), new PyString("ctx")};
    @ExposedGet(name = "_fields")
    public PyString[] get_fields() { return fields; }

    private final static PyString[] attributes = new PyString[0];
    @ExposedGet(name = "_attributes")
    public PyString[] get_attributes() { return attributes; }

    public Name() {
        this(TYPE);
    }
    public Name(PyType subType) {
        super(subType);
    }
    @ExposedNew
    @ExposedMethod
    public void Name___init__(PyObject[] args, String[] keywords) {}
    public Name(PyObject id, PyObject ctx) {
        setId(id);
        setCtx(ctx);
    }

    public Name(Token token, String id, expr_contextType ctx) {
        super(token);
        this.id = id;
        this.ctx = ctx;
    }

    public Name(Integer ttype, Token token, String id, expr_contextType ctx) {
        super(ttype, token);
        this.id = id;
        this.ctx = ctx;
    }

    public Name(PythonTree tree, String id, expr_contextType ctx) {
        super(tree);
        this.id = id;
        this.ctx = ctx;
    }

    @ExposedGet(name = "repr")
    public String toString() {
        return "Name";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("Name(");
        sb.append("id=");
        sb.append(dumpThis(id));
        sb.append(",");
        sb.append("ctx=");
        sb.append(dumpThis(ctx));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitName(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
    }

    public void setContext(expr_contextType c) {
        this.ctx = c;
    }

    private int lineno = -1;
    @ExposedGet(name = "lineno")
    public int getLineno() {
        if (lineno != -1) {
            return lineno;
        }
        return getLine();
    }

    @ExposedSet(name = "lineno")
    public void setLineno(int num) {
        lineno = num;
    }

    private int col_offset = -1;
    @ExposedGet(name = "col_offset")
    public int getCol_offset() {
        if (col_offset != -1) {
            return col_offset;
        }
        return getCharPositionInLine();
    }

    @ExposedSet(name = "col_offset")
    public void setCol_offset(int num) {
        col_offset = num;
    }

}
