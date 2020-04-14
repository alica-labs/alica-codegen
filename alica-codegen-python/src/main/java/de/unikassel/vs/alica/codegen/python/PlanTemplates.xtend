package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import org.apache.commons.lang3.StringUtils;
import de.unikassel.vs.alica.codegen.templates.IPlanTemplates;


class PlanTemplates implements IPlanTemplates {

    override String constraints(Plan plan) '''
# Constraints - («StringUtils.capitalize(plan.name)»): «plan.id»
class «StringUtils.capitalize(plan.name)»«plan.id»Constraints(object):
    id_ = «plan.id»

    def __init__(self) -> None:
        pass
'''

    override String constraintPlanPreCondition(Plan plan) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«plan.preCondition.id»_impl import Constraint«plan.preCondition.id»Impl


# PreCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.preCondition.id»
class Constraint«plan.preCondition.id»(BasicConstraint):
    id_ = «plan.preCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.get_constraint(problem_descriptor, running_plan)
'''

    override String constraintPlanPreConditionImpl(Plan plan) '''
from engine import ProblemDescriptor, RunningPlan


# Plan PreCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.preCondition.id»
class Constraint«plan.preCondition.id»Impl(object):
    id_ = «plan.preCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String constraintPlanRuntimeCondition(Plan plan) '''
from engine import BasicConstraint, ProblemDescriptor, RunningPlan
from impl.constraints.constraint_«plan.runtimeCondition.id» import Constraint«plan.runtimeCondition.id»


# Plan RuntimeCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.runtimeCondition.id»
class Constraint«plan.runtimeCondition.id»(BasicConstraint):
    id_ = «plan.runtimeCondition.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.runtimeCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        self.impl.get_constraint(problem_descriptor, running_plan)
'''

    override String constraintPlanRuntimeConditionImpl(Plan plan) '''
from engine import ProblemDescriptor, RunningPlan


# Plan RuntimeCondition («StringUtils.capitalize(plan.name)»:«plan.id»): «plan.runtimeCondition.id»
class Constraint«plan.runtimeCondition.id»Impl(object):
    id_ = «plan.runtimeCondition.id»

    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    override String utilityFunctionPlan(Plan plan) '''
from engine import BasicPlan, BasicUtilityFunction
from impl.utilityfunctions.utility_function_«plan.id»_impl import UtilityFunction«plan.id»Impl


class UtilityFunction«plan.id»(BasicUtilityFunction):
    id_ = «plan.id»

    def __init__(self) -> None:
        super().__init__()
        self.impl = UtilityFunction«plan.id»Impl()

    def get_utility_function(self, basic_plan: BasicPlan) -> BasicUtilityFunction:
        return self.impl.get_utility_function(basic_plan)
'''

    override String utilityFunctionPlanImpl(Plan plan) '''
from engine import BasicPlan, DefaultUtilityFunction


class UtilityFunction«plan.id»Impl(object):
    id_ = «plan.id»

    def __init__(self) -> None:
        pass

    def get_utility_function(self, plan: BasicPlan) -> DefaultUtilityFunction:
        return DefaultUtilityFunction(plan)
'''

    override String preConditionPlan(Plan plan) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.pre_condition_«plan.preCondition.id»_impl import PreCondition«plan.preCondition.id»Impl


class PreCondition«plan.preCondition.id»(DomainCondition):
    id_ = «plan.preCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = PreCondition«plan.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(running_plan)
'''

    override String preConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class PreCondition«plan.preCondition.id»Impl(object):
    id_ = «plan.preCondition.id»

    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        print("The PreCondition {} in Plan «plan.getName» is not implement yet!".format(id_));
        return False
'''

    override String runtimeConditionPlan(Plan plan) '''
from typing import Any
from engine import RunningPlan
from gen.domain.domain_condition import DomainCondition
from impl.conditions.runtime_condition_«plan.runtimeCondition.id»_impl import RunTimeCondition«plan.runtimeCondition.id»Impl


class RunTimeCondition«plan.runtimeCondition.id»(DomainCondition):
    id_ = «plan.runtimeCondition.id»

    def __init__(self, context: Any) -> None:
        super().__init__(context)
        self.impl = RunTimeCondition«plan.runtimeCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return self.impl.evaluate(running_plan)
'''

    override String runtimeConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class RunTimeCondition«plan.runtimeCondition.id»Impl(object):
    id_ = «plan.runtimeCondition.id»

    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

}
