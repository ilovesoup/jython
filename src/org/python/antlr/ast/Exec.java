// Autogenerated AST node
package org.python.antlr.ast;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
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

@ExposedType(name = "_ast.Exec", base = PyObject.class)
public class Exec extends stmtType {
public static final PyType TYPE = PyType.fromClass(Exec.class);
    private exprType body;
    public exprType getInternalBody() {
        return body;
    }
    @ExposedGet(name = "body")
    public PyObject getBody() {
        return body;
    }
    @ExposedSet(name = "body")
    public void setBody(PyObject body) {
        this.body = AstAdapters.to_expr(body);
    }

    private exprType globals;
    public exprType getInternalGlobals() {
        return globals;
    }
    @ExposedGet(name = "globals")
    public PyObject getGlobals() {
        return globals;
    }
    @ExposedSet(name = "globals")
    public void setGlobals(PyObject globals) {
        this.globals = AstAdapters.to_expr(globals);
    }

    private exprType locals;
    public exprType getInternalLocals() {
        return locals;
    }
    @ExposedGet(name = "locals")
    public PyObject getLocals() {
        return locals;
    }
    @ExposedSet(name = "locals")
    public void setLocals(PyObject locals) {
        this.locals = AstAdapters.to_expr(locals);
    }


    private final static String[] fields = new String[] {"body", "globals",
                                                          "locals"};
@ExposedGet(name = "_fields")
    public String[] get_fields() { return fields; }

    public Exec() {
        this(TYPE);
    }
    public Exec(PyType subType) {
        super(subType);
    }
    @ExposedNew
    @ExposedMethod
    public void Module___init__(PyObject[] args, String[] keywords) {}
    public Exec(PyObject body, PyObject globals, PyObject locals) {
        setBody(body);
        setGlobals(globals);
        setLocals(locals);
    }

    public Exec(Token token, exprType body, exprType globals, exprType locals) {
        super(token);
        this.body = body;
        addChild(body);
        this.globals = globals;
        addChild(globals);
        this.locals = locals;
        addChild(locals);
    }

    public Exec(Integer ttype, Token token, exprType body, exprType globals,
    exprType locals) {
        super(ttype, token);
        this.body = body;
        addChild(body);
        this.globals = globals;
        addChild(globals);
        this.locals = locals;
        addChild(locals);
    }

    public Exec(PythonTree tree, exprType body, exprType globals, exprType
    locals) {
        super(tree);
        this.body = body;
        addChild(body);
        this.globals = globals;
        addChild(globals);
        this.locals = locals;
        addChild(locals);
    }

    @ExposedGet(name = "repr")
    public String toString() {
        return "Exec";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("Exec(");
        sb.append("body=");
        sb.append(dumpThis(body));
        sb.append(",");
        sb.append("globals=");
        sb.append(dumpThis(globals));
        sb.append(",");
        sb.append("locals=");
        sb.append(dumpThis(locals));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitExec(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (body != null)
            body.accept(visitor);
        if (globals != null)
            globals.accept(visitor);
        if (locals != null)
            locals.accept(visitor);
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
