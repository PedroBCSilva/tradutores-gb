package br.unisinos.tradutores.custom;

import br.unisinos.tradutores.generated.ExprBaseVisitor;
import br.unisinos.tradutores.generated.ExprParser;

import java.util.HashMap;
import java.util.Map;

public class ExprVisitor extends ExprBaseVisitor<Value> {

    private Map<String, Value> memory = new HashMap<String, Value>();

    @Override
    public Value visitAttribution_operation(ExprParser.Attribution_operationContext ctx) {
        String variableName = ctx.TEXT().getText();
        Value value = new Value(ctx.e.v);
        return memory.put(variableName,value);
    }
}
