package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.planDesigner.alicamodel.Plan;
import de.unikassel.vs.alica.planDesigner.alicamodel.PreCondition;
import org.apache.commons.lang3.StringUtils;


class XtendTemplates {

    def String constraints(Plan plan) '''
class «StringUtils.capitalize(plan.name)»«plan.id»Constraints(object):
    def __init__(self) -> None:
        pass
'''

    def String constraintPlanPreCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.preCondition.id»_impl import Constraint«plan.preCondition.id»Impl


class Constraint«plan.preCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.preCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            self.impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

    def String constraintPlanPreConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«plan.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String constraintPlanRuntimeCondition(Plan plan) '''
from engine import BasicConstraint
from engine import ProblemDescriptor
from engine import RunningPlan
from impl.constraint_«plan.runtimeCondition.id» import Constraint«plan.runtimeCondition.id»


class Constraint«plan.runtimeCondition.id»(BasicConstraint):
    def __init__(self) -> None:
        super().__init__()
        self.impl = Constraint«plan.runtimeCondition.id»Impl()

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            self.impl.get_constraint(problem_descriptor, running_plan)
        «ENDIF»
'''

    def String constraintPlanRuntimeConditionImpl(Plan plan) '''
from engine import ProblemDescriptor
from engine import RunningPlan


class Constraint«plan.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_constraint(self, problem_descriptor: ProblemDescriptor, running_plan: RunningPlan) -> None:
        pass
'''

    def String plan(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from impl.«StringUtils.lowerCase(plan.name)»_«plan.id»_impl import «StringUtils.capitalize(plan.name)»«plan.id»Impl


class «StringUtils.capitalize(plan.name)»«plan.id»(BasicPlan):
    def __init__(self) -> None:
        super().__init__()
        self.impl = «StringUtils.capitalize(plan.name)»«plan.id»Impl()

    def get_utility_function(self, basic_plan: BasicPlan) -> BasicUtilityFunction:
        return self.impl.get_utility_function(basic_plan)
'''

    def String utilityFunctionPlan(Plan plan) '''
from engine import BasicPlan
from engine import BasicUtilityFunction
from impl.utility_function_«plan.id»_impl import UtilityFunction«plan.id»Impl


class UtilityFunction«plan.id»(BasicUtilityFunction):
    def __init__(self) -> None:
        super().__init__()
        self.impl = UtilityFunction«plan.id»Impl()

    def get_utility_function(self, basic_plan: BasicPlan) -> BasicUtilityFunction:
        return self.impl.get_utility_function(basic_plan)
'''

    def String utilityFunctionPlanImpl(Plan plan) '''
from engine import BasicPlan
from engine import DefaultUtilityFunction


class UtilityFunction«plan.id»Impl(object):
    def __init__(self) -> None:
        pass

    def get_utility_function(self, basic_plan: BasicPlan) -> DefaultUtilityFunction:
        return DefaultUtilityFunction(basic_plan)
'''

    def String preConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.pre_condition_«plan.preCondition.id»_impl import PreCondition«plan.preCondition.id»Impl


class PreCondition«plan.preCondition.id»(DomainCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = PreCondition«plan.preCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        «IF (plan.preCondition !== null && plan.preCondition.pluginName == "DefaultPlugin")»
            return self.impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

    def String preConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class PreCondition«plan.preCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String runtimeConditionPlan(Plan plan) '''
from engine import RunningPlan
from domain_condition import DomainCondition
from impl.runtime_condition_«plan.runtimeCondition.id»_impl import RunTimeCondition«plan.runtimeCondition.id»Impl


class RunTimeCondition«plan.runtimeCondition.id»(DomainCondition):
    def __init__(self) -> None:
        super().__init__()
        self.impl = RunTimeCondition«plan.runtimeCondition.id»Impl()

    def evaluate(self, running_plan: RunningPlan) -> bool:
        «IF (plan.runtimeCondition !== null && plan.runtimeCondition.pluginName == "DefaultPlugin")»
            self.impl.evaluate(running_plan)
        «ELSE»
            return True
        «ENDIF»
'''

    def String runtimeConditionPlanImpl(Plan plan) '''
from engine import RunningPlan


class RunTimeCondition«plan.runtimeCondition.id»Impl(object):
    def __init__(self) -> None:
        pass

    def evaluate(self, running_plan: RunningPlan) -> bool:
        return False
'''

    def String planImpl(Plan plan) '''
from engine import BasicPlan
from engine import DefaultUtilityFunction


class «StringUtils.capitalize(plan.name)»«plan.id»Impl(object):
    def get_utility_function(self, basic_plan: BasicPlan) -> DefaultUtilityFunction:
        return DefaultUtilityFunction(basic_plan)
'''

}
