import cpp
import semmle.code.cpp.dataflow.DataFlow

from Function malloc, FunctionCall fc, Expr src
where malloc.hasGlobalName("malloc")
  and fc.getTarget() = malloc
  and DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(fc.getArgument(0)))
  and src.toString().regexpMatch(".*([\\+\\/\\-\\=\\*]+).*")
select src