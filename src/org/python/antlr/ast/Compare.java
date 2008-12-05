// Autogenerated AST node
package org.python.antlr.ast;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.Token;
import org.python.antlr.AST;
import org.python.antlr.PythonTree;
import org.python.antlr.adapter.AstAdapters;
import org.python.antlr.base.excepthandler;
import org.python.antlr.base.expr;
import org.python.antlr.base.mod;
import org.python.antlr.base.slice;
import org.python.antlr.base.stmt;
import org.python.core.ArgParser;
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

@ExposedType(name = "_ast.Compare", base = AST.class)
public class Compare extends expr {
public static final PyType TYPE = PyType.fromClass(Compare.class);
    private expr left;
    public expr getInternalLeft() {
        return left;
    }
    @ExposedGet(name = "left")
    public PyObject getLeft() {
        return left;
    }
    @ExposedSet(name = "left")
    public void setLeft(PyObject left) {
        this.left = AstAdapters.py2expr(left);
    }

    private java.util.List<cmpopType> ops;
    public java.util.List<cmpopType> getInternalOps() {
        return ops;
    }
    @ExposedGet(name = "ops")
    public PyObject getOps() {
        return new AstList(ops, AstAdapters.cmpopAdapter);
    }
    @ExposedSet(name = "ops")
    public void setOps(PyObject ops) {
        this.ops = AstAdapters.py2cmpopList(ops);
    }

    private java.util.List<expr> comparators;
    public java.util.List<expr> getInternalComparators() {
        return comparators;
    }
    @ExposedGet(name = "comparators")
    public PyObject getComparators() {
        return new AstList(comparators, AstAdapters.exprAdapter);
    }
    @ExposedSet(name = "comparators")
    public void setComparators(PyObject comparators) {
        this.comparators = AstAdapters.py2exprList(comparators);
    }


    private final static PyString[] fields =
    new PyString[] {new PyString("left"), new PyString("ops"), new PyString("comparators")};
    @ExposedGet(name = "_fields")
    public PyString[] get_fields() { return fields; }

    private final static PyString[] attributes =
    new PyString[] {new PyString("lineno"), new PyString("col_offset")};
    @ExposedGet(name = "_attributes")
    public PyString[] get_attributes() { return attributes; }

    public Compare(PyType subType) {
        super(subType);
    }
    public Compare() {
        this(TYPE);
    }
    @ExposedNew
    @ExposedMethod
    public void Compare___init__(PyObject[] args, String[] keywords) {
        ArgParser ap = new ArgParser("Compare", args, keywords, new String[]
            {"left", "ops", "comparators"}, 3);
        setLeft(ap.getPyObject(0));
        setOps(ap.getPyObject(1));
        setComparators(ap.getPyObject(2));
    }

    public Compare(PyObject left, PyObject ops, PyObject comparators) {
        setLeft(left);
        setOps(ops);
        setComparators(comparators);
    }

    public Compare(Token token, expr left, java.util.List<cmpopType> ops, java.util.List<expr>
    comparators) {
        super(token);
        this.left = left;
        addChild(left);
        this.ops = ops;
        this.comparators = comparators;
        if (comparators == null) {
            this.comparators = new ArrayList<expr>();
        }
        for(PythonTree t : this.comparators) {
            addChild(t);
        }
    }

    public Compare(Integer ttype, Token token, expr left, java.util.List<cmpopType> ops,
    java.util.List<expr> comparators) {
        super(ttype, token);
        this.left = left;
        addChild(left);
        this.ops = ops;
        this.comparators = comparators;
        if (comparators == null) {
            this.comparators = new ArrayList<expr>();
        }
        for(PythonTree t : this.comparators) {
            addChild(t);
        }
    }

    public Compare(PythonTree tree, expr left, java.util.List<cmpopType> ops, java.util.List<expr>
    comparators) {
        super(tree);
        this.left = left;
        addChild(left);
        this.ops = ops;
        this.comparators = comparators;
        if (comparators == null) {
            this.comparators = new ArrayList<expr>();
        }
        for(PythonTree t : this.comparators) {
            addChild(t);
        }
    }

    @ExposedGet(name = "repr")
    public String toString() {
        return "Compare";
    }

    public String toStringTree() {
        StringBuffer sb = new StringBuffer("Compare(");
        sb.append("left=");
        sb.append(dumpThis(left));
        sb.append(",");
        sb.append("ops=");
        sb.append(dumpThis(ops));
        sb.append(",");
        sb.append("comparators=");
        sb.append(dumpThis(comparators));
        sb.append(",");
        sb.append(")");
        return sb.toString();
    }

    public <R> R accept(VisitorIF<R> visitor) throws Exception {
        return visitor.visitCompare(this);
    }

    public void traverse(VisitorIF visitor) throws Exception {
        if (left != null)
            left.accept(visitor);
        if (comparators != null) {
            for (PythonTree t : comparators) {
                if (t != null)
                    t.accept(visitor);
            }
        }
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
