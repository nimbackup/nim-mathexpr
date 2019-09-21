import math, tables
import mathexpr/[types, expr_eval]

proc newEvaluator*: Evaluator =
  Evaluator(
    vars: newTable[string, float](),
    hasVars: false,
    funcs: newTable[string, MathFunction](),
    hasFuncs: false
  )

proc addFunc*(e: Evaluator, name: string, fun: MathFunction) =
  ## Adds custom function *fun* named *name* which will be available inside of
  ## a mathematical expression passed to eval()
  ##
  ## You can use any valid Nim code inside of a custom function, but it must
  e.hasFuncs = true
  e.funcs[name] = fun

proc removeFunc*(e: Evaluator, name: string) =
  e.funcs.del(name)
  if e.funcs.len == 0:
    e.hasFuncs = false

proc addVar*(e: Evaluator, name: string, val: float) =
  e.hasVars = true
  e.vars[name] = val

proc addVars*(e: Evaluator, vars: openarray[(string, float)]) =
  for (name, val) in vars:
    e.addVar(name, val)

proc removeVar*(e: Evaluator, name: string) =
  e.vars.del(name)
  if e.vars.len == 0:
    e.hasVars = false

proc eval*(e: Evaluator, input: string): float =
  if input.len == 0:
    raise newException(EmptyInput, "The line is empty!")

  var expr = MathExpression(
    eval: e,
    input: input,
    len: input.len,
    ch: input[0],
    pos: 0
  )
  expr.parseExpression()
