package br.unisinos.tradutores.custom;

import br.unisinos.tradutores.generated.ExprBaseVisitor;
import br.unisinos.tradutores.generated.ExprParser;

import java.util.HashMap;
import java.util.Map;

import static java.util.Objects.isNull;

public class ExprVisitor extends ExprBaseVisitor<Value> {

    private Map<String, Value> memory = new HashMap<String, Value>();

    @Override
    public Value visitAttribution_operation(ExprParser.Attribution_operationContext ctx) {
        String variableName = ctx.TEXT().getText();
        Value value = this.visitArithmetic_op(ctx.arithmetic_op());
        System.out.println(variableName + "=" + value.asDouble());
        return memory.put(variableName, value);
    }

    @Override
    public Value visitArithmetic_op(ExprParser.Arithmetic_opContext ctx) {
        return this.visit(ctx.do_arithmetic_operation());
    }

    @Override
    public Value visitDo_arithmetic_operation(ExprParser.Do_arithmetic_operationContext ctx) {
        Value value = getValueForDoArithmeticOperation(ctx);
        return doArithmeticOperation(ctx, value);
    }

    private Value getValueForDoArithmeticOperation(ExprParser.Do_arithmetic_operationContext ctx) {
        Value value = null;
        if (!isNull(ctx.NUMBER()))
            value = new Value(ctx.NUMBER().getSymbol().getText());
        else if (!isNull(ctx.TEXT()))
            value = getMemoryVariable(ctx.TEXT().getSymbol().getText());
        else
            value = this.visit(ctx.do_arithmetic_operation().get(0));
        return value;
    }

    private Value doArithmeticOperation(ExprParser.Do_arithmetic_operationContext ctx, Value value) {
        if (!isNull(ctx.SUM_OP())) {
            return new Value(value.asDouble() + this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.SUB_OP())) {
            return new Value(value.asDouble() - this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.MULT_OP())) {
            return new Value(value.asDouble() * this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.DIV_OP())) {
            return new Value(value.asDouble() / this.visit(ctx.e).asDouble());
        } else {
            return value;
        }
    }

    @Override
    public Value visitRelational_op(ExprParser.Relational_opContext ctx) {
        return this.visit(ctx.do_relational_operation());
    }

    @Override
    public Value visitDo_relational_operation(ExprParser.Do_relational_operationContext ctx) {
        Value value = getValueForDoRelationalOperation(ctx);
        Value result = doRelationalOperation(ctx, value);
        System.out.println("result:" + result.asBoolean());
        return result;
    }

    private Value getValueForDoRelationalOperation(ExprParser.Do_relational_operationContext ctx) {
        if (!isNull(ctx.NUMBER()))
            return new Value(ctx.NUMBER().getSymbol().getText());
        else if (!isNull(ctx.TEXT()))
            return getMemoryVariable(ctx.TEXT().getSymbol().getText());
        return null;
    }

    private Value doRelationalOperation(ExprParser.Do_relational_operationContext ctx, Value value) {
        if (!isNull(ctx.EQ())) {
            return new Value(value.asDouble().equals(this.visit(ctx.e).asDouble()));
        } else if (!isNull(ctx.DIF())) {
            return new Value(!value.asDouble().equals(this.visit(ctx.e).asDouble()));
        } else if (!isNull(ctx.SM())) {
            return new Value(value.asDouble() < this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.SMALLER_EQ())) {
            return new Value(value.asDouble() <= this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.BIG())) {
            return new Value(value.asDouble() > this.visit(ctx.e).asDouble());
        } else if (!isNull(ctx.BIGGER_EQ())) {
            return new Value(value.asDouble() >= this.visit(ctx.e).asDouble());
        }
        return new Value(true);
    }

    @Override
    public Value visitWhile_stat(ExprParser.While_statContext ctx) {
        while(this.visit(ctx.relational_op()).asBoolean()){
            for(ExprParser.StatementContext currentStatCtx : ctx.statement()){
                this.visit(currentStatCtx);
            }
        }
        return Value.VOID;
    }

    @Override
    public Value visitIf_stat(ExprParser.If_statContext ctx) {
        if(this.visit(ctx.relational_op()).asBoolean()){
            for(ExprParser.StatementContext currentStatCtx : ctx.statement()){
                this.visit(currentStatCtx);
            }
        } else {
            if(!isNull(ctx.else_stat())) {
                this.visit(ctx.else_stat());
            }
        }
        return Value.VOID;
    }

    @Override
    public Value visitElse_stat(ExprParser.Else_statContext ctx) {
        for(ExprParser.StatementContext currentStatCtx : ctx.statement()){
            this.visit(currentStatCtx);
        }
        return Value.VOID;
    }

    private Value getMemoryVariable(String variableName){
        Value v = memory.get(variableName);
        if(isNull(v)){
            throw new RuntimeException("Variable not created: "+variableName);
        } else {
            return v;
        }
    }
}
