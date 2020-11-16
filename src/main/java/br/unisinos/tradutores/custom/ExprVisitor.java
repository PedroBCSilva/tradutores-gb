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
        if(isNull(value)) { // this case solves cases ()
            return this.visit(ctx.e);
        }
        return doArithmeticOperation(ctx, value);
    }

    private Value getValueForDoArithmeticOperation(ExprParser.Do_arithmetic_operationContext ctx){
        if (!isNull(ctx.NUMBER()))
            return new Value(ctx.NUMBER().getSymbol().getText());
        else if (!isNull(ctx.TEXT()))
            return memory.get(ctx.TEXT().getSymbol().getText());
        return null;
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

}
